// Gzowo Glass v0.9 — print-ready parametric frame (OpenSCAD 2021.01)
// ---------------------------------------------------------------------------
// Frame of reference (mm): X = wearer's right, Y = forward (away from the
// face), Z = up. The right pupil axis is the line (PD/2, *, 0). The back face
// of the front plate is the plane y = 0; the cornea sits at y = -VD.
//
// v0.9 (2026-10-23): BOXES MOVE TO THE SIDES, BEHIND THE HINGES.
//   * No brows on the front. Each side has one box (22 x 80 x 32) running back
//     along the temple, outboard of it. It snaps with 3 magnets + 2 pins onto a
//     RAIL that grows from the plate's end-piece (the rail is also the temple's
//     fold stop). The temple folds under the box. Weight moves ~50 mm back.
//   * RIGHT box: OLED stands in its front part, screen facing inward through a
//     window. No mirror: OLED -> lens (on the HUD arm) -> splitter -> eye, one
//     reflection (image mirrored left-right: SSD1306 segment remap fixes it in
//     firmware). do = 39 mm, lens->eye 60 mm, FOV ~28 deg.
//   * HUD ARM: a separate flat part screwed to the plate front with 2 x M2.5x12
//     (the only screws besides the 2 hinge screws). It carries the lens ring
//     and the splitter slot (splitter vertical, 45 deg about Z, on the pupil).
//     Remove the arm and the boxes: ordinary glasses.
//   * LEFT box: XIAO in the front (camera looks forward through the box's front
//     wall, USB-C up through the lid), battery lying behind it, amp on the floor.
//   * Lids on 4 magnets (columns floor-to-lid). Temples, hinge, nose pads,
//     keyhole bridge: as v0.8.
// ---------------------------------------------------------------------------

FOLD = 85;
part = "assembly";    // plate | arm | box_r | box_l | lid_r | lid_l | temple_r | temple_l | test_hinge_front | test_hinge_temple | test_plate | assembly | fit | fold | exploded
print_orient = false;
show_parts = true;
show_head = true;
head_file = "../reference/head2-mm.stl";
$fn = 48;

// ------------------------------------------------------------ head / fit ---
PD       = 62;
VD       = 21;
EX       = PD/2;
PAD_X    = 11.5;   PAD_Z = -14;   PAD_ANG = 38;   PAD_TILT = 20;   PAD_FLARE = 30;
EAR_Z    = -4;     EAR_Y = -108;
TEMPLE_SPLAY = 7;

// ------------------------------------------------------- component sizes ---
XIAO     = [21, 17.8, 15];      // XIAO ESP32-S3 Sense stack (long, wide, stack height)
OLED_PCB = [27.3, 27.3, 4.3];   // 0.96" I2C module board. Active area 21.7x10.9.
AMP      = [19.4, 17.8, 3.2];
SPK_D    = 20;  SPK_T = 3.6;
BS       = [25, 25, 1.1];       // beam splitter plate
LENS_D   = 30;  LENS_T = 6.5;   // biconvex f=50
BTN      = [6, 6, 5];
BAT      = [40, 20, 8];         // battery (long, tall, thick)
MAG_D    = 6;  MAG_T = 2;
S_TAP    = 2.1;  S_TAP_H = 2.3;  S_CLR = 3.0;  S_HEAD = 5.4;
CLR      = 0.4;  WALL = 1.6;

// ---------------------------------------------------------------- layout ---
FRONT_T  = 6;
BAR_Z0   = 6;   BAR_Z1 = 22;
BAR_BACK = 3;
GROOVE   = [4.5, 3.5];  GROOVE_Z = 17;
// end-pieces, hinge, rails
EP_X0 = 66;  EP_X1 = 78;  EP_Y0 = -2;  EP_Z0 = 0;  EP_Z1 = 34;
HX = 72;  HY = -7;
HK_Z0_R = 4;  HK_Z0_L = 16;
HK_BOT = 8; HK_TEMPLE = 5; HK_TOP = 2; HK_GAP = 0.3;
HK_BORE = 2.8;  HK_R = 5;  HK_NECK = 12;
RAIL_X0 = 78;  RAIL_X1 = 82;          // rail outboard of the temple (temple outer face at 76.6)
RAIL_Y0 = -54; RAIL_Z0 = -14;  RAIL_Z1 = 16;   // rail spans the box's height (box z -16..18)
RAIL_MAG_Y = [-38, -22, -6];          // magnets in the rail's outer face
RAIL_MAG_Z = 0;
RAIL_PIN_Y = [-30, -14];  PIN_D = 4;  PIN_L = 1.6;  RAIL_PIN_Z = 8;
// boxes
BOX_X0 = 82;  BOX_X1 = 104;           // 22 thick (inner 18.8: XIAO 17.8 across)
BOX_Y0 = -46; BOX_Y1 = 40;            // 86 long: the front 34 mm sit beside the plate corner (OLED / camera)
BOX_Z0 = -16; BOX_Z1 = 18;            // 34 tall (OLED board 27.3 + lid)
BOX_R  = 4;
LID_T  = 3;
// HUD optics: beam along -x at y = BEAM_Y, z = 0
BEAM_Y   = 23;                        // splitter 44 mm in front of the cornea; the lens ring clears the plate front
LENS_X   = 52;                        // lens centre x (ring on the arm)
OLED_X   = LENS_X + 39;               // OLED screen face x (do = 39 mm; slide range +-3 on the rails)
COMB     = [EX, BEAM_Y, 0];           // splitter centre on the pupil axis, vertical, 45 deg about Z
ARM_Z0 = 12;  ARM_Z1 = 18;            // arm bar above the beam (beam is 22 x 11 around z = 0 -> top at 5.5)
ARM_D  = 8;                           // bar depth y 6..14: M2.5x12 leaves 6 mm of thread in the plate
ARM_X0 = 16;  ARM_X1 = BOX_X0;        // bar from left of the splitter to the box's inner wall
ARM_SCREWS_X = [44, 72];              // M2.5x12 from the front, into the plate bar (z = 16)
// lid columns [x, y] (right box mirrored for the left)
function lid_cols(s) = [[s*(BOX_X0+WALL+3), BOX_Y0+WALL+3], [s*(BOX_X1-WALL-3), BOX_Y0+WALL+3], [s*(BOX_X0+WALL+3), BOX_Y1-WALL-3], [s*(BOX_X1-WALL-3), BOX_Y1-WALL-3]];
// temples
ARM_W0 = 6;  ARM_H0 = 9;  ARM_W1 = 4;  ARM_H1 = 5;
TEMPLE_L = 80;  HOOK_DROP = 26;  HOOK_IN = 0;
KN_FLAT  = HK_R - 0.4;
SPEAKER  = false;  SPK_Y = -TEMPLE_L-10;

function hk_z0(s) = s>0 ? HK_Z0_R : HK_Z0_L;
function zk0(s) = hk_z0(s) + HK_BOT + HK_GAP;
function zk(s)  = zk0(s) + HK_TEMPLE/2;

// --------------------------------------------------------------- helpers ---
module rbox(size, r=2) { hull() for (i=[-1,1], j=[-1,1], k=[-1,1]) translate([i*(size[0]/2-r), j*(size[1]/2-r), k*(size[2]/2-r)]) sphere(r=r, $fn=40); }
module rboxc(p, size, r=2) translate(p + size/2) rbox(size, r);
module rrect_prism(p, size, r) hull() for (i=[0,1], j=[0,1]) translate([p[0]+r+i*(size[0]-2*r), p[1]+r+j*(size[1]-2*r), p[2]]) cylinder(r=r, h=size[2]);   // rounded vertical edges, flat top/bottom
module plate2d(d) rotate([90,0,0]) translate([0,0,-d]) linear_extrude(height=d) children();
module lens2d(mir=false) scale([mir ? -1 : 1, 1]) offset(r=3) offset(r=-3)
    polygon([[9,6],[54,6],[56,-3],[52,-17],[42,-24],[26,-25],[20,-20],[14,-14],[9,-5]]);
module tap(l)  cylinder(d=S_TAP, h=l);
module tap_h(l) cylinder(d=S_TAP_H, h=l);
module lead_in(z, d) translate([0, 0, z-0.65]) cylinder(d1=d, d2=d+1.3, h=0.66);
module clr(l)  cylinder(d=S_CLR, h=l);
module mag_pocket(l=MAG_T+0.3) cylinder(d=MAG_D+0.4, h=l);

// ================================================================= PLATE ====
module rims() difference() {
    for (m=[false,true]) plate2d(FRONT_T) offset(r=5) lens2d(m);
    for (m=[false,true]) { translate([0,-1,0]) plate2d(FRONT_T+2) lens2d(m); translate([0,-1,0]) plate2d(3.4) offset(r=1) lens2d(m); }
}
module bar() rboxc([-EP_X1+2, -BAR_BACK, BAR_Z0], [2*EP_X1-4, FRONT_T+BAR_BACK, BAR_Z1-BAR_Z0], 2.5);
module nose_pads() for (s=[-1,1]) hull() {
    translate([s*PAD_X, -3.5, PAD_Z]) rotate([PAD_TILT, -s*PAD_FLARE, s*PAD_ANG]) rbox([2.6, 9, 16], 1.2);
    translate([s*(PAD_X-2.5), 2.5, PAD_Z+3]) rbox([4, 5, 10], 1);
}
module end_piece(s) { z0 = hk_z0(s);
    rboxc([s>0 ? EP_X0 : -EP_X1, EP_Y0, EP_Z0], [EP_X1-EP_X0, FRONT_T-EP_Y0, EP_Z1-EP_Z0], 3);
    rboxc([s>0 ? RAIL_X0 : -RAIL_X1, RAIL_Y0, RAIL_Z0], [RAIL_X1-RAIL_X0, FRONT_T-RAIL_Y0, RAIL_Z1-RAIL_Z0], 1.5);   // rail: box mount + temple stop
    for (z=[[z0, z0+HK_BOT], [z0+HK_BOT+HK_TEMPLE+2*HK_GAP, z0+HK_BOT+HK_TEMPLE+2*HK_GAP+HK_TOP]]) hull() {
        translate([s*HX, HY, z[0]]) cylinder(r=HK_R, h=z[1]-z[0]);
        translate([s*HX-HK_R, HY+3, z[0]]) cube([2*HK_R, 4-HY+EP_Y0, z[1]-z[0]]);
    }
}
module plate_cuts() {
    for (s=[-1,1]) { z0 = hk_z0(s);
        ztop = z0+HK_BOT+HK_TEMPLE+2*HK_GAP;
        translate([s*HX, HY, ztop-1]) clr(HK_TOP+2);
        translate([s*HX, HY, z0-1]) tap_h(HK_BOT+2);
        translate([s*HX, HY, z0+HK_BOT]) lead_in(0, S_TAP_H);
        translate([s*HX, HY, z0+HK_BOT-0.01]) cylinder(r=HK_R+CLR, h=HK_TEMPLE+2*HK_GAP+0.02);
        translate([s*HX-HK_R-CLR, HY-HK_NECK-6, z0+HK_BOT-0.01]) cube([2*HK_R+2*CLR, HK_NECK+6, HK_TEMPLE+2*HK_GAP+0.02]);
        for (y=RAIL_MAG_Y) translate([s>0 ? RAIL_X1-MAG_T-0.3 : -RAIL_X1-1, y, RAIL_MAG_Z]) rotate([0,90,0]) mag_pocket(MAG_T+1.3);        // magnets in the rail's outer face
        for (y=RAIL_PIN_Y) translate([s>0 ? RAIL_X1-PIN_L-0.4 : -RAIL_X1-1, y, RAIL_PIN_Z]) rotate([0,90,0]) cylinder(d=PIN_D+0.5, h=PIN_L+1.4); // pin holes
        if (s>0) for (x=ARM_SCREWS_X) translate([x, FRONT_T+1, (ARM_Z0+ARM_Z1)/2]) rotate([90,0,0]) { tap(FRONT_T+2); }              // HUD arm screws (tapped, from the front)
    }
    // wires left box -> right box: groove along the back of the bar (z 17..21.5), then per side at a height clear of that side's hinge
    translate([-66, -BAR_BACK-0.1, GROOVE_Z]) cube([132, GROOVE[1]+0.1, GROOVE[0]]);
    translate([62, -BAR_BACK-1, 10]) cube([4, FRONT_T+BAR_BACK+2, GROOVE_Z+GROOVE[0]-10]);           // right: through the plate at x 62..66 (the right hinge sits at z 4..19.6 behind)
    translate([62, FRONT_T-3.5, 10]) cube([RAIL_X1-62+1, 3.6, 4.5]);                                   // right: groove on the FRONT of the end-piece and rail (covered by the HUD arm), z 10..14.5
    translate([-66, -BAR_BACK-0.1, 8]) cube([4, GROOVE[1]+0.1, GROOVE_Z+GROOVE[0]-8]);                // left: jog down at x -66..-62
    translate([-RAIL_X1-1, -BAR_BACK-0.1, 8]) cube([RAIL_X1-62+1, GROOVE[1]+0.1, 4.5]);              // left: z 8..12.5 on the back, below the left hinge (16..31.6), to the rail
}
module plate() difference() { union() { rims(); bar(); nose_pads(); for (s=[-1,1]) end_piece(s); } plate_cuts(); }

// =============================================================== HUD ARM ====
module arm() difference() {
    union() {
        rboxc([ARM_X0, FRONT_T, ARM_Z0], [ARM_X1-ARM_X0, ARM_D, ARM_Z1-ARM_Z0], 1.5);                                // bar y 6..14 along the plate front
        rboxc([EX-14, FRONT_T, ARM_Z0], [28, BEAM_Y+12-FRONT_T, ARM_Z1-ARM_Z0], 1.5);                                // head over the splitter, y 6..35
        translate([LENS_X, BEAM_Y, 0]) rotate([0,90,0]) cylinder(d=LENS_D+2*CLR+3.2, h=LENS_T+2, center=true);       // lens ring
        translate([LENS_X-(LENS_T+2)/2, FRONT_T, 0]) cube([LENS_T+2, BEAM_Y-FRONT_T, ARM_Z1]);                         // ring -> bar web
    }
    translate([LENS_X-(LENS_T+CLR)/2, BEAM_Y, 0]) rotate([0,90,0]) cylinder(d=LENS_D+2*CLR, h=20);                     // lens pocket, open toward +x (lens goes in from the OLED side, glued at 3 points)
    translate([LENS_X-20, BEAM_Y, 0]) rotate([0,90,0]) cylinder(d=LENS_D-4, h=40);                                      // clear aperture through the web
    translate(COMB) rotate([0,0,45]) translate([0, 0, 2]) cube([BS[0]+0.8, BS[2]+0.6, BS[1]+4], center=true);          // splitter slot from below, top edge 4.5 mm inside the head
    translate(COMB) rotate([0,0,45]) translate([0, 0, ARM_Z0]) cube([BS[0]+0.8, BS[2]+2.5, 2.4], center=true);         // slot mouth relief
    for (x=ARM_SCREWS_X) translate([x, FRONT_T+ARM_D+10, (ARM_Z0+ARM_Z1)/2]) rotate([90,0,0]) { clr(30); translate([0,0,10-2.5]) cylinder(d=S_HEAD+0.4, h=5); }   // screw holes + 2.5 mm counterbore from the front
}

// ================================================================= BOXES ====
function box_x0(s) = s>0 ? BOX_X0 : -BOX_X1;
module box_shell(s) rrect_prism([box_x0(s), BOX_Y0, BOX_Z0], [BOX_X1-BOX_X0, BOX_Y1-BOX_Y0, BOX_Z1-BOX_Z0], BOX_R);
module box_cavity(s) translate([box_x0(s)+WALL, BOX_Y0+WALL, BOX_Z0+WALL]) cube([BOX_X1-BOX_X0-2*WALL, BOX_Y1-BOX_Y0-2*WALL, BOX_Z1-BOX_Z0+10]);   // open at the top
module box_common_holders(s) {
    for (y=RAIL_MAG_Y) translate([s>0 ? BOX_X0+WALL-0.01 : -BOX_X0-WALL-MAG_T-0.8+0.01, y, RAIL_MAG_Z]) rotate([0,90,0]) cylinder(d=MAG_D+3.6, h=MAG_T+0.8);   // magnet bosses on the inner wall
    for (y=RAIL_PIN_Y) translate([s>0 ? BOX_X0-PIN_L : -BOX_X0-0.5, y, RAIL_PIN_Z]) rotate([0,90,0]) cylinder(d=PIN_D, h=PIN_L+0.5);                           // locating pins
    for (p=lid_cols(s)) translate([p[0]-3, p[1]-3, BOX_Z0+WALL-0.01]) cube([6, 6, BOX_Z1-LID_T-BOX_Z0-WALL]);
}
module box_common_cuts(s) {
    for (y=RAIL_MAG_Y) translate([s>0 ? BOX_X0-1 : -BOX_X0-MAG_T-0.3, y, RAIL_MAG_Z]) rotate([0,90,0]) mag_pocket(MAG_T+1.3);
    for (p=lid_cols(s)) translate([p[0], p[1], BOX_Z1-LID_T-MAG_T-0.3]) mag_pocket(MAG_T+1);
}
module right_holders() {   // OLED rails on the floor and under the lid, board slides along x (focus)
    for (z=[BOX_Z0+WALL, BOX_Z1-LID_T-1.2]) for (dy=[-1,1]) {
        yc = BEAM_Y + dy*(OLED_PCB[0]/2 + CLR + 0.6);
        translate([OLED_X-3, yc-0.6, z]) cube([OLED_PCB[2]+6, 1.2, 1.2]);
    }
}
module right_cuts() {
    translate([BOX_X0-1, BEAM_Y-7, -6]) cube([WALL+2, 14, 12]);                                                      // beam window in the inner wall
    translate([BOX_X0-1, FRONT_T-3.5, 10]) cube([WALL+2, 3.5, 4.5]);                                                     // wire hole from the front groove of the rail
}
XIAO_Y = BOX_Y1-WALL-XIAO[2]-CLR;      // XIAO stack back face y (camera board against the front wall)
BAT_Y1 = XIAO_Y-3;
BOX_CX_L = -(BOX_X0+BOX_X1)/2;         // left box centre x
module left_holders() {
    for (d=[-1,1]) translate([BOX_CX_L + d*(XIAO[1]/2+CLR+0.6) - 0.6, XIAO_Y-1, BOX_Z0+WALL]) cube([1.2, XIAO[2]+1, 12]);        // XIAO side ribs (board 17.8 across x)
    for (y=[BAT_Y1+CLR, BAT_Y1-BAT[0]-CLR-1.2]) translate([-BOX_X1+WALL, y, BOX_Z0+WALL]) cube([BOX_X1-BOX_X0-2*WALL, 1.2, 8]);  // battery end ribs (battery lies along y)
}
module left_cuts() {
    translate([BOX_CX_L, BOX_Y1-WALL-1, 0]) rotate([-90,0,0]) cylinder(d=7, h=WALL+2);                                 // camera window (position: verify on the board)
    translate([BOX_CX_L, BOX_Y1-WALL-2.6, 0]) rotate([-90,0,0]) cylinder(d=10, h=2.7);                                 // barrel relief
    translate([-BOX_X0-WALL-1, -3, 8]) cube([WALL+2, 4.5, 4.5]);                                                         // wire hole from the back groove of the rail
}
module box(s) difference() {
    union() { difference() { box_shell(s); box_cavity(s); } box_common_holders(s); if (s>0) right_holders(); else left_holders(); }
    box_common_cuts(s); if (s>0) right_cuts(); else left_cuts();
}

// ================================================================== LIDS ====
BTN_X = 93;  BTN_Y = -20;   // button in the right lid, behind the OLED
module lid(s) { x0 = box_x0(s)+WALL; y0 = BOX_Y0+WALL; w = BOX_X1-BOX_X0-2*WALL; d = BOX_Y1-BOX_Y0-2*WALL; z = BOX_Z1-LID_T;
    difference() {
        rboxc([x0+CLR/2, y0+CLR/2, z], [w-CLR, d-CLR, LID_T], 1);
        for (p=lid_cols(s)) translate([p[0], p[1], z-1]) mag_pocket(MAG_T+1.3);
        if (s>0) translate([BTN_X, BTN_Y, z-1]) cylinder(d=4.2, h=LID_T+2);
        if (s<0) translate([-(BOX_X0+BOX_X1)/2-5.25, XIAO_Y+(XIAO[2]-4.5)/2, z-1]) cube([10.5, 4.5, LID_T+2]);      // USB-C up through the lid (verify on the board)
    }
    if (s>0) translate([BTN_X-4.4, BTN_Y-4.4, z-BTN[2]-1.2]) difference() { cube([8.8, 8.8, BTN[2]+1.2]); translate([1.2, 1.2, -1]) cube([6.4, 6.4, BTN[2]+3]); }
}

// =============================================================== TEMPLES ====
function bez(p0,p1,p2,p3,t) = pow(1-t,3)*p0 + 3*pow(1-t,2)*t*p1 + 3*(1-t)*t*t*p2 + pow(t,3)*p3;
module section(w, h, r=1) hull() for (i=[-1,1], k=[-1,1]) translate([i*(w/2-r), 0, k*(h/2-r)]) sphere(r=r, $fn=20);
module temple(s) { hx = s*HX;
    difference() {
        union() {
            translate([hx, HY, 0]) rotate([0,0,s*TEMPLE_SPLAY]) translate([-hx, -HY, 0]) temple_body(s);
            translate([hx, HY, zk0(s)]) cylinder(r1=HK_R-0.5, r2=HK_R, h=0.5);
            translate([hx, HY, zk0(s)+0.5]) cylinder(r=HK_R, h=HK_TEMPLE-1);
            translate([hx, HY, zk0(s)+HK_TEMPLE-0.5]) cylinder(r1=HK_R, r2=HK_R-0.5, h=0.5);
        }
        translate([hx, HY, hk_z0(s)-1]) cylinder(d=HK_BORE, h=HK_BOT+HK_TEMPLE+2*HK_GAP+HK_TOP+3);
        translate([hx, HY, 0]) rotate([0,0,s*TEMPLE_SPLAY]) translate([-hx, -HY, 0])
            translate([s>0 ? hx+KN_FLAT : hx-KN_FLAT-30, HY-200, -60]) cube([30, 400, 160]);
    }
}
module temple_neck(s) { hx = s*HX;
    hull() { translate([hx, HY, zk0(s)]) cylinder(r=HK_R, h=HK_TEMPLE); translate([hx-HK_R, HY-HK_NECK, zk0(s)]) cube([2*HK_R, HK_NECK, HK_TEMPLE]); }
}
module temple_body(s) {
    hx = s*HX; z0 = zk(s);
    drop = z0 - (EAR_Z + ARM_H1/2 + 1);
    p0 = [0, -HK_NECK-6, 0]; p1 = [0, -TEMPLE_L-6, -drop*0.25]; p2 = [0, -TEMPLE_L-26, -drop]; p3 = [-s*HOOK_IN, -TEMPLE_L-34, -drop-HOOK_DROP];
    N = 32;
    difference() {
        union() {
            temple_neck(s);
            hull() { translate([hx-HK_R, HY-HK_NECK, zk0(s)]) cube([2*HK_R, 0.01, HK_TEMPLE]); translate([hx+s*(KN_FLAT-ARM_W0/2), HY-HK_NECK-6, z0]) section(ARM_W0, ARM_H0); }
            for (i=[0:N-1]) hull() for (t=[i/N, (i+1)/N]) { q = bez(p0,p1,p2,p3,t); w = ARM_W0+(ARM_W1-ARM_W0)*t; translate([hx+s*(KN_FLAT-w/2)+q[0], HY+q[1], z0+q[2]]) section(w, ARM_H0+(ARM_H1-ARM_H0)*t); }
            if (SPEAKER && s>0) hull() {
                translate([hx, HY+SPK_Y, z0-7.5]) rotate([0,90,0]) cylinder(d=SPK_D+5, h=ARM_W0, center=true);
                translate([hx, HY+SPK_Y, z0]) section(ARM_W0, ARM_H0);
            }
        }
        if (SPEAKER && s>0) translate([hx-1.1, HY+SPK_Y, z0-1.2]) cube([2.2, -SPK_Y-HK_NECK-3, 2.4]);
        if (SPEAKER && s>0) translate([hx-HK_R-1, HY-HK_NECK-1, z0-1.2]) cube([HK_R-0.1, 4, 2.4]);
        if (SPEAKER && s>0) translate([hx-ARM_W0/2-1, HY+SPK_Y, z0-7.5]) rotate([0,90,0]) cylinder(d=SPK_D+2*CLR, h=SPK_T+CLR+1);
    }
}

// ================================================================ GHOSTS ====
module ghosts() {
    color("blue", 0.7)   translate([OLED_X, BEAM_Y-OLED_PCB[0]/2, -OLED_PCB[1]/2]) cube([OLED_PCB[2], OLED_PCB[0], OLED_PCB[1]]);
    color("cyan", 0.5)   translate([LENS_X, BEAM_Y, 0]) rotate([0,90,0]) cylinder(d=LENS_D, h=LENS_T, center=true);
    color("cyan", 0.4)   translate(COMB) rotate([0,0,45]) cube([BS[0], BS[2], BS[1]], center=true);
    color("yellow", 0.3) translate([EX, BEAM_Y-5.45, -10.85]) cube([OLED_X-EX, 10.9, 21.7]);
    color("yellow", 0.3) translate([EX-10.85, -VD, -5.45]) cube([21.7, BEAM_Y+VD, 10.9]);
    color("gray", 0.7)   translate([BTN_X-3, BTN_Y-3, BOX_Z1-LID_T-BTN[2]-1.2]) cube([6, 6, BTN[2]]);
    color("green", 0.6)  translate([-(BOX_X0+BOX_X1)/2-XIAO[1]/2, XIAO_Y, -XIAO[0]/2]) cube([XIAO[1], XIAO[2], XIAO[0]]);
    color("orange", 0.7) translate([-BOX_X1+WALL+CLR+(BOX_X1-BOX_X0-2*WALL-BAT[2])/2, BAT_Y1-BAT[0], BOX_Z0+WALL]) cube([BAT[2], BAT[0], BAT[1]]);
    color("red", 0.7)    translate([-BOX_X1+WALL+0.5, BOX_Y0+WALL+2, BOX_Z0+WALL]) cube([AMP[1], AMP[0], AMP[2]]);
    color("silver", 0.8) for (s=[-1,1]) for (y=RAIL_MAG_Y) translate([s>0 ? RAIL_X1-MAG_T : -RAIL_X1, y, RAIL_MAG_Z]) rotate([0,90,0]) cylinder(d=MAG_D, h=MAG_T);
}
module head_ghost() %translate([0, -VD, 0]) import(head_file);

// ================================================================ OUTPUT ====
module assembly() {
    color("dimgray") plate();
    color("dimgray") arm();
    color("dimgray") { box(1); box(-1); }
    color("darkslategray") { lid(1); lid(-1); }
    color("dimgray") { temple(1); temple(-1); }
    if (show_parts) ghosts();
    if (show_head) head_ghost();
}
use <screw_coupon.scad>

// ------------------------------------------------------------ test pieces ---
TS = -1;
module test_hinge_front() intersection() { plate(); translate([-RAIL_X1-2, HY-HK_NECK-8, EP_Z0-1]) cube([RAIL_X1-EP_X0+4, FRONT_T-HY+HK_NECK+10, EP_Z1-EP_Z0+2]); }
module test_hinge_temple() { hx = TS*HX;
    difference() {
        union() {
            translate([hx, HY, 0]) rotate([0,0,TS*TEMPLE_SPLAY]) translate([-hx, -HY, 0]) temple_neck(TS);
            translate([hx, HY, zk0(TS)]) cylinder(r1=HK_R-0.5, r2=HK_R, h=0.5);
            translate([hx, HY, zk0(TS)+0.5]) cylinder(r=HK_R, h=HK_TEMPLE-1);
            translate([hx, HY, zk0(TS)+HK_TEMPLE-0.5]) cylinder(r1=HK_R, r2=HK_R-0.5, h=0.5);
        }
        translate([hx, HY, hk_z0(TS)-1]) cylinder(d=HK_BORE, h=HK_BOT+HK_TEMPLE+2*HK_GAP+HK_TOP+3);
    }
}

// ------------------------------------------------------- print orientation ---
module pr_plate()   if (print_orient) translate([0, 0, FRONT_T]) rotate([-90,0,0]) plate(); else plate();                      // front face down; pads, knuckles and rails up
module pr_arm()     if (print_orient) translate([0, 0, -FRONT_T]) rotate([90,0,0]) arm(); else arm();                          // back face (plate side) down; ring and splitter head stand up
module pr_box(s)    if (print_orient) translate([0, 0, -BOX_Z0]) box(s); else box(s);                                            // open top up
module pr_lid(s)    if (print_orient) translate([0, 0, BOX_Z1]) rotate([180,0,0]) lid(s); else lid(s);
module pr_temple(s) if (print_orient) translate([0, 0, HX+KN_FLAT]) rotate([0, s*90, 0]) translate([s*HX, HY, 0]) rotate([0,0,-s*TEMPLE_SPLAY]) translate([-s*HX, -HY, 0]) temple(s); else temple(s);
module pr_test_front()  if (print_orient) translate([0, 0, FRONT_T]) rotate([-90,0,0]) test_hinge_front(); else test_hinge_front();
module pr_test_temple() if (print_orient) translate([0, 0, -zk0(TS)]) translate([TS*HX, HY, 0]) rotate([0,0,-TS*TEMPLE_SPLAY]) translate([-TS*HX, -HY, 0]) test_hinge_temple(); else test_hinge_temple();

if (part == "plate") pr_plate();
else if (part == "arm") pr_arm();
else if (part == "box_r") pr_box(1);
else if (part == "box_l") pr_box(-1);
else if (part == "lid_r") pr_lid(1);
else if (part == "lid_l") pr_lid(-1);
else if (part == "temple_r") pr_temple(1);
else if (part == "temple_l") pr_temple(-1);
else if (part == "test_hinge_front") pr_test_front();
else if (part == "test_hinge_temple") pr_test_temple();
else if (part == "test_plate") { screw_coupon(); translate([150, 32, 0]) pr_test_front(); translate([178, 24, 0]) pr_test_temple(); }
else if (part == "fit") { %plate(); %arm(); %box(1); %box(-1); ghosts(); }
else if (part == "fold") { %plate(); %arm(); %box(1); %box(-1); for (s=[-1,1]) color("orange") translate([s*HX, HY, 0]) rotate([0,0,-s*FOLD]) translate([-s*HX, -HY, 0]) temple(s); }
else if (part == "exploded") { color("dimgray") plate(); color("dimgray") translate([0, 25, 0]) arm(); color("dimgray") for (s=[-1,1]) translate([s*20, 0, 0]) box(s); color("darkslategray") for (s=[-1,1]) translate([s*20, 0, 18]) lid(s); for (s=[-1,1]) color("dimgray") translate([0, -20, -14]) temple(s); }
else assembly();
