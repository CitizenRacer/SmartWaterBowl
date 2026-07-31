/*
  Smart Water Bowl enclosure side-hole pilot jig

  Purpose
  -------
  Holds the LeMotech 115 x 90 x 55 mm enclosure base and locates one pilot hole
  through each long side wall. The two pilot holes are aligned with the cable
  zip-tie pairs in water_bowl_electronics_carrier.scad V40.

  Coordinate derivation
  ---------------------
  Carrier cable tie pairs begin at Y=34 mm and use:
      slot width along Y = 2.4 mm
      pair spacing       = 10.0 mm

  The cable centerline is midway between the two slot centers:
      34 + 2.4/2 + 10/2 = 40.2 mm from the carrier's lower edge.

  The enclosure drawing gives 115 mm outside length and 109 mm inside length,
  so the nominal end wall is (115-109)/2 = 3.0 mm thick.
  The carrier has 0.65 mm end clearance.

  Therefore the nominal pilot station is:
      3.0 + 0.65 + 40.2 = 43.85 mm from the enclosure's outside end.

  Use
  ---
  1. Put the empty enclosure base into the jig with the chosen short end firmly
     against the end stop.
  2. Clamp the enclosure and jig together.
  3. Drill both pilot holes through the flat locating holes.
  4. Remove the jig and enlarge each hole with a step drill.

  Print orientation
  -----------------
  Print exactly as modeled, flat base down. The side walls remain flat with no
  projecting drill bosses, so no supports are required.
  PETG or ASA is recommended.

  IMPORTANT
  ---------
  The default vertical hole center is 12 mm above the enclosure's outside
  bottom. This is user-adjustable below because the enclosure drawing does not
  define the installed carrier's exact cable center height.
*/

$fn = 64;

// ---------------------------------------------------------------------------
// USER PARAMETERS
// ---------------------------------------------------------------------------

// Enclosure outside dimensions
// These match the LeMotech enclosure used by this project.
enclosure_length = 115.0;
enclosure_width  = 90.0;
enclosure_height = 55.0;

// Enclosure inside length from the manufacturer drawing. This is used to infer
// the nominal thickness of the two short end walls.
enclosure_inside_length = 109.0;

// Carrier geometry used to derive the longitudinal drilling station.
// Keep these synchronized with water_bowl_electronics_carrier.scad.
carrier_end_clearance = 0.65;
zip_pair_y = 34.0;
zip_slot_w = 2.4;
zip_pair_spacing = 10.0;

// Pilot drill opening. A 3.30 mm opening clears a nominal 1/8 inch bit while
// keeping the jig suitable only for locating the pilot. Enlarge the enclosure
// holes afterward with a step drill; do not run the step drill through the jig.
pilot_d = 3.30;

// Vertical pilot-hole center measured from the enclosure's outside bottom.
hole_height_from_bottom = 12.0;

// Jig fit and structure.
side_clearance = 0.40;        // Clearance on each side of the enclosure.
base_t = 4.0;                 // Thickness of the bottom frame rails.
side_wall_t = 6.0;            // Thickness of each flat drilling wall.
side_wall_h = 22.0;           // Height above the jig base.
end_stop_t = 6.0;             // Thickness of the short-end registration stop.
end_stop_h = 16.0;            // Height of the end stop.
station_margin = 14.0;        // Jig extension beyond the pilot-hole center.

// Weight-saving bottom rails.
bottom_rail_w = 14.0;
cross_rail_w = 12.0;

// ---------------------------------------------------------------------------
// DERIVED VALUES
// ---------------------------------------------------------------------------

// Nominal thickness of either short enclosure wall.
nominal_end_wall_t = (enclosure_length - enclosure_inside_length) / 2;

// Cable center measured from the carrier's lower edge. Each rectangular slot's
// center is zip_slot_w/2 from its origin; the cable runs midway between the pair.
cable_center_from_carrier_end =
    zip_pair_y + zip_slot_w/2 + zip_pair_spacing/2;

// Longitudinal pilot location measured from the enclosure's outside short end.
hole_x =
    nominal_end_wall_t +
    carrier_end_clearance +
    cable_center_from_carrier_end;

// Finished clear and outside widths of the jig.
inside_w = enclosure_width + 2*side_clearance;
outside_w = inside_w + 2*side_wall_t;

// The jig only covers the enclosure from the indexing end through the pilot
// station, plus enough material beyond the hole to keep the side walls rigid.
jig_length = hole_x + station_margin;

// OpenSCAD Z coordinate of the pilot center. The enclosure rests on the frame.
hole_z = base_t + hole_height_from_bottom;

// Catch incompatible parameter edits before rendering or printing.
assert(hole_height_from_bottom > pilot_d/2,
       "Pilot hole is too close to the bottom.");
assert(hole_height_from_bottom + pilot_d/2 < side_wall_h,
       "Increase side_wall_h or lower hole_height_from_bottom.");
assert(jig_length < enclosure_length,
       "Jig length unexpectedly exceeds enclosure length.");

// ---------------------------------------------------------------------------
// JIG COMPONENTS
// ---------------------------------------------------------------------------

module bottom_frame() {
    // Two longitudinal rails support the enclosure near its long edges.
    translate([0, side_wall_t, 0])
        cube([jig_length, bottom_rail_w, base_t]);

    translate([0, side_wall_t + inside_w - bottom_rail_w, 0])
        cube([jig_length, bottom_rail_w, base_t]);

    // Three cross rails keep the long side walls parallel and resist spreading.
    translate([0, side_wall_t, 0])
        cube([cross_rail_w, inside_w, base_t]);

    translate([hole_x - cross_rail_w/2, side_wall_t, 0])
        cube([cross_rail_w, inside_w, base_t]);

    translate([jig_length-cross_rail_w, side_wall_t, 0])
        cube([cross_rail_w, inside_w, base_t]);
}

module side_walls_with_pilot_holes() {
    difference() {
        union() {
            // Flat left drilling wall.
            translate([0, 0, 0])
                cube([jig_length, side_wall_t, base_t + side_wall_h]);

            // Flat right drilling wall.
            translate([0, side_wall_t + inside_w, 0])
                cube([jig_length, side_wall_t, base_t + side_wall_h]);
        }

        // One coaxial cutter passes through both walls. Keeping the walls flat
        // avoids unsupported cylindrical bosses and lets the jig print as modeled.
        translate([hole_x, -0.1, hole_z])
            rotate([-90,0,0])
                cylinder(h=outside_w + 0.2, d=pilot_d);
    }
}

module end_stop() {
    // The enclosure's outside short end touches the inner face at X=0.
    // The stop spans the full jig width so orientation is obvious and repeatable.
    translate([-end_stop_t, 0, 0])
        cube([end_stop_t, outside_w, base_t + end_stop_h]);
}

module relief_opening() {
    // Remove the unneeded middle of the end stop while preserving substantial
    // corner registration surfaces and reducing print time and material.
    opening_w = inside_w - 2*18;
    translate([-end_stop_t-0.1, side_wall_t + 18, base_t + 5])
        cube([end_stop_t+0.2, opening_w, end_stop_h]);
}

// ---------------------------------------------------------------------------
// COMPLETE JIG
// ---------------------------------------------------------------------------

difference() {
    union() {
        bottom_frame();
        side_walls_with_pilot_holes();
        end_stop();
    }

    relief_opening();
}

// Optional translucent enclosure envelope for checking fit in OpenSCAD preview.
// Leave false when exporting the jig.
show_enclosure_preview = false;
if (show_enclosure_preview) {
    %translate([0, side_wall_t + side_clearance, base_t])
        cube([enclosure_length, enclosure_width, enclosure_height]);
}

// Print key derived dimensions in the OpenSCAD console for verification.
echo("Pilot station from enclosure outside end (mm): ", hole_x);
echo("Pilot height above enclosure outside bottom (mm): ",
     hole_height_from_bottom);
echo("Jig outside width (mm): ", outside_w);
echo("Jig length excluding end stop (mm): ", jig_length);
