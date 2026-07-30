# Water Bowl Corner Hole-Marking Jig v1.0

This jig locates the two mounting holes for each 50 kg load-cell bracket at the four corners of the 16 × 11 × 1 inch cutting-board scale platform.

## Files

- `water_bowl_corner_hole_jig_v1.0.scad` — parametric OpenSCAD source
- `water_bowl_corner_hole_jig_v1.0.stl` — ready-to-slice model

## Version 1.0 geometry

- Solid top plate with no large lightening opening
- Small inside-corner relief retained for rounded or beveled board edges
- Two 2.2 mm marking holes
- Marking-hole spacing: 44.0 mm center to center
- Pattern center: 38.0 mm from each adjacent board edge
- Raised marking collars disabled with `collar_h = 0`
- Sized for a nominal 25.4 mm-thick cutting board

## Use

1. Place the jig on the underside of one cutting-board corner.
2. Seat both fences firmly against the adjacent board edges.
3. Keep the 82 mm side parallel to the board's 16-inch edge.
4. Mark through both guide holes with an awl, transfer punch, or a small drill bit turned by hand.
5. Rotate the jig around the board and repeat at all four corners.

## Printing

Print with the flat top plate on the build plate and the fences extending upward. No supports should be required.

Suggested starting settings:

- 0.20 mm layer height
- Four walls
- 25% infill
- PETG or ASA preferred; PLA is adequate for a temporary drilling jig

## Validation note

The 44.0 mm mounting-hole spacing is the current prototype value. Compare a printed jig directly against a printed load-cell bracket before drilling the cutting board.

## Bracket attribution

The mounting geometry is based on **50kg Loadcell Bracket versionF** by Thingiverse user **patrick3345** (Patrick Laidlaw):

- Original source: https://www.thingiverse.com/thing:2624188
- License: Creative Commons Attribution, as preserved in `hardware/loadcell-brackets/LICENSE.txt`
