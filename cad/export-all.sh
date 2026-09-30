#!/bin/bash
# Export every printable part of glass.scad to cad/stl/ (print orientation: the front is exported upside down,
# rim on the bed). The folder is a BUILD OUTPUT: it is wiped first so stale files cannot survive.
set -e
cd "$(dirname "$0")"
O=/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD
rm -rf stl && mkdir -p stl
PARTS="front lid_hood lid_r lid_l temple_r temple_l test_hinge_front test_hinge_temple test_plate"
for p in $PARTS; do
  ( $O -o "stl/$p.stl" -D "part=\"$p\"" -D "show_parts=false" -D "print_orient=true" glass.scad > "stl/$p.log" 2>&1 ; echo "exported $p" ) &
done
wait
$O -o stl/screw-coupon.stl screw_coupon.scad > stl/screw-coupon.log 2>&1
ls -la stl
