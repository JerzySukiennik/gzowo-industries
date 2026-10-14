// Gzowo Glass v0.7 — print-ready parametric frame (OpenSCAD 2021.01)
// ---------------------------------------------------------------------------
// Frame of reference (mm): X = wearer's right, Y = forward (away from the
// face), Z = up. The right pupil axis is the line (PD/2, *, 0). The back face
// of the front plate is the plane y = 0; the cornea sits at y = -VD.
//
// v0.7 after the first full print of v0.6 (2026-10-12, see do-druku/00-START.md):
//   * NO SIDE PODS. Two symmetric "brows" sit on the front of the plate above
//     the eyes: the RIGHT brow is the optics hood (OLED, mirror, lens, splitter
//     below), the LEFT brow holds the electronics (XIAO with the camera looking
//     forward, battery, amp). Button in the right lid. Hinges move to the plate
//     corners (axis x = +-72), so the temples run along the head instead of
//     20 mm outside it.
//   * The front is SPLIT for printing: plate (rims, bridge, nose pads, bar,
//     end-pieces with the hinge knuckles) + 2 brows + 2 lids + 2 temples. The
//     brows are screwed to the plate from the back (2 x M2.5x12 each). After a
//     nose/fit change only the plate (~2 h) is reprinted.
//   * Keyhole bridge: the rim edges follow the nose (scan), the frame rests on
//     real nose pads 4 mm behind the plate. Hinge lowered to z 4..20 and the
//     temples slope down to the ear; temples 17 mm longer (bend crest on the ear).
//   * Hinge stop: a fin on each end-piece blocks the temple from opening past
//     its rest angle. Speaker wires: short open loop on the inside of the hinge.
//   * Wire route: left brow -> hole in the plate -> groove on the back of the
//     bridge bar -> hole -> hood; hood -> hole -> groove -> hinge -> right temple.
//   * Hinge, screws, OLED slide, mirror ribs, lens floor, splitter slot: as v0.6
//     (tested: tap 2.3 bridged / 2.1 open, clearance 3.0, temple bore 2.8).
// ---------------------------------------------------------------------------

FOLD = 80;            // fold angle for part="fold" (temples swing inward, behind the plate)
part = "assembly";    // plate | brow_r | brow_l | lid_r | lid_l | temple_r | temple_l | test_hinge_front | test_hinge_temple | test_plate | assembly | fit | fold | exploded
print_orient = false; // true: every part is exported already in its print orientation (z = 0 on the bed)
show_parts = true;    // ghost electronics/optics in assembly/fit
show_head = true;     // ghost of Jurek's head scan (reference/head2-mm.stl)
head_file = "../reference/head2-mm.stl";
$fn = 48;

// ------------------------------------------------------------ head / fit ---
PD       = 62;     // pupil distance (provisional; scan scaled to this)
VD       = 21;     // vertex distance: cornea -> plate back
EX       = PD/2;
PAD_X    = 11.5;   // nose pad face centre x (scan: nose flank half-width 4 mm behind the plate is 9.6 @ z-10, 11.7 @ z-14, 13.3 @ z-16)
PAD_Z    = -14;    // nose pad centre z
PAD_ANG  = 38;     // pad face angle about Z (deg): face points outward-and-forward like the nose flank
PAD_TILT = 20;     // pad face tilt about X (deg): flank leans back toward the eye
EAR_Z    = -4;     // ear top z (scan landmark)
EAR_Y    = -108;   // ear top y (scan: 87 mm behind the cornea)
TEMPLE_SPLAY = 7;  // deg, temples open OUTWARD from the hinge (hinge x 72 -> ear x 85 over 100 mm)

// ------------------------------------------------------- component sizes ---
XIAO     = [21, 17.8, 15];      // XIAO ESP32-S3 Sense stack incl. camera board (long, wide, stack height)
OLED_PCB = [27.3, 27.3, 4.3];   // 0.96" I2C module board (w, h, thickness incl. pins). Active area 21.7x10.9.
AMP      = [19.4, 17.8, 3.2];   // MAX98357 breakout
SPK_D    = 20;  SPK_T = 3.6;    // speaker
BS       = [25, 25, 1.1];       // beam splitter plate
MIR      = [30, 30, 1.6];       // first-surface mirror, 1 pc
LENS_D   = 30;  LENS_T = 6.5;   // biconvex f=50
BTN      = [6, 6, 5];           // tact switch body
BAT      = [40, 20, 8];         // battery (long, tall, thick): edit when the cell is known
S_TAP    = 2.1;  S_CLR = 3.0;  S_HEAD = 5.4;  // M2.5x12 in PLA, measured on the coupon 2026-10-05
S_TAP_H  = 2.3;                 // tapped hole printed horizontally or over a bridge (tested on the hinge)
CLR      = 0.4;  WALL = 1.6;

// ---------------------------------------------------------------- layout ---
FRONT_T  = 6;                  // plate depth (y 0..6)
BAR_Z0   = 6;   BAR_Z1 = 22;   // brow bar z-range (plate)
BAR_BACK = 3;                  // the bar is thickened to the back (y -3..0) where the wire groove runs
GROOVE   = [4.5, 3.5];         // wire groove h (z) x depth (y) on the back of the bar
GROOVE_Z = 17;                 // groove z0 (z 17..21.5)
WIRE_X   = 17;                 // wire holes through the plate into the brows at x = +-17
SPK_WIRE_X = 56;               // speaker wire hole through the plate behind the hood (between the mirror and the OLED)
// brows: x 13..68 mirrored, in front of the plate
BROW_X0  = 13;  BROW_X1 = 73;   // 60 long: the OLED slide (60..66 + 4.3 board) stays inside the hood
BROW_Y0  = FRONT_T;  BROW_Y1 = 42;   // y 6..42 (36 deep)
BROW_Z0  = 4;   BROW_Z1 = 40;        // z 4..40 (36 tall: the flush lid clears the upper OLED rail)
BROW_R   = 4;                        // corner radius
// optics in the right brow
BEAM_Z   = 22;                 // optical axis height
AX_Y     = BROW_Y0 + 2 + LENS_D/2 + CLR;   // optical axis y = 23.4 (lens pocket leaves a 2 mm wall to the plate)
MIR_C    = [EX, AX_Y, BEAM_Z]; // mirror centre; plane at 45° about Y turns the -X beam to -Z
LENS_Z   = 13.4;               // lens centre z
COMB     = [EX, AX_Y, 0];      // splitter centre on the pupil axis, tilted 45° about X, top toward +Y
OLED_X0  = 60;  OLED_X1 = 66;  // OLED slide range (screen face x): do = (x-EX) + (BEAM_Z-LENS_Z) = 37.6..43.6
OLED_X   = 63;
// brow screws (from the back of the plate into bosses on the brow back wall), [x, z]
BROW_SCREWS_R = [[16.5, 10], [50, 10]];
BROW_SCREWS_L = [[-16.5, 10], [-40, 10]];
// end-pieces and hinge: axis x = +-72, y = -7; knuckle stack z 4..19.6 (bottom 8 tapped, temple 5, top 2, gaps 0.3)
EP_X0 = 66;  EP_X1 = 81;  EP_Y0 = -2;  EP_Z0 = 0;  EP_Z1 = 22;
HX = 72;  HY = -7;
HK_Z0 = 4; HK_BOT = 8; HK_TEMPLE = 5; HK_TOP = 2; HK_GAP = 0.3;
HK_BORE = 2.8;  HK_R = 5;  HK_NECK = 12;
FIN_T = 3;                     // hinge stop fin thickness (outside the temple neck)
TEMPLE_W = 12;  TEMPLE_H = 14;
TEMPLE_L = 80;                 // hinge -> start of the ear bend (bend crest lands on the ear top)
LID_T    = 2.4;

function zk0() = HK_Z0 + HK_BOT + HK_GAP;
function zk()  = zk0() + HK_TEMPLE/2;

// --------------------------------------------------------------- helpers ---
module rbox(size, r=2) { hull() for (i=[-1,1], j=[-1,1], k=[-1,1]) translate([i*(size[0]/2-r), j*(size[1]/2-r), k*(size[2]/2-r)]) sphere(r=r, $fn=40); }
module rboxc(p, size, r=2) translate(p + size/2) rbox(size, r);
module plate2d(d) rotate([90,0,0]) translate([0,0,-d]) linear_extrude(height=d) children(); // 2D (x,z) -> +y 0..d
module lens2d(mir=false) scale([mir ? -1 : 1, 1]) offset(r=3) offset(r=-3)
    polygon([[9,6],[54,6],[56,-3],[52,-17],[42,-24],[26,-25],[20,-20],[14,-14],[9,-5]]);   // keyhole bridge: the inner edge follows the nose
module tap(l)  cylinder(d=S_TAP, h=l);
module tap_h(l) cylinder(d=S_TAP_H, h=l);
module lead_in(z, d) translate([0, 0, z-0.65]) cylinder(d1=d, d2=d+1.3, h=0.66);
module clr(l)  cylinder(d=S_CLR, h=l);
function brow_x0(s) = s>0 ? BROW_X0 : -BROW_X1;
function brow_screws(s) = s>0 ? BROW_SCREWS_R : BROW_SCREWS_L;
function lid_boss_pts(s) = s>0 ? [[17, BROW_Y0+WALL+3], [50, BROW_Y0+WALL+3], [17, BROW_Y1-WALL-3], [50, BROW_Y1-WALL-3]]
                             : [[-BROW_X1+WALL+2.5, BROW_Y0+WALL+3], [-BROW_X0-WALL-2.5, BROW_Y0+WALL+3], [-BROW_X1+WALL+2.5, BROW_Y1-WALL-3], [-BROW_X0-WALL-2.5, BROW_Y1-WALL-3]];

// ================================================================= PLATE ====
module rims() difference() {
    for (m=[false,true]) plate2d(FRONT_T) offset(r=5) lens2d(m);
    for (m=[false,true]) { translate([0,-1,0]) plate2d(FRONT_T+2) lens2d(m); translate([0,-1,0]) plate2d(3.4) offset(r=1) lens2d(m); }   // opening + 2.4 mm rebate for the tinted lens
}
module bar() rboxc([-EP_X1+2, -BAR_BACK, BAR_Z0], [2*EP_X1-4, FRONT_T+BAR_BACK, BAR_Z1-BAR_Z0], 2.5);
module nose_pads() for (s=[-1,1]) hull() {
    translate([s*PAD_X, -3.5, PAD_Z]) rotate([PAD_TILT, 0, s*PAD_ANG]) rbox([3, 8, 14], 1.2);         // pad face, centred 3.5 mm behind the plate
    translate([s*(PAD_X-2.5), 2.5, PAD_Z+2]) rbox([4, 5, 10], 1);                                      // root in the rim band
}
module end_piece(s) {
    translate([s*HX, HY, 0]) rotate([0,0,s*TEMPLE_SPLAY]) translate([-s*HX, -HY, 0])
        rboxc([s>0 ? HX+HK_R+0.6 : -HX-HK_R-0.6-FIN_T, HY-HK_NECK-1, HK_Z0], [FIN_T, EP_Y0-(HY-HK_NECK-1), HK_BOT+HK_TEMPLE+2*HK_GAP+HK_TOP], 1);   // stop fin
    rboxc([s>0 ? EP_X0 : -EP_X1, EP_Y0, EP_Z0], [EP_X1-EP_X0, FRONT_T-EP_Y0, EP_Z1-EP_Z0], 3);
    for (z=[[HK_Z0, HK_Z0+HK_BOT], [HK_Z0+HK_BOT+HK_TEMPLE+2*HK_GAP, HK_Z0+HK_BOT+HK_TEMPLE+2*HK_GAP+HK_TOP]]) hull() {
        translate([s*HX, HY, z[0]]) cylinder(r=HK_R, h=z[1]-z[0]);
        translate([s*HX-HK_R, HY+3, z[0]]) cube([2*HK_R, 4-HY+EP_Y0, z[1]-z[0]]);   // knuckle block reaches into the end-piece
    }
}
module plate_cuts() {
    for (s=[-1,1]) {
        ztop = HK_Z0+HK_BOT+HK_TEMPLE+2*HK_GAP;
        translate([s*HX, HY, ztop-1]) clr(HK_TOP+2);
        translate([s*HX, HY, HK_Z0-1]) tap_h(HK_BOT+2);
        translate([s*HX, HY, HK_Z0+HK_BOT]) lead_in(0, S_TAP_H);
        translate([s*HX, HY, HK_Z0+HK_BOT-0.01]) cylinder(r=HK_R+CLR, h=HK_TEMPLE+2*HK_GAP+0.02);          // free swing for the temple knuckle
        translate([s*HX-HK_R-CLR, HY-HK_NECK-6, HK_Z0+HK_BOT-0.01]) cube([2*HK_R+2*CLR, HK_NECK+6, HK_TEMPLE+2*HK_GAP+0.02]);   // slot open to the back
        for (p=brow_screws(s)) translate([p[0], -BAR_BACK-1, p[1]]) rotate([-90,0,0]) { clr(FRONT_T+BAR_BACK+2); cylinder(d=S_HEAD+0.4, h=4); }  // through hole + 3 mm counterbore on the bar back
        translate([s*WIRE_X-1.75, -BAR_BACK-1, GROOVE_Z]) cube([3.5, FRONT_T+BAR_BACK+2, GROOVE[0]]);          // wire hole plate -> brow
    }
    translate([-WIRE_X, -BAR_BACK-0.1, GROOVE_Z]) cube([2*WIRE_X, GROOVE[1]+0.1, GROOVE[0]]);                // groove behind the bridge
    translate([SPK_WIRE_X-1.75, -BAR_BACK-1, GROOVE_Z]) cube([3.5, FRONT_T+BAR_BACK+2, GROOVE[0]]);            // speaker wire hole behind the hood
    translate([SPK_WIRE_X-1.75, -BAR_BACK-0.1, GROOVE_Z]) cube([EP_X0-SPK_WIRE_X+1.75, GROOVE[1]+0.1, GROOVE[0]]);   // groove to the end-piece
}
module plate() difference() { union() { rims(); bar(); nose_pads(); for (s=[-1,1]) end_piece(s); } plate_cuts(); }

// ================================================================= BROWS ====
module brow_shell(s) rboxc([brow_x0(s), BROW_Y0, BROW_Z0], [BROW_X1-BROW_X0, BROW_Y1-BROW_Y0, BROW_Z1-BROW_Z0], BROW_R);
module brow_cavity(s) translate([brow_x0(s)+WALL, BROW_Y0+WALL, BROW_Z0+WALL]) cube([BROW_X1-BROW_X0-2*WALL, BROW_Y1-BROW_Y0-2*WALL, BROW_Z1]);   // open at the top
module brow_common_holders(s) {
    for (p=brow_screws(s)) translate([p[0], BROW_Y0, p[1]]) rotate([-90,0,0]) cylinder(d=6.5, h=7.5);            // screw bosses on the back wall (y 6..13.5)
    for (p=lid_boss_pts(s)) translate([p[0]-2.5, p[1]-2.5, BROW_Z1-LID_T-10]) cube([5, 5, 10]);                  // lid bosses, top at Z1-LID_T (flush lid)
}
module brow_common_cuts(s) {
    for (p=brow_screws(s)) translate([p[0], BROW_Y0-1, p[1]]) rotate([-90,0,0]) tap_h(8);
    for (p=lid_boss_pts(s)) translate([p[0], p[1], BROW_Z1-LID_T-9]) { tap(10); lead_in(9, S_TAP); }
    translate([s*WIRE_X-1.75, BROW_Y0-1, GROOVE_Z]) cube([3.5, WALL+2, GROOVE[0]]);                              // wire hole through the back wall
}
module hood_holders() {
    for (y=[BROW_Y0+WALL, BROW_Y1-WALL-1.2]) for (dz=[-1,1]) {                                                    // OLED rails on the front and back walls
        zc = BEAM_Z + dz*(OLED_PCB[1]/2 + CLR + 0.6);
        translate([OLED_X0-3, y, zc-0.6]) cube([min(OLED_X1-OLED_X0+OLED_PCB[2]+4, BROW_X1-WALL-(OLED_X0-3)), 1.2, 1.2]);
    }
    for (y=[BROW_Y0+WALL+0.6, BROW_Y1-WALL-0.6]) for (d=[-1,1])                                                   // mirror ribs along the 45° plane
        translate([MIR_C[0], y, MIR_C[2]]) rotate([0,-45,0]) translate([0, 0, d*(MIR[2]/2+CLR+0.6)]) cube([MIR[0]+2, 1.2, 1.2], center=true);
    translate([EX, AX_Y, BROW_Z0]) cylinder(d=LENS_D+2*CLR+2.4, h=LENS_Z-LENS_T/2-CLR-BROW_Z0);                   // lens floor boss
}
module hood_cuts() {
    translate([EX, AX_Y, LENS_Z-LENS_T/2-CLR]) cylinder(d=LENS_D+2*CLR, h=BROW_Z1);                                // lens pocket from above
    translate([EX-11, AX_Y-7, BROW_Z0-1]) cube([22, 14, LENS_Z]);                                                   // beam window 22x14
    translate(COMB) rotate([-45,0,0]) cube([BS[0]+0.8, BS[2]+0.6, BS[1]+6], center=true);                          // splitter slot through the floor
    translate(COMB) rotate([-45,0,0]) translate([0, -(BS[2]+0.6)/2-1.5, 0]) cube([BS[0]+0.8, 3, BS[1]+6], center=true);
    translate([SPK_WIRE_X-1.75, BROW_Y0-1, GROOVE_Z]) cube([3.5, WALL+2, GROOVE[0]]);                              // speaker wire hole through the back wall
}
module left_holders() {
    // XIAO stands against the front wall (camera looking forward) at the outer end, between two ribs
    for (d=[-1,1]) translate([XIAO_CX + d*(XIAO[0]/2+CLR+0.6) - 0.6, BROW_Y1-WALL-XIAO[2]-2*CLR-1, BROW_Z0+WALL]) cube([1.2, XIAO[2]+2*CLR+1, 12]);
    // battery stands against the back wall on a shelf above the screw bosses, between two ribs (wires run underneath)
    translate([BAT_CX-BAT[0]/2-1.4, BROW_Y0+WALL, BAT_Z0-1.2]) cube([BAT[0]+2.8, BAT[2]+2*CLR+1.2, 1.2]);
    for (d=[-1,1]) translate([BAT_CX + d*(BAT[0]/2+CLR+0.6) - 0.6, BROW_Y0+WALL, BAT_Z0-1.2]) cube([1.2, BAT[2]+2*CLR+1.2, 14]);
}
XIAO_CX = -(BROW_X1-WALL-CLR-XIAO[0]/2-1.2);   // XIAO centre x (outer end of the left brow)
BAT_CX  = -(BROW_X0+WALL+2.5+2.5+CLR+BAT[0]/2+0.6);   // battery centre x: between the two back lid bosses
BAT_Z0  = 14;                                         // battery bottom z (above the brow screw bosses)
module left_cuts() {
    translate([XIAO_CX, BROW_Y1-WALL-1, BROW_Z0+WALL+XIAO[1]/2+2]) rotate([-90,0,0]) cylinder(d=7, h=WALL+2);     // camera window (position: verify on the board)
    translate([XIAO_CX, BROW_Y1-WALL-2.6, BROW_Z0+WALL+XIAO[1]/2+2]) rotate([-90,0,0]) cylinder(d=10, h=2.7);     // barrel relief inside
    translate([-BROW_X1-1, BROW_Y1-WALL-XIAO[2]-CLR+ (XIAO[2]-4.5)/2, BROW_Z0+WALL+XIAO[1]/2+2-5.25]) cube([WALL+2, 4.5, 10.5]);   // USB-C through the outer end wall (verify on the board)
}
module brow(s) difference() {
    union() { difference() { brow_shell(s); brow_cavity(s); } brow_common_holders(s); if (s>0) hood_holders(); else left_holders(); }
    brow_common_cuts(s); if (s>0) hood_cuts(); else left_cuts();
}

// ================================================================== LIDS ====
module lid(s) { x0 = brow_x0(s)+WALL; y0 = BROW_Y0+WALL; w = BROW_X1-BROW_X0-2*WALL; d = BROW_Y1-BROW_Y0-2*WALL; z = BROW_Z1-LID_T;
    difference() {
        rboxc([x0+CLR/2, y0+CLR/2, z], [w-CLR, d-CLR, LID_T], 1);
        for (p=lid_boss_pts(s)) translate([p[0], p[1], z-1]) { clr(LID_T+2); translate([0,0,LID_T+1-1.2]) cylinder(d=S_HEAD+0.4, h=2); }   // countersunk 1.2 mm
        if (s>0) translate([BTN_X, BTN_Y, z-1]) cylinder(d=4.2, h=LID_T+2);                                        // button actuator hole
    }
    if (s>0) translate([BTN_X-4.4, BTN_Y-4.4, z-BTN[2]-1.2]) difference() { cube([8.8, 8.8, BTN[2]+1.2]); translate([1.2, 1.2, -1]) cube([6.4, 6.4, BTN[2]+3]); }   // button cage under the lid
}
BTN_X = 52;  BTN_Y = 26;   // button in the right lid: between the mirror (x<=42) and the OLED (x>=60), clear of the lid bosses

// =============================================================== TEMPLES ====
function bez(p0,p1,p2,p3,t) = pow(1-t,3)*p0 + 3*pow(1-t,2)*t*p1 + 3*(1-t)*t*t*p2 + pow(t,3)*p3;
module temple(s) {
    hx = s*HX;
    difference() {
        union() {
            translate([hx, HY, 0]) rotate([0,0,s*TEMPLE_SPLAY]) translate([-hx, -HY, 0]) temple_body(s);
            translate([hx, HY, zk0()]) cylinder(r1=HK_R-0.5, r2=HK_R, h=0.5);
            translate([hx, HY, zk0()+0.5]) cylinder(r=HK_R, h=HK_TEMPLE-1);
            translate([hx, HY, zk0()+HK_TEMPLE-0.5]) cylinder(r1=HK_R, r2=HK_R-0.5, h=0.5);
        }
        translate([hx, HY, HK_Z0-1]) cylinder(d=HK_BORE, h=HK_BOT+HK_TEMPLE+2*HK_GAP+HK_TOP+3);   // bore cut LAST through everything
    }
}
module temple_neck(s) { hx = s*HX;
    hull() { translate([hx, HY, zk0()]) cylinder(r=HK_R, h=HK_TEMPLE); translate([hx-HK_R, HY-HK_NECK, zk0()]) cube([2*HK_R, HK_NECK, HK_TEMPLE]); }
}
module temple_body(s) {
    hx = s*HX; z0 = zk();
    drop = z0 - (EAR_Z + 6);                                 // the arm's underside at the bend crest sits on the ear top
    p0 = [0, -HK_NECK-8, 0]; p1 = [0, -TEMPLE_L-8, -drop*0.35]; p2 = [0, -TEMPLE_L-24, -drop]; p3 = [0, -TEMPLE_L-38, -drop-24];
    N = 28;
    difference() {
        union() {
            temple_neck(s);
            hull() { translate([hx-HK_R, HY-HK_NECK, zk0()]) cube([2*HK_R, 0.01, HK_TEMPLE]); translate([hx, HY-HK_NECK-8, z0]) scale([TEMPLE_W/2, 4, TEMPLE_H/2]) sphere(r=1, $fn=24); }
            for (i=[0:N-1]) hull() for (t=[i/N, (i+1)/N]) { q = bez(p0,p1,p2,p3,t); k = 1 - 0.4*t; translate([hx, HY+q[1], z0+q[2]]) scale([TEMPLE_W/2*k, 4, TEMPLE_H/2*k]) sphere(r=1, $fn=24); }
            if (s>0) translate([hx-TEMPLE_W/2-1, HY-TEMPLE_L+16, z0-1]) rotate([0,90,0]) cylinder(d=SPK_D+4, h=7.5);   // speaker boss, head side
        }
        translate([hx-1.5, HY-TEMPLE_L+10, z0-1.5]) cube([3, TEMPLE_L-10-HK_NECK+3, 3]);                 // wire channel along the arm, ends 9 mm behind the axis
        translate([s>0 ? hx-HK_R-1 : hx+1.5, HY-HK_NECK-1, z0-1.5]) cube([HK_R-0.5, 4, 3]);                   // ...and opens on the INNER face of the neck (wire loop to the end-piece)
        if (s>0) { cy = HY-TEMPLE_L+16;
            translate([hx-TEMPLE_W/2-2.2, cy, z0-1]) rotate([0,90,0]) cylinder(d=SPK_D+2*CLR, h=SPK_T+CLR+0.8+2);   // speaker pocket, open toward the head
            for (a=[0:45:315]) translate([hx-TEMPLE_W/2-2, cy+6*cos(a), z0-1+6*sin(a)]) rotate([0,90,0]) cylinder(d=1.6, h=4);
            translate([hx-TEMPLE_W/2-2, cy, z0-1]) rotate([0,90,0]) cylinder(d=1.6, h=4);
        }
    }
}

// ================================================================ GHOSTS ====
module ghosts() {
    color("blue", 0.7)   translate([OLED_X, AX_Y-OLED_PCB[0]/2, BEAM_Z-OLED_PCB[1]/2]) cube([OLED_PCB[2], OLED_PCB[0], OLED_PCB[1]]);
    color("silver", 0.9) translate(MIR_C) rotate([0,-45,0]) cube([MIR[2], MIR[0], MIR[1]], center=true);
    color("cyan", 0.5)   translate([EX, AX_Y, LENS_Z]) cylinder(d=LENS_D, h=LENS_T, center=true);
    color("cyan", 0.4)   translate(COMB) rotate([-45,0,0]) cube([BS[0], BS[2], BS[1]], center=true);
    color("yellow", 0.3) translate([EX, AX_Y-5.45, BEAM_Z-10.85]) cube([OLED_X-EX, 10.9, 21.7]);
    color("yellow", 0.3) translate([EX-10.85, AX_Y-5.45, 0]) cube([21.7, 10.9, BEAM_Z]);
    color("yellow", 0.3) translate([EX-10.85, -VD, -5.45]) cube([21.7, AX_Y+VD, 10.9]);
    color("gray", 0.7)   translate([BTN_X-3, BTN_Y-3, BROW_Z1-LID_T-BTN[2]-1.2]) cube([6, 6, BTN[2]]);
    color("green", 0.6)  translate([XIAO_CX-XIAO[0]/2, BROW_Y1-WALL-XIAO[2]-CLR, BROW_Z0+WALL+2]) cube([XIAO[0], XIAO[2], XIAO[1]]);
    color("orange", 0.7) translate([BAT_CX-BAT[0]/2, BROW_Y0+WALL+CLR, BAT_Z0]) cube([BAT[0], BAT[2], BAT[1]]);
    color("red", 0.7)    translate([-44, BROW_Y0+WALL+BAT[2]+2*CLR+3, BROW_Z0+WALL]) cube([AMP[0], AMP[1], AMP[2]]);   // amp flat on the floor, middle
    translate([HX, HY, 0]) rotate([0,0,TEMPLE_SPLAY]) translate([-HX, -HY, 0])
        color("gray", 0.7) translate([HX-TEMPLE_W/2, HY-TEMPLE_L+16, zk()-1]) rotate([0,90,0]) cylinder(d=SPK_D, h=SPK_T);
}
module head_ghost() %translate([0, -VD, 0]) import(head_file);

// ================================================================ OUTPUT ====
module assembly() {
    color("dimgray") plate();
    color("dimgray") { brow(1); brow(-1); }
    color("darkslategray") { lid(1); lid(-1); }
    color("dimgray") { temple(1); temple(-1); }
    if (show_parts) ghosts();
    if (show_head) head_ghost();
}
use <screw_coupon.scad>

// ------------------------------------------------------------ test pieces ---
TS = -1;   // test pieces use the LEFT hinge
module test_hinge_front() intersection() { plate(); translate([-EP_X1-2, HY-HK_NECK-8, EP_Z0-1]) cube([EP_X1-EP_X0+4, FRONT_T-HY+HK_NECK+10, EP_Z1-EP_Z0+2]); }
module test_hinge_temple() { hx = TS*HX;
    difference() {
        union() {
            translate([hx, HY, 0]) rotate([0,0,TS*TEMPLE_SPLAY]) translate([-hx, -HY, 0]) temple_neck(TS);
            translate([hx, HY, zk0()]) cylinder(r1=HK_R-0.5, r2=HK_R, h=0.5);
            translate([hx, HY, zk0()+0.5]) cylinder(r=HK_R, h=HK_TEMPLE-1);
            translate([hx, HY, zk0()+HK_TEMPLE-0.5]) cylinder(r1=HK_R, r2=HK_R-0.5, h=0.5);
        }
        translate([hx, HY, HK_Z0-1]) cylinder(d=HK_BORE, h=HK_BOT+HK_TEMPLE+2*HK_GAP+HK_TOP+3);
    }
}

// ------------------------------------------------------- print orientation ---
module pr_plate()   if (print_orient) translate([0, 0, FRONT_T]) rotate([-90,0,0]) plate(); else plate();          // front face on the bed, pads and knuckles up
module pr_brow(s)   if (print_orient) translate([0, 0, -BROW_Z0]) brow(s); else brow(s);                              // open top up
module pr_lid(s)    if (print_orient) translate([0, 0, BROW_Z1]) rotate([180,0,0]) lid(s); else lid(s);               // outer face on the bed, cage up
module pr_temple(s) if (print_orient) translate([0, 0, HX+TEMPLE_W/2]) rotate([0, s*90, 0]) translate([s*HX, HY, 0]) rotate([0,0,-s*TEMPLE_SPLAY]) translate([-s*HX, -HY, 0]) temple(s); else temple(s);   // on its outer side, speaker pocket up
module pr_test_front()  if (print_orient) translate([0, 0, FRONT_T]) rotate([-90,0,0]) test_hinge_front(); else test_hinge_front();
module pr_test_temple() if (print_orient) translate([0, 0, -zk0()]) translate([TS*HX, HY, 0]) rotate([0,0,-TS*TEMPLE_SPLAY]) translate([-TS*HX, -HY, 0]) test_hinge_temple(); else test_hinge_temple();

if (part == "plate") pr_plate();
else if (part == "brow_r") pr_brow(1);
else if (part == "brow_l") pr_brow(-1);
else if (part == "lid_r") pr_lid(1);
else if (part == "lid_l") pr_lid(-1);
else if (part == "temple_r") pr_temple(1);
else if (part == "temple_l") pr_temple(-1);
else if (part == "test_hinge_front") pr_test_front();
else if (part == "test_hinge_temple") pr_test_temple();
else if (part == "test_plate") { screw_coupon(); translate([150, 32, 0]) pr_test_front(); translate([178, 24, 0]) pr_test_temple(); }
else if (part == "fit") { %plate(); %brow(1); %brow(-1); ghosts(); }
else if (part == "fold") { %plate(); %brow(1); %brow(-1); for (s=[-1,1]) color("orange") translate([s*HX, HY, 0]) rotate([0,0,-s*FOLD]) translate([-s*HX, -HY, 0]) temple(s); }
else if (part == "exploded") { color("dimgray") plate(); color("dimgray") translate([0, 30, 0]) { brow(1); brow(-1); } color("darkslategray") translate([0, 30, 18]) { lid(1); lid(-1); } for (s=[-1,1]) color("dimgray") translate([s*14, -28, 0]) temple(s); }
else assembly();
