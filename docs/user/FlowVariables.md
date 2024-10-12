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

| Variable | Description | Default |
| --- | --- | --- |
| <a name="ABC_AREA"></a>ABC_AREA| Strategies for Yosys ABC synthesis: Area/Speed. Default ABC_SPEED.|  |
| <a name="ABC_CLOCK_PERIOD_IN_PS"></a>ABC_CLOCK_PERIOD_IN_PS| Clock period to be used by STA during synthesis. Default value read from `constraint.sdc`.|  |
| <a name="ABC_DRIVER_CELL"></a>ABC_DRIVER_CELL| Default driver cell used during ABC synthesis.|  |
| <a name="ABC_LOAD_IN_FF"></a>ABC_LOAD_IN_FF| During synthesis set_load value used.|  |
| <a name="ADDER_MAP_FILE"></a>ADDER_MAP_FILE| List of adders treated as a black box by Yosys.|  |
| <a name="ADDITIONAL_FILES"></a>ADDITIONAL_FILES| Additional files to be added to `make issue` archive.|  |
| <a name="ADDITIONAL_GDS"></a>ADDITIONAL_GDS| Hardened macro GDS files listed here.|  |
| <a name="ADDITIONAL_LEFS"></a>ADDITIONAL_LEFS| Hardened macro LEF view files listed here. The LEF information of the macros is immutable and used throughout all stages. Stored in the .odb file.|  |
| <a name="ADDITIONAL_LIBS"></a>ADDITIONAL_LIBS| Hardened macro library files listed here. The library information is immutable and used throughout all stages. Not stored in the .odb file.|  |
| <a name="BLOCKS"></a>BLOCKS| Blocks used as hard macros in a hierarchical flow. Do note that you have to specify block-specific inputs file in the directory mentioned by Makefile.|  |
| <a name="CAP_MARGIN"></a>CAP_MARGIN| Specifies a capacitance margin when fixing max capacitance violations. This option allows you to overfix.|  |
| <a name="CDL_FILES"></a>CDL_FILES| Insert additional Circuit Description Language (`.cdl`) netlist files.|  |
| <a name="CELL_PAD_IN_SITES_DETAIL_PLACEMENT"></a>CELL_PAD_IN_SITES_DETAIL_PLACEMENT| Cell padding on both sides in site widths to ease routability in detail placement.|  |
| <a name="CELL_PAD_IN_SITES_GLOBAL_PLACEMENT"></a>CELL_PAD_IN_SITES_GLOBAL_PLACEMENT| Cell padding on both sides in site widths to ease routability during global placement.|  |
| <a name="CLKGATE_MAP_FILE"></a>CLKGATE_MAP_FILE| List of cells for gating clock treated as a black box by Yosys.|  |
| <a name="CORE_AREA"></a>CORE_AREA| The core area specified as a list of lower-left and upper-right corners in microns (X1 Y1 X2 Y2).|  |
| <a name="CORE_ASPECT_RATIO"></a>CORE_ASPECT_RATIO| The core aspect ratio (height / width). This value is ignored if `CORE_UTILIZATION` is undefined.|  |
| <a name="CORE_MARGIN"></a>CORE_MARGIN| The margin between the core area and die area, in multiples of SITE heights. The margin is applied to each side. This variable is ignored if `CORE_UTILIZATION` is undefined.|  |
| <a name="CORE_UTILIZATION"></a>CORE_UTILIZATION| The core utilization percentage (0-100).|  |
| <a name="CORNER"></a>CORNER| PVT corner library selection. Only available for ASAP7 and GF180 PDK.|  |
| <a name="CTS_ARGS"></a>CTS_ARGS| Override `clock_tree_synthesis` arguments.|  |
| <a name="CTS_BUF_DISTANCE"></a>CTS_BUF_DISTANCE| Distance (in microns) between buffers.|  |
| <a name="CTS_CLUSTER_DIAMETER"></a>CTS_CLUSTER_DIAMETER| Maximum diameter (in microns) of sink cluster. Default 20.|  |
| <a name="CTS_CLUSTER_SIZE"></a>CTS_CLUSTER_SIZE| Maximum number of sinks per cluster. Default 50.|  |
| <a name="CTS_SNAPSHOT"></a>CTS_SNAPSHOT| Creates ODB/SDC files prior to clock net and setup/hold repair.|  |
| <a name="DESIGN_NAME"></a>DESIGN_NAME| The name of the top-level module of the design.|  |
| <a name="DESIGN_NICKNAME"></a>DESIGN_NICKNAME| DESIGN_NICKNAME just changes the directory name that ORFS outputs to be DESIGN_NICKNAME instead of DESIGN_NAME in case DESIGN_NAME is unwieldy or conflicts with a different design.|  |
| <a name="DETAILED_METRICS"></a>DETAILED_METRICS| If set, then calls report_metrics prior to repair operations in the CTS and global route stages| 0 |
| <a name="DETAILED_ROUTE_ARGS"></a>DETAILED_ROUTE_ARGS| Add additional arguments for debugging purposes during detail route.|  |
| <a name="DETAILED_ROUTE_END_ITERATION"></a>DETAILED_ROUTE_END_ITERATION| Maximum number of iterations, default 64.|  |
| <a name="DFF_LIB_FILES"></a>DFF_LIB_FILES| Technology mapping liberty files for flip-flops.|  |
| <a name="DIE_AREA"></a>DIE_AREA| The die area specified as a list of lower-left and upper-right corners in microns (X1 Y1 X2 Y2).|  |
| <a name="DONT_USE_CELLS"></a>DONT_USE_CELLS| Dont use cells eases pin access in detailed routing.|  |
| <a name="DONT_USE_LIBS"></a>DONT_USE_LIBS| Set liberty files as `dont_use`.|  |
| <a name="DPO_MAX_DISPLACEMENT"></a>DPO_MAX_DISPLACEMENT| Specifies how far an instance can be moved when optimizing.|  |
| <a name="ENABLE_DPO"></a>ENABLE_DPO| Enable detail placement with improve_placement feature.|  |
| <a name="EQUIVALENCE_CHECK"></a>EQUIVALENCE_CHECK| Enable running equivalence checks to verify logical correctness of repair_timing.| 0 |
| <a name="FASTROUTE_TCL"></a>FASTROUTE_TCL| Specifies a Tcl script with commands to run before FastRoute.|  |
| <a name="FILL_CELLS"></a>FILL_CELLS| Fill cells are used to fill empty sites. If not set or empty, fill cell insertion is skipped.|  |
| <a name="FILL_CONFIG"></a>FILL_CONFIG| JSON rule file for metal fill during chip finishing.|  |
| <a name="FLOORPLAN_DEF"></a>FLOORPLAN_DEF| Use the DEF file to initialize floorplan.|  |
| <a name="GDS_FILES"></a>GDS_FILES| Path to platform GDS files.|  |
| <a name="GENERATE_ARTIFACTS_ON_FAILURE"></a>GENERATE_ARTIFACTS_ON_FAILURE| For instance Bazel needs artifacts (.odb and .rpt files) on a failure to allow the user to save hours on re-running the failed step locally, but when working with a Makefile flow, it is more natural to fail the step and leave the user to manually inspect the logs and artifacts directly via the file system. Set to 1 to change the behavior to generate artifacts upon failure to e.g. do a global route. The exit code will still be non-zero on all other failures that aren't covered by the "useful to inspect the artifacts on failure" use-case. Example: just like detailed routing, a global route that fails with congestion, is not a build failure(as in exit code non-zero), it is a successful(as in zero exit code) global route that produce reports detailing the problem. Detailed route will not proceed, if there is global routing congestion This allows build systems, such as bazel, to create artifacts for global and detailed route, even if the operation had problems, without having know about the semantics between global and detailed route. Considering that global and detailed route can run for a long time and use a lot of memory, this allows inspecting results on a laptop for a build that ran on a server.| 0 |
| <a name="GLOBAL_PLACEMENT_ARGS"></a>GLOBAL_PLACEMENT_ARGS| Use additional tuning parameters during global placement other than default args defined in global_place.tcl.|  |
| <a name="GND_NETS_VOLTAGES"></a>GND_NETS_VOLTAGES| Used for IR Drop calculation.|  |
| <a name="GPL_ROUTABILITY_DRIVEN"></a>GPL_ROUTABILITY_DRIVEN| Specifies whether the placer should use routability driven placement.|  |
| <a name="GPL_TIMING_DRIVEN"></a>GPL_TIMING_DRIVEN| Specifies whether the placer should use timing driven placement.|  |
| <a name="GUI_NO_TIMING"></a>GUI_NO_TIMING| Skip loading timing for a faster GUI load.|  |
| <a name="HOLD_SLACK_MARGIN"></a>HOLD_SLACK_MARGIN| Specifies a time margin for the slack when fixing hold violations. This option allows you to overfix.|  |
| <a name="IO_PLACER_H"></a>IO_PLACER_H| The metal layer on which to place the I/O pins horizontally (top and bottom of the die).|  |
| <a name="IO_PLACER_V"></a>IO_PLACER_V| The metal layer on which to place the I/O pins vertically (sides of the die).|  |
| <a name="IR_DROP_LAYER"></a>IR_DROP_LAYER| Default metal layer to report IR drop.|  |
| <a name="KLAYOUT_TECH_FILE"></a>KLAYOUT_TECH_FILE| A mapping from LEF/DEF to GDS using the KLayout tool.|  |
| <a name="LATCH_MAP_FILE"></a>LATCH_MAP_FILE| List of latches treated as a black box by Yosys.|  |
| <a name="LIB_FILES"></a>LIB_FILES| A Liberty file of the standard cell library with PVT characterization, input and output characteristics, timing and power definitions for each cell.|  |
| <a name="MACRO_BLOCKAGE_HALO"></a>MACRO_BLOCKAGE_HALO| Blockage width overridden from default calculation.|  |
| <a name="MACRO_EXTENSION"></a>MACRO_EXTENSION| Sets the number of GCells added to the blockages boundaries from macros.|  |
| <a name="MACRO_HALO_X"></a>MACRO_HALO_X| Set macro halo for x-direction. Only available for ASAP7 PDK.|  |
| <a name="MACRO_HALO_Y"></a>MACRO_HALO_Y| Set macro halo for y-direction. Only available for ASAP7 PDK.|  |
| <a name="MACRO_PLACEMENT"></a>MACRO_PLACEMENT| Specifies the path of a file on how to place certain macros manually using read_macro_placement.|  |
| <a name="MACRO_PLACEMENT_TCL"></a>MACRO_PLACEMENT_TCL| Specifies the path of a TCL file on how to place certain macros manually.|  |
| <a name="MACRO_PLACE_CHANNEL"></a>MACRO_PLACE_CHANNEL| Horizontal/vertical channel width between macros (microns). Used by automatic macro placement when RTLMP_FLOW is disabled. Imagine channel=10 and halo=5. Then macros must be 10 apart but standard cells must be 5 away from a macro.|  |
| <a name="MACRO_PLACE_HALO"></a>MACRO_PLACE_HALO| Horizontal/vertical halo around macros (microns). Used by automatic macro placement.|  |
| <a name="MACRO_WRAPPERS"></a>MACRO_WRAPPERS| The wrapper file that replaces existing macros with their wrapped version.|  |
| <a name="MAKE_TRACKS"></a>MAKE_TRACKS| Tcl file that defines add routing tracks to a floorplan.|  |
| <a name="MAX_ROUTING_LAYER"></a>MAX_ROUTING_LAYER| The highest metal layer name to be used in routing.|  |
| <a name="MAX_UNGROUP_SIZE"></a>MAX_UNGROUP_SIZE| For hierarchical synthesis, we ungroup modules of size given by this variable.|  |
| <a name="MIN_BUF_CELL_AND_PORTS"></a>MIN_BUF_CELL_AND_PORTS| Used to insert a buffer cell to pass through wires. Used in synthesis.|  |
| <a name="MIN_ROUTING_LAYER"></a>MIN_ROUTING_LAYER| The lowest metal layer name to be used in routing.|  |
| <a name="PDN_TCL"></a>PDN_TCL| File path which has a set of power grid policies used by pdn to be applied to the design, such as layers to use, stripe width and spacing to generate the actual metal straps.|  |
| <a name="PLACE_DENSITY"></a>PLACE_DENSITY| The desired placement density of cells. It reflects how spread the cells would be on the core area. 1.0 = closely dense. 0.0 = widely spread.|  |
| <a name="PLACE_DENSITY_LB_ADDON"></a>PLACE_DENSITY_LB_ADDON| Check the lower boundary of the PLACE_DENSITY and add PLACE_DENSITY_LB_ADDON if it exists.|  |
| <a name="PLACE_SITE"></a>PLACE_SITE| Placement site for core cells defined in the technology LEF file.|  |
| <a name="PLATFORM"></a>PLATFORM| Specifies process design kit or technology node to be used.|  |
| <a name="POST_CTS_TCL"></a>POST_CTS_TCL| Specifies a Tcl script with commands to run after CTS is completed.|  |
| <a name="PRESERVE_CELLS"></a>PRESERVE_CELLS| Mark modules to keep from getting removed in flattening.|  |
| <a name="PROCESS"></a>PROCESS| Technology node or process in use.|  |
| <a name="PWR_NETS_VOLTAGES"></a>PWR_NETS_VOLTAGES| Used for IR Drop calculation.|  |
| <a name="RCX_RULES"></a>RCX_RULES| RC Extraction rules file path.|  |
| <a name="RECOVER_POWER"></a>RECOVER_POWER| Specifies how many percent of paths with positive slacks can be slowed for power savings [0-100].| 0 |
| <a name="REMOVE_CELLS_FOR_EQY"></a>REMOVE_CELLS_FOR_EQY| String patterns directly passed to write_verilog -remove_cells <> for equivalence checks.|  |
| <a name="REPAIR_PDN_VIA_LAYER"></a>REPAIR_PDN_VIA_LAYER| Remove power grid vias which generate DRC violations after detailed routing.|  |
| <a name="RESYNTH_AREA_RECOVER"></a>RESYNTH_AREA_RECOVER| Enable re-synthesis for area reclaim.|  |
| <a name="RESYNTH_TIMING_RECOVER"></a>RESYNTH_TIMING_RECOVER| Enable re-synthesis for timing optimization.|  |
| <a name="ROUTING_LAYER_ADJUSTMENT"></a>ROUTING_LAYER_ADJUSTMENT| Default routing layer adjustment| 0.5 |
| <a name="RTLMP_FLOW"></a>RTLMP_FLOW| 1 to enable the Hierarchical RTLMP flow, default empty.|  |
| <a name="SC_LEF"></a>SC_LEF| Path to technology standard cell LEF file.|  |
| <a name="SDC_FILE"></a>SDC_FILE| The path to design constraint (SDC) file.|  |
| <a name="SEAL_GDS"></a>SEAL_GDS| Seal macro to place around the design.|  |
| <a name="SETUP_SLACK_MARGIN"></a>SETUP_SLACK_MARGIN| Specifies a time margin for the slack when fixing setup violations.|  |
| <a name="SET_RC_TCL"></a>SET_RC_TCL| Metal & Via RC definition file path.|  |
| <a name="SKIP_CTS_REPAIR_TIMING"></a>SKIP_CTS_REPAIR_TIMING| Skipping CTS repair, which can take a long time, can be useful in architectural exploration or when getting CI up and running.|  |
| <a name="SKIP_GATE_CLONING"></a>SKIP_GATE_CLONING| Do not use gate cloning transform to fix timing violations (default: use gate cloning).|  |
| <a name="SKIP_INCREMENTAL_REPAIR"></a>SKIP_INCREMENTAL_REPAIR| | 0 |
| <a name="SKIP_PIN_SWAP"></a>SKIP_PIN_SWAP| Do not use pin swapping as a transform to fix timing violations (default: use pin swapping).|  |
| <a name="SKIP_REPORT_METRICS"></a>SKIP_REPORT_METRICS| If set to 1, then metrics, report_metrics does nothing. Useful to speed up builds.|  |
| <a name="SLEW_MARGIN"></a>SLEW_MARGIN| Specifies a slew margin when fixing max slew violations. This option allows you to overfix.|  |
| <a name="SYNTH_ARGS"></a>SYNTH_ARGS| Optional synthesis variables for yosys.|  |
| <a name="SYNTH_HIERARCHICAL"></a>SYNTH_HIERARCHICAL| Enable to Synthesis hierarchically, otherwise considered flat synthesis.|  |
| <a name="TAPCELL_TCL"></a>TAPCELL_TCL| Path to Endcap and Welltie cells file.|  |
| <a name="TAP_CELL_NAME"></a>TAP_CELL_NAME| Name of the cell to use in tap cell insertion.|  |
| <a name="TECH_LEF"></a>TECH_LEF| A technology LEF file of the PDK that includes all relevant information regarding metal layers, vias, and spacing requirements.|  |
| <a name="TIEHI_CELL_AND_PORT"></a>TIEHI_CELL_AND_PORT| Tie high cells used in Yosys synthesis to replace a logical 1 in the Netlist.|  |
| <a name="TIELO_CELL_AND_PORT"></a>TIELO_CELL_AND_PORT| Tie low cells used in Yosys synthesis to replace a logical 0 in the Netlist.|  |
| <a name="TNS_END_PERCENT"></a>TNS_END_PERCENT| Default TNS_END_PERCENT value for post CTS timing repair. Try fixing all violating endpoints by default (reduce to 5% for runtime). Specifies how many percent of violating paths to fix [0-100]. Worst path will always be fixed.| 100 |
| <a name="USE_FILL"></a>USE_FILL| Whether to perform metal density filling. Default 0 (=off).|  |
| <a name="VERILOG_FILES"></a>VERILOG_FILES| The path to the design Verilog files or JSON files providing a description of modules (check `yosys -h write_json` for more details).|  |
| <a name="VERILOG_INCLUDE_DIRS"></a>VERILOG_INCLUDE_DIRS| Specifies the include directories for the Verilog input files.|  |
| <a name="VERILOG_TOP_PARAMS"></a>VERILOG_TOP_PARAMS| Apply toplevel params (if exist).|  |
## synth variables

- [ABC_AREA](#ABC_AREA)
- [ABC_CLOCK_PERIOD_IN_PS](#ABC_CLOCK_PERIOD_IN_PS)
- [ABC_DRIVER_CELL](#ABC_DRIVER_CELL)
- [ABC_LOAD_IN_FF](#ABC_LOAD_IN_FF)
- [ADDER_MAP_FILE](#ADDER_MAP_FILE)
- [ADDITIONAL_FILES](#ADDITIONAL_FILES)
- [CLKGATE_MAP_FILE](#CLKGATE_MAP_FILE)
- [LATCH_MAP_FILE](#LATCH_MAP_FILE)
- [MAX_UNGROUP_SIZE](#MAX_UNGROUP_SIZE)
- [MIN_BUF_CELL_AND_PORTS](#MIN_BUF_CELL_AND_PORTS)
- [RESYNTH_AREA_RECOVER](#RESYNTH_AREA_RECOVER)
- [RESYNTH_TIMING_RECOVER](#RESYNTH_TIMING_RECOVER)
- [SYNTH_HIERARCHICAL](#SYNTH_HIERARCHICAL)
- [TIEHI_CELL_AND_PORT](#TIEHI_CELL_AND_PORT)
- [TIELO_CELL_AND_PORT](#TIELO_CELL_AND_PORT)
- [VERILOG_FILES](#VERILOG_FILES)
- [VERILOG_INCLUDE_DIRS](#VERILOG_INCLUDE_DIRS)
- [VERILOG_TOP_PARAMS](#VERILOG_TOP_PARAMS)

## floorplan variables

- [ADDITIONAL_FILES](#ADDITIONAL_FILES)
- [CELL_PAD_IN_SITES_GLOBAL_PLACEMENT](#CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)
- [CORE_AREA](#CORE_AREA)
- [CORE_ASPECT_RATIO](#CORE_ASPECT_RATIO)
- [CORE_MARGIN](#CORE_MARGIN)
- [CORE_UTILIZATION](#CORE_UTILIZATION)
- [DIE_AREA](#DIE_AREA)
- [FLOORPLAN_DEF](#FLOORPLAN_DEF)
- [IO_PLACER_H](#IO_PLACER_H)
- [IO_PLACER_V](#IO_PLACER_V)
- [MACRO_BLOCKAGE_HALO](#MACRO_BLOCKAGE_HALO)
- [MACRO_HALO_X](#MACRO_HALO_X)
- [MACRO_HALO_Y](#MACRO_HALO_Y)
- [MACRO_PLACEMENT](#MACRO_PLACEMENT)
- [MACRO_PLACEMENT_TCL](#MACRO_PLACEMENT_TCL)
- [MACRO_PLACE_CHANNEL](#MACRO_PLACE_CHANNEL)
- [MACRO_PLACE_HALO](#MACRO_PLACE_HALO)
- [MACRO_WRAPPERS](#MACRO_WRAPPERS)
- [MAKE_TRACKS](#MAKE_TRACKS)
- [PDN_TCL](#PDN_TCL)
- [PLACE_DENSITY](#PLACE_DENSITY)
- [PLACE_SITE](#PLACE_SITE)
- [RTLMP_FLOW](#RTLMP_FLOW)
- [TAPCELL_TCL](#TAPCELL_TCL)
- [TNS_END_PERCENT](#TNS_END_PERCENT)

## place variables

- [ADDITIONAL_FILES](#ADDITIONAL_FILES)
- [CELL_PAD_IN_SITES_DETAIL_PLACEMENT](#CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
- [CELL_PAD_IN_SITES_GLOBAL_PLACEMENT](#CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)
- [GPL_ROUTABILITY_DRIVEN](#GPL_ROUTABILITY_DRIVEN)
- [GPL_TIMING_DRIVEN](#GPL_TIMING_DRIVEN)
- [IO_PLACER_H](#IO_PLACER_H)
- [IO_PLACER_V](#IO_PLACER_V)
- [MAX_ROUTING_LAYER](#MAX_ROUTING_LAYER)
- [MIN_ROUTING_LAYER](#MIN_ROUTING_LAYER)
- [PLACE_DENSITY](#PLACE_DENSITY)
- [ROUTING_LAYER_ADJUSTMENT](#ROUTING_LAYER_ADJUSTMENT)
- [TIEHI_CELL_AND_PORT](#TIEHI_CELL_AND_PORT)
- [TIELO_CELL_AND_PORT](#TIELO_CELL_AND_PORT)

## cts variables

- [ADDITIONAL_FILES](#ADDITIONAL_FILES)
- [CELL_PAD_IN_SITES_DETAIL_PLACEMENT](#CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
- [CTS_ARGS](#CTS_ARGS)
- [CTS_BUF_DISTANCE](#CTS_BUF_DISTANCE)
- [CTS_CLUSTER_DIAMETER](#CTS_CLUSTER_DIAMETER)
- [CTS_CLUSTER_SIZE](#CTS_CLUSTER_SIZE)
- [CTS_SNAPSHOT](#CTS_SNAPSHOT)
- [DETAILED_METRICS](#DETAILED_METRICS)
- [EQUIVALENCE_CHECK](#EQUIVALENCE_CHECK)
- [POST_CTS_TCL](#POST_CTS_TCL)
- [REMOVE_CELLS_FOR_EQY](#REMOVE_CELLS_FOR_EQY)
- [SKIP_CTS_REPAIR_TIMING](#SKIP_CTS_REPAIR_TIMING)
- [TNS_END_PERCENT](#TNS_END_PERCENT)

## grt variables

- [ADDITIONAL_FILES](#ADDITIONAL_FILES)
- [CELL_PAD_IN_SITES_DETAIL_PLACEMENT](#CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
- [DETAILED_METRICS](#DETAILED_METRICS)
- [MAX_ROUTING_LAYER](#MAX_ROUTING_LAYER)
- [MIN_ROUTING_LAYER](#MIN_ROUTING_LAYER)
- [ROUTING_LAYER_ADJUSTMENT](#ROUTING_LAYER_ADJUSTMENT)
- [TNS_END_PERCENT](#TNS_END_PERCENT)

## route variables

- [ADDITIONAL_FILES](#ADDITIONAL_FILES)
- [DETAILED_ROUTE_ARGS](#DETAILED_ROUTE_ARGS)
- [DETAILED_ROUTE_END_ITERATION](#DETAILED_ROUTE_END_ITERATION)
- [MAX_ROUTING_LAYER](#MAX_ROUTING_LAYER)
- [MIN_ROUTING_LAYER](#MIN_ROUTING_LAYER)
- [ROUTING_LAYER_ADJUSTMENT](#ROUTING_LAYER_ADJUSTMENT)

## final variables

- [ADDITIONAL_FILES](#ADDITIONAL_FILES)
- [ROUTING_LAYER_ADJUSTMENT](#ROUTING_LAYER_ADJUSTMENT)

## All stages variables

- [ADDITIONAL_FILES](#ADDITIONAL_FILES)

## Uncategorized variables

- [ADDITIONAL_GDS](#ADDITIONAL_GDS)
- [ADDITIONAL_LEFS](#ADDITIONAL_LEFS)
- [ADDITIONAL_LIBS](#ADDITIONAL_LIBS)
- [BLOCKS](#BLOCKS)
- [CAP_MARGIN](#CAP_MARGIN)
- [CDL_FILES](#CDL_FILES)
- [CORNER](#CORNER)
- [DESIGN_NAME](#DESIGN_NAME)
- [DESIGN_NICKNAME](#DESIGN_NICKNAME)
- [DFF_LIB_FILES](#DFF_LIB_FILES)
- [DONT_USE_CELLS](#DONT_USE_CELLS)
- [DONT_USE_LIBS](#DONT_USE_LIBS)
- [DPO_MAX_DISPLACEMENT](#DPO_MAX_DISPLACEMENT)
- [ENABLE_DPO](#ENABLE_DPO)
- [FASTROUTE_TCL](#FASTROUTE_TCL)
- [FILL_CELLS](#FILL_CELLS)
- [FILL_CONFIG](#FILL_CONFIG)
- [GDS_FILES](#GDS_FILES)
- [GENERATE_ARTIFACTS_ON_FAILURE](#GENERATE_ARTIFACTS_ON_FAILURE)
- [GLOBAL_PLACEMENT_ARGS](#GLOBAL_PLACEMENT_ARGS)
- [GND_NETS_VOLTAGES](#GND_NETS_VOLTAGES)
- [GUI_NO_TIMING](#GUI_NO_TIMING)
- [HOLD_SLACK_MARGIN](#HOLD_SLACK_MARGIN)
- [IR_DROP_LAYER](#IR_DROP_LAYER)
- [KLAYOUT_TECH_FILE](#KLAYOUT_TECH_FILE)
- [LIB_FILES](#LIB_FILES)
- [MACRO_EXTENSION](#MACRO_EXTENSION)
- [PLACE_DENSITY_LB_ADDON](#PLACE_DENSITY_LB_ADDON)
- [PLATFORM](#PLATFORM)
- [PRESERVE_CELLS](#PRESERVE_CELLS)
- [PROCESS](#PROCESS)
- [PWR_NETS_VOLTAGES](#PWR_NETS_VOLTAGES)
- [RCX_RULES](#RCX_RULES)
- [RECOVER_POWER](#RECOVER_POWER)
- [REPAIR_PDN_VIA_LAYER](#REPAIR_PDN_VIA_LAYER)
- [SC_LEF](#SC_LEF)
- [SDC_FILE](#SDC_FILE)
- [SEAL_GDS](#SEAL_GDS)
- [SETUP_SLACK_MARGIN](#SETUP_SLACK_MARGIN)
- [SET_RC_TCL](#SET_RC_TCL)
- [SKIP_GATE_CLONING](#SKIP_GATE_CLONING)
- [SKIP_INCREMENTAL_REPAIR](#SKIP_INCREMENTAL_REPAIR)
- [SKIP_PIN_SWAP](#SKIP_PIN_SWAP)
- [SKIP_REPORT_METRICS](#SKIP_REPORT_METRICS)
- [SLEW_MARGIN](#SLEW_MARGIN)
- [SYNTH_ARGS](#SYNTH_ARGS)
- [TAP_CELL_NAME](#TAP_CELL_NAME)
- [TECH_LEF](#TECH_LEF)
- [USE_FILL](#USE_FILL)

