# Enclosure jigs

This folder contains printable fabrication aids for the LeMotech 115 × 90 × 55 mm enclosure used by the Smart Water Bowl project.

## `water_bowl_enclosure_pilot_hole_jig.scad`

Use this jig to locate the two cable-entry pilot holes, one in each long side of the enclosure base.

The pilot holes are positioned to line up with the left and right cable zip-tie pairs on `../water_bowl_electronics_carrier.scad`. The jig indexes from one outside short end of the enclosure and places both holes on the same longitudinal station.

### What it does

- Holds the empty enclosure base between two flat side walls.
- Registers the enclosure against a short-end stop.
- Locates both pilot holes 43.85 mm from the indexed outside end.
- Locates both pilot-hole centers 12 mm above the enclosure's outside bottom.
- Provides 3.30 mm holes for a nominal 1/8-inch pilot drill.

### How to use it

1. Print the jig flat on its bottom frame. No supports are required.
2. Place the empty enclosure base in the jig and press its short end firmly against the end stop.
3. Clamp the enclosure and jig together so neither can move.
4. Drill a pilot hole through each flat locating wall.
5. Remove the jig.
6. Enlarge each enclosure hole to its required final diameter with a step drill.

Do not use the step drill through the printed jig. The jig is intended only to establish the pilot-hole centers.

### Adjustable parameters

The OpenSCAD file is fully commented. The main parameters near the top are:

- `pilot_d`: pilot-hole diameter in the printed jig.
- `hole_height_from_bottom`: vertical hole-center location.
- `side_clearance`: fit clearance around the enclosure.
- `side_wall_t` and `side_wall_h`: drilling-wall dimensions.

The longitudinal position is derived from the enclosure dimensions and the cable zip-tie geometry in the electronics carrier. Keep those values synchronized if the carrier design changes.

## Adding another jig

Add each future jig as a descriptively named `.scad` file without a revision number in the filename. Document its purpose, indexing surfaces, critical dimensions, print orientation, and use procedure in this README.
