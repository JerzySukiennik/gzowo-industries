// Screw tolerance coupon for M2.5x12 DIN 912 in PLA (glass.scad uses S_TAP=2.4, S_CLR=2.9).
// Two rows of holes, each labelled with its diameter in 1/10 mm:
//   TAP row (8 mm deep, blind, like the hinge bottom knuckle and lid bosses):
//     the screw must cut its own thread. Pick the LARGEST hole that still holds firmly.
//   CLR row (through, 5 mm thick, like the lid holes and temple knuckle):
//     the screw must pass and turn freely. Pick the SMALLEST hole that slides without forcing.
// Print flat, no supports, same profile as the glasses (0.2 mm, 3 walls).
$fn = 32;
TAP = [2.1, 2.2, 2.3, 2.4, 2.5, 2.6];
CLR = [2.6, 2.7, 2.8, 2.9, 3.0, 3.1];
P = 9;          // pitch between holes
T_TAP = 10;     // block height for tapped holes (8 mm hole depth + 2 mm floor)
T_CLR = 5;      // plate thickness for clearance holes

// pips instead of text (headless OpenSCAD has no fonts): n dots = position from the left, 1..6
module pips(n, x, y, z) for (k = [0:n-1]) translate([x - (n-1)*0.9 + 1.8*k, y, z]) cylinder(d=1, h=1);

module screw_coupon() difference() {
  union() {
    translate([0, 0, 0]) cube([P * len(TAP) + 4, 12, T_TAP]);      // tap block
    translate([0, 14, 0]) cube([P * len(CLR) + 4, 12, T_CLR]);     // clearance plate
  }
  for (i = [0:len(TAP) - 1]) translate([4 + P * i + P / 2 - 2.5, 6, T_TAP - 8]) cylinder(d=TAP[i], h=9);
  for (i = [0:len(CLR) - 1]) translate([4 + P * i + P / 2 - 2.5, 20, -1]) cylinder(d=CLR[i], h=T_CLR + 2);
  // pips: dots count = position from the left (1..6); hole diameters grow left to right
  for (i = [0:len(TAP) - 1]) pips(i + 1, 4 + P * i + P / 2 - 2.5, 2.2, T_TAP - 0.6);
  for (i = [0:len(CLR) - 1]) pips(i + 1, 4 + P * i + P / 2 - 2.5, 24.2, T_CLR - 0.6);
  // one long groove marks the TAP block (blind holes), so the two rows cannot be confused
  translate([2, 10.5, T_TAP - 0.6]) cube([P * len(TAP), 0.8, 1]);
}

screw_coupon();
