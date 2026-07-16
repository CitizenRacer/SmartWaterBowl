/*
ChatGPT ESPHome Water Bowl Scale
LeMotech 115 x 90 x 55 mm electronics carrier - V35

V35 changes:
- ESP32 header-pin channel gap set to 0.635 mm for measured 0.63 mm-wide pins.
- SparkFun board locking retention restored.
- Each SparkFun board uses two diagonal split snap-lock posts and two diagonal locator posts.
- Enclosure geometry and measured mounting-hole positions remain unchanged.
*/

$fn = 48;  // Number of facets used to approximate circles.

// ---------- User settings ----------

mode = "carrier";  // "carrier" creates the complete part; "fit_check" creates a thin enclosure-fit test.

board_version = "V35";  // Revision text printed on the carrier.

base_t = 2.0;  // Finished carrier plate thickness.

fit_check_t = 1.0;  // Plate thickness in fit-check mode.

wall_clearance = 0.65;  // Clearance removed from each side of the nominal enclosure interior.

retention_bumps = true;  // Enables the four small enclosure-retention bumps.

bump_projection = 0.05;  // Distance each bump projects beyond the nominal carrier edge.

bump_overlap = 0.60;  // Distance each bump overlaps the plate to ensure fusion.

bump_length = 12.0;  // Length of each retention bump.

bump_height = 1.2;  // Height of each retention bump.

finger_holes = false;  // Enables optional finger-removal holes in the end tabs.

zip_tie_slots = true;  // Enables the two pairs of zip-tie slots.

zip_tie_slot_w = 2.4;  // Width of each zip-tie slot.

zip_tie_slot_l = 10.0;  // Length of each zip-tie slot.

zip_tie_pair_spacing = 10.0;  // Y-axis spacing between slots in each pair.

mount_holes = true;  // Enables the four measured enclosure mounting holes.

mount_hole_d = 3.40;  // Through-hole diameter for M3 clearance screws.

mount_points = [
    [5.98, 93.00],   // Hole A: moved left 0.25 mm.
    [74.54, 93.13],  // Hole B: moved up 0.50 mm.
    [6.38, 15.10],   // Hole C: moved left 0.10 mm and down 0.10 mm.
    [74.64, 15.07]   // Hole D: unchanged.
];


standoff_h = 5.0;  // Height of SparkFun PCB support pads.

standoff_od = 6.4;  // Outside diameter of SparkFun PCB support pads.

// SparkFun board retention. Mounting holes are nominally about 3.302 mm.
locator_pin_d = 2.90;  // Diameter of the two plain locating posts on each board.
locator_pin_h = 2.35;  // Height of each locating post above its support pad.

snap_stem_d = 2.82;  // Diameter of the flexible snap-post stem.
snap_stem_h = 2.15;  // Stem height before the retaining barb.
snap_barb_d = 3.55;  // Maximum retaining-barb diameter.
snap_barb_h = 0.95;  // Height of the tapered retaining barb.
snap_tip_d = 2.45;   // Diameter at the top of the tapered barb.
snap_slot_w = 0.72;  // Width of the split that lets the post compress.

esp_clearance = 0.20;  // Extra clearance around each side of the ESP32 PCB envelope.

esp_rail_t = 1.40;  // Thickness of the outer ESP32 cradle rails.

esp_rail_h = 3.2;  // Height of the outer ESP32 cradle rails.

esp_pin_channel_w = 0.635;  // Gap sized for measured 0.63 mm-wide ESP32 header pins.

esp_inner_rail_t = 1.00;  // Thickness of each inner ESP32 rail.

esp_inner_rail_h = 3.20;  // Height of each inner ESP32 rail.

esp_inner_rail_end_clearance = 1.50;  // Distance inner rails stop short of each cradle end.

// ---------- Diagnostic output ----------

echo("V35 wall_clearance", wall_clearance);
echo("V35 bump_projection", bump_projection);
echo("V35 esp_pin_channel_w", esp_pin_channel_w);
echo("V35 snap_barb_d", snap_barb_d);
echo("Board version", board_version);
echo("V35 hole A", mount_points[0]);
echo("V35 hole B", mount_points[1]);
echo("V35 hole C", mount_points[2]);
echo("V35 hole D", mount_points[3]);
echo("V35 hole A", mount_points[0]);
echo("V35 hole B", mount_points[1]);
echo("V35 hole C", mount_points[2]);
echo("V35 hole D", mount_points[3]);
echo("V35 rotated combinator position", comb_pos);
echo("V35 combinator center Y", comb_pos[1] + comb_h/2);
echo("V35 HX711 center Y", hx_pos[1] + hx_h/2);
echo("V35 rotated combinator size", [comb_w, comb_h]);
echo("V35 combinator right edge", comb_pos[0] + comb_w);
echo("V35 HX711 left edge", hx_pos[0]);
echo("V35 board gap", hx_pos[0] - (comb_pos[0] + comb_w));
echo("V35 hole A", mount_points[0]);
echo("V35 hole B", mount_points[1]);
echo("V35 hole C", mount_points[2]);
echo("V35 hole D", mount_points[3]);

// ---------- Version marking ----------

version_text_size = 5.0;  // Character height of the raised revision text.

version_text_height = 0.60;  // Raised height of the revision text.
version_text_embed = 0.10;  // Amount the revision text overlaps the plate to guarantee fusion.

version_text_font = "Liberation Sans:style=Bold";  // Font used for the revision text.

version_text_pos = [8, 20];  // [X,Y] anchor position of the revision text.

// ---------- Enclosure geometry ----------

inner_w = 82.0;  // Nominal usable enclosure width.

inner_h = 109.0;  // Nominal usable enclosure length.

clear_middle_h = 87.0;  // Nominal length of the wide central section.

end_throat_w = 46.0;  // Nominal width of the narrow end tabs.

carrier_w = inner_w - 2*wall_clearance;  // Final carrier width.

carrier_h = inner_h - 2*wall_clearance;  // Final carrier length.

middle_h = clear_middle_h - 2*wall_clearance;  // Final central-section length.

end_tab_w = end_throat_w - 2*wall_clearance;  // Final narrow-tab width.

end_tab_h = (carrier_h-middle_h)/2;  // Length of each narrow end tab.

end_x0 = (carrier_w-end_tab_w)/2;  // Left X coordinate of each narrow tab.

end_x1 = end_x0+end_tab_w;  // Right X coordinate of each narrow tab.

mid_y0 = end_tab_h;  // Lower Y transition into the wide center.

mid_y1 = carrier_h-end_tab_h;  // Upper Y transition out of the wide center.

// ---------- Board geometry ----------

comb_w = 30.48;  // SparkFun Load Sensor Combinator width.

comb_h = 27.94;  // SparkFun Load Sensor Combinator height.

hx_w = 30.48;  // SparkFun HX711 board width.

hx_h = 22.86;  // SparkFun HX711 board height.

esp_x = 18.034;  // ESP32-S3 SuperMini short dimension.

esp_y = 25.4;  // ESP32-S3 SuperMini long dimension.

comb_pos = [7.0, 59.46];  // Combinator local-origin position.

hx_pos = [44.0, 62.0];  // HX711 local-origin position.

esp_pos = [(carrier_w-esp_y)/2, 14.0];  // ESP32 cradle position.

comb_holes = [
    [27.94, 2.54],
    [2.54, 2.54],
    [27.94, 25.40],
    [2.54, 25.40]
];

hx_holes = [
    [2.54, 2.54],
    [2.54, 20.32],
    [27.94, 2.54],
    [27.94, 20.32]
];

module carrier_outline_2d() {
    polygon(points=[
        [end_x0, 0],
        [end_x1, 0],
        [end_x1, mid_y0],
        [carrier_w, mid_y0],
        [carrier_w, mid_y1],
        [end_x1, mid_y1],
        [end_x1, carrier_h],
        [end_x0, carrier_h],
        [end_x0, mid_y1],
        [0, mid_y1],
        [0, mid_y0],
        [end_x0, mid_y0]
    ]);
}

module support_pad(x, y) {
    translate([x, y, base_t])
        cylinder(h=standoff_h, d=standoff_od);
}

module locator_post(x, y) {
    support_pad(x, y);

    translate([x, y, base_t + standoff_h])
        cylinder(h=locator_pin_h, d=locator_pin_d);
}

module snap_post(x, y) {
    support_pad(x, y);

    translate([x, y, base_t + standoff_h])
    difference() {
        union() {
            cylinder(h=snap_stem_h, d=snap_stem_d);

            translate([0, 0, snap_stem_h])
                cylinder(
                    h=snap_barb_h,
                    d1=snap_barb_d,
                    d2=snap_tip_d
                );
        }

        // The vertical split lets both halves flex inward during insertion.
        translate([-snap_slot_w/2, -snap_barb_d, -0.1])
            cube([
                snap_slot_w,
                2*snap_barb_d,
                snap_stem_h + snap_barb_h + 0.2
            ]);
    }
}

// Two diagonal snap posts retain each board; two locator posts align it.
module screwless_board_mount(origin, holes) {
    locator_post(origin[0]+holes[0][0], origin[1]+holes[0][1]);
    snap_post   (origin[0]+holes[1][0], origin[1]+holes[1][1]);
    snap_post   (origin[0]+holes[2][0], origin[1]+holes[2][1]);
    locator_post(origin[0]+holes[3][0], origin[1]+holes[3][1]);
}

module esp_cradle(x, y) {
    board_w = esp_y;
    board_h = esp_x;
    gap_w = board_w + 2*esp_clearance;
    gap_h = board_h + 2*esp_clearance;

    translate([x, y, base_t]) {
        cube([gap_w, esp_rail_t, esp_rail_h]);

        translate([0, gap_h-esp_rail_t, 0])
            cube([gap_w, esp_rail_t, esp_rail_h]);

        cube([esp_rail_t, 4, esp_rail_h]);

        translate([gap_w-esp_rail_t, 0, 0])
            cube([esp_rail_t, 4, esp_rail_h]);

        translate([0, gap_h-4, 0])
            cube([esp_rail_t, 4, esp_rail_h]);

        translate([gap_w-esp_rail_t, gap_h-4, 0])
            cube([esp_rail_t, 4, esp_rail_h]);

        inner_len = gap_w - 2*esp_inner_rail_end_clearance;

        translate([
            esp_inner_rail_end_clearance,
            esp_rail_t + esp_pin_channel_w,
            0
        ])
            cube([inner_len, esp_inner_rail_t, esp_inner_rail_h]);

        translate([
            esp_inner_rail_end_clearance,
            gap_h - esp_rail_t - esp_pin_channel_w - esp_inner_rail_t,
            0
        ])
            cube([inner_len, esp_inner_rail_t, esp_inner_rail_h]);
    }
}

module zip_tie_slot_pair(x, y, t) {
    translate([x, y, -0.1])
        cube([zip_tie_slot_l, zip_tie_slot_w, t+0.2]);

    translate([x, y+zip_tie_pair_spacing, -0.1])
        cube([zip_tie_slot_l, zip_tie_slot_w, t+0.2]);
}

module side_bump_left(y) {
    translate([-bump_projection, y, base_t-bump_height])
        cube([bump_projection+bump_overlap, bump_length, bump_height]);
}

module side_bump_right(y) {
    translate([carrier_w-bump_overlap, y, base_t-bump_height])
        cube([bump_projection+bump_overlap, bump_length, bump_height]);
}

module plate(t) {
    difference() {
        linear_extrude(height=t)
            carrier_outline_2d();

        if (finger_holes) {
            translate([carrier_w/2, 5.0, -0.1])
                cylinder(h=t+0.2, d=8);

            translate([carrier_w/2, carrier_h-5.0, -0.1])
                cylinder(h=t+0.2, d=8);
        }

        if (zip_tie_slots) {
            zip_tie_slot_pair(7, 34, t);
            zip_tie_slot_pair(63, 34, t);
        }

        if (mount_holes) {
            for (p = mount_points)
                translate([p[0], p[1], -0.1])
                    cylinder(h=t+0.2, d=mount_hole_d);
        }
    }
}

module version_mark(plate_height) {
    translate([
        version_text_pos[0],
        version_text_pos[1],
        max(0, plate_height-version_text_embed)
    ])
        linear_extrude(height=version_text_height+version_text_embed)
            text(
                board_version,
                size=version_text_size,
                font=version_text_font,
                halign="center",
                valign="bottom"
            );
}

module carrier() {
    t = mode == "fit_check" ? fit_check_t : base_t;

    union() {
        plate(t);

        if (retention_bumps && mode == "carrier") {
            side_bump_left(24);
            side_bump_left(70);
            side_bump_right(24);
            side_bump_right(70);
        }

        if (mode == "carrier") {
            screwless_board_mount(comb_pos, comb_holes);
            screwless_board_mount(hx_pos, hx_holes);
            esp_cradle(esp_pos[0], esp_pos[1]);
        }

        version_mark(t);
    }
}

carrier();
