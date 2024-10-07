# Environment Variables for the OpenROAD Flow Scripts


Environment variables are used in the OpenROAD flow to define various
platform, design and tool specific variables to allow finer control and
user overrides at various flow stages. These are defined in the
`config.mk` file located in the platform and design specific directories.

## Platform

These variables must be defined in the platform specific config file
located in the OpenROAD-flow-scripts directory of
`./flow/platforms/<PLATFORM>/config.mk`

Note: The variable `PLATFORM_DIR` is set by default based on the `PLATFORM`
variable. For OpenROAD Flow Scripts we have the following public platforms:

-   `sky130hd`
-   `sky130hs`
-   `nangate45`
-   `asap7`

## Platform Specific Environment Variables


The table below lists the complete set of variables used in each of the
public platforms supported by the OpenROAD flow.


Note:
-   = indicates default definition assigned by the tool
-   ?= indicates that the variable value may be reassigned with design `config.mk`

## Design Specific Configuration Variables


### Required Variables

Required variables must be defined in the design configuration
file for each design located in the OpenROAD-flow-scripts directory of
`./flow/designs/<PLATFORM>/<DESIGN_NAME>/config.mk`

### Optional Variables

These are optional variables that may be over-ridden/appended with
default value from the platform `config.mk` by defining in the design
configuration file.

# Automatically generated tables from flow/scripts/variables.yaml
## Variables in alphabetic order

| Variable | Description |
| --- | --- |
| ABC_AREA | Strategies for Yosys ABC synthesis: Area/Speed. Default ABC_SPEED. |
| ABC_CLOCK_PERIOD_IN_PS | Clock period to be used by STA during synthesis. Default value read from `constraint.sdc`. |
| ABC_DRIVER_CELL | Default driver cell used during ABC synthesis. |
| ABC_LOAD_IN_FF | During synthesis set_load value used. |
| ADDER_MAP_FILE | List of adders treated as a black box by Yosys. |
| ADDITIONAL_FILES | Additional files to be added to `make issue` archive. |
| ADDITIONAL_GDS | Hardened macro GDS files listed here. |
| ADDITIONAL_LEFS | Hardened macro LEF view files listed here. The LEF information of the macros is immutable and used throughout all stages. Stored in the .odb file. |
| ADDITIONAL_LIBS | Hardened macro library files listed here. The library information is immutable and used throughout all stages. Not stored in the .odb file. |
| BLOCKS | Blocks used as hard macros in a hierarchical flow. Do note that you have to specify block-specific inputs file in the directory mentioned by Makefile. |
| CAP_MARGIN | Specifies a capacitance margin when fixing max capacitance violations. This option allows you to overfix. |
| CDL_FILES | Insert additional Circuit Description Language (`.cdl`) netlist files. |
| CELL_PAD_IN_SITES_DETAIL_PLACEMENT | Cell padding on both sides in site widths to ease routability in detail placement. |
| CELL_PAD_IN_SITES_GLOBAL_PLACEMENT | Cell padding on both sides in site widths to ease routability during global placement. |
| CLKGATE_MAP_FILE | List of cells for gating clock treated as a black box by Yosys. |
| CORE_AREA | The core area specified as a list of lower-left and upper-right corners in microns (X1 Y1 X2 Y2). |
| CORE_ASPECT_RATIO | The core aspect ratio (height / width). This value is ignored if `CORE_UTILIZATION` is undefined. |
| CORE_MARGIN | The margin between the core area and die area, in multiples of SITE heights. The margin is applied to each side. This variable is ignored if `CORE_UTILIZATION` is undefined. |
| CORE_UTILIZATION | The core utilization percentage (0-100). |
| CORNER | PVT corner library selection. Only available for ASAP7 and GF180 PDK. |
| CTS_ARGS | Override `clock_tree_synthesis` arguments. |
| CTS_BUF_DISTANCE | Distance (in microns) between buffers. |
| CTS_CLUSTER_DIAMETER | Maximum diameter (in microns) of sink cluster. Default 20. |
| CTS_CLUSTER_SIZE | Maximum number of sinks per cluster. Default 50. |
| CTS_SNAPSHOT | Creates ODB/SDC files prior to clock net and setup/hold repair. |
| DESIGN_NAME | The name of the top-level module of the design. |
| DESIGN_NICKNAME | DESIGN_NICKNAME just changes the directory name that ORFS outputs to be DESIGN_NICKNAME instead of DESIGN_NAME in case DESIGN_NAME is unwieldy or conflicts with a different design. |
| DETAILED_METRICS | If set, then calls report_metrics prior to repair operations in the CTS and global route stages |
| DETAILED_ROUTE_ARGS | Add additional arguments for debugging purposes during detail route. |
| DETAILED_ROUTE_END_ITERATION | Maximum number of iterations, default 64. |
| DFF_LIB_FILES | Technology mapping liberty files for flip-flops. |
| DIE_AREA | The die area specified as a list of lower-left and upper-right corners in microns (X1 Y1 X2 Y2). |
| DONT_USE_CELLS | Dont use cells eases pin access in detailed routing. |
| DONT_USE_LIBS | Set liberty files as `dont_use`. |
| DPO_MAX_DISPLACEMENT | Specifies how far an instance can be moved when optimizing. |
| ENABLE_DPO | Enable detail placement with improve_placement feature. |
| EQUIVALENCE_CHECK | Enable running equivalence checks to verify logical correctness of repair_timing. |
| FASTROUTE_TCL | Specifies a Tcl script with commands to run before FastRoute. |
| FILL_CELLS | Fill cells are used to fill empty sites. If not set or empty, fill cell insertion is skipped. |
| FILL_CONFIG | JSON rule file for metal fill during chip finishing. |
| FLOORPLAN_DEF | Use the DEF file to initialize floorplan. |
| GDS_FILES | Path to platform GDS files. |
| GENERATE_ARTIFACTS_ON_FAILURE | For instance Bazel needs artifacts (.odb and .rpt files) on a failure to allow the user to save hours on re-running the failed step locally, but when working with a Makefile flow, it is more natural to fail the step and leave the user to manually inspect the logs and artifacts directly via the file system. Set to 1 to change the behavior to generate artifacts upon failure to e.g. do a global route. The exit code will still be non-zero on all other failures that aren't covered by the "useful to inspect the artifacts on failure" use-case. Example: just like detailed routing, a global route that fails with congestion, is not a build failure(as in exit code non-zero), it is a successful(as in zero exit code) global route that produce reports detailing the problem. Detailed route will not proceed, if there is global routing congestion This allows build systems, such as bazel, to create artifacts for global and detailed route, even if the operation had problems, without having know about the semantics between global and detailed route. Considering that global and detailed route can run for a long time and use a lot of memory, this allows inspecting results on a laptop for a build that ran on a server. |
| GLOBAL_PLACEMENT_ARGS | Use additional tuning parameters during global placement other than default args defined in global_place.tcl. |
| GND_NETS_VOLTAGES | Used for IR Drop calculation. |
| GPL_ROUTABILITY_DRIVEN | Specifies whether the placer should use routability driven placement. |
| GPL_TIMING_DRIVEN | Specifies whether the placer should use timing driven placement. |
| GUI_NO_TIMING | Skip loading timing for a faster GUI load. |
| HOLD_SLACK_MARGIN | Specifies a time margin for the slack when fixing hold violations. This option allows you to overfix. |
| IO_PLACER_H | The metal layer on which to place the I/O pins horizontally (top and bottom of the die). |
| IO_PLACER_V | The metal layer on which to place the I/O pins vertically (sides of the die). |
| IR_DROP_LAYER | Default metal layer to report IR drop. |
| KLAYOUT_TECH_FILE | A mapping from LEF/DEF to GDS using the KLayout tool. |
| LATCH_MAP_FILE | List of latches treated as a black box by Yosys. |
| LIB_FILES | A Liberty file of the standard cell library with PVT characterization, input and output characteristics, timing and power definitions for each cell. |
| MACRO_BLOCKAGE_HALO | Blockage width overridden from default calculation. |
| MACRO_EXTENSION | Sets the number of GCells added to the blockages boundaries from macros. |
| MACRO_HALO_X | Set macro halo for x-direction. Only available for ASAP7 PDK. |
| MACRO_HALO_Y | Set macro halo for y-direction. Only available for ASAP7 PDK. |
| MACRO_PLACEMENT | Specifies the path of a file on how to place certain macros manually using read_macro_placement. |
| MACRO_PLACEMENT_TCL | Specifies the path of a TCL file on how to place certain macros manually. |
| MACRO_PLACE_CHANNEL | Horizontal/vertical channel width between macros (microns). Used by automatic macro placement when RTLMP_FLOW is disabled. Imagine channel=10 and halo=5. Then macros must be 10 apart but standard cells must be 5 away from a macro. |
| MACRO_PLACE_HALO | Horizontal/vertical halo around macros (microns). Used by automatic macro placement. |
| MACRO_WRAPPERS | The wrapper file that replaces existing macros with their wrapped version. |
| MAKE_TRACKS | Tcl file that defines add routing tracks to a floorplan. |
| MAX_ROUTING_LAYER | The highest metal layer name to be used in routing. |
| MAX_UNGROUP_SIZE | For hierarchical synthesis, we ungroup modules of size given by this variable. |
| MIN_BUF_CELL_AND_PORTS | Used to insert a buffer cell to pass through wires. Used in synthesis. |
| MIN_ROUTING_LAYER | The lowest metal layer name to be used in routing. |
| PDN_TCL | File path which has a set of power grid policies used by pdn to be applied to the design, such as layers to use, stripe width and spacing to generate the actual metal straps. |
| PLACE_DENSITY | The desired placement density of cells. It reflects how spread the cells would be on the core area. 1.0 = closely dense. 0.0 = widely spread. |
| PLACE_DENSITY_LB_ADDON | Check the lower boundary of the PLACE_DENSITY and add PLACE_DENSITY_LB_ADDON if it exists. |
| PLACE_SITE | Placement site for core cells defined in the technology LEF file. |
| PLATFORM | Specifies process design kit or technology node to be used. |
| POST_CTS_TCL | Specifies a Tcl script with commands to run after CTS is completed. |
| PRESERVE_CELLS | Mark modules to keep from getting removed in flattening. |
| PROCESS | Technology node or process in use. |
| PWR_NETS_VOLTAGES | Used for IR Drop calculation. |
| RCX_RULES | RC Extraction rules file path. |
| RECOVER_POWER | Specifies how many percent of paths with positive slacks can be slowed for power savings [0-100]. |
| REMOVE_CELLS_FOR_EQY | String patterns directly passed to write_verilog -remove_cells <> for equivalence checks. |
| REPAIR_PDN_VIA_LAYER | Remove power grid vias which generate DRC violations after detailed routing. |
| RESYNTH_AREA_RECOVER | Enable re-synthesis for area reclaim. |
| RESYNTH_TIMING_RECOVER | Enable re-synthesis for timing optimization. |
| ROUTING_LAYER_ADJUSTMENT | Default routing layer adjustment |
| RTLMP_FLOW | 1 to enable the Hierarchical RTLMP flow, default empty. |
| SC_LEF | Path to technology standard cell LEF file. |
| SDC_FILE | The path to design constraint (SDC) file. |
| SEAL_GDS | Seal macro to place around the design. |
| SETUP_SLACK_MARGIN | Specifies a time margin for the slack when fixing setup violations. |
| SET_RC_TCL | Metal & Via RC definition file path. |
| SKIP_CTS_REPAIR_TIMING | Skipping CTS repair, which can take a long time, can be useful in architectural exploration or when getting CI up and running. |
| SKIP_GATE_CLONING | Do not use gate cloning transform to fix timing violations (default: use gate cloning). |
| SKIP_INCREMENTAL_REPAIR |  |
| SKIP_PIN_SWAP | Do not use pin swapping as a transform to fix timing violations (default: use pin swapping). |
| SKIP_REPORT_METRICS | If set to 1, then metrics, report_metrics does nothing. Useful to speed up builds. |
| SLEW_MARGIN | Specifies a slew margin when fixing max slew violations. This option allows you to overfix. |
| SYNTH_ARGS | Optional synthesis variables for yosys. |
| SYNTH_HIERARCHICAL | Enable to Synthesis hierarchically, otherwise considered flat synthesis. |
| TAPCELL_TCL | Path to Endcap and Welltie cells file. |
| TAP_CELL_NAME | Name of the cell to use in tap cell insertion. |
| TECH_LEF | A technology LEF file of the PDK that includes all relevant information regarding metal layers, vias, and spacing requirements. |
| TIEHI_CELL_AND_PORT | Tie high cells used in Yosys synthesis to replace a logical 1 in the Netlist. |
| TIELO_CELL_AND_PORT | Tie low cells used in Yosys synthesis to replace a logical 0 in the Netlist. |
| TNS_END_PERCENT | Default TNS_END_PERCENT value for post CTS timing repair. Try fixing all violating endpoints by default (reduce to 5% for runtime). Specifies how many percent of violating paths to fix [0-100]. Worst path will always be fixed. |
| USE_FILL | Whether to perform metal density filling. Default 0 (=off). |
| VERILOG_FILES | The path to the design Verilog files or JSON files providing a description of modules (check `yosys -h write_json` for more details). |
| VERILOG_INCLUDE_DIRS | Specifies the include directories for the Verilog input files. |
| VERILOG_TOP_PARAMS | Apply toplevel params (if exist). |
## synth variables

ABC_AREA ABC_CLOCK_PERIOD_IN_PS ABC_DRIVER_CELL ABC_LOAD_IN_FF ADDER_MAP_FILE CLKGATE_MAP_FILE LATCH_MAP_FILE MAX_UNGROUP_SIZE MIN_BUF_CELL_AND_PORTS RESYNTH_AREA_RECOVER RESYNTH_TIMING_RECOVER SYNTH_HIERARCHICAL TIEHI_CELL_AND_PORT TIELO_CELL_AND_PORT VERILOG_FILES VERILOG_INCLUDE_DIRS VERILOG_TOP_PARAMS

## floorplan variables

CELL_PAD_IN_SITES_GLOBAL_PLACEMENT CORE_AREA CORE_ASPECT_RATIO CORE_MARGIN CORE_UTILIZATION DIE_AREA FLOORPLAN_DEF IO_PLACER_H IO_PLACER_V MACRO_BLOCKAGE_HALO MACRO_HALO_X MACRO_HALO_Y MACRO_PLACEMENT MACRO_PLACEMENT_TCL MACRO_PLACE_CHANNEL MACRO_PLACE_HALO MACRO_WRAPPERS MAKE_TRACKS PDN_TCL PLACE_DENSITY PLACE_SITE RTLMP_FLOW TAPCELL_TCL TNS_END_PERCENT

## place variables

CELL_PAD_IN_SITES_DETAIL_PLACEMENT CELL_PAD_IN_SITES_GLOBAL_PLACEMENT GPL_ROUTABILITY_DRIVEN GPL_TIMING_DRIVEN IO_PLACER_H IO_PLACER_V MAX_ROUTING_LAYER MIN_ROUTING_LAYER PLACE_DENSITY ROUTING_LAYER_ADJUSTMENT TIEHI_CELL_AND_PORT TIELO_CELL_AND_PORT

## cts variables

CELL_PAD_IN_SITES_DETAIL_PLACEMENT CTS_ARGS CTS_BUF_DISTANCE CTS_CLUSTER_DIAMETER CTS_CLUSTER_SIZE CTS_SNAPSHOT DETAILED_METRICS EQUIVALENCE_CHECK POST_CTS_TCL REMOVE_CELLS_FOR_EQY SKIP_CTS_REPAIR_TIMING TNS_END_PERCENT

## grt variables

CELL_PAD_IN_SITES_DETAIL_PLACEMENT DETAILED_METRICS MAX_ROUTING_LAYER MIN_ROUTING_LAYER ROUTING_LAYER_ADJUSTMENT TNS_END_PERCENT

## route variables

DETAILED_ROUTE_ARGS DETAILED_ROUTE_END_ITERATION MAX_ROUTING_LAYER MIN_ROUTING_LAYER ROUTING_LAYER_ADJUSTMENT

## final variables

ROUTING_LAYER_ADJUSTMENT

