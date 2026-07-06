utl::set_metrics_stage "synth__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables synth
load_design 1_2_yosys.v 1_2_yosys.sdc
source_step_tcl PRE SYNTH

# Eliminate dead logic before writing the synthesis odb so that
# 1_synth.odb already reflects the live design.
#
# This matters for parallel synthesis flows (e.g., MegaBoom) where yosys
# only sees a slice of the design at a time and cannot prune logic that
# is dead only when looking at the whole design. In those flows this
# step can eliminate vast quantities of debug logic — for MegaBoom it
# has historically removed ~50% of the design.
#
# eliminate_dead_logic is a pure netlist transform: it does not need a
# die area, bterm placement or routing layers, so it is safe to run
# here. Other synthesis-looking transforms in floorplan.tcl
# (repair_tie_fanout, replace_arith_modules, remove_buffers,
# repair_timing_helper) DO depend on floorplan-stage context (bterm
# locations from initialize_floorplan, routing-layer setup) and must
# stay in floorplan.tcl — moving them here was tried in PR #4187 and
# regressed setup TNS by 1.7-46x on I/O-heavy designs (asap7/aes-block,
# asap7/jpeg_lvt, asap7/swerv_wrapper, nangate45/ariane133).
log_cmd eliminate_dead_logic

report_design_area
report_design_area_metrics

source_step_tcl POST SYNTH
# Producing 1_synth.odb/.sdc is this step's contract:
# unconditional, no WRITE_ODB_AND_SDC_EACH_STAGE.
log_cmd write_db $::env(RESULTS_DIR)/1_synth.odb
# Canonicalize 1_synth.sdc. The original SDC_FILE provided by
# the user could have dependencies, such as sourcing util.tcl,
# which are read in here and a canonicalized version is written
# out by OpenSTA that has no dependencies. Sole writer of
# 1_synth.sdc.
log_cmd write_sdc -no_timestamp $::env(RESULTS_DIR)/1_synth.sdc
