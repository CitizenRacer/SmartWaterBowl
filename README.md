# SmartWaterBowl

SmartWaterBowl is an ESPHome-based scale for monitoring the amount of water in a shared dog bowl and publishing the measurements to Home Assistant.

Four load sensors support the bowl platform. Their signals are combined, digitized by an HX711 amplifier, and read by an ESP32-S3 running ESPHome.

> **Current status:** The electronics carrier has been fit-tested and is currently at board revision **V35**. The load-cell bracket design, repaired STL files, and initial ESPHome firmware are tracked in the repository. Wiring validation, calibration, and the bowl platform are still in development.

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

## Hardware

| Component | Purpose |
|---|---|
| 4 × SparkFun 50 kg load sensors | Support and weigh the bowl platform |
| 3D-printed load-cell brackets | Hold each load sensor and transfer platform load |
| SparkFun Load Sensor Combinator | Combines the four load sensors into one bridge output |
| SparkFun HX711 Load Cell Amplifier | Digitizes the load-cell signal |
| ESP32-S3 SuperMini | Runs ESPHome and publishes measurements over Wi-Fi |
| LeMotech 115 × 90 × 55 mm enclosure | Protects the electronics |
| USB-C panel-mount extension | Provides external power and programming access |
| PG7 cable glands | Seal the load-sensor cable entries |
| 22 AWG silicone wire | Internal wiring |
| JST-PH connectors | Provide disconnectable internal connections |

## Repository layout

```text
firmware/
└── esphome_water_bowl.yaml
hardware/
├── enclosure/
│   └── water_bowl_electronics_carrier.scad
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

The current board revision is **V35**.

### Supported hardware

The carrier is designed for the LeMotech 115 × 90 × 55 mm enclosure and holds:

- SparkFun Load Sensor Combinator
- SparkFun HX711 Load Cell Amplifier
- ESP32-S3 SuperMini

### Carrier features

- Four measured 3.4 mm enclosure mounting holes
- Four support pads per SparkFun board
- Two diagonal split snap-lock posts and two diagonal locator posts per SparkFun board
- Captured-rail cradle for the ESP32-S3 SuperMini
- 0.635 mm ESP32 header-pin channels, sized for measured 0.63 mm-wide pins
- Optional zip-tie slots
- Small enclosure-retention bumps in full carrier mode
- Raised board-revision marking
- Thin `fit_check` mode for verifying enclosure fit before printing the complete carrier

The SparkFun snap-lock posts are designed to compress through the PCB mounting holes and spring back out above the board. PETG or ASA is preferable for these flexible features; PLA may make the split posts more brittle.

### Generating the carrier

1. Open the SCAD file in [OpenSCAD](https://openscad.org/).
2. Set the mode near the top of the file:

   ```scad
   mode = "carrier";
   ```

   Available modes:

   - `"fit_check"` creates a thin enclosure-fit test plate without the raised side retention bumps or board holders.
   - `"carrier"` creates the complete electronics carrier.

3. Render the model with **F6**.
4. Export it as an STL.
5. Slice and print it flat on the build plate.

Suggested starting print settings:

- 0.20 mm layer height or finer
- At least three walls
- PETG preferred for the flexible SparkFun snap-lock posts
- ASA is also suitable

Confirm dimensions, tolerances, and material suitability for the actual enclosure and operating environment before committing to a complete build.

## Load-cell brackets

The selected bracket design is **50kg Loadcell Bracket versionF** by Thingiverse user **patrick3345**:

- Original source: <https://www.thingiverse.com/thing:2624188>
- License: Creative Commons Attribution, as stated in the supplied `LICENSE.txt`
- Preserved attribution and source files: [`hardware/loadcell-brackets/`](hardware/loadcell-brackets/)

The two STL files in this directory have been repaired for reliable slicing while retaining their original filenames. The original README, license, source CAD files, preview images, and project fit-test photos remain beside them so attribution and design context stay together.

## Current progress

- [x] Select the load sensors and electronics
- [x] Purchase the core electronics and wiring hardware
- [x] Measure the LeMotech enclosure
- [x] Design and fit-test the electronics carrier
- [x] Finalize carrier board revision V35
- [x] Adopt a stable carrier filename independent of board revision
- [x] Select and archive the load-cell bracket design with attribution
- [x] Repair the bracket STL files for slicing
- [x] Select initial ESP32 pin assignments
- [x] Add the initial ESPHome configuration
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
board_version = "V35";
```

This value is rendered directly onto the printed carrier, making the physical revision identifiable without changing repository paths or documentation links.

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

The printed electronics carrier and load-cell brackets are mechanical parts and are not themselves waterproof barriers.
