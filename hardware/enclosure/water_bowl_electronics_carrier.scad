/*
ChatGPT ESPHome Water Bowl Scale
LeMotech 115 x 90 x 55 mm electronics carrier - V37

V37 changes from V36:
- Removed the ineffective side-retention bumps; the carrier is secured by the four enclosure mounting screws.
- Extended each 2.55 mm M3 pilot hole 1.0 mm into the base while leaving a 1.0 mm floor.
- Intended SparkFun-board fastener is an M3 x 6 mm machine screw.
- Added validation for the two supported output modes.
- Documented the mounting-hole coordinate frame.
- Preserved the physically verified V35 ESP32 cradle geometry, 0.635 mm pin channels, zip-tie slots, and measured enclosure geometry.
*/

$fn = 48;  // Number of facets used to approximate circles.

// ---------- User settings ----------

mode = "carrier";  // "carrier" creates the complete part; "fit_check" creates a thin enclosure-fit test.

board_version = "V37";  // Revision text printed on the carrier.

base_t = 2.0;  // Finished carrier plate thickness.

fit_check_t = 1.0;  // Plate thickness in fit-check mode.

wall_clearance = 0.65;  // Clearance removed from each side of the nominal enclosure interior.

finger_holes = false;  // Enables optional finger-removal holes in the end tabs.

zip_tie_slots = true;  // Enables the two pairs of zip-tie slots.

zip_tie_slot_w = 2.4;  // Width of each zip-tie slot.

zip_tie_slot_l = 10.0;  // Length of each zip-tie slot.

zip_tie_pair_spacing = 10.0;  // Y-axis spacing between slots in each pair.

mount_holes = true;  // Enables the four measured enclosure mounting holes.

mount_hole_d = 3.40;  // Through-hole diameter for M3 clearance screws.

// Coordinates are in the final carrier-local frame and were adjusted empirically
// against the enclosure. Changing wall_clearance requires revalidating these points.
mount_points = [
    [5.98, 93.00],
    [74.54, 93.13],
    [6.38, 15.10],
    [74.64, 15.07]
];

standoff_h = 5.0;
standoff_od = 6.4;
m3_pilot_d = 2.55;
m3_pilot_into_plate = 1.0;  // Leaves a 1.0 mm floor with the default 2.0 mm base.
prototype_pin_d = 3.18;
prototype_pin_h = 3.20;
prototype_tip_h = 0.60;
prototype_tip_d = 2.75;

esp_clearance = 0.20;
esp_rail_t = 1.40;
esp_rail_h = 3.2;
esp_pin_channel_w = 0.635;
esp_inner_rail_t = 1.00;
esp_inner_rail_h = 3.20;
esp_inner_rail_end_clearance = 1.50;

version_text_size = 5.0;
version_text_height = 0.60;
version_text_embed = 0.10;
version_text_font = "Liberation Sans:style=Bold";
version_text_pos = [8, 20];

inner_w = 82.0;
inner_h = 109.0;
clear_middle_h = 87.0;
end_throat_w = 46.0;
carrier_w = inner_w - 2*wall_clearance;
carrier_h = inner_h - 2*wall_clearance;
middle_h = clear_middle_h - 2*wall_clearance;
end_tab_w = end_throat_w - 2*wall_clearance;
end_tab_h = (carrier_h-middle_h)/2;
end_x0 = (carrier_w-end_tab_w)/2;
end_x1 = end_x0+end_tab_w;
mid_y0 = end_tab_h;
mid_y1 = carrier_h-end_tab_h;

comb_w = 30.48;
comb_h = 27.94;
hx_w = 30.48;
hx_h = 22.86;
esp_x = 18.034;
esp_y = 25.4;
comb_pos = [7.0, 59.46];
hx_pos = [44.0, 62.0];

// Intentionally preserves the physically verified V35 ESP32 fit. Do not recenter
// this using the clearance envelope without another physical fit test.
esp_pos = [(carrier_w-esp_y)/2, 14.0];

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

module prototype_locator_pin(x, y) {
    support_pad(x, y);
    translate([x, y, base_t + standoff_h]) {
        cylinder(h=prototype_pin_h-prototype_tip_h, d=prototype_pin_d);
        translate([0, 0, prototype_pin_h-prototype_tip_h])
            cylinder(h=prototype_tip_h, d1=prototype_pin_d, d2=prototype_tip_d);
    }
}

module direct_m3_screw_boss(x, y) {
    support_pad(x, y);
}

module direct_screw_board_mount(origin, holes) {
    direct_m3_screw_boss(origin[0]+holes[0][0], origin[1]+holes[0][1]);
    prototype_locator_pin(origin[0]+holes[1][0], origin[1]+holes[1][1]);
    prototype_locator_pin(origin[0]+holes[2][0], origin[1]+holes[2][1]);
    direct_m3_screw_boss(origin[0]+holes[3][0], origin[1]+holes[3][1]);
}

module m3_pilot_hole(x, y) {
    translate([x, y, base_t-m3_pilot_into_plate-0.01])
        cylinder(h=standoff_h+m3_pilot_into_plate+0.02, d=m3_pilot_d);
}

module direct_screw_pilot_holes(origin, holes) {
    m3_pilot_hole(origin[0]+holes[0][0], origin[1]+holes[0][1]);
    m3_pilot_hole(origin[0]+holes[3][0], origin[1]+holes[3][1]);
}

module esp_cradle(x, y) {
    board_w = esp_y;
    board_h = esp_x;
    gap_w = board_w + 2*esp_clearance;
    gap_h = board_h + 2*esp_clearance;

    translate([x, y, base_t]) {
        cube([gap_w, esp_rail_t, esp_rail_h]);
        translate([0, gap_h-esp_rail_t, 0]) cube([gap_w, esp_rail_t, esp_rail_h]);
        cube([esp_rail_t, 4, esp_rail_h]);
        translate([gap_w-esp_rail_t, 0, 0]) cube([esp_rail_t, 4, esp_rail_h]);
        translate([0, gap_h-4, 0]) cube([esp_rail_t, 4, esp_rail_h]);
        translate([gap_w-esp_rail_t, gap_h-4, 0]) cube([esp_rail_t, 4, esp_rail_h]);

        inner_len = gap_w - 2*esp_inner_rail_end_clearance;

        translate([esp_inner_rail_end_clearance, esp_rail_t + esp_pin_channel_w, 0])
            cube([inner_len, esp_inner_rail_t, esp_inner_rail_h]);

        translate([esp_inner_rail_end_clearance, gap_h - esp_rail_t - esp_pin_channel_w - esp_inner_rail_t, 0])
            cube([inner_len, esp_inner_rail_t, esp_inner_rail_h]);
    }
}

module zip_tie_slot_pair(x, y, t) {
    translate([x, y, -0.1]) cube([zip_tie_slot_l, zip_tie_slot_w, t+0.2]);
    translate([x, y+zip_tie_pair_spacing, -0.1]) cube([zip_tie_slot_l, zip_tie_slot_w, t+0.2]);
}

module plate(t) {
    difference() {
        linear_extrude(height=t) carrier_outline_2d();

        if (finger_holes) {
            translate([carrier_w/2, 5.0, -0.1]) cylinder(h=t+0.2, d=8);
            translate([carrier_w/2, carrier_h-5.0, -0.1]) cylinder(h=t+0.2, d=8);
        }

        if (zip_tie_slots) {
            zip_tie_slot_pair(7, 34, t);
            zip_tie_slot_pair(63, 34, t);
        }

        if (mount_holes) {
            for (p = mount_points)
                translate([p[0], p[1], -0.1]) cylinder(h=t+0.2, d=mount_hole_d);
        }
    }
}

module version_mark(plate_height) {
    translate([version_text_pos[0], version_text_pos[1], max(0, plate_height-version_text_embed)])
        linear_extrude(height=version_text_height+version_text_embed)
            text(board_version, size=version_text_size, font=version_text_font, halign="center", valign="bottom");
}

module carrier() {
    assert(mode == "carrier" || mode == "fit_check",
        str("Unsupported mode: ", mode, ". Use \"carrier\" or \"fit_check\"."));
    assert(m3_pilot_into_plate > 0 && m3_pilot_into_plate < base_t,
        "m3_pilot_into_plate must be greater than zero and less than base_t.");

    t = mode == "fit_check" ? fit_check_t : base_t;

    difference() {
        union() {
            plate(t);

            if (mode == "carrier") {
                direct_screw_board_mount(comb_pos, comb_holes);
                direct_screw_board_mount(hx_pos, hx_holes);
                esp_cradle(esp_pos[0], esp_pos[1]);
            }

            version_mark(t);
        }

        if (mode == "carrier") {
            direct_screw_pilot_holes(comb_pos, comb_holes);
            direct_screw_pilot_holes(hx_pos, hx_holes);
        }
    }
}

carrier();
