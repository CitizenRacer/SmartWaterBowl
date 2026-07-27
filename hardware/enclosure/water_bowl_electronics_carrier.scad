/*
ChatGPT ESPHome Water Bowl Scale
LeMotech 115 x 90 x 55 mm electronics carrier - V40
LeMotech enclosure Amazon ASIN: B0895J3SWL

V40 change from V39:
- Replaced the diagonal HX711 support-pad reliefs with east-west flat faces.
- The two southern HX711 supports have north-facing flats; the two northern supports have south-facing flats.
- Each flat is tangent to the outside of the 3.18 mm central post envelope.
- The Load Sensor Combinator supports and all other V39 geometry are unchanged.

Units and coordinate conventions:
- All dimensions are millimeters unless otherwise noted.
- X increases from the carrier's left edge to its right edge (west to east).
- Y increases from the carrier's lower end toward its upper end (south to north).
- Z increases upward from the bottom face of the printed carrier.
- Board positions and enclosure mounting-hole coordinates use the final carrier-local frame.

Fit-sensitive geometry:
- The ESP32 cradle position and 0.635 mm pin channels were physically verified in V35.
- The four enclosure mounting-hole coordinates were adjusted empirically against the enclosure.
- Do not alter those values without another physical fit test.
*/

$fn = 96;  // Facet count for cylinders; higher values look smoother but render more slowly.

// ---------- Output and plate settings ----------

// Selects the generated part:
// - "carrier": complete electronics carrier with board mounts and ESP32 cradle.
// - "fit_check": thin outline plate for checking enclosure fit only.
mode = "carrier";

// Text physically raised on the printed carrier.
board_version = "V40";

// Thickness of the complete carrier plate in "carrier" mode.
base_t = 2.0;

// Thickness of the reduced-cost enclosure test plate in "fit_check" mode.
fit_check_t = 1.0;

// Clearance removed from EACH side of the nominal enclosure interior dimensions.
// Increasing this reduces the finished carrier's width and length. The mounting-hole
// coordinates below do not automatically compensate and must then be revalidated.
wall_clearance = 0.65;

// Optional circular removal holes near the narrow end tabs. Disabled in V40.
finger_holes = false;

// Enables the two pairs of through-slots used for optional cable or component zip ties.
zip_tie_slots = true;

// Short dimension of each rectangular zip-tie slot.
zip_tie_slot_w = 2.4;

// Long dimension of each rectangular zip-tie slot.
zip_tie_slot_l = 10.0;

// Center-to-center Y separation between the two slots in each pair.
zip_tie_pair_spacing = 10.0;

// Enables the four enclosure-screw clearance holes in the carrier plate.
mount_holes = true;

// Diameter of each enclosure mounting through-hole; sized as M3 screw clearance.
mount_hole_d = 3.40;

// Enclosure mounting-hole centers in the FINAL carrier-local [X,Y] frame.
// These values were adjusted empirically against the physical LeMotech enclosure.
// Changing wall_clearance or the carrier outline requires revalidating all four points.
mount_points = [
    [5.98, 93.00],   // Upper-left enclosure mounting hole.
    [74.54, 93.13],  // Upper-right enclosure mounting hole.
    [6.38, 15.10],   // Lower-left enclosure mounting hole.
    [74.64, 15.07]   // Lower-right enclosure mounting hole.
];

// ---------- SparkFun board supports and fasteners ----------

// Height from the carrier's top surface to the underside of each SparkFun PCB.
standoff_h = 5.0;

// Outside diameter of every circular SparkFun support pad / screw boss.
standoff_od = 6.4;

// Printed thread-forming pilot diameter for M3 machine screws.
// This is intentionally smaller than the screw's 3.0 mm major diameter; the screw
// forms its own threads during the one-time installation rather than dropping through.
m3_pilot_d = 2.80;

// Additional pilot-hole depth below the top surface of the 2.0 mm carrier plate.
// At 1.0 mm this leaves a solid 1.0 mm floor beneath the hole.
m3_pilot_into_plate = 1.0;

// Diameter of the straight section of each non-threaded SparkFun locator pin.
prototype_pin_d = 3.18;

// Total locator-pin height above its circular support pad.
prototype_pin_h = 3.20;

// Height of the tapered lead-in at the top of each locator pin.
prototype_tip_h = 0.60;

// Diameter at the narrow top end of each locator-pin taper.
prototype_tip_d = 2.75;

// The HX711 pad relief stops at a tangent to this narrow central envelope.
hx_support_relief_d = prototype_pin_d;

// ---------- ESP32-S3 SuperMini cradle ----------

// Nominal free space added around each side of the ESP32 PCB envelope.
esp_clearance = 0.20;

// Thickness of each outside cradle rail surrounding the ESP32.
esp_rail_t = 1.40;

// Height of the outside cradle rails above the carrier plate.
esp_rail_h = 3.2;

// Gap between each outer and inner rail that captures an ESP32 header-pin row.
// This 0.635 mm value is intentionally retained from the physically verified V35 fit.
esp_pin_channel_w = 0.635;

// Thickness of each inner rail on the board side of a header-pin channel.
esp_inner_rail_t = 1.00;

// Height of each inner rail above the carrier plate.
esp_inner_rail_h = 3.20;

// Distance that each inner rail stops short of both cradle ends, allowing insertion.
esp_inner_rail_end_clearance = 1.50;

// ---------- Raised revision marking ----------

// Character size of the raised board revision text.
version_text_size = 5.0;

// Amount that the revision text rises above the carrier's top surface.
version_text_height = 0.60;

// Amount that the text extrusion overlaps the plate to guarantee a fused solid.
version_text_embed = 0.10;

// OpenSCAD font specification for the raised revision marking.
version_text_font = "Liberation Sans:style=Bold";

// [X,Y] anchor point for the revision text in the carrier-local frame.
version_text_pos = [8, 20];

// ---------- Enclosure and carrier outline ----------

// Nominal usable inside width of the LeMotech enclosure.
inner_w = 82.0;

// Nominal usable inside length of the LeMotech enclosure.
inner_h = 109.0;

// Nominal Y length of the wide middle section between the two narrow end tabs.
clear_middle_h = 87.0;

// Nominal X width of the narrow throat at each end of the enclosure.
end_throat_w = 46.0;

// Finished carrier width after removing wall_clearance from both left and right sides.
carrier_w = inner_w - 2*wall_clearance;

// Finished carrier length after removing wall_clearance from both ends.
carrier_h = inner_h - 2*wall_clearance;

// Finished Y length of the wide middle section after end clearances are applied.
middle_h = clear_middle_h - 2*wall_clearance;

// Finished X width of each narrow end tab.
end_tab_w = end_throat_w - 2*wall_clearance;

// Derived Y length of each narrow end tab; the upper and lower tabs are equal.
end_tab_h = (carrier_h-middle_h)/2;

// Left X boundary of each centered narrow end tab.
end_x0 = (carrier_w-end_tab_w)/2;

// Right X boundary of each centered narrow end tab.
end_x1 = end_x0+end_tab_w;

// Y coordinate where the lower narrow tab transitions into the wide center section.
mid_y0 = end_tab_h;

// Y coordinate where the wide center section transitions into the upper narrow tab.
mid_y1 = carrier_h-end_tab_h;

// ---------- Electronics board dimensions and positions ----------

// SparkFun Load Sensor Combinator nominal PCB width and height.
comb_w = 30.48;
comb_h = 27.94;

// SparkFun HX711 Load Cell Amplifier nominal PCB width and height.
hx_w = 30.48;
hx_h = 22.86;

// ESP32-S3 SuperMini PCB dimensions as used by the rotated cradle geometry.
// esp_y becomes the cradle's local X dimension; esp_x becomes its local Y dimension.
esp_x = 18.034;
esp_y = 25.4;

// Lower-left local origin of each SparkFun board footprint in carrier coordinates.
comb_pos = [7.0, 59.46];
hx_pos = [44.0, 62.0];

// Intentionally preserves the physically verified V35 ESP32 fit. This position uses
// the historical cradle origin rather than recentering the clearance envelope.
// Do not recenter or alter it without another physical fit test.
esp_pos = [(carrier_w-esp_y)/2, 14.0];

// SparkFun Combinator mounting-hole centers relative to comb_pos.
// Indices 0 and 3 receive M3 screw bosses; indices 1 and 2 receive locator pins.
comb_holes = [
    [27.94, 2.54],
    [2.54, 2.54],
    [27.94, 25.40],
    [2.54, 25.40]
];

// SparkFun HX711 mounting-hole centers relative to hx_pos.
// Hole order: lower-left, upper-left, lower-right, upper-right.
// Indices 0 and 3 receive M3 screw bosses; indices 1 and 2 receive locator pins.
hx_holes = [
    [2.54, 2.54],
    [2.54, 20.32],
    [27.94, 2.54],
    [27.94, 20.32]
];

// Relief-face direction for each HX711 support in the same order as hx_holes.
// The lower (southern) row faces north; the upper (northern) row faces south.
hx_relief_faces = ["north", "south", "north", "south"];

// ---------- Geometry modules ----------

// Creates the stepped two-dimensional carrier perimeter before extrusion.
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

// Adds one PCB support pad.
// relief_face may be undef for a complete circular pad, "north" for a north-facing
// east-west flat, or "south" for a south-facing east-west flat.
module support_pad(x, y, relief_face=undef) {
    if (is_undef(relief_face)) {
        translate([x, y, base_t])
            cylinder(h=standoff_h, d=standoff_od);
    } else {
        assert(relief_face == "north" || relief_face == "south",
            str("Unsupported relief face: ", relief_face, ". Use north, south, or undef."));

        translate([x, y, base_t])
            intersection() {
                cylinder(h=standoff_h, d=standoff_od);

                if (relief_face == "north") {
                    // Keep the pad south of y=+radius, creating a north-facing flat.
                    translate([-standoff_od, -standoff_od, -0.01])
                        cube([2*standoff_od,
                              standoff_od + hx_support_relief_d/2,
                              standoff_h + 0.02]);
                } else {
                    // Keep the pad north of y=-radius, creating a south-facing flat.
                    translate([-standoff_od, -hx_support_relief_d/2, -0.01])
                        cube([2*standoff_od,
                              standoff_od + hx_support_relief_d/2,
                              standoff_h + 0.02]);
                }
            }
    }
}

// Adds a support pad and tapered locator pin for a non-threaded PCB mounting hole.
module prototype_locator_pin(x, y, relief_face=undef) {
    support_pad(x, y, relief_face);
    translate([x, y, base_t + standoff_h]) {
        cylinder(h=prototype_pin_h-prototype_tip_h, d=prototype_pin_d);
        translate([0, 0, prototype_pin_h-prototype_tip_h])
            cylinder(h=prototype_tip_h, d1=prototype_pin_d, d2=prototype_tip_d);
    }
}

// Adds the solid boss used at an M3 screw location. Pilot holes are cut later.
module direct_m3_screw_boss(x, y, relief_face=undef) {
    support_pad(x, y, relief_face);
}

// Places two diagonal M3 bosses and two diagonal locator pins.
// relief_faces follows the same four-element order as holes.
module direct_screw_board_mount(origin, holes, relief_faces=[undef, undef, undef, undef]) {
    assert(len(holes) == 4 && len(relief_faces) == 4,
        "Board mounts require four holes and four relief-face entries.");

    direct_m3_screw_boss(origin[0]+holes[0][0], origin[1]+holes[0][1], relief_faces[0]);
    prototype_locator_pin(origin[0]+holes[1][0], origin[1]+holes[1][1], relief_faces[1]);
    prototype_locator_pin(origin[0]+holes[2][0], origin[1]+holes[2][1], relief_faces[2]);
    direct_m3_screw_boss(origin[0]+holes[3][0], origin[1]+holes[3][1], relief_faces[3]);
}

// Defines one M3 pilot-hole cutting solid. It passes through the full 5 mm boss and
// continues m3_pilot_into_plate below the carrier's top surface.
module m3_pilot_hole(x, y) {
    translate([x, y, base_t-m3_pilot_into_plate-0.01])
        cylinder(h=standoff_h+m3_pilot_into_plate+0.02, d=m3_pilot_d);
}

// Places pilot-hole cutters at the same diagonal hole indices used by the M3 bosses.
module direct_screw_pilot_holes(origin, holes) {
    m3_pilot_hole(origin[0]+holes[0][0], origin[1]+holes[0][1]);
    m3_pilot_hole(origin[0]+holes[3][0], origin[1]+holes[3][1]);
}

// Builds the ESP32 captured-rail cradle. The board is rotated so esp_y is the local
// X dimension and esp_x is the local Y dimension. Geometry is unchanged from V35.
module esp_cradle(x, y) {
    board_w = esp_y;
    board_h = esp_x;
    gap_w = board_w + 2*esp_clearance;
    gap_h = board_h + 2*esp_clearance;

    translate([x, y, base_t]) {
        // Long outside rails along the two header-pin sides.
        cube([gap_w, esp_rail_t, esp_rail_h]);
        translate([0, gap_h-esp_rail_t, 0]) cube([gap_w, esp_rail_t, esp_rail_h]);

        // Four short corner stops constrain the board at both ends.
        cube([esp_rail_t, 4, esp_rail_h]);
        translate([gap_w-esp_rail_t, 0, 0]) cube([esp_rail_t, 4, esp_rail_h]);
        translate([0, gap_h-4, 0]) cube([esp_rail_t, 4, esp_rail_h]);
        translate([gap_w-esp_rail_t, gap_h-4, 0]) cube([esp_rail_t, 4, esp_rail_h]);

        // Inner rails form the board-side walls of the two header-pin channels.
        inner_len = gap_w - 2*esp_inner_rail_end_clearance;

        translate([esp_inner_rail_end_clearance, esp_rail_t + esp_pin_channel_w, 0])
            cube([inner_len, esp_inner_rail_t, esp_inner_rail_h]);

        translate([esp_inner_rail_end_clearance, gap_h - esp_rail_t - esp_pin_channel_w - esp_inner_rail_t, 0])
            cube([inner_len, esp_inner_rail_t, esp_inner_rail_h]);
    }
}

// Creates two rectangular through-cutting solids for one zip-tie slot pair.
module zip_tie_slot_pair(x, y, t) {
    translate([x, y, -0.1]) cube([zip_tie_slot_l, zip_tie_slot_w, t+0.2]);
    translate([x, y+zip_tie_pair_spacing, -0.1]) cube([zip_tie_slot_l, zip_tie_slot_w, t+0.2]);
}

// Extrudes the carrier outline and subtracts optional plate-level through-features.
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

// Adds the raised revision marking and embeds it slightly into the plate for fusion.
module version_mark(plate_height) {
    translate([version_text_pos[0], version_text_pos[1], max(0, plate_height-version_text_embed)])
        linear_extrude(height=version_text_height+version_text_embed)
            text(board_version, size=version_text_size, font=version_text_font, halign="center", valign="bottom");
}

// Assembles the selected output. Pilot holes are subtracted from the complete union.
module carrier() {
    assert(mode == "carrier" || mode == "fit_check",
        str("Unsupported mode: ", mode, ". Use \"carrier\" or \"fit_check\"."));
    assert(m3_pilot_into_plate > 0 && m3_pilot_into_plate < base_t,
        "m3_pilot_into_plate must be greater than zero and less than base_t.");
    assert(hx_support_relief_d > m3_pilot_d && hx_support_relief_d < standoff_od,
        "hx_support_relief_d must remain larger than m3_pilot_d and smaller than standoff_od.");

    t = mode == "fit_check" ? fit_check_t : base_t;

    difference() {
        union() {
            plate(t);

            if (mode == "carrier") {
                direct_screw_board_mount(comb_pos, comb_holes);
                direct_screw_board_mount(hx_pos, hx_holes, hx_relief_faces);
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
