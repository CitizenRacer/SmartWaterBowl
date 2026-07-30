/*
ESPHome Water Bowl Scale
Corner Hole-Marking Jig v1.0 for a 16 x 11 x 1 inch cutting-board platform

Bracket source used for mounting geometry:
50kg Loadcell Bracket versionF by Patrick Laidlaw (patrick3345)
https://www.thingiverse.com/thing:2624188
CC BY, as preserved in the SmartWaterBowl repository.

Use:
- Put the jig on the UNDERSIDE of one board corner.
- Keep the 82 mm side parallel to a 16 inch edge.
- Push both fences fully against the board.
- Mark through both 2.2 mm guide holes with an awl or transfer punch.
- Rotate the physical jig around the board, always keeping the 82 mm side
  parallel to a 16 inch edge.

The two guide-hole centers are parameterized below so they can be revised after
an actual printed-foot fit check without redesigning the jig.
*/

$fn = 64;

jig_version = "v1.0";

// Board
board_t = 25.4;              // 1 inch
fit_clearance = 0.45;        // each fence-to-board clearance

// Jig body
plate_x = 82.0;              // along the board's 16 inch edge
plate_y = 76.0;              // along the board's 11 inch edge
plate_t = 4.0;
fence_t = 4.0;
fence_drop = board_t + 3.0;
corner_relief = 2.0;

// Hole pattern, corner-local coordinates in mm.
// Hole axis is parallel to the 16 inch board edge.
hole_spacing = 44.0;
foot_center_x = 38.0;
foot_center_y = 38.0;
mark_hole_d = 2.2;
collar_od = 8.0;
collar_h = 0.0;

hole_a = [foot_center_x-hole_spacing/2, foot_center_y];
hole_b = [foot_center_x+hole_spacing/2, foot_center_y];

module rounded_rect_2d(w,h,r) {
    offset(r=r) square([w-2*r,h-2*r]);
}

module plate_2d() {
    difference() {
        rounded_rect_2d(plate_x, plate_y, 4);
        for (p=[hole_a,hole_b]) translate(p) circle(d=mark_hole_d);
    }
}

module jig() {
    difference() {
        union() {
            linear_extrude(plate_t) plate_2d();

            // Fences descend from the underside of the top plate.
            translate([0,-fence_t,-fence_drop])
                cube([plate_x+fence_t, fence_t, fence_drop+plate_t]);
            translate([-fence_t,0,-fence_drop])
                cube([fence_t, plate_y+fence_t, fence_drop+plate_t]);

            // Reinforced marking collars are disabled in v1.0.
            for (p=[hole_a,hole_b])
                translate([p[0],p[1],plate_t])
                    difference() {
                        cylinder(h=collar_h,d=collar_od);
                        translate([0,0,-0.1]) cylinder(h=collar_h+0.2,d=mark_hole_d);
                    }
        }

        // Inside-corner relief so a slightly radiused cutting-board edge does
        // not keep the fences from seating fully.
        translate([-0.1,-0.1,-fence_drop-0.1])
            cube([corner_relief,corner_relief,fence_drop+plate_t+0.2]);
    }
}

jig();
