# 3D Hybrid Bonding Yield Flow

A Makefile-driven flow for 3D hybrid bonding yield analysis. It combines
OpenROAD for 3D stack validation with [YAP](https://github.com/osamahammad21/YAP)
(Yield Analysis Platform) for wafer-to-wafer (W2W) hybrid bonding yield
simulation, and visualizes per-pad risk heatmaps in the OpenROAD GUI.

This flow shares the ORFS directory layout and `make` entry point with the
RTL-to-GDS flow, but nothing else: there is no platform, no synthesis and no
place and route. It is selected per design, and a design that does not ask for
it is unaffected.

## Selecting the flow

A 3D design config opts in by setting `FLOW_TYPE`:

```makefile
export FLOW_TYPE = 3d
```

The top level `flow/Makefile` reads the design config first, and only then
decides which flow to set up. With `FLOW_TYPE=3d` it includes
`flow/scripts/3d.mk` and skips `flow/scripts/variables.mk` and every RTL-to-GDS
target. Running `make` without `DESIGN_CONFIG`, or with any of the shipped
2D design configs, never touches the 3D flow.

## Setup

The flow needs `tools/YAP`, which is a submodule like any other and comes in
with `git submodule update --init --recursive`. Its Python requirements are not
installed by default, since the RTL-to-GDS flow has no use for them:

```bash
./build_openroad.sh --3d
```

This is additive - it does everything a normal `./build_openroad.sh` does, plus
installing `tools/YAP/requirements.txt` into a venv at `tools/install/yap-venv`
The flow uses that venv's Python by default; set `PYTHON_EXE` to use
another interpreter.

`YAP_HOME` defaults to `tools/YAP` and can be pointed at a YAP checkout
elsewhere.

## Running

```bash
cd flow
make DESIGN_CONFIG=./designs/3d/design_6/config.mk
```

Or run individual steps:

```bash
make DESIGN_CONFIG=./designs/3d/design_6/config.mk yap_simulate
```

Two designs ship with the flow, and they differ in where their inputs live:

| Design | Stack | Inputs |
| --- | --- | --- |
| `design_6` | A four high DRAM stack on a TSV interconnect die, four interfaces bonded vertically | In the YAP checkout, under `$(YAP_HOME)/W2W/input/design_6` |
| `design_2` | Four `Compute_Large` chiplets side by side on an organic substrate, four interfaces at the same z | Next to `config.mk`, in the design directory |

| Step | Target | Description | Output |
| --- | --- | --- | --- |
| 1 | `check_3dblox` | Reads the 3D stack config into OpenROAD, validates the design, writes an ODB | `results/3d/<design>/<design>.odb` |
| 2 | `prepare` | Stages the design files into `objects/`, patching the YAP config copy with the output path and `NUM_WAFERS` | `objects/3d/<design>/` |
| 3 | `generate_criticality` | Generates a default criticality file for any `.bmap` missing one | `objects/3d/<design>/*_criticality.txt` |
| 4 | `yap_simulate` | Runs the YAP Monte Carlo W2W hybrid bonding simulation | `results/3d/<design>/**/*.npz` |
| 5 | `generate_risk_map` | Converts the YAP fail maps into per-pad risk CSVs, one per failure mechanism | `results/3d/<design>/**/*_risk.csv` |
| 6 | `view_heatmaps` | Opens the OpenROAD web viewer with the risk heatmaps attached to their chiplets | Interactive viewer |

`make` (or `make all`) runs steps 1 through 5. Step 6 is interactive and is
never part of `all`.

Step 6 prints a URL and stays in the foreground serving it. The heatmaps land
in the viewer's Heat Maps panel, one entry per bonding interface. To pin the
port instead of letting the server pick one:

```bash
make DESIGN_CONFIG=./designs/3d/design_6/config.mk OR_ARGS="-web_port 8080" view_heatmaps
```

`make clean` removes this design's `objects/`, `results/` and `logs/`
directories.

Per-step logs land in `logs/3d/<design>/`.

> **Note:** `view_heatmaps` calls `web_load_chiplet_heatmap`, which is not in
> every OpenROAD build. If the command is missing, the viewer reports an unknown
> command; steps 1 to 5 are unaffected.

## Directory layout

The 3D flow uses `3d` where the RTL-to-GDS flow uses the platform name, so 3D
runs never collide with a hardened design of the same name. `FLOW_VARIANT` has
no meaning here.

```
flow/
├── designs/3d/<design>/config.mk   # design configuration
├── scripts/3d.mk                   # flow variables and targets
├── scripts/3d/                     # flow scripts (Tcl + Python)
├── objects/3d/<design>/            # staged YAP inputs   (generated)
├── results/3d/<design>/            # ODB and simulation output (generated)
└── logs/3d/<design>/               # per-step logs       (generated)
```

## Failure mechanisms

YAP models five failure mechanisms per bonding interface:

| Mechanism | Description |
| --- | --- |
| `overlay` | Random and systematic pad misalignment |
| `particle` | Particle contamination defects |
| `mechanical` | Wafer warpage and peeling stress |
| `ESD` | Electrostatic discharge at tilt/dish conditions |
| `overall` | Any of the above |

`view_heatmaps` loads the `overall` maps.

### Risk map CSV format

`generate_risk_map.py` writes what `web_load_chiplet_heatmap` reads, so the two
have to agree:

```
<chiplet_instance>,<connection_name>_<mechanism>
x0,y0,x1,y1,value
...
```

The header row names the chiplet the pads belong to; the server matches it
against the chiplet's hierarchical path, instance name or chip name, and applies
that chiplet's world transform. So the pad coordinates are in the chiplet's own
local frame, in microns - not stack coordinates. The instance name comes from
the `ChipletInst` key in the `.3dbx` (`Memory_DRAM_0_1`, not the `reference`
`Memory_DRAM_0`).

## Adding a design

Create `flow/designs/3d/<design>/config.mk`:

```makefile
export FLOW_TYPE        = 3d

export DESIGN           = <design>
export YAP_MODE         = w2w_simulation    # or w2w_modeling
export NUM_WAFERS       = 1

export YAP_CONFIG       = $(DESIGN_DIR)/<design>.yaml
export STACK_CONFIG     = $(DESIGN_DIR)/generated_stack_config.3dbx
export CHIPLET_DEFS     = $(DESIGN_DIR)/generated_chiplet_definitions.3dbv
export BMAP_FILES       = $(DESIGN_DIR)/Interface_A_From_B.bmap \
                          $(DESIGN_DIR)/Interface_B_From_A.bmap
export THREEDBF_FILES   = $(DESIGN_DIR)/ChipletA.3dbf \
                          $(DESIGN_DIR)/ChipletB.3dbf
```

Every input is named by its full path, so the files can live next to
`config.mk` (`$(DESIGN_DIR)`, as above and as `designs/3d/design_2` does) or
inside a YAP checkout (`$(YAP_HOME)/W2W/input/<design>`, as
`designs/3d/design_6` does).

Only list the `*_From_*.bmap` files in `BMAP_FILES` that YAP should simulate.
`generate_criticality` globs for that pattern in the staged objects directory,
so a `*_To_*.bmap` that is not staged is simply not simulated.

`<design>.yaml` holds the YAP simulation parameters: wafer geometry, material
properties, misalignment distributions and so on. Use an existing design's YAML
as a starting point. The flow never modifies it - `prepare` copies it into
`objects/` and patches the copy, so `OUTPUT_DIR` and `NUM_WAFER_STACKS` in the
original are ignored.

Then run:

```bash
make DESIGN_CONFIG=./designs/3d/<design>/config.mk
```
