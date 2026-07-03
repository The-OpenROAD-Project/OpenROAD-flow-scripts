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
# Canonicalize 1_synth.sdc. The original SDC_FILE provided by
# the user could have dependencies, such as sourcing util.tcl,
# which are read in here and a canonicalized version is written
# out by OpenSTA that has no dependencies.
#
# Written before the fanout repair below so that its repair-scoping
# set_max_fanout does not leak into the flow's SDC.
orfs_write_sdc $::env(RESULTS_DIR)/1_synth.sdc

# The synth stage owns the electrical sanity of its product. Raw yosys/ABC
# output leaves egregious high-fanout nets unbuffered; STA on 1_synth.odb
# then reports fanout artifacts instead of logic depth, which misleads
# anyone using synth as a signal for RTL changes. synth_syn.tcl already
# runs repair_design -pre_placement unconditionally before writing
# 1_synth.odb; this is the yosys-path analog, but DRC-only and bounded:
# -pre_placement is a whole-design gain round and conflicts with
# -placement parasitics (EST-0104). set_max_fanout makes only the
# egregious nets DRC violations; -max_wire_length large disables wire
# splitting (unplaced cells have no meaningful wire length). Like
# eliminate_dead_logic above, this is context-free (no die/bterm/layer
# dependence) -- the floorplan.tcl conditioning block stays in floorplan
# per PR #4187.
if { !$::env(SKIP_SYNTH_REPAIR_DESIGN) } {
  if { [env_var_exists_and_non_empty DONT_USE_CELLS] } {
    set_dont_use $::env(DONT_USE_CELLS)
  }
  set_max_fanout $::env(SYNTH_REPAIR_DESIGN_MAX_FANOUT) [current_design]
  log_cmd estimate_parasitics -placement
  log_cmd repair_design -max_wire_length 1000000
}

orfs_write_db $::env(RESULTS_DIR)/1_synth.odb
