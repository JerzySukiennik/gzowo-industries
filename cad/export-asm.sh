#!/bin/bash
# Export every part in DESIGN orientation (assembled coordinates) to cad/stl-asm/ for Blender renders and the film.
set -e
cd "$(dirname "$0")"
O=/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD
rm -rf stl-asm && mkdir -p stl-asm
for p in plate arm box_r box_l lid_r lid_l temple_r temple_l; do
  ( nice -n 10 $O -o "stl-asm/$p.stl" -D "part=\"$p\"" -D "show_parts=false" -D "print_orient=false" glass.scad > "stl-asm/$p.log" 2>&1 ; echo "exported $p" ) &
done
wait
ls -la stl-asm
