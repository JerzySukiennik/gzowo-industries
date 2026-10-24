"""G.L.A.S.S. unveiling film: Blender 4.5 headless.

    Blender -b -P film/film_build.py -- <h|v> [frame_start frame_end] [test]

Builds the scene from cad/stl-asm (design orientation, mm), animates a light reveal,
magnet snap-on, temple fold, hero orbit and the title, then renders PNG frames to
film/frames_<h|v>/. The audio is mixed afterwards with ffmpeg (film/mix.sh).
Timeline: 24 fps, 60 s = 1440 frames.
"""
import bpy, math, os, sys
from mathutils import Vector, Euler

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
STL = os.path.join(ROOT, 'cad', 'stl-asm')
FONT = '/Library/Fonts/SF-Pro-Text-Medium.otf'
FPS = 24
DUR = 60
args = sys.argv[sys.argv.index('--') + 1:] if '--' in sys.argv else ['h']
MODE = args[0]
F0 = int(args[1]) if len(args) > 2 else 1
F1 = int(args[2]) if len(args) > 2 else DUR * FPS
TEST = 'test' in args

def sec(t): return int(round(t * FPS)) + 1

# ------------------------------------------------------------------ scene ---
bpy.ops.wm.read_factory_settings(use_empty=True)
sc = bpy.context.scene
sc.unit_settings.system = 'METRIC'; sc.unit_settings.scale_length = 0.001
sc.render.engine = 'BLENDER_EEVEE_NEXT'
sc.render.fps = FPS
sc.frame_start = 1; sc.frame_end = DUR * FPS
sc.eevee.taa_render_samples = 24 if TEST else 48
sc.eevee.use_shadows = True
sc.view_settings.view_transform = 'AgX'
sc.view_settings.look = 'AgX - Medium High Contrast'
if MODE == 'v':
    sc.render.resolution_x, sc.render.resolution_y = 1080, 1920
else:
    sc.render.resolution_x, sc.render.resolution_y = 1920, 1080
sc.render.resolution_percentage = 100
sc.render.image_settings.file_format = 'PNG'
sc.render.image_settings.color_mode = 'RGB'
sc.render.filepath = os.path.join(HERE, f'frames_{MODE}', 'f')
sc.world = bpy.data.worlds.new('world'); sc.world.use_nodes = True
sc.world.node_tree.nodes['Background'].inputs[0].default_value = (0, 0, 0, 1)

def mat(name, color, rough=0.5, metallic=0.0, alpha=1.0, emit=None, strength=0.0):
    m = bpy.data.materials.new(name); m.use_nodes = True
    b = next(n for n in m.node_tree.nodes if n.type == 'BSDF_PRINCIPLED')
    b.inputs['Base Color'].default_value = (*color, 1)
    b.inputs['Roughness'].default_value = rough
    b.inputs['Metallic'].default_value = metallic
    b.inputs['Alpha'].default_value = alpha
    if emit:
        b.inputs['Emission Color'].default_value = (*emit, 1)
        b.inputs['Emission Strength'].default_value = strength
    if alpha < 1:
        m.surface_render_method = 'BLENDED'
    return m

M_FRAME = mat('frame', (0.015, 0.015, 0.017), rough=0.32)
M_FRAME2 = mat('frame2', (0.03, 0.03, 0.034), rough=0.5)
M_LENS = mat('lens', (0.02, 0.025, 0.03), rough=0.05, alpha=0.75)
M_GLASS = mat('splitter', (0.6, 0.75, 0.9), rough=0.02, alpha=0.18)
M_MAG = mat('magnet', (0.75, 0.75, 0.78), rough=0.25, metallic=1.0)
M_HUD = mat('hud', (0.9, 0.95, 1.0), emit=(0.85, 0.95, 1.0), strength=0)
M_TEXT = mat('text', (1, 1, 1), emit=(1, 1, 1), strength=0)
M_TEXT2 = mat('text2', (1, 1, 1), emit=(1, 1, 1), strength=0)

def key(obj, path, frame, value, index=-1):
    if index >= 0:
        v = list(getattr(obj, path)); v[index] = value; setattr(obj, path, v)
    else:
        setattr(obj, path, value)
    obj.keyframe_insert(data_path=path, frame=frame, index=index)

def smooth(obj):
    if obj.animation_data and obj.animation_data.action:
        for fc in obj.animation_data.action.fcurves:
            for kp in fc.keyframe_points:
                kp.interpolation = 'BEZIER'; kp.easing = 'EASE_IN_OUT'

def import_stl(name, m):
    bpy.ops.wm.stl_import(filepath=os.path.join(STL, name + '.stl'))
    o = bpy.context.selected_objects[0]; o.name = name
    o.data.materials.append(m)
    try: bpy.ops.object.shade_auto_smooth(angle=math.radians(40))
    except Exception:
        for p in o.data.polygons: p.use_smooth = True
    return o

def empty(name, loc):
    e = bpy.data.objects.new(name, None); e.location = loc; bpy.context.collection.objects.link(e); return e

# ------------------------------------------------------------------ parts ---
plate = import_stl('plate', M_FRAME)
arm = import_stl('arm', M_FRAME)
piv_r = empty('piv_r', (72, -7, 0)); piv_l = empty('piv_l', (-72, -7, 0))
temples = {}
for s, piv in ((1, piv_r), (-1, piv_l)):
    t = import_stl('temple_r' if s > 0 else 'temple_l', M_FRAME)
    t.parent = piv; t.matrix_parent_inverse = piv.matrix_world.inverted(); temples[s] = t
boxes = {}; lids = {}
for s in (1, -1):
    bx = empty(f'box_piv_{s}', (0, 0, 0))
    b = import_stl('box_r' if s > 0 else 'box_l', M_FRAME); b.parent = bx; boxes[s] = bx
    l = import_stl('lid_r' if s > 0 else 'lid_l', M_FRAME2); l.parent = bx; lids[s] = l

# tinted lenses in the rim rebates
LENS_IN = [(9, 6), (54, 6), (56, -3), (52, -17), (42, -24), (26, -25), (20, -20), (14, -14), (9, -5)]
for s in (1, -1):
    verts = [(s * x, 0.6, z) for x, z in LENS_IN] + [(s * x, 2.6, z) for x, z in LENS_IN]
    n = len(LENS_IN)
    faces = [list(range(n)), list(range(n, 2 * n))[::-1]] + [[i, (i + 1) % n, n + (i + 1) % n, n + i] for i in range(n)]
    me = bpy.data.meshes.new(f'lens_{s}'); me.from_pydata(verts, [], faces); me.update()
    o = bpy.data.objects.new(f'lens_{s}', me); bpy.context.collection.objects.link(o); o.data.materials.append(M_LENS)

# beam splitter: vertical plate 25x25, 45 deg about Z, on the right pupil axis at y = 23
bpy.ops.mesh.primitive_cube_add(size=1, location=(31, 23, 0)); comb = bpy.context.object; comb.name = 'splitter'
comb.scale = (25, 1.1, 25); comb.rotation_euler = (0, 0, math.radians(45)); comb.data.materials.append(M_GLASS)
# HUD text glowing on the splitter, readable from the front-right
bpy.ops.object.text_add(location=(31, 23, 0)); hud = bpy.context.object; hud.name = 'hud'
hud.data.body = '12:34\nGZOWO  WiFi ok'; hud.data.size = 3.2; hud.data.align_x = 'CENTER'; hud.data.align_y = 'CENTER'
hud.data.font = bpy.data.fonts.load(FONT); hud.data.extrude = 0.05; hud.data.materials.append(M_HUD)
hud.rotation_euler = Euler((math.radians(90), 0, math.radians(135)), 'XYZ')
hud.location = (31 + 0.9, 23 + 0.9, 0)

# magnets in the rails (visible when the boxes are off)
mags = []
for s in (1, -1):
    for y in (-48, -28, -10):
        bpy.ops.mesh.primitive_cylinder_add(radius=3, depth=2, location=(s * 81, y, 17), rotation=(0, math.radians(90), 0))
        m = bpy.context.object; m.name = f'mag_{s}_{y}'; m.data.materials.append(M_MAG); mags.append(m)

# --------------------------------------------------------- background text ---
def text(name, body, size, loc, m, align='CENTER'):
    bpy.ops.object.text_add(location=loc); t = bpy.context.object; t.name = name
    t.data.body = body; t.data.size = size; t.data.align_x = align; t.data.align_y = 'CENTER'
    t.data.font = bpy.data.fonts.load(FONT); t.data.extrude = 0
    t.rotation_euler = Euler((math.radians(90), 0, math.radians(180)), 'XYZ')   # stands up, readable from +y (the camera side)
    t.data.materials.append(m)
    return t

CAPS = [   # (start, end, text, size, z, behind: -1 = behind the model for a camera in front, +1 = behind for a camera at the back)
    (6.5, 13.5, 'Smart glasses. Built at home.', 26, 52, -1),
    (14.5, 21.5, 'A display in your line of sight.', 13, -36, -3),
    (23.0, 30.5, 'Snap on. Snap off.', 28, -40, 1),
    (31.5, 38.5, 'Printed, not molded.', 28, -60, 1),
    (40.0, 48.5, 'An assistant that talks back.', 18, 50, -2),
]
cap_objs = []
for i, (t0, t1, body, size, z, side) in enumerate(CAPS):
    t = text(f'cap{i}', body, size, (0, -140 if side == -1 else -60, z), M_TEXT if i % 2 == 0 else M_TEXT2)   # side -2: close behind the model (less parallax during the orbit)
    if side > 0: t.rotation_euler = Euler((0, 0, 0), 'XYZ'); t.location = (0, 160, z)   # lies on the floor beyond the glasses, read from the camera behind-above
    if side == -3: t.rotation_euler = Euler((0, 0, math.radians(142)), 'XYZ'); t.location = (40, 30, z)   # on the floor under the HUD arm, read from the close-up camera at +x+y
    t.hide_render = True; t.keyframe_insert('hide_render', frame=1)
    t.hide_render = False; t.keyframe_insert('hide_render', frame=sec(t0))
    t.hide_render = True; t.keyframe_insert('hide_render', frame=sec(t1))
    cap_objs.append((t, t0, t1))

title = text('title', 'G.L.A.S.S.', 40, (0, -120, 50), mat('title', (1, 1, 1), emit=(1, 1, 1), strength=0))
tagline = text('tagline', 'See more. Look normal.', 16, (0, -120, -70), mat('tagline', (1, 1, 1), emit=(1, 1, 1), strength=0))
url = text('url', 'industries.gzowo.fun', 12, (0, -120, -92), mat('url', (1, 1, 1), emit=(1, 1, 1), strength=0))
intro = text('intro', 'Gzowo Industries', 16, (0, -140, 50), mat('intro', (1, 1, 1), emit=(1, 1, 1), strength=0))
for o in (title, tagline, url, intro):
    o.hide_render = True; o.keyframe_insert('hide_render', frame=1)

def emission_keys(m, keys):
    b = next(n for n in m.node_tree.nodes if n.type == 'BSDF_PRINCIPLED')
    for f, v in keys:
        b.inputs['Emission Strength'].default_value = v
        b.inputs['Emission Strength'].keyframe_insert('default_value', frame=f)

def fade_text(o, t0, t1, peak=4.0, fade=0.8):
    o.hide_render = False; o.keyframe_insert('hide_render', frame=sec(t0))
    o.hide_render = True; o.keyframe_insert('hide_render', frame=sec(t1))
    emission_keys(o.data.materials[0], [(sec(t0), 0), (sec(t0 + fade), peak), (sec(t1 - fade), peak), (sec(t1), 0)])

for t, t0, t1 in cap_objs:
    emission_keys(t.data.materials[0], [(sec(t0), 0), (sec(t0 + 0.8), 10), (sec(t1 - 0.8), 10), (sec(t1), 0)])
fade_text(intro, 1.5, 5.5, peak=6.0)
fade_text(title, 49.0, 58.5, peak=12.0, fade=1.2)
fade_text(tagline, 55.0, 58.5, peak=9.0, fade=1.0)
fade_text(url, 57.0, 60.0, peak=8.0, fade=0.8)
emission_keys(M_HUD, [(sec(15.5), 0), (sec(16.5), 6), (sec(22), 6), (sec(22.5), 0), (sec(40), 0), (sec(41), 6), (sec(49), 6), (sec(50), 0)])

# ---------------------------------------------------------------- lights ---
def light(name, kind, loc, energy, color=(1, 1, 1), angle=6):
    d = bpy.data.lights.new(name, kind); d.energy = energy; d.color = color
    if kind == 'SUN': d.angle = math.radians(angle)
    o = bpy.data.objects.new(name, d); o.location = loc; bpy.context.collection.objects.link(o)
    tgt = empty(name + '_tgt', (0, 0, 0)); c = o.constraints.new('TRACK_TO'); c.target = tgt; c.track_axis = 'TRACK_NEGATIVE_Z'; c.up_axis = 'UP_Y'
    return o, tgt

E_KEY, E_RIM, E_FILL = 3.0, 2.2, 0.9
keyl, key_t = light('key', 'SUN', (200, 260, 220), E_KEY, (1, 0.97, 0.92), 8)
rim, rim_t = light('rim', 'SUN', (-160, -220, 140), E_RIM, (0.85, 0.92, 1), 4)
fill, fill_t = light('fill', 'SUN', (-220, 200, 60), E_FILL, (1, 1, 1), 20)
sweep, sweep_t = light('sweep', 'SPOT', (-300, 120, 160), 0); sweep.data.spot_size = math.radians(26); sweep.data.spot_blend = 0.7
key_t.location = (0, 0, 5); rim_t.location = (0, 0, 5); fill_t.location = (0, 0, 0); sweep_t.location = (72, -7, 10)
# reveal: key/rim/fill rise from black over the first shot, the sweep spot crosses the frame left -> right
for L, e in ((keyl, E_KEY), (rim, E_RIM), (fill, E_FILL)):
    key(L.data, 'energy', 1, 0); key(L.data, 'energy', sec(2.0), 0); key(L.data, 'energy', sec(7.5), e)
key(sweep.data, 'energy', 1, 0); key(sweep.data, 'energy', sec(1.0), 3e7); key(sweep.data, 'energy', sec(6.5), 3e7); key(sweep.data, 'energy', sec(8), 0)
key(sweep_t, 'location', sec(1.0), (-120, 0, 10)); key(sweep_t, 'location', sec(6.5), (120, 0, 10))
# the key light dims for the title, the text carries the end
for L, e in ((keyl, E_KEY), (rim, E_RIM), (fill, E_FILL)):
    key(L.data, 'energy', sec(49), e); key(L.data, 'energy', sec(53), e * 0.3); key(L.data, 'energy', sec(58), e * 0.3); key(L.data, 'energy', sec(60), 0)

# ------------------------------------------------------------------ camera ---
cam_d = bpy.data.cameras.new('cam'); cam_d.lens = 50 if MODE == 'h' else 32; cam_d.clip_end = 5000; cam_d.sensor_width = 36
cam_d.dof.use_dof = True; cam_d.dof.aperture_fstop = 2.8
cam = bpy.data.objects.new('cam', cam_d); bpy.context.collection.objects.link(cam); sc.camera = cam
tgt = empty('cam_tgt', (0, 0, 0)); c = cam.constraints.new('TRACK_TO'); c.target = tgt; c.track_axis = 'TRACK_NEGATIVE_Z'; c.up_axis = 'UP_Y'
cam_d.dof.focus_object = tgt
V = 1.25 if MODE == 'v' else 1.0   # the vertical cut stands a little further back
SHOTS = [   # (t0, t1, cam_from, cam_to, target_from, target_to)
    (0.0, 6.5, (150, 60, 40), (120, 70, 28), (72, -7, 12), (60, 0, 8)),            # hinge and end-piece, light sweep
    (6.5, 14.5, (260, 300, 120), (190, 330, 80), (0, 0, 0), (0, 0, 0)),             # whole glasses, slow drift
    (14.5, 23.0, (175, 187, 72), (119, 144, 50), (40, 23, -10), (36, 23, -8)),         # HUD arm and splitter, caption on the floor below
    (23.0, 31.5, (0, -380, 230), (0, -330, 190), (0, -10, 0), (0, -10, 0)),          # boxes snap on, seen from behind-above
    (31.5, 40.0, (60, -200, 300), (-40, -220, 280), (0, -30, 0), (0, -30, 0)),        # temples fold, from behind-above
    (40.0, 49.5, (300, 260, 120), (-220, 330, 100), (0, 0, 0), (0, 0, 0)),           # hero orbit
    (49.5, 56.5, (0, 260, 20), (0, 320, 30), (0, 0, 5), (0, 0, 5)),                   # title behind and above the glasses
    (56.5, 60.0, (0, 320, 30), (0, 340, 32), (0, 0, 5), (0, 0, 5)),
]
for t0, t1, c0, c1, g0, g1 in SHOTS:
    key(cam, 'location', sec(t0), Vector(c0) * V); key(cam, 'location', sec(t1) - 1, Vector(c1) * V)
    key(tgt, 'location', sec(t0), g0); key(tgt, 'location', sec(t1) - 1, g1)
for o in (cam, tgt):
    if o.animation_data:
        for fc in o.animation_data.action.fcurves:
            for kp in fc.keyframe_points: kp.interpolation = 'LINEAR'

# --------------------------------------------------------------- actions ---
# boxes start off the frame (sideways) and snap on at 24-26 s, lids drop in at 27-29 s
for s in (1, -1):
    bx = boxes[s]
    key(bx, 'location', 1, (s * 70, 0, 0)); key(bx, 'location', sec(23.5), (s * 70, 0, 0)); key(bx, 'location', sec(25.5), (0, 0, 0))
    l = lids[s]
    key(l, 'delta_location', 1, (0, 0, 40)); key(l, 'delta_location', sec(27.0), (0, 0, 40)); key(l, 'delta_location', sec(29.0), (0, 0, 0))
    smooth(bx); smooth(l)
    # before 23.5 s the boxes are simply not rendered (they would float in the air)
    for o in (bx.children[0], bx.children[1]):
        o.hide_render = True; o.keyframe_insert('hide_render', frame=1)
        o.hide_render = False; o.keyframe_insert('hide_render', frame=sec(23.0))
# magnet flash at the snap
# temples fold (right first, then left over it) at 32-35.5 s, unfold 36-39 s
for s, piv, d in ((1, piv_r, 0.0), (-1, piv_l, 0.8)):
    ang = -s * math.radians(85)
    key(piv, 'rotation_euler', sec(31.5 + d), 0, 2); key(piv, 'rotation_euler', sec(34.5 + d), ang, 2)
    key(piv, 'rotation_euler', sec(36.0 + d), ang, 2); key(piv, 'rotation_euler', sec(39.0 + d), 0, 2)
    smooth(piv)

# ------------------------------------------------------------------ render ---
sc.frame_start = F0; sc.frame_end = F1
if TEST:
    for f in (sec(3), sec(10), sec(18), sec(26), sec(33), sec(44), sec(52), sec(58)):
        sc.frame_set(f); sc.render.filepath = os.path.join(HERE, f'test_{MODE}_{f:04d}.png'); bpy.ops.render.render(write_still=True)
        print('RENDERED', sc.render.filepath)
else:
    bpy.ops.render.render(animation=True)
    print('RENDERED frames', F0, F1)
