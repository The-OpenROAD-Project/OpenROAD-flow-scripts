# 3D Hybrid Bonding Yield Flow

A Makefile-driven flow for 3D hybrid bonding yield analysis. It combines
OpenROAD for 3D stack validation with [YAP](https://github.com/The-OpenROAD-Project/YAP)
(Yield Analysis Platform) for wafer-to-wafer (W2W) or die-to-wafer (D2W) hybrid
bonding yield simulation, and visualizes per-pad risk heatmaps in the OpenROAD
GUI.

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
make DESIGN_CONFIG=./designs/3d/design_2/config.mk
```

Or run individual steps:

```bash
make DESIGN_CONFIG=./designs/3d/design_2/config.mk yap_simulate
```

One design ships with the flow:

| Design | Stack | Simulator | Inputs |
| --- | --- | --- | --- |
| `design_2` | Four `Compute_Large` chiplets side by side on an organic substrate, four interfaces at the same z | D2W | Next to `config.mk`, in the design directory |

| Step | Target | Description | Output |
| --- | --- | --- | --- |
| 1 | `check_3dblox` | Reads the 3D stack config into OpenROAD, validates the design, writes an ODB | `results/3d/<design>/<design>.odb` |
| 2 | `prepare` | Stages the design files into `objects/`, patching the YAP config copy with the output path and sample count, and optionally assigning bump names | `objects/3d/<design>/` |
| 3 | `generate_criticality` | Generates a default criticality file for any `.bmap` missing one | `objects/3d/<design>/*_criticality.txt` |
| 4 | `yap_simulate` | Runs the YAP Monte Carlo W2W or D2W hybrid bonding simulation | `results/3d/<design>/**/*.npz` |
| 5 | `generate_risk_map` | Converts the YAP fail maps into per-pad risk CSVs, one per failure mechanism | `results/3d/<design>/**/*_risk.csv` |
| 6 | `view_heatmaps` | Opens the OpenROAD web viewer with the risk heatmaps attached to their chiplets | Interactive viewer |

`make` (or `make all`) runs steps 1 through 5. Step 6 is interactive and is
never part of `all`.

Step 6 prints a URL and stays in the foreground serving it. The heatmaps land
in the viewer's Heat Maps panel, one entry per bonding interface. To pin the
port instead of letting the server pick one:

```bash
make DESIGN_CONFIG=./designs/3d/design_2/config.mk OR_ARGS="-web_port 8080" view_heatmaps
```

`make clean` removes this design's `objects/`, `results/` and `logs/`
directories.

Per-step logs land in `logs/3d/<design>/`.

> **Note:** `view_heatmaps` calls `web_load_chiplet_heatmap`, which is not in
> every OpenROAD build. If the command is missing, the viewer reports an unknown
> command; steps 1 to 5 are unaffected.

## Choosing W2W or D2W

YAP has two simulators, and a design picks one with `YAP_FLOW`:

- `W2W` (default): wafer-to-wafer, whole wafers bonded to each other.
- `D2W`: die-to-wafer, individual dies placed onto a base wafer or substrate.

| Variable | Applies to | Default | Description |
| --- | --- | --- | --- |
| `YAP_FLOW` | both | `W2W` | `W2W` or `D2W`; selects `$(YAP_HOME)/W2W` or `$(YAP_HOME)/D2W` |
| `YAP_MODE` | both | `w2w_simulation` / `d2w_simulation` | Section of `YAP_CONFIG` to run |
| `NUM_WAFERS` | W2W | `1` | Written to `NUM_WAFER_STACKS` in the staged config |
| `NUM_DIE_STACKS` | D2W | `1000` | Written to `NUM_DIE_STACKS` in the staged config |
| `YAP_CRITICALITY_PROFILE` | D2W | `default` | `default` or `esd_strict`, see YAP's `D2W/utils/generate_criticality.py` |
| `YAP_ASSIGN_BUMP_NAMES_ARGS` | both | empty | Arguments to YAP's `D2W/utils/assign_bump_names.py`, for `.bmap` files without port/net names |

The two simulators take different configs: a W2W `YAP_CONFIG` has
`w2w_simulation`/`w2w_modeling` sections, a D2W one `d2w_simulation`/
`d2w_modeling`. `$(YAP_HOME)/D2W/configs/GOLDEN.yaml` is a D2W starting point.

D2W names its outputs with a `__<config name>__<profile>` suffix, for example
`assembly_fail_map_per_interface_dict__design_2_d2w__default.npz`. The flow
accounts for this.

Some `.bmap` files ship with `-` in place of every port and net name, which
YAP would read as one net shared by every bump. Setting
`YAP_ASSIGN_BUMP_NAMES_ARGS` names them by ratio during `prepare`, for example:

```makefile
export YAP_ASSIGN_BUMP_NAMES_ARGS = --critical-ratio 0.30 --redundant-ratio 0 \
                                    --pg-ratio 0.50 --dummy-ratio 0.20
```

Only the staged copies in `objects/` are renamed. Changing this variable does
not re-run `prepare` on its own; run `make clean` first.

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
export YAP_FLOW         = W2W               # or D2W, see "Choosing W2W or D2W"
export YAP_MODE         = w2w_simulation    # or w2w_modeling
export NUM_WAFERS       = 1                 # NUM_DIE_STACKS for D2W

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
inside a YAP checkout (e.g. `$(YAP_HOME)/W2W/input/<design>`).

Only list the `*_From_*.bmap` files in `BMAP_FILES` that YAP should simulate.
`generate_criticality` globs for that pattern in the staged objects directory,
so a `*_To_*.bmap` that is not staged is simply not simulated.

`<design>.yaml` holds the YAP simulation parameters: wafer geometry, material
properties, misalignment distributions and so on. Use an existing design's YAML
as a starting point. The flow never modifies it - `prepare` copies it into
`objects/` and patches the copy, so `OUTPUT_DIR` and `NUM_WAFER_STACKS` (or
`NUM_DIE_STACKS` for D2W) in the original are ignored.

Then run:

```bash
make DESIGN_CONFIG=./designs/3d/<design>/config.mk
```
