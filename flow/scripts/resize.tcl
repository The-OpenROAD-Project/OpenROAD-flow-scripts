utl::set_metrics_stage "placeopt__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place
load_design 3_3_place_gp.odb 2_floorplan.sdc
source_step_tcl PRE RESIZE

log_cmd estimate_parasitics -placement

set instance_count_before [sta::network_leaf_instance_count]
set pin_count_before [sta::network_leaf_pin_count]

set_dont_use $::env(DONT_USE_CELLS)

if { [env_var_exists_and_non_empty EARLY_SIZING_CAP_RATIO] } {
  log_cmd set_opt_config -set_early_sizing_cap_ratio $env(EARLY_SIZING_CAP_RATIO)
}

if { [env_var_exists_and_non_empty SWAP_ARITH_OPERATORS] } {
  # Enable sanity checker until replace_arith_modules becomes stable
  set_debug_level ODB replace_design_check_sanity 1
  replace_arith_modules
  global_placement -incremental
}

repair_design_helper

if { $::env(ENABLE_PLACE_REPAIR_TIMING) } {
  # Repair timing using placement parasitics.
  puts "Repair setup and hold violations..."
  log_cmd estimate_parasitics -placement

  repair_timing_helper
}

# post report

puts "Floating nets: "
report_floating_nets

report_metrics 3 "resizer" true false

puts "Instance count before $instance_count_before, after [sta::network_leaf_instance_count]"
puts "Pin count before $pin_count_before, after [sta::network_leaf_pin_count]"

source_step_tcl POST RESIZE

orfs_write_db $::env(RESULTS_DIR)/3_4_place_resized.odb
