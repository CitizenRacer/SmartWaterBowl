/*
  water_bowl_fountain_mount.scad

  Flat-printing clip-on dog-bowl fountain mount.

  The flexible tube enters from near the pump, travels vertically upward in a
  rigid candy-cane-shaped cradle, bends over the bowl, and exits downward at an
  adjustable inward angle. The cradle is a continuous open trough. Three pairs
  of slots accept small zip ties to retain the tube while still allowing easy
  replacement and cleaning. The groove is open through both ends so the
  tube can lie at full depth from the pump-side inlet through the outlet.

  PRINT ORIENTATION
  -----------------
  Print exactly as modeled, with the large flat rear face on the build plate.
  The tube groove faces upward. No supports should be required.

  Recommended material: PETG or ASA
  Suggested walls: 4-5
  Suggested layer height: 0.20 mm
  Suggested infill: 25-35%
*/

$fn = 48;

// ---------------------------------------------------------------------------
// USER PARAMETERS
// ---------------------------------------------------------------------------

// Tubing
 tube_od = 10.0;                 // Actual outside diameter of the tubing
 tube_clearance = 0.35;          // Added radial clearance in the cradle
 groove_depth = 5.6;             // Depth of the open tube trough

// Bowl rim
 bowl_rim_thickness = 6.0;       // Horizontal thickness of the bowl rim
 rim_clearance = 0.7;            // Extra sliding clearance
 clip_wall = 4.0;                // Thickness of each U-clip leg
 clip_leg_length = 35.0;         // How far the clip extends down the bowl
 clip_top_thickness = 5.0;       // Material above the rim
 retention_bump = 0.65;          // Set to 0 for no retention bumps

// Overall printed thickness; this is the Z height when printed flat
 part_depth = 12.0;

// Candy-cane dimensions
 riser_height_above_rim = 100.0;  // Straight rise above the top of the clip
 bend_radius = 22.0;             // Centerline radius of the upper bend
 outlet_inward_angle = 25.0;     // Degrees inward from vertical
 outlet_length = 33.0;           // Straight guided outlet section
 end_groove_extension = 12.0;    // Opens the tube groove through both end borders
 guide_overlap = 3.0;            // Overlap into the bowl-side clip leg
 guide_side_wall = 3.0;          // Material beside tube groove
 guide_extra_for_ties = 2.0;     // Extra width for zip-tie slots

// Zip-tie slots
 include_zip_tie_slots = true;
 zip_tie_width = 3.2;             // Typical small zip tie width
 zip_tie_slot_clearance = 0.5;
 zip_tie_slot_cross = 2.0;        // Slot width across the guide
 zip_tie_side_offset = 2.0;       // Gap between tube and each slot

// Preview only; leave false for exporting the part
 show_tube_preview = false;

// ---------------------------------------------------------------------------
// DERIVED VALUES
// ---------------------------------------------------------------------------

rim_gap = bowl_rim_thickness + rim_clearance;
clip_total_x = clip_wall + rim_gap + clip_wall;
clip_top_y = clip_leg_length + clip_top_thickness;

 tube_r = tube_od / 2 + tube_clearance;
 guide_half_width = tube_r + guide_side_wall + guide_extra_for_ties;

// Positive X points into the bowl.
riser_x = clip_total_x + guide_half_width - guide_overlap;
riser_start_y = 3.0;
riser_top_y = clip_top_y + riser_height_above_rim;

arc_center_x = riser_x + bend_radius;
arc_center_y = riser_top_y;
arc_end_angle = outlet_inward_angle;
outlet_direction = arc_end_angle - 90.0;

// Keep enough material under the groove while opening the groove at Z=part_depth.
groove_center_z = part_depth + tube_r - groove_depth;

// ---------------------------------------------------------------------------
// PATH HELPERS
// ---------------------------------------------------------------------------

function arc_points(cx, cy, r, a0, a1, count) =
    [for (i = [0 : count])
        [cx + r * cos(a0 + (a1 - a0) * i / count),
         cy + r * sin(a0 + (a1 - a0) * i / count)]];

arc_path = arc_points(
    arc_center_x,
    arc_center_y,
    bend_radius,
    180,
    arc_end_angle,
    24
);

arc_end = arc_path[len(arc_path) - 1];
outlet_end = [
    arc_end[0] + outlet_length * cos(outlet_direction),
    arc_end[1] + outlet_length * sin(outlet_direction)
];

// Duplicate endpoints are harmless and make the construction easy to read.
tube_path = concat(
    [[riser_x, riser_start_y], [riser_x, riser_top_y]],
    arc_path,
    [outlet_end]
);

// Extend only the groove subtraction beyond the physical guide at both ends.
// This removes the rounded end walls while preserving the supporting floor
// under the tube.
groove_start = [
    riser_x,
    riser_start_y - end_groove_extension
];

groove_end = [
    outlet_end[0] + end_groove_extension * cos(outlet_direction),
    outlet_end[1] + end_groove_extension * sin(outlet_direction)
];

groove_path = concat(
    [groove_start],
    tube_path,
    [groove_end]
);

// ---------------------------------------------------------------------------
// GENERAL GEOMETRY HELPERS
// ---------------------------------------------------------------------------

module stroke_2d(points, radius) {
    union() {
        for (i = [0 : len(points) - 2]) {
            hull() {
                translate(points[i]) circle(r = radius);
                translate(points[i + 1]) circle(r = radius);
            }
        }
    }
}

module swept_spheres(points, radius, z_center) {
    union() {
        for (i = [0 : len(points) - 2]) {
            hull() {
                translate([points[i][0], points[i][1], z_center])
                    sphere(r = radius);
                translate([points[i + 1][0], points[i + 1][1], z_center])
                    sphere(r = radius);
            }
        }
    }
}

// Rounded rectangle made in 2D, then extruded elsewhere.
module rounded_rect_2d(size_x, size_y, radius) {
    hull() {
        for (x = [radius, size_x - radius])
            for (y = [radius, size_y - radius])
                translate([x, y]) circle(r = radius);
    }
}

// ---------------------------------------------------------------------------
// BOWL CLIP PROFILE
// ---------------------------------------------------------------------------

module retention_triangle_2d(x0, y0, direction = 1) {
    // direction=1 points toward +X; direction=-1 points toward -X
    if (retention_bump > 0) {
        if (direction > 0)
            polygon(points = [
                [x0, y0],
                [x0 + retention_bump, y0 + 2.0],
                [x0, y0 + 5.5]
            ]);
        else
            polygon(points = [
                [x0, y0],
                [x0 - retention_bump, y0 + 2.0],
                [x0, y0 + 5.5]
            ]);
    }
}

module bowl_clip_profile_2d() {
    union() {
        // Outside leg
        square([clip_wall, clip_top_y]);

        // Bowl-side leg
        translate([clip_wall + rim_gap, 0])
            square([clip_wall, clip_top_y]);

        // Top bridge
        translate([0, clip_leg_length])
            square([clip_total_x, clip_top_thickness]);

        // Gentle lead-in feet to help the rim enter the clip.
        polygon(points = [
            [0, 0],
            [clip_wall, 0],
            [clip_wall, 4.0],
            [clip_wall - 1.1, 2.0]
        ]);

        translate([clip_wall + rim_gap, 0])
            polygon(points = [
                [0, 0],
                [clip_wall, 0],
                [1.1, 2.0],
                [0, 4.0]
            ]);

        // Opposing bumps resist accidental lift-off without making removal hard.
        retention_triangle_2d(clip_wall, 4.5, 1);
        retention_triangle_2d(clip_wall + rim_gap, 4.5, -1);
    }
}

// ---------------------------------------------------------------------------
// ZIP-TIE SLOT HELPERS
// ---------------------------------------------------------------------------

module slot_pair_at(point, tangent_angle) {
    slot_along = zip_tie_width + zip_tie_slot_clearance;
    side_distance = tube_r + zip_tie_side_offset;

    for (normal_offset = [-side_distance, side_distance]) {
        translate([point[0], point[1], part_depth / 2])
            rotate([0, 0, tangent_angle])
                translate([0, normal_offset, 0])
                    cube([
                        slot_along,
                        zip_tie_slot_cross,
                        part_depth + 0.4
                    ], center = true);
    }
}

module all_zip_tie_slots() {
    if (include_zip_tie_slots) {
        // Two retainers on the straight riser.
        slot_pair_at([riser_x, 19.0], 90);
        slot_pair_at([riser_x, riser_top_y - 12.0], 90);

        // One retainer on the angled outlet section.
        outlet_mid = [
            arc_end[0] + outlet_length * 0.52 * cos(outlet_direction),
            arc_end[1] + outlet_length * 0.52 * sin(outlet_direction)
        ];
        slot_pair_at(outlet_mid, outlet_direction);
    }
}

// ---------------------------------------------------------------------------
// COMPLETE MODEL
// ---------------------------------------------------------------------------

module solid_mount() {
    union() {
        // Flat-extruded bowl clip: strongest and easiest print orientation.
        linear_extrude(height = part_depth)
            bowl_clip_profile_2d();

        // Continuous candy-cane backbone.
        linear_extrude(height = part_depth)
            stroke_2d(tube_path, guide_half_width);

        // Broad gusset joining the riser to the bowl-side leg.
        linear_extrude(height = part_depth)
            hull() {
                translate([clip_total_x - 1.5, 8.0]) circle(r = 3.0);
                translate([riser_x, 12.0]) circle(r = guide_half_width - 1.0);
                translate([clip_total_x - 1.5, clip_top_y - 5.0]) circle(r = 3.0);
                translate([riser_x, clip_top_y + 2.0]) circle(r = guide_half_width - 1.0);
            }
    }
}

module fountain_mount() {
    difference() {
        solid_mount();

        // Open trough following the full candy-cane path.
        swept_spheres(groove_path, tube_r, groove_center_z);

        // Slots allow ordinary small zip ties to hold the tubing securely.
        all_zip_tie_slots();
    }
}

fountain_mount();

// Optional translucent tube preview in OpenSCAD preview mode.
if (show_tube_preview) {
    %swept_spheres(tube_path, tube_od / 2, part_depth + tube_od / 2 - groove_depth);
}
