/*
  ChatGPT_Dog_Bowl_Candy_Cane_100mm_Lip_Hook.scad

  Revision of the original 100 mm candy-cane fountain holder.
  Keeps the original candy-cane trough, open ends, angled outlet, zip-tie
  slots, and flat print orientation. Replaces only the old thick-wall U-clip
  with a simple gravity hook for a stainless lip about 12.7 mm wide and
  1.6-3.2 mm thick. This revision removes the underside spring tab entirely.
*/

$fn = 48;

// Tubing
tube_od = 10.0;
tube_clearance = 0.35;
groove_depth = 5.6;

// Thin stainless bowl lip
lip_width = 12.7;
lip_width_clearance = 1.2;
lip_thickness_max = 3.2;
lip_vertical_clearance = 0.8;

// Hook structure
outside_leg_thickness = 4.0;
outside_leg_length = 28.0;   // Shorter, cleaner exterior leg
top_bridge_thickness = 5.0;
inside_stop_thickness = 3.5;
inside_stop_drop = 8.0;

// Overall printed thickness
part_depth = 12.0;

// Original candy-cane dimensions
riser_height_above_rim = 100.0;
bend_radius = 22.0;
outlet_inward_angle = 25.0;
outlet_length = 33.0;
end_groove_extension = 12.0;
guide_overlap = 3.0;
guide_side_wall = 3.0;
guide_extra_for_ties = 2.0;

// Zip ties
include_zip_tie_slots = true;
zip_tie_width = 3.2;
zip_tie_slot_clearance = 0.5;
zip_tie_slot_cross = 2.0;
zip_tie_side_offset = 2.0;

// Preview helpers
show_tube_preview = false;
show_lip_preview = false;

// Derived values
lip_gap_x = lip_width + lip_width_clearance;
lip_gap_y = lip_thickness_max + lip_vertical_clearance;

hook_inside_x = outside_leg_thickness + lip_gap_x;
hook_total_x = hook_inside_x + inside_stop_thickness;

hook_top_y = outside_leg_length;
lip_underside_y = hook_top_y - lip_gap_y;
inside_stop_bottom_y = hook_top_y - inside_stop_drop;

tube_r = tube_od / 2 + tube_clearance;
guide_half_width = tube_r + guide_side_wall + guide_extra_for_ties;

// Positive X points into the bowl.
riser_x = hook_total_x + guide_half_width - guide_overlap;
riser_start_y = 3.0;
riser_top_y = hook_top_y + top_bridge_thickness + riser_height_above_rim;

arc_center_x = riser_x + bend_radius;
arc_center_y = riser_top_y;
arc_end_angle = outlet_inward_angle;
outlet_direction = arc_end_angle - 90.0;

groove_center_z = part_depth + tube_r - groove_depth;

function arc_points(cx, cy, r, a0, a1, count) =
    [for (i = [0 : count])
        [cx + r * cos(a0 + (a1 - a0) * i / count),
         cy + r * sin(a0 + (a1 - a0) * i / count)]];

arc_path = arc_points(arc_center_x, arc_center_y, bend_radius, 180, arc_end_angle, 24);
arc_end = arc_path[len(arc_path) - 1];
outlet_end = [
    arc_end[0] + outlet_length * cos(outlet_direction),
    arc_end[1] + outlet_length * sin(outlet_direction)
];

tube_path = concat(
    [[riser_x, riser_start_y], [riser_x, riser_top_y]],
    arc_path,
    [outlet_end]
);

groove_start = [riser_x, riser_start_y - end_groove_extension];
groove_end = [
    outlet_end[0] + end_groove_extension * cos(outlet_direction),
    outlet_end[1] + end_groove_extension * sin(outlet_direction)
];
groove_path = concat([groove_start], tube_path, [groove_end]);

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
                translate([points[i][0], points[i][1], z_center]) sphere(r = radius);
                translate([points[i + 1][0], points[i + 1][1], z_center]) sphere(r = radius);
            }
        }
    }
}

module bowl_hook_profile_2d() {
    union() {
        // Long outside structural leg.
        square([outside_leg_thickness, hook_top_y + top_bridge_thickness]);

        // Bridge rests across the 1/2-inch rolled lip.
        translate([0, hook_top_y])
            square([hook_total_x, top_bridge_thickness]);

        // Short inside stop only; no full inner clamping leg.
        translate([hook_inside_x, inside_stop_bottom_y])
            square([
                inside_stop_thickness,
                hook_top_y + top_bridge_thickness - inside_stop_bottom_y
            ]);

        // Lead-in at bottom of outside leg.
        polygon(points = [
            [0, 0],
            [outside_leg_thickness, 0],
            [outside_leg_thickness, 4.0],
            [outside_leg_thickness - 1.2, 2.0]
        ]);
    }
}

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
        slot_pair_at([riser_x, 19.0], 90);
        slot_pair_at([riser_x, riser_top_y - 12.0], 90);

        outlet_mid = [
            arc_end[0] + outlet_length * 0.52 * cos(outlet_direction),
            arc_end[1] + outlet_length * 0.52 * sin(outlet_direction)
        ];
        slot_pair_at(outlet_mid, outlet_direction);
    }
}

module solid_mount() {
    union() {
        linear_extrude(height = part_depth)
            bowl_hook_profile_2d();

        linear_extrude(height = part_depth)
            stroke_2d(tube_path, guide_half_width);

        // Revised gusset joins the original riser to the new hook.
        linear_extrude(height = part_depth)
            hull() {
                translate([
                    hook_inside_x + inside_stop_thickness / 2,
                    inside_stop_bottom_y + 2.5
                ]) circle(r = 3.0);

                translate([riser_x, 12.0])
                    circle(r = guide_half_width - 1.0);

                translate([
                    hook_inside_x + inside_stop_thickness / 2,
                    hook_top_y + top_bridge_thickness - 2.0
                ]) circle(r = 3.0);

                translate([
                    riser_x,
                    hook_top_y + top_bridge_thickness + 2.0
                ]) circle(r = guide_half_width - 1.0);
            }
    }
}

module fountain_mount() {
    difference() {
        solid_mount();
        swept_spheres(groove_path, tube_r, groove_center_z);
        all_zip_tie_slots();
    }
}

fountain_mount();

if (show_tube_preview) {
    %swept_spheres(
        tube_path,
        tube_od / 2,
        part_depth + tube_od / 2 - groove_depth
    );
}

if (show_lip_preview) {
    %color([0.65, 0.68, 0.72, 0.55])
        translate([
            outside_leg_thickness,
            hook_top_y - lip_thickness_max,
            -1
        ])
            cube([lip_width, lip_thickness_max, part_depth + 2]);

    %color([0.65, 0.68, 0.72, 0.35])
        translate([
            outside_leg_thickness + lip_width - 1.2,
            hook_top_y - lip_thickness_max - 35,
            -1
        ])
            cube([1.2, 35, part_depth + 2]);
}
