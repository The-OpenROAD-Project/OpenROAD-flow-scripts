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


| Variable | Description | Default | Deprecated |
| --- | --- | --- | --- |
| <a name="ABC_AREA"></a>ABC_AREA| Strategies for Yosys ABC synthesis: Area/Speed. Default ABC_SPEED.| 0| |
| <a name="ABC_CLOCK_PERIOD_IN_PS"></a>ABC_CLOCK_PERIOD_IN_PS| Clock period to be used by STA during synthesis. Default value read from `constraint.sdc`.| | |
| <a name="ABC_DRIVER_CELL"></a>ABC_DRIVER_CELL| Default driver cell used during ABC synthesis.| | |
| <a name="ABC_LOAD_IN_FF"></a>ABC_LOAD_IN_FF| During synthesis set_load value used.| | |
| <a name="ABSTRACT_SOURCE"></a>ABSTRACT_SOURCE| Which .odb file to use to create abstract| | |
| <a name="ADDER_MAP_FILE"></a>ADDER_MAP_FILE| List of adders treated as a black box by Yosys.| | |
| <a name="ADDITIONAL_FILES"></a>ADDITIONAL_FILES| Additional files to be added to `make issue` archive.| | |
| <a name="ADDITIONAL_GDS"></a>ADDITIONAL_GDS| Hardened macro GDS files listed here.| | |
| <a name="ADDITIONAL_LEFS"></a>ADDITIONAL_LEFS| Hardened macro LEF view files listed here. The LEF information of the macros is immutable and used throughout all stages. Stored in the .odb file.| | |
| <a name="ADDITIONAL_LIBS"></a>ADDITIONAL_LIBS| Hardened macro library files listed here. The library information is immutable and used throughout all stages. Not stored in the .odb file.| | |
| <a name="BLOCKS"></a>BLOCKS| Blocks used as hard macros in a hierarchical flow. Do note that you have to specify block-specific inputs file in the directory mentioned by Makefile.| | |
| <a name="CAP_MARGIN"></a>CAP_MARGIN| Specifies a capacitance margin when fixing max capacitance violations. This option allows you to overfix.| | |
| <a name="CDL_FILES"></a>CDL_FILES| Insert additional Circuit Description Language (`.cdl`) netlist files.| | |
| <a name="CELL_PAD_IN_SITES_DETAIL_PLACEMENT"></a>CELL_PAD_IN_SITES_DETAIL_PLACEMENT| Cell padding on both sides in site widths to ease routability in detail placement.| 0| |
| <a name="CELL_PAD_IN_SITES_GLOBAL_PLACEMENT"></a>CELL_PAD_IN_SITES_GLOBAL_PLACEMENT| Cell padding on both sides in site widths to ease routability during global placement.| 0| |
| <a name="CLKGATE_MAP_FILE"></a>CLKGATE_MAP_FILE| List of cells for gating clock treated as a black box by Yosys.| | |
| <a name="CORE_AREA"></a>CORE_AREA| The core area specified as a list of lower-left and upper-right corners in microns (X1 Y1 X2 Y2).| | |
| <a name="CORE_ASPECT_RATIO"></a>CORE_ASPECT_RATIO| The core aspect ratio (height / width). This value is ignored if `CORE_UTILIZATION` is undefined.| | |
| <a name="CORE_MARGIN"></a>CORE_MARGIN| The margin between the core area and die area, specified in microns. Allowed values are either one value for all margins or a set of four values, one for each margin. The order of the four values are: `{bottom top left right}`. This variable is ignored if `CORE_UTILIZATION` is undefined.| | |
| <a name="CORE_UTILIZATION"></a>CORE_UTILIZATION| The core utilization percentage (0-100).| | |
| <a name="CORNER"></a>CORNER| PVT corner library selection. Only available for ASAP7 and GF180 PDKs.| | |
| <a name="CTS_ARGS"></a>CTS_ARGS| Override `clock_tree_synthesis` arguments.| | |
| <a name="CTS_BUF_DISTANCE"></a>CTS_BUF_DISTANCE| Distance (in microns) between buffers.| | |
| <a name="CTS_CLUSTER_DIAMETER"></a>CTS_CLUSTER_DIAMETER| Maximum diameter (in microns) of sink cluster.| 20| |
| <a name="CTS_CLUSTER_SIZE"></a>CTS_CLUSTER_SIZE| Maximum number of sinks per cluster.| 50| |
| <a name="CTS_SNAPSHOT"></a>CTS_SNAPSHOT| Creates ODB/SDC files prior to clock net and setup/hold repair.| | |
| <a name="DESIGN_NAME"></a>DESIGN_NAME| The name of the top-level module of the design.| | |
| <a name="DESIGN_NICKNAME"></a>DESIGN_NICKNAME| DESIGN_NICKNAME just changes the directory name that ORFS outputs to be DESIGN_NICKNAME instead of DESIGN_NAME in case DESIGN_NAME is unwieldy or conflicts with a different design.| | |
| <a name="DETAILED_METRICS"></a>DETAILED_METRICS| If set, then calls report_metrics prior to repair operations in the CTS and global route stages| 0| |
| <a name="DETAILED_ROUTE_ARGS"></a>DETAILED_ROUTE_ARGS| Add additional arguments for debugging purposes during detail route.| | |
| <a name="DETAILED_ROUTE_END_ITERATION"></a>DETAILED_ROUTE_END_ITERATION| Maximum number of iterations.| 64| |
| <a name="DFF_LIB_FILES"></a>DFF_LIB_FILES| Technology mapping liberty files for flip-flops.| | |
| <a name="DIE_AREA"></a>DIE_AREA| The die area specified as a list of lower-left and upper-right corners in microns (X1 Y1 X2 Y2).| | |
| <a name="DONT_USE_CELLS"></a>DONT_USE_CELLS| Dont use cells eases pin access in detailed routing.| | |
| <a name="DONT_USE_LIBS"></a>DONT_USE_LIBS| Set liberty files as `dont_use`.| | |
| <a name="DPO_MAX_DISPLACEMENT"></a>DPO_MAX_DISPLACEMENT| Specifies how far an instance can be moved when optimizing.| 5 1| |
| <a name="ENABLE_DPO"></a>ENABLE_DPO| Enable detail placement with improve_placement feature.| 1| |
| <a name="EQUIVALENCE_CHECK"></a>EQUIVALENCE_CHECK| Enable running equivalence checks to verify logical correctness of repair_timing.| 0| |
| <a name="FASTROUTE_TCL"></a>FASTROUTE_TCL| Specifies a Tcl script with commands to run before FastRoute.| | |
| <a name="FILL_CELLS"></a>FILL_CELLS| Fill cells are used to fill empty sites. If not set or empty, fill cell insertion is skipped.| | |
| <a name="FILL_CONFIG"></a>FILL_CONFIG| JSON rule file for metal fill during chip finishing.| | |
| <a name="FLOORPLAN_DEF"></a>FLOORPLAN_DEF| Use the DEF file to initialize floorplan.| | |
| <a name="GDS_ALLOW_EMPTY"></a>GDS_ALLOW_EMPTY| Regular expression of module names of macros that have no .gds file| | |
| <a name="GDS_FILES"></a>GDS_FILES| Path to platform GDS files.| | |
| <a name="GENERATE_ARTIFACTS_ON_FAILURE"></a>GENERATE_ARTIFACTS_ON_FAILURE| For instance Bazel needs artifacts (.odb and .rpt files) on a failure to allow the user to save hours on re-running the failed step locally, but when working with a Makefile flow, it is more natural to fail the step and leave the user to manually inspect the logs and artifacts directly via the file system. Set to 1 to change the behavior to generate artifacts upon failure to e.g. do a global route. The exit code will still be non-zero on all other failures that aren't covered by the "useful to inspect the artifacts on failure" use-case. Example: just like detailed routing, a global route that fails with congestion, is not a build failure(as in exit code non-zero), it is a successful(as in zero exit code) global route that produce reports detailing the problem. Detailed route will not proceed, if there is global routing congestion This allows build systems, such as bazel, to create artifacts for global and detailed route, even if the operation had problems, without having know about the semantics between global and detailed route. Considering that global and detailed route can run for a long time and use a lot of memory, this allows inspecting results on a laptop for a build that ran on a server.| 0| |
| <a name="GLOBAL_PLACEMENT_ARGS"></a>GLOBAL_PLACEMENT_ARGS| Use additional tuning parameters during global placement other than default args defined in global_place.tcl.| | |
| <a name="GLOBAL_ROUTE_ARGS"></a>GLOBAL_ROUTE_ARGS| Replaces default arguments for global route.| -congestion_iterations 30 -congestion_report_iter_step 5 -verbose| |
| <a name="GND_NETS_VOLTAGES"></a>GND_NETS_VOLTAGES| Used for IR Drop calculation.| | |
| <a name="GPL_ROUTABILITY_DRIVEN"></a>GPL_ROUTABILITY_DRIVEN| Specifies whether the placer should use routability driven placement.| 1| |
| <a name="GPL_TIMING_DRIVEN"></a>GPL_TIMING_DRIVEN| Specifies whether the placer should use timing driven placement.| 1| |
| <a name="GUI_TIMING"></a>GUI_TIMING| Load timing information when opening GUI. For large designs, this can be quite time consuming. Useful to disable when investigating non-timing aspects like floorplan, placement, routing, etc.| 1| |
| <a name="HOLD_SLACK_MARGIN"></a>HOLD_SLACK_MARGIN| Specifies a time margin for the slack when fixing hold violations. This option allows you to overfix or underfix (negative value, terminate retiming before 0 or positive slack). floorplan.tcl uses min of HOLD_SLACK_MARGIN and 0 (default hold slack margin). This avoids overrepair in floorplan for hold by default, but allows skipping hold repair using a negative HOLD_SLACK_MARGIN. Exiting timing repair early is useful in exploration where the .sdc has a fixed clock period at the design's target clock period and where HOLD/SETUP_SLACK_MARGIN is used to avoid overrepair (extremely long running times) when exploring different parameter settings. When an ideal clock is used, that is before CTS, a clock insertion delay of 0 is used in timing paths. This creates a mismatch between macros that have a .lib file from after CTS, when the clock is propagated. To mitigate this, OpenSTA will use subtract the clock insertion delay of macros when calculating timing with ideal clock. Provided that min_clock_tree_path and max_clock_tree_path are in the .lib file, which is the case for macros built with OpenROAD. This is less accurate than if OpenROAD had created a placeholder clock tree for timing estimation purposes prior to CTS. There will inevitably be inaccuracies in the timing calculation prior to CTS. Use a slack margin that is low enough, even negative, to avoid overrepair. Inaccuracies in the timing prior to CTS can also lead to underrepair, but there no obvious and simple way to avoid underrapir in these cases. Overrepair can lead to excessive runtimes in repair or too much buffering being added, which can present itself as congestion of hold cells or buffer cells. Another use of SETUP/HOLD_SLACK_MARGIN is design parameter exploration when trying to find the minimum clock period for a design. The SDC_FILE for a design can be quite complicated and instead of modifying the clock period in the SDC_FILE, which can be non-trivial, the clock period can be fixed at the target frequency and the SETUP/HOLD_SLACK_MARGIN can be swept to find a plausible current minimum clock period.| 0| |
| <a name="IO_CONSTRAINTS"></a>IO_CONSTRAINTS| File path to the IO constraints .tcl file.| | |
| <a name="IO_PLACER_H"></a>IO_PLACER_H| The metal layer on which to place the I/O pins horizontally (top and bottom of the die).| | |
| <a name="IO_PLACER_V"></a>IO_PLACER_V| The metal layer on which to place the I/O pins vertically (sides of the die).| | |
| <a name="IR_DROP_LAYER"></a>IR_DROP_LAYER| Default metal layer to report IR drop.| | |
| <a name="KLAYOUT_TECH_FILE"></a>KLAYOUT_TECH_FILE| A mapping from LEF/DEF to GDS using the KLayout tool.| | |
| <a name="LATCH_MAP_FILE"></a>LATCH_MAP_FILE| List of latches treated as a black box by Yosys.| | |
| <a name="LIB_FILES"></a>LIB_FILES| A Liberty file of the standard cell library with PVT characterization, input and output characteristics, timing and power definitions for each cell.| | |
| <a name="MACRO_BLOCKAGE_HALO"></a>MACRO_BLOCKAGE_HALO| Distance beyond the edges of a macro that will also be covered by the blockage generated for that macro. Note that the default macro blockage halo comes from the largest of the specified MACRO_PLACE_HALO x or y values. This variable overrides that calculation.| | |
| <a name="MACRO_EXTENSION"></a>MACRO_EXTENSION| Sets the number of GCells added to the blockages boundaries from macros.| | |
| <a name="MACRO_PLACEMENT"></a>MACRO_PLACEMENT| Specifies the path of a file on how to place certain macros manually using read_macro_placement.| | |
| <a name="MACRO_PLACEMENT_TCL"></a>MACRO_PLACEMENT_TCL| Specifies the path of a TCL file on how to place certain macros manually.| | |
| <a name="MACRO_PLACE_HALO"></a>MACRO_PLACE_HALO| Horizontal/vertical halo around macros (microns). Used by automatic macro placement.| | |
| <a name="MACRO_ROWS_HALO_X"></a>MACRO_ROWS_HALO_X| Horizontal distance between the edge of the macro and the beginning of the rows created by tapcell. Only available for ASAP7 PDK and GF180/uart-blocks design.| | |
| <a name="MACRO_ROWS_HALO_Y"></a>MACRO_ROWS_HALO_Y| Vertical distance between the edge of the macro and the beginning of the rows created by tapcell. Only available for ASAP7 PDK and GF180/uart-blocks design.| | |
| <a name="MACRO_WRAPPERS"></a>MACRO_WRAPPERS| The wrapper file that replaces existing macros with their wrapped version.| | |
| <a name="MAKE_TRACKS"></a>MAKE_TRACKS| Tcl file that defines add routing tracks to a floorplan.| | |
| <a name="MATCH_CELL_FOOTPRINT"></a>MATCH_CELL_FOOTPRINT| Enforce sizing operations to only swap cells that have the same layout boundary.| 0| |
| <a name="MAX_ROUTING_LAYER"></a>MAX_ROUTING_LAYER| The highest metal layer name to be used in routing.| | |
| <a name="MAX_UNGROUP_SIZE"></a>MAX_UNGROUP_SIZE| For hierarchical synthesis, we ungroup modules of larger area than given by this variable. The area unit used is the size of a basic nand2 gate from the platform's standard cell library. The default value is platform specific.| | |
| <a name="MIN_BUF_CELL_AND_PORTS"></a>MIN_BUF_CELL_AND_PORTS| Used to insert a buffer cell to pass through wires. Used in synthesis.| | |
| <a name="MIN_ROUTING_LAYER"></a>MIN_ROUTING_LAYER| The lowest metal layer name to be used in routing.| | |
| <a name="PDN_TCL"></a>PDN_TCL| File path which has a set of power grid policies used by pdn to be applied to the design, such as layers to use, stripe width and spacing to generate the actual metal straps.| | |
| <a name="PLACE_DENSITY"></a>PLACE_DENSITY| The desired placement density of cells. It reflects how spread the cells would be on the core area. 1.0 = closely dense. 0.0 = widely spread.| | |
| <a name="PLACE_DENSITY_LB_ADDON"></a>PLACE_DENSITY_LB_ADDON| Check the lower boundary of the PLACE_DENSITY and add PLACE_DENSITY_LB_ADDON if it exists.| | |
| <a name="PLACE_PINS_ARGS"></a>PLACE_PINS_ARGS| Arguments to place_pins| | |
| <a name="PLACE_SITE"></a>PLACE_SITE| Placement site for core cells defined in the technology LEF file.| | |
| <a name="PLATFORM"></a>PLATFORM| Specifies process design kit or technology node to be used.| | |
| <a name="POST_CTS_TCL"></a>POST_CTS_TCL| Specifies a Tcl script with commands to run after CTS is completed.| | |
| <a name="PRESERVE_CELLS"></a>PRESERVE_CELLS| Mark modules to keep from getting removed in flattening.| | |
| <a name="PROCESS"></a>PROCESS| Technology node or process in use.| | |
| <a name="PWR_NETS_VOLTAGES"></a>PWR_NETS_VOLTAGES| Used for IR Drop calculation.| | |
| <a name="RCX_RULES"></a>RCX_RULES| RC Extraction rules file path.| | |
| <a name="RECOVER_POWER"></a>RECOVER_POWER| Specifies how many percent of paths with positive slacks can be slowed for power savings [0-100].| 0| |
| <a name="REMOVE_ABC_BUFFERS"></a>REMOVE_ABC_BUFFERS| Remove abc buffers from the netlist. If timing repair in floorplanning is taking too long, use a SETUP/HOLD_SLACK_MARGIN to terminate timing repair early instead of using REMOVE_ABC_BUFFERS or set SKIP_LAST_GASP=1.| | yes|
| <a name="REMOVE_CELLS_FOR_EQY"></a>REMOVE_CELLS_FOR_EQY| String patterns directly passed to write_verilog -remove_cells <> for equivalence checks.| | |
| <a name="REPAIR_PDN_VIA_LAYER"></a>REPAIR_PDN_VIA_LAYER| Remove power grid vias which generate DRC violations after detailed routing.| | |
| <a name="REPORT_CLOCK_SKEW"></a>REPORT_CLOCK_SKEW| Report clock skew as part of reporting metrics, starting at CTS, before which there is no clock skew. This metric can be quite time-consuming, so it can be useful to disable.| 1| |
| <a name="RESYNTH_AREA_RECOVER"></a>RESYNTH_AREA_RECOVER| Enable re-synthesis for area reclaim.| 0| |
| <a name="RESYNTH_TIMING_RECOVER"></a>RESYNTH_TIMING_RECOVER| Enable re-synthesis for timing optimization.| 0| |
| <a name="ROUTING_LAYER_ADJUSTMENT"></a>ROUTING_LAYER_ADJUSTMENT| Adjusts routing layer capacities to manage congestion and improve detailed routing. High values ease detailed routing but risk excessive detours and long global routing times, while low values reduce global routing failure but can complicate detailed routing. The global routing running time normally reduces dramatically (entirely design specific, but going from hours to minutes has been observed) when the value is low (such as 0.10). Sometimes, global routing will succeed with lower values and fail with higher values. Exploring results with different values can help shed light on the problem. Start with a too low value, such as 0.10, and bisect to value that works by doing multiple global routing runs. As a last resort, `make global_route_issue` and using the tools/OpenROAD/etc/deltaDebug.py can be useful to debug global routing errors. If there is something specific that is impossible to route, such as a clock line over a macro, global routing will terminate with DRC errors routes that could have been routed were it not for the specific impossible routes. deltaDebug.py should weed out the possible routes and leave a minimal failing case that pinpoints the problem.| 0.5| |
| <a name="RTLMP_AREA_WT"></a>RTLMP_AREA_WT| Weight for the area of the current floorplan.| 0.1| |
| <a name="RTLMP_ARGS"></a>RTLMP_ARGS| Overrides all other RTL macro placer arguments.| | |
| <a name="RTLMP_BOUNDARY_WT"></a>RTLMP_BOUNDARY_WT| Weight for the boundary or how far the hard macro clusters are from boundaries.| 50.0| |
| <a name="RTLMP_DEAD_SPACE"></a>RTLMP_DEAD_SPACE| Specifies the target dead space percentage, which influences the utilization of a cluster.| 0.05| |
| <a name="RTLMP_FENCE_LX"></a>RTLMP_FENCE_LX| Defines the lower left X coordinate for the global fence bounding box in microns.| 0.0| |
| <a name="RTLMP_FENCE_LY"></a>RTLMP_FENCE_LY| Defines the lower left Y coordinate for the global fence bounding box in microns.| 0.0| |
| <a name="RTLMP_FENCE_UX"></a>RTLMP_FENCE_UX| Defines the upper right X coordinate for the global fence bounding box in microns.| 100000000.0| |
| <a name="RTLMP_FENCE_UY"></a>RTLMP_FENCE_UY| Defines the upper right Y coordinate for the global fence bounding box in microns.| 100000000.0| |
| <a name="RTLMP_MAX_INST"></a>RTLMP_MAX_INST| Maximum number of standard cells in a cluster. If unset, rtl_macro_placer will calculate a value based on the design attributes.| | |
| <a name="RTLMP_MAX_LEVEL"></a>RTLMP_MAX_LEVEL| Maximum depth of the physical hierarchy tree.| 2| |
| <a name="RTLMP_MAX_MACRO"></a>RTLMP_MAX_MACRO| Maximum number of macros in a cluster. If unset, rtl_macro_placer will calculate a value based on the design attributes.| | |
| <a name="RTLMP_MIN_AR"></a>RTLMP_MIN_AR| Specifies the minimum aspect ratio (height/width).| 0.33| |
| <a name="RTLMP_MIN_INST"></a>RTLMP_MIN_INST| Minimum number of standard cells in a cluster. If unset, rtl_macro_placer will calculate a value based on the design attributes.| | |
| <a name="RTLMP_MIN_MACRO"></a>RTLMP_MIN_MACRO| Minimum number of macros in a cluster. If unset, rtl_macro_placer will calculate a value based on the design attributes.| | |
| <a name="RTLMP_NOTCH_WT"></a>RTLMP_NOTCH_WT| Weight for the notch, or the existence of dead space that cannot be used for placement and routing.| 10.0| |
| <a name="RTLMP_OUTLINE_WT"></a>RTLMP_OUTLINE_WT| Weight for violating the fixed outline constraint, meaning that all clusters should be placed within the shape of their parent cluster.| 100.0| |
| <a name="RTLMP_RPT_DIR"></a>RTLMP_RPT_DIR| Path to the directory where reports are saved.| | |
| <a name="RTLMP_SIGNATURE_NET_THRESHOLD"></a>RTLMP_SIGNATURE_NET_THRESHOLD| Minimum number of connections between two clusters to be identified as connected.| 50| |
| <a name="RTLMP_WIRELENGTH_WT"></a>RTLMP_WIRELENGTH_WT| Weight for half-perimiter wirelength.| 100.0| |
| <a name="RUN_LOG_NAME_STEM"></a>RUN_LOG_NAME_STEM| Stem of the log file name, the log file will be named `$(LOG_DIR)/$(RUN_LOG_NAME_STEM).log`.| run| |
| <a name="RUN_SCRIPT"></a>RUN_SCRIPT| Path to script to run from `make run`, python or tcl script detected by .py or .tcl extension.| | |
| <a name="SC_LEF"></a>SC_LEF| Path to technology standard cell LEF file.| | |
| <a name="SDC_FILE"></a>SDC_FILE| The path to design constraint (SDC) file.| | |
| <a name="SDC_GUT"></a>SDC_GUT| Load design and remove all internal logic before doing synthesis. This is useful when creating a mock .lef abstract that has a smaller area than the amount of logic would allow. bazel-orfs uses this to mock SRAMs, for instance.| | |
| <a name="SEAL_GDS"></a>SEAL_GDS| Seal macro to place around the design.| | |
| <a name="SETUP_SLACK_MARGIN"></a>SETUP_SLACK_MARGIN| Specifies a time margin for the slack when fixing setup violations. This option allows you to overfix or underfix(negative value, terminate retiming before 0 or positive slack). See HOLD_SLACK_MARGIN for more details.| 0| |
| <a name="SET_RC_TCL"></a>SET_RC_TCL| Metal & Via RC definition file path.| | |
| <a name="SKIP_CTS_REPAIR_TIMING"></a>SKIP_CTS_REPAIR_TIMING| Skipping CTS repair, which can take a long time, can be useful in architectural exploration or when getting CI up and running.| | |
| <a name="SKIP_GATE_CLONING"></a>SKIP_GATE_CLONING| Do not use gate cloning transform to fix timing violations (default: use gate cloning).| | |
| <a name="SKIP_INCREMENTAL_REPAIR"></a>SKIP_INCREMENTAL_REPAIR| Skip incremental repair in global route.| 0| |
| <a name="SKIP_LAST_GASP"></a>SKIP_LAST_GASP| Do not use last gasp optimization to fix timing violations (default: use gate last gasp).| | |
| <a name="SKIP_PIN_SWAP"></a>SKIP_PIN_SWAP| Do not use pin swapping as a transform to fix timing violations (default: use pin swapping).| | |
| <a name="SKIP_REPORT_METRICS"></a>SKIP_REPORT_METRICS| If set to 1, then metrics, report_metrics does nothing. Useful to speed up builds.| | |
| <a name="SLEW_MARGIN"></a>SLEW_MARGIN| Specifies a slew margin when fixing max slew violations. This option allows you to overfix.| | |
| <a name="SYNTH_ARGS"></a>SYNTH_ARGS| Optional synthesis variables for yosys.| -flatten| |
| <a name="SYNTH_GUT"></a>SYNTH_GUT| Load design and remove all internal logic before doing synthesis. This is useful when creating a mock .lef abstract that has a smaller area than the amount of logic would allow. bazel-orfs uses this to mock SRAMs, for instance.| | |
| <a name="SYNTH_HIERARCHICAL"></a>SYNTH_HIERARCHICAL| Enable to Synthesis hierarchically, otherwise considered flat synthesis.| 0| |
| <a name="SYNTH_MEMORY_MAX_BITS"></a>SYNTH_MEMORY_MAX_BITS| Maximum number of bits for memory synthesis.| 4096| |
| <a name="TAPCELL_TCL"></a>TAPCELL_TCL| Path to Endcap and Welltie cells file.| | |
| <a name="TAP_CELL_NAME"></a>TAP_CELL_NAME| Name of the cell to use in tap cell insertion.| | |
| <a name="TECH_LEF"></a>TECH_LEF| A technology LEF file of the PDK that includes all relevant information regarding metal layers, vias, and spacing requirements.| | |
| <a name="TIEHI_CELL_AND_PORT"></a>TIEHI_CELL_AND_PORT| Tie high cells used in Yosys synthesis to replace a logical 1 in the Netlist.| | |
| <a name="TIELO_CELL_AND_PORT"></a>TIELO_CELL_AND_PORT| Tie low cells used in Yosys synthesis to replace a logical 0 in the Netlist.| | |
| <a name="TNS_END_PERCENT"></a>TNS_END_PERCENT| Default TNS_END_PERCENT value for post CTS timing repair. Try fixing all violating endpoints by default (reduce to 5% for runtime). Specifies how many percent of violating paths to fix [0-100]. Worst path will always be fixed.| 100| |
| <a name="USE_FILL"></a>USE_FILL| Whether to perform metal density filling.| 0| |
| <a name="VERILOG_FILES"></a>VERILOG_FILES| The path to the design Verilog files or JSON files providing a description of modules (check `yosys -h write_json` for more details).| | |
| <a name="VERILOG_INCLUDE_DIRS"></a>VERILOG_INCLUDE_DIRS| Specifies the include directories for the Verilog input files.| | |
| <a name="VERILOG_TOP_PARAMS"></a>VERILOG_TOP_PARAMS| Apply toplevel params (if exist).| | |
| <a name="YOSYS_FLAGS"></a>YOSYS_FLAGS| Additional flags to pass to yosys.| | |
## synth variables

- [ABC_AREA](#ABC_AREA)
- [ABC_CLOCK_PERIOD_IN_PS](#ABC_CLOCK_PERIOD_IN_PS)
- [ABC_DRIVER_CELL](#ABC_DRIVER_CELL)
- [ABC_LOAD_IN_FF](#ABC_LOAD_IN_FF)
- [ADDER_MAP_FILE](#ADDER_MAP_FILE)
- [CLKGATE_MAP_FILE](#CLKGATE_MAP_FILE)
- [LATCH_MAP_FILE](#LATCH_MAP_FILE)
- [MAX_UNGROUP_SIZE](#MAX_UNGROUP_SIZE)
- [MIN_BUF_CELL_AND_PORTS](#MIN_BUF_CELL_AND_PORTS)
- [RESYNTH_AREA_RECOVER](#RESYNTH_AREA_RECOVER)
- [RESYNTH_TIMING_RECOVER](#RESYNTH_TIMING_RECOVER)
- [SDC_FILE](#SDC_FILE)
- [SDC_GUT](#SDC_GUT)
- [SYNTH_GUT](#SYNTH_GUT)
- [SYNTH_HIERARCHICAL](#SYNTH_HIERARCHICAL)
- [SYNTH_MEMORY_MAX_BITS](#SYNTH_MEMORY_MAX_BITS)
- [TIEHI_CELL_AND_PORT](#TIEHI_CELL_AND_PORT)
- [TIELO_CELL_AND_PORT](#TIELO_CELL_AND_PORT)
- [VERILOG_FILES](#VERILOG_FILES)
- [VERILOG_INCLUDE_DIRS](#VERILOG_INCLUDE_DIRS)
- [VERILOG_TOP_PARAMS](#VERILOG_TOP_PARAMS)
- [YOSYS_FLAGS](#YOSYS_FLAGS)

## floorplan variables

- [CELL_PAD_IN_SITES_GLOBAL_PLACEMENT](#CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)
- [CORE_AREA](#CORE_AREA)
- [CORE_ASPECT_RATIO](#CORE_ASPECT_RATIO)
- [CORE_MARGIN](#CORE_MARGIN)
- [CORE_UTILIZATION](#CORE_UTILIZATION)
- [DIE_AREA](#DIE_AREA)
- [FLOORPLAN_DEF](#FLOORPLAN_DEF)
- [HOLD_SLACK_MARGIN](#HOLD_SLACK_MARGIN)
- [IO_CONSTRAINTS](#IO_CONSTRAINTS)
- [IO_PLACER_H](#IO_PLACER_H)
- [IO_PLACER_V](#IO_PLACER_V)
- [MACRO_BLOCKAGE_HALO](#MACRO_BLOCKAGE_HALO)
- [MACRO_PLACEMENT](#MACRO_PLACEMENT)
- [MACRO_PLACEMENT_TCL](#MACRO_PLACEMENT_TCL)
- [MACRO_PLACE_HALO](#MACRO_PLACE_HALO)
- [MACRO_ROWS_HALO_X](#MACRO_ROWS_HALO_X)
- [MACRO_ROWS_HALO_Y](#MACRO_ROWS_HALO_Y)
- [MACRO_WRAPPERS](#MACRO_WRAPPERS)
- [MAKE_TRACKS](#MAKE_TRACKS)
- [MATCH_CELL_FOOTPRINT](#MATCH_CELL_FOOTPRINT)
- [PDN_TCL](#PDN_TCL)
- [PLACE_DENSITY](#PLACE_DENSITY)
- [PLACE_DENSITY_LB_ADDON](#PLACE_DENSITY_LB_ADDON)
- [PLACE_PINS_ARGS](#PLACE_PINS_ARGS)
- [PLACE_SITE](#PLACE_SITE)
- [REMOVE_ABC_BUFFERS](#REMOVE_ABC_BUFFERS)
- [RTLMP_AREA_WT](#RTLMP_AREA_WT)
- [RTLMP_ARGS](#RTLMP_ARGS)
- [RTLMP_BOUNDARY_WT](#RTLMP_BOUNDARY_WT)
- [RTLMP_DEAD_SPACE](#RTLMP_DEAD_SPACE)
- [RTLMP_FENCE_LX](#RTLMP_FENCE_LX)
- [RTLMP_FENCE_LY](#RTLMP_FENCE_LY)
- [RTLMP_FENCE_UX](#RTLMP_FENCE_UX)
- [RTLMP_FENCE_UY](#RTLMP_FENCE_UY)
- [RTLMP_MAX_INST](#RTLMP_MAX_INST)
- [RTLMP_MAX_LEVEL](#RTLMP_MAX_LEVEL)
- [RTLMP_MAX_MACRO](#RTLMP_MAX_MACRO)
- [RTLMP_MIN_AR](#RTLMP_MIN_AR)
- [RTLMP_MIN_INST](#RTLMP_MIN_INST)
- [RTLMP_MIN_MACRO](#RTLMP_MIN_MACRO)
- [RTLMP_NOTCH_WT](#RTLMP_NOTCH_WT)
- [RTLMP_OUTLINE_WT](#RTLMP_OUTLINE_WT)
- [RTLMP_RPT_DIR](#RTLMP_RPT_DIR)
- [RTLMP_SIGNATURE_NET_THRESHOLD](#RTLMP_SIGNATURE_NET_THRESHOLD)
- [RTLMP_WIRELENGTH_WT](#RTLMP_WIRELENGTH_WT)
- [SETUP_SLACK_MARGIN](#SETUP_SLACK_MARGIN)
- [SKIP_GATE_CLONING](#SKIP_GATE_CLONING)
- [SKIP_LAST_GASP](#SKIP_LAST_GASP)
- [SKIP_PIN_SWAP](#SKIP_PIN_SWAP)
- [SKIP_REPORT_METRICS](#SKIP_REPORT_METRICS)
- [TAPCELL_TCL](#TAPCELL_TCL)
- [TNS_END_PERCENT](#TNS_END_PERCENT)

## place variables

- [CELL_PAD_IN_SITES_DETAIL_PLACEMENT](#CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
- [CELL_PAD_IN_SITES_GLOBAL_PLACEMENT](#CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)
- [FLOORPLAN_DEF](#FLOORPLAN_DEF)
- [GPL_ROUTABILITY_DRIVEN](#GPL_ROUTABILITY_DRIVEN)
- [GPL_TIMING_DRIVEN](#GPL_TIMING_DRIVEN)
- [IO_CONSTRAINTS](#IO_CONSTRAINTS)
- [IO_PLACER_H](#IO_PLACER_H)
- [IO_PLACER_V](#IO_PLACER_V)
- [MATCH_CELL_FOOTPRINT](#MATCH_CELL_FOOTPRINT)
- [MAX_ROUTING_LAYER](#MAX_ROUTING_LAYER)
- [MIN_ROUTING_LAYER](#MIN_ROUTING_LAYER)
- [PLACE_DENSITY](#PLACE_DENSITY)
- [PLACE_DENSITY_LB_ADDON](#PLACE_DENSITY_LB_ADDON)
- [PLACE_PINS_ARGS](#PLACE_PINS_ARGS)
- [ROUTING_LAYER_ADJUSTMENT](#ROUTING_LAYER_ADJUSTMENT)
- [SKIP_REPORT_METRICS](#SKIP_REPORT_METRICS)
- [TIEHI_CELL_AND_PORT](#TIEHI_CELL_AND_PORT)
- [TIELO_CELL_AND_PORT](#TIELO_CELL_AND_PORT)

## cts variables

- [CELL_PAD_IN_SITES_DETAIL_PLACEMENT](#CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
- [CTS_ARGS](#CTS_ARGS)
- [CTS_BUF_DISTANCE](#CTS_BUF_DISTANCE)
- [CTS_CLUSTER_DIAMETER](#CTS_CLUSTER_DIAMETER)
- [CTS_CLUSTER_SIZE](#CTS_CLUSTER_SIZE)
- [CTS_SNAPSHOT](#CTS_SNAPSHOT)
- [DETAILED_METRICS](#DETAILED_METRICS)
- [EQUIVALENCE_CHECK](#EQUIVALENCE_CHECK)
- [HOLD_SLACK_MARGIN](#HOLD_SLACK_MARGIN)
- [MATCH_CELL_FOOTPRINT](#MATCH_CELL_FOOTPRINT)
- [POST_CTS_TCL](#POST_CTS_TCL)
- [REMOVE_CELLS_FOR_EQY](#REMOVE_CELLS_FOR_EQY)
- [REPORT_CLOCK_SKEW](#REPORT_CLOCK_SKEW)
- [SETUP_SLACK_MARGIN](#SETUP_SLACK_MARGIN)
- [SKIP_CTS_REPAIR_TIMING](#SKIP_CTS_REPAIR_TIMING)
- [SKIP_GATE_CLONING](#SKIP_GATE_CLONING)
- [SKIP_LAST_GASP](#SKIP_LAST_GASP)
- [SKIP_PIN_SWAP](#SKIP_PIN_SWAP)
- [SKIP_REPORT_METRICS](#SKIP_REPORT_METRICS)
- [TNS_END_PERCENT](#TNS_END_PERCENT)

## grt variables

- [CELL_PAD_IN_SITES_DETAIL_PLACEMENT](#CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
- [DETAILED_METRICS](#DETAILED_METRICS)
- [GLOBAL_ROUTE_ARGS](#GLOBAL_ROUTE_ARGS)
- [HOLD_SLACK_MARGIN](#HOLD_SLACK_MARGIN)
- [MAX_ROUTING_LAYER](#MAX_ROUTING_LAYER)
- [MIN_ROUTING_LAYER](#MIN_ROUTING_LAYER)
- [REPORT_CLOCK_SKEW](#REPORT_CLOCK_SKEW)
- [ROUTING_LAYER_ADJUSTMENT](#ROUTING_LAYER_ADJUSTMENT)
- [SETUP_SLACK_MARGIN](#SETUP_SLACK_MARGIN)
- [SKIP_GATE_CLONING](#SKIP_GATE_CLONING)
- [SKIP_INCREMENTAL_REPAIR](#SKIP_INCREMENTAL_REPAIR)
- [SKIP_LAST_GASP](#SKIP_LAST_GASP)
- [SKIP_PIN_SWAP](#SKIP_PIN_SWAP)
- [SKIP_REPORT_METRICS](#SKIP_REPORT_METRICS)
- [TNS_END_PERCENT](#TNS_END_PERCENT)

## route variables

- [DETAILED_ROUTE_ARGS](#DETAILED_ROUTE_ARGS)
- [DETAILED_ROUTE_END_ITERATION](#DETAILED_ROUTE_END_ITERATION)
- [FILL_CELLS](#FILL_CELLS)
- [MATCH_CELL_FOOTPRINT](#MATCH_CELL_FOOTPRINT)
- [MAX_ROUTING_LAYER](#MAX_ROUTING_LAYER)
- [MIN_ROUTING_LAYER](#MIN_ROUTING_LAYER)
- [REPORT_CLOCK_SKEW](#REPORT_CLOCK_SKEW)
- [ROUTING_LAYER_ADJUSTMENT](#ROUTING_LAYER_ADJUSTMENT)
- [SKIP_REPORT_METRICS](#SKIP_REPORT_METRICS)

## final variables

- [ADDITIONAL_GDS](#ADDITIONAL_GDS)
- [GDS_ALLOW_EMPTY](#GDS_ALLOW_EMPTY)
- [GND_NETS_VOLTAGES](#GND_NETS_VOLTAGES)
- [MAX_ROUTING_LAYER](#MAX_ROUTING_LAYER)
- [MIN_ROUTING_LAYER](#MIN_ROUTING_LAYER)
- [PWR_NETS_VOLTAGES](#PWR_NETS_VOLTAGES)
- [REPORT_CLOCK_SKEW](#REPORT_CLOCK_SKEW)
- [ROUTING_LAYER_ADJUSTMENT](#ROUTING_LAYER_ADJUSTMENT)
- [SKIP_REPORT_METRICS](#SKIP_REPORT_METRICS)

## generate_abstract variables

- [ABSTRACT_SOURCE](#ABSTRACT_SOURCE)

## All stages variables



## Uncategorized variables

- [ADDITIONAL_FILES](#ADDITIONAL_FILES)
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
- [FILL_CONFIG](#FILL_CONFIG)
- [GDS_FILES](#GDS_FILES)
- [GENERATE_ARTIFACTS_ON_FAILURE](#GENERATE_ARTIFACTS_ON_FAILURE)
- [GLOBAL_PLACEMENT_ARGS](#GLOBAL_PLACEMENT_ARGS)
- [GUI_TIMING](#GUI_TIMING)
- [IR_DROP_LAYER](#IR_DROP_LAYER)
- [KLAYOUT_TECH_FILE](#KLAYOUT_TECH_FILE)
- [LIB_FILES](#LIB_FILES)
- [MACRO_EXTENSION](#MACRO_EXTENSION)
- [PLATFORM](#PLATFORM)
- [PRESERVE_CELLS](#PRESERVE_CELLS)
- [PROCESS](#PROCESS)
- [RCX_RULES](#RCX_RULES)
- [RECOVER_POWER](#RECOVER_POWER)
- [REPAIR_PDN_VIA_LAYER](#REPAIR_PDN_VIA_LAYER)
- [RUN_LOG_NAME_STEM](#RUN_LOG_NAME_STEM)
- [RUN_SCRIPT](#RUN_SCRIPT)
- [SC_LEF](#SC_LEF)
- [SEAL_GDS](#SEAL_GDS)
- [SET_RC_TCL](#SET_RC_TCL)
- [SLEW_MARGIN](#SLEW_MARGIN)
- [SYNTH_ARGS](#SYNTH_ARGS)
- [TAP_CELL_NAME](#TAP_CELL_NAME)
- [TECH_LEF](#TECH_LEF)
- [USE_FILL](#USE_FILL)

