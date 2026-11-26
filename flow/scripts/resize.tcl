utl::set_metrics_stage "placeopt__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables place
load_design 3_3_place_gp.odb
source_step_tcl PRE RESIZE

log_cmd estimate_parasitics

set instance_count_before [sta::network_leaf_instance_count]
set pin_count_before [sta::network_leaf_pin_count]

set_dont_use $::env(DONT_USE_CELLS)

if { [env_var_exists_and_non_empty EARLY_SIZING_CAP_RATIO] } {
  log_cmd set_opt_config -set_early_sizing_cap_ratio $env(EARLY_SIZING_CAP_RATIO)
}

set swapped 0
if { [env_var_equals SWAP_ARITH_OPERATORS 1] } {
  # Enable sanity checker until replace_arith_modules becomes stable
  set_debug_level ODB replace_design_check_sanity 1
  set overflow 0.1
  set density [estimate_target_density -overflow $overflow]
  set area_before [instance_area_um2]
  set swapped [log_cmd replace_arith_modules]

  # The swapped modules' cells are the unplaced ones. The cells they replaced
  # account for the rest of the area change, so their area as placed (sizing
  # and buffers included) is the room the new cells have. Whatever does not
  # fit is let overflow there in phase 1, rather than spreading the new
  # modules out to resolve it.
  set new_area [instance_area_um2 -unplaced]
  set old_area [expr { $new_area + $area_before - [instance_area_um2] }]
  if { $new_area > 0 } {
    set excess [expr { max(0.0, ($new_area - $old_area) / $new_area) }]
    set overflow [expr { min(1.0, $overflow + $excess) }]
    puts [format "Swapped modules: %.3f um^2 replaced by %.3f um^2,\
      incremental placement overflow target %.3f" \
      $old_area $new_area $overflow]
  }
  # Phase 1 stops at the looser target above; phase 2 then unlocks every
  # instance and brings the whole design back to 0.1.
  log_cmd global_placement -incremental -density $density -overflow $overflow \
    -incremental_phase2_overflow 0.1
}

repair_design_helper

if { $::env(ENABLE_PLACE_REPAIR_TIMING) || $swapped } {
  # Repair setup using placement parasitics, always after a swap. Hold is
  # left to CTS, where the clock tree exists.
  puts "Repair setup violations..."
  log_cmd estimate_parasitics

  repair_timing_helper -setup -skip_last_gasp
}

# post report

puts "Floating nets: "
report_floating_nets

report_metrics 3 "resizer" true false

puts "Instance count before $instance_count_before, after [sta::network_leaf_instance_count]"
puts "Pin count before $pin_count_before, after [sta::network_leaf_pin_count]"

source_step_tcl POST RESIZE

orfs_write_db $::env(RESULTS_DIR)/3_4_place_resized.odb
