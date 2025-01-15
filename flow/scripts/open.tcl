source $::env(SCRIPTS_DIR)/util.tcl
# Read liberty files
source $::env(SCRIPTS_DIR)/read_liberty.tcl

proc log_seconds {cmd args} {
  set start_time_seconds [clock seconds]
  log_cmd $cmd {*}$args
  set total [expr {[clock seconds] - $start_time_seconds}]
  if {$total > 0} {
    puts "  $total seconds"
  }
}

# Read def
if {[env_var_exists_and_non_empty DEF_FILE]} {
    # Read lef
    read_lef $::env(TECH_LEF)
    read_lef $::env(SC_LEF)
    if {[env_var_exists_and_non_empty ADDITIONAL_LEFS]} {
      foreach lef $::env(ADDITIONAL_LEFS) {
        read_lef $lef
      }
    }
    set input_file $::env(DEF_FILE)
    read_def $input_file
} else {
    set input_file $::env(ODB_FILE)
    log_seconds read_db $input_file
}

proc read_timing {input_file} {
  set result [find_sdc_file $input_file]
  set design_stage [lindex $result 0]
  set sdc_file [lindex $result 1]

  if {$sdc_file == ""} {
    set sdc_file $::env(SDC_FILE)
  }
  log_seconds read_sdc $sdc_file
  if [file exists $::env(PLATFORM_DIR)/derate.tcl] {
    source $::env(PLATFORM_DIR)/derate.tcl
  }
  
  source $::env(PLATFORM_DIR)/setRC.tcl
  if {$design_stage >= 4} {
    # CTS has run, so propagate clocks
    set_propagated_clock [all_clocks]
  }
  
  if {$design_stage >= 6 && [file exist $::env(RESULTS_DIR)/6_final.spef]} {
    log_seconds read_spef $::env(RESULTS_DIR)/6_final.spef
  } elseif {$design_stage >= 5} {
    if { [grt::have_routes] } {
      log_seconds estimate_parasitics -global_routing
    } else {
      puts "No global routing results available, skipping estimate_parasitics"
      puts "Load $::global_route_congestion_report for details"
    }
  } elseif {$design_stage >= 3} {
    log_seconds estimate_parasitics -placement
  }

  # Warm up OpenSTA, so clicking on timing related buttons reacts faster
  log_seconds find_timing_paths
}

if {[ord::openroad_gui_compiled]} {
  set db_basename [file rootname [file tail $input_file]]
  gui::set_title "OpenROAD - $::env(PLATFORM)/$::env(DESIGN_NICKNAME)/$::env(FLOW_VARIANT) - ${db_basename}"
}

if {[env_var_equals GUI_TIMING 1]} {
  puts "GUI_TIMING=1 reading timing, takes a little while for large designs..."
  read_timing $input_file
  if {[gui::enabled]} {
    gui::select_chart "Endpoint Slack"
    log_seconds gui::update_timing_report
  }
}

fast_route
