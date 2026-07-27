# SmartWaterBowl

SmartWaterBowl is an ESPHome-based scale for monitoring the amount of water in a shared dog bowl and publishing the measurements to Home Assistant. The repository also includes an optional clip-on fountain-tube mount for circulating water back into the bowl.

Four load sensors support the bowl platform. Their signals are combined, digitized by an HX711 amplifier, and read by an ESP32-S3 running ESPHome.

> **Current status:** The enclosure fit and ESP32 cradle fit were physically verified in earlier revisions, including the V35 ESP32 geometry retained in the current **V39** source. V39 relieves the board-facing side of all four HX711 support pads so soldered underside pins do not prevent the amplifier board from sitting flush. The load-cell bracket design, repaired STL files, initial ESPHome firmware, and parametric fountain-tube mount are tracked in the repository; V39 physical validation, wiring validation, calibration, the bowl platform, and physical validation of the fountain mount remain in development.

## System overview

```text
Water bowl and platform
        ↓
4 × load sensors in printed brackets
        ↓
SparkFun Load Sensor Combinator
        ↓
SparkFun HX711 Load Cell Amplifier
        ↓
ESP32-S3 SuperMini running ESPHome
        ↓
Home Assistant
```

## Project goals

- Measure the current amount of water in the bowl.
- Track water added and water consumed over time.
- Publish measurements to Home Assistant through ESPHome.
- Keep powered electronics protected in a separate enclosure.
- Make the mechanical and electronics mounting parts reproducible with a 3D printer.
- Support an optional low-voltage recirculating fountain with a removable, rigidly supported tube path.

## Hardware

| Component | Purpose |
|---|---|
| 4 × SparkFun 50 kg load sensors | Support and weigh the bowl platform |
| 3D-printed load-cell brackets | Hold each load sensor and transfer platform load |
| SparkFun Load Sensor Combinator | Combines the four load sensors into one bridge output |
| SparkFun HX711 Load Cell Amplifier | Digitizes the load-cell signal |
| ESP32-S3 SuperMini | Runs ESPHome and publishes measurements over Wi-Fi |
| LeMotech 115 × 90 × 55 mm enclosure — Amazon ASIN `B0895J3SWL` | Protects the electronics |
| USB-C panel-mount extension | Provides external power and programming access |
| PG7 cable glands | Seal the load-sensor cable entries |
| 22 AWG silicone wire | Internal wiring |
| JST-PH connectors | Provide disconnectable internal connections |
| M3 × 6 mm machine screws | Permanently secure the two SparkFun boards directly to printed plastic bosses |
| Optional low-voltage submersible pump and 10 mm OD tubing | Recirculate water through the clip-on fountain mount |

## Repository layout

```text
firmware/
└── esphome_water_bowl.yaml
hardware/
├── enclosure/
│   └── water_bowl_electronics_carrier.scad
├── fountain/
│   └── water_bowl_fountain_mount.scad
└── loadcell-brackets/
    ├── 50kgLoadcell-VersionF.stl
    ├── 50kgLoadcell-VersionF-2021.stl
    ├── source CAD and preview images
    ├── README.txt
    └── LICENSE.txt
```

Additional directories will be added as wiring documentation and the bowl-platform design are completed.

## ESPHome firmware

The current ESPHome configuration is:

[`firmware/esphome_water_bowl.yaml`](firmware/esphome_water_bowl.yaml)

It currently provides:

- Current water-only weight after subtracting a configurable empty-bowl weight
- Latest settled refill weight, used as the 100% reference
- Percentage full based on the most recent qualifying refill
- Timestamp of the last manual or automatic tare
- A Home Assistant tare button
- Automatic tare detection after a drop greater than one pound, confirmed only after the platform remains near zero for five seconds
- Refill detection requiring approximately eight fluid ounces of added water and a five-second settling period

The initial pin assignment is:

| HX711 signal | ESP32-S3 pin |
|---|---|
| DOUT | GPIO5 |
| CLK | GPIO6 |

The `counts_per_lb` substitution is currently a placeholder and must be replaced after physical calibration. Wi-Fi, API encryption, OTA, and fallback access-point credentials are expected in the ESPHome secrets file.

## Electronics carrier

The current carrier source is:

[`hardware/enclosure/water_bowl_electronics_carrier.scad`](hardware/enclosure/water_bowl_electronics_carrier.scad)

The filename remains stable across revisions. The printed revision is controlled by the `board_version` value inside the SCAD file and is physically raised on the carrier.

The current board revision is **V39**.

### Supported hardware

The carrier is designed for the LeMotech 115 × 90 × 55 mm enclosure, Amazon ASIN `B0895J3SWL`, and holds:

- SparkFun Load Sensor Combinator
- SparkFun HX711 Load Cell Amplifier
- ESP32-S3 SuperMini

### Carrier features

- Four measured 3.4 mm enclosure mounting holes
- Four support locations per SparkFun board
- Two diagonal M3 screw bosses and two diagonal locator pins per SparkFun board
- Printed 2.80 mm thread-forming pilot holes for M3 screws, so no drilling is required
- Pilot holes extend 1.0 mm into the 2.0 mm carrier base while leaving a 1.0 mm floor
- Board-facing relief on all four HX711 support pads for clearance around soldered underside pins
- Fully round, unchanged support pads for the Load Sensor Combinator
- Captured-rail cradle for the ESP32-S3 SuperMini
- Physically verified V35 ESP32 cradle position preserved unchanged
- 0.635 mm ESP32 header-pin channels, sized for measured 0.63 mm-wide pins
- Two pairs of optional zip-tie slots
- Raised board-revision marking
- Thin `fit_check` mode for verifying enclosure fit before printing the complete carrier
- Validation that rejects unsupported `mode` values instead of silently producing an incomplete part

The M3 × 6 mm screws are intended to form threads directly in the printed plastic. The 2.80 mm holes are thread-forming pilots, not clearance holes: an M3 screw should be driven into them rather than dropping freely through. Because the boards are not expected to be removed after assembly, this avoids heat-set inserts while still providing positive retention. Tighten the screws only until the boards are secure; excessive torque can strip the printed threads or damage the PCB.

V38 increased the pilot-hole diameter from 2.55 mm to 2.80 mm after the V37 print accepted an M2.5 screw but was too tight for the intended M3 fastener.

V39 changes only the four HX711 support pads. The circular cap facing the PCB center is removed from each 6.4 mm pad, producing a flat face tangent to the 3.18 mm central post envelope. The outer portion of each support remains full width. The Load Sensor Combinator supports, board coordinates, support heights, M3 pilots, locator pins, ESP32 cradle, zip-tie slots, and enclosure geometry remain unchanged.

The enclosure mounting-hole coordinates are expressed in the final carrier-local coordinate frame and were adjusted empirically against the enclosure. Changing `wall_clearance` requires revalidating those four coordinates.

The current design omits the earlier side-retention bumps because their geometry did not reach the nominal enclosure wall. The carrier is secured by the four enclosure mounting screws.

### Generating the carrier

1. Open the SCAD file in [OpenSCAD](https://openscad.org/).
2. Set the mode near the top of the file:

   ```scad
   mode = "carrier";
   ```

   Available modes:

   - `"fit_check"` creates a thin enclosure-fit test plate without the board holders.
   - `"carrier"` creates the complete electronics carrier.

   Any other value stops rendering with an explanatory assertion error.

3. Render the model with **F6**.
4. Export it as an STL.
5. Slice and print it flat on the build plate.

Suggested starting print settings:

- 0.20 mm layer height or finer
- At least three walls
- PLA, PETG, or ASA

PETG or ASA should provide more durable screw threads than brittle PLA, but PLA is acceptable for a one-time installation when the screws are tightened carefully.

Confirm dimensions, tolerances, and material suitability for the actual enclosure and operating environment before committing to a complete build.

## Load-cell brackets

The selected bracket design is **50kg Loadcell Bracket versionF** by Thingiverse user **patrick3345**:

- Original source: <https://www.thingiverse.com/thing:2624188>
- License: Creative Commons Attribution, as stated in the supplied `LICENSE.txt`
- Preserved attribution and source files: [`hardware/loadcell-brackets/`](hardware/loadcell-brackets/)

The two STL files in this directory have been repaired for reliable slicing while retaining their original filenames. The original README, license, source CAD files, preview images, and project fit-test photos remain beside them so attribution and design context stay together.

## Fountain tube mount

The optional fountain mount source is:

[`hardware/fountain/water_bowl_fountain_mount.scad`](hardware/fountain/water_bowl_fountain_mount.scad)

It is a parametric clip-on guide for nominal 10 mm OD flexible tubing. The tube follows an open candy-cane-shaped trough, rises 100 mm above the bowl rim, curves over the bowl, and points the outlet downward and inward. The groove is cut through at both ends so the tubing can sit at full depth throughout the guide. Three pairs of slots accept small zip ties for removable retention.

The key dimensions near the top of the file are:

```scad
tube_od = 10.0;
bowl_rim_thickness = 6.0;
riser_height_above_rim = 100.0;
bend_radius = 22.0;
outlet_inward_angle = 25.0;
outlet_length = 33.0;
```

Measure the actual bowl rim and tubing before printing. Print the mount with its broad flat rear face on the build plate and the tube groove facing upward. The model is intended to print without supports. PETG or ASA is preferred for durability around water and repeated clipping, but material and tubing suitability for the intended water-contact environment must be evaluated before use.

## Current progress

- [x] Select the load sensors and electronics
- [x] Purchase the core electronics and wiring hardware
- [x] Measure the LeMotech enclosure
- [x] Design and fit-test the electronics carrier
- [x] Preserve the physically verified V35 ESP32 holder geometry
- [x] Create carrier board revision V39
- [x] Replace ineffective snap tabs with direct-threaded M3 board retention
- [x] Remove ineffective side-retention bumps
- [x] Deepen the printed M3 pilot holes while retaining a solid base floor
- [x] Increase the SparkFun-board pilot holes to 2.80 mm for M3 thread forming
- [x] Relieve all four HX711 supports for soldered underside-pin clearance
- [x] Keep the Load Sensor Combinator supports unchanged
- [x] Adopt a stable carrier filename independent of board revision
- [x] Select and archive the load-cell bracket design with attribution
- [x] Repair the bracket STL files for slicing
- [x] Select initial ESP32 pin assignments
- [x] Add the initial ESPHome configuration
- [x] Add the parametric clip-on fountain tube mount source
- [ ] Physically print and validate carrier board revision V39
- [ ] Physically print and validate the fountain mount against the bowl and tubing
- [ ] Integrate the brackets into the bowl platform
- [ ] Validate the wiring and pin assignments on assembled hardware
- [ ] Calibrate the assembled scale
- [ ] Add Home Assistant dashboards and automations
- [ ] Validate long-term stability and water resistance

## Versioning convention

The carrier filename does not include a revision number. Future carrier revisions will continue to use:

```text
hardware/enclosure/water_bowl_electronics_carrier.scad
```

The revision number must instead be updated in the SCAD file:

```scad
board_version = "V39";
```

This value is rendered directly onto the printed carrier, making the physical revision identifiable without changing repository paths or documentation links.

The fountain mount also uses a stable descriptive path:

```text
hardware/fountain/water_bowl_fountain_mount.scad
```

## Repository maintenance

Every repository change should include a review of this README to verify that it remains factually correct and easy to understand. Update it whenever a change affects:

- File or directory names
- Hardware selections
- Board revision or mechanical design
- Wiring or pin assignments
- ESPHome configuration
- Calibration procedure
- Build status or remaining work

Readability improvements should be made whenever they clarify setup, operation, or project status.

## Calibration plan

Once assembled, the scale will need at least two calibration points:

1. Record the unloaded HX711 reading with the empty platform installed.
2. Place a known calibration weight on the platform and record the loaded reading.
3. Use those values to calculate the scale factor in ESPHome.
4. Verify the result with several known weights across the expected operating range.

The scale should be tared with the permanent platform hardware installed but without the removable bowl. Enter the empty bowl's measured weight using the `Bowl Weight` entity so the published weight represents water only.

## Water protection

This project places powered electronics near a water bowl. Use only low-voltage power, route cables through sealed glands, provide strain relief, and keep the electronics enclosure physically separated from areas where spilled water can collect.

The printed electronics carrier, load-cell brackets, and fountain mount are mechanical parts and are not themselves waterproof barriers. Use pump, tubing, fasteners, and printed materials suitable for the intended water-contact environment, and inspect and clean the fountain components regularly.
