# SmartWaterBowl

An ESPHome-based scale for monitoring how much water dogs drink from a shared water bowl.

The bowl sits on four load sensors. Their combined measurement is read by an HX711 amplifier and an ESP32-S3, then published through ESPHome for use in Home Assistant.

> **Project status:** Work in progress. The electronics carrier has been fit-tested and finalized as **V33**. Wiring, firmware, calibration, and the final bowl platform are still being developed.

## System overview

```text
Water bowl
    ↓
4 × load sensors
    ↓
SparkFun Load Sensor Combinator
    ↓
SparkFun HX711 Load Cell Amplifier
    ↓
ESP32-S3 SuperMini running ESPHome
    ↓
Home Assistant
```

## Goals

- Measure the current amount of water in the bowl.
- Track water added and water consumed over time.
- Make the readings available to Home Assistant through ESPHome.
- Keep the electronics protected in a separate enclosure.
- Make the mechanical and electronics mounting parts reproducible with a 3D printer.

## Hardware

| Component | Purpose |
|---|---|
| 4 × SparkFun 50 kg load sensors | Support and weigh the bowl platform |
| SparkFun Load Sensor Combinator | Combines the four load sensors into one bridge output |
| SparkFun HX711 Load Cell Amplifier | Digitizes the load-cell signal |
| ESP32-S3 SuperMini | Runs ESPHome and sends measurements over Wi-Fi |
| LeMotech 115 × 90 × 55 mm enclosure | Protects the electronics |
| USB-C panel-mount extension | Provides external power and programming access |
| PG7 cable glands | Seals load-sensor cable entries |
| 22 AWG silicone wire | Internal wiring |
| JST-PH connectors | Disconnectable internal connections |

## Repository layout

```text
hardware/
└── enclosure/
    └── ChatGPT_water_bowl_electronics_carrier_v33_latest_hole_positions.scad
```

Additional directories will be added as the ESPHome configuration, wiring documentation, and remaining mechanical parts are completed.

## Electronics carrier

The current electronics carrier is:

[`hardware/enclosure/ChatGPT_water_bowl_electronics_carrier_v33_latest_hole_positions.scad`](hardware/enclosure/ChatGPT_water_bowl_electronics_carrier_v33_latest_hole_positions.scad)

V33 is designed specifically for the LeMotech enclosure and holds:

- SparkFun Load Sensor Combinator
- SparkFun HX711 Load Cell Amplifier
- ESP32-S3 SuperMini

It also includes:

- Four measured 3.4 mm enclosure mounting holes
- Locator pins and support pads for the SparkFun boards
- A captured-rail cradle for the ESP32-S3 SuperMini
- Optional zip-tie slots
- Small enclosure-retention bumps
- A raised revision marking
- A thin `fit_check` mode for verifying enclosure fit before printing the complete carrier

### Generating the carrier

1. Open the SCAD file in [OpenSCAD](https://openscad.org/).
2. Set the mode near the top of the file:

   ```scad
   mode = "carrier";
   ```

   Use `"fit_check"` for a thin test plate or `"carrier"` for the complete part.

3. Render the model with **F6**.
4. Export it as an STL.
5. Slice and print it flat on the build plate.

Suggested starting print settings are a 0.20 mm layer height, at least three walls, and PLA or PETG. Confirm dimensions and material suitability for your own enclosure and environment before committing to the complete build.

## Current status

- [x] Select the load sensors and electronics
- [x] Purchase the core electronics and wiring hardware
- [x] Measure the LeMotech enclosure
- [x] Design and fit-test the electronics carrier
- [x] Finalize carrier V33
- [ ] Finalize the wiring diagram and ESP32 pin assignments
- [ ] Add the ESPHome configuration
- [ ] Calibrate the assembled scale
- [ ] Design the bowl platform and load-sensor mounts
- [ ] Add Home Assistant dashboards and automations
- [ ] Validate long-term stability and water resistance

## Calibration plan

Once assembled, the scale will need at least two calibration points:

1. Record the unloaded HX711 reading with the empty platform installed.
2. Place a known calibration weight on the platform and record the loaded reading.
3. Use those values to calculate the scale factor in ESPHome.
4. Verify the result with several known weights across the expected operating range.

The bowl, platform, and any permanent hardware should be installed before calibration so their weight can be included in the tare value.

## Water protection

This project places powered electronics near a water bowl. Use only low-voltage power, route cables through sealed glands, provide strain relief, and keep the electronics enclosure physically separated from areas where spilled water can collect. The printed carrier is an internal mounting part and is not itself a waterproof barrier.
