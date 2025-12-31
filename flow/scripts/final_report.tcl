utl::set_metrics_stage "finish__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables final
load_design 6_1_fill.odb 6_1_fill.sdc

set_propagated_clock [all_clocks]

# Ensure all OR created (rsz/cts) instances are connected
global_connect

orfs_write_db $::env(RESULTS_DIR)/6_final.odb

# Delete routing obstructions for final DEF
source $::env(SCRIPTS_DIR)/deleteRoutingObstructions.tcl
deleteRoutingObstructions

write_def $::env(RESULTS_DIR)/6_final.def
write_verilog $::env(RESULTS_DIR)/6_final.v \
  -remove_cells [find_physical_only_masters]

# Run extraction and STA
if {
  [env_var_exists_and_non_empty RCX_RULES]
  && !$::env(SKIP_DETAILED_ROUTE)
} {
  # RCX section
  define_process_corner -ext_model_index 0 X
  extract_parasitics -ext_model_file $::env(RCX_RULES)

  # Write Spef
  write_spef $::env(RESULTS_DIR)/6_final.spef
  file delete $::env(DESIGN_NAME).totCap

  # Read Spef for OpenSTA
  read_spef $::env(RESULTS_DIR)/6_final.spef

  # Static IR drop analysis
  if { [env_var_exists_and_non_empty PWR_NETS_VOLTAGES] } {
    dict for {pwrNetName pwrNetVoltage} $::env(PWR_NETS_VOLTAGES) {
      set_pdnsim_net_voltage -net ${pwrNetName} -voltage ${pwrNetVoltage}
      analyze_power_grid -net ${pwrNetName} \
        -error_file $::env(REPORTS_DIR)/${pwrNetName}.rpt
    }
  } else {
    puts "IR drop analysis for power nets is skipped because PWR_NETS_VOLTAGES is undefined"
  }
  if { [env_var_exists_and_non_empty GND_NETS_VOLTAGES] } {
    dict for {gndNetName gndNetVoltage} $::env(GND_NETS_VOLTAGES) {
      set_pdnsim_net_voltage -net ${gndNetName} -voltage ${gndNetVoltage}
      analyze_power_grid -net ${gndNetName} \
        -error_file $::env(REPORTS_DIR)/${gndNetName}.rpt
    }
  } else {
    puts "IR drop analysis for ground nets is skipped because GND_NETS_VOLTAGES is undefined"
  }
} else {
  puts "OpenRCX is not enabled for this platform."
  puts "Falling back to global route-based estimates."
  log_cmd estimate_parasitics -global_routing
}

report_cell_usage

report_metrics 6 "finish"

# Save a final image if openroad is compiled with the gui
if { [ord::openroad_gui_compiled] } {
  gui::show "source $::env(SCRIPTS_DIR)/save_images.tcl" false
}
