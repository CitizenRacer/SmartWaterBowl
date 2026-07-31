# Smart Water Bowl fabrication jigs

This folder contains printable OpenSCAD jigs used to locate holes and repeat critical fabrication steps for the Smart Water Bowl hardware.

Generated STL files are intentionally not stored in the repository. Open the desired `.scad` file in OpenSCAD, render it with **F6**, and export an STL locally.

## `water_bowl_corner_hole_jig.scad`

### Purpose

Locates the two mounting holes for each 50 kg load-cell bracket at the four corners of the 16 × 11 × 1 inch cutting-board scale platform.

### Critical geometry

- Two 2.2 mm marking holes
- Mounting-hole spacing: 44.0 mm center to center
- Pattern center: 38.0 mm from each adjacent board edge
- Sized for a nominal 25.4 mm-thick cutting board
- Small inside-corner relief for rounded or beveled board edges
- Raised marking collars disabled with `collar_h = 0`

### Use

1. Place the jig on the underside of one cutting-board corner.
2. Seat both fences firmly against the adjacent board edges.
3. Keep the 82 mm side parallel to the board's 16-inch edge.
4. Mark through both holes with an awl, transfer punch, or a small drill bit turned by hand.
5. Rotate the jig around the board and repeat at all four corners.

### Printing

Print with the flat top plate on the build plate and the fences extending upward. No supports should be required.

Suggested starting settings:

- 0.20 mm layer height
- Four walls
- 25% infill
- PETG or ASA preferred; PLA is adequate for a temporary jig

### Validation note

The 44.0 mm mounting-hole spacing is the current prototype value. Compare a printed jig directly against a printed load-cell bracket before drilling the cutting board.

### Bracket attribution

The mounting geometry is based on **50kg Loadcell Bracket versionF** by Thingiverse user **patrick3345** (Patrick Laidlaw):

- Original source: https://www.thingiverse.com/thing:2624188
- License: Creative Commons Attribution, as preserved in `hardware/loadcell-brackets/LICENSE.txt`

## `water_bowl_enclosure_pilot_hole_jig.scad`

### Purpose

Locates the two cable-entry pilot holes, one in each long side of the LeMotech 115 × 90 × 55 mm enclosure base.

The holes align with the cable zip-tie pairs on `hardware/enclosure/water_bowl_electronics_carrier.scad`. The jig indexes from one outside short end of the enclosure and places both side holes at the same longitudinal station.

### Critical geometry

- Pilot-hole station: 43.85 mm from the indexed outside end
- Pilot-hole center height: 12 mm above the enclosure's outside bottom
- Printed locating-hole diameter: 3.30 mm for a nominal 1/8-inch pilot bit
- Flat drilling walls with no projecting bosses
- Short-end stop for repeatable positioning

The 43.85 mm station is derived from the enclosure wall thickness, carrier end clearance, and carrier zip-tie geometry. Those values are documented in the OpenSCAD source and should remain synchronized with the carrier design.

### Use

1. Print the jig flat on its bottom frame.
2. Place the empty enclosure base in the jig.
3. Press the selected short end firmly against the end stop.
4. Clamp the enclosure and jig together.
5. Drill through both flat pilot-hole locators.
6. Remove the jig.
7. Enlarge each enclosure hole to its final diameter with a step drill.

Do not run the step drill through the printed jig. The jig is only intended to establish the pilot-hole centers.

### Printing

Print exactly as modeled with the bottom frame on the build plate. The side walls are flat and no supports should be required.

PETG or ASA is recommended for better heat resistance and durability.

### Adjustable parameters

The main user-adjustable values near the top of the OpenSCAD file are:

- `pilot_d`
- `hole_height_from_bottom`
- `side_clearance`
- `side_wall_t`
- `side_wall_h`

## Adding another jig

Use a descriptive filename without a revision number. Add a section here that documents:

- What the jig is for
- The surfaces or edges it indexes from
- Critical dimensions
- Print orientation and support requirements
- How to use it
- Any measurements that must stay synchronized with another project file
