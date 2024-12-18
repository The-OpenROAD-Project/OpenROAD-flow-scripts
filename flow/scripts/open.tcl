source $::env(SCRIPTS_DIR)/util.tcl
# Read liberty files
source $::env(SCRIPTS_DIR)/read_liberty.tcl

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
    read_db $input_file
}

proc read_timing {input_file} {
  set result [find_sdc_file $input_file]
  set design_stage [lindex $result 0]
  set sdc_file [lindex $result 1]

  if {$sdc_file == ""} {
    set sdc_file $::env(SDC_FILE)
  }
  read_sdc $sdc_file
  if [file exists $::env(PLATFORM_DIR)/derate.tcl] {
    source $::env(PLATFORM_DIR)/derate.tcl
  }
  
  source $::env(PLATFORM_DIR)/setRC.tcl
  if {$design_stage >= 4} {
    # CTS has run, so propagate clocks
    set_propagated_clock [all_clocks]
  }
  
  if {$design_stage >= 6 && [file exist $::env(RESULTS_DIR)/6_final.spef]} {
    log_cmd read_spef $::env(RESULTS_DIR)/6_final.spef
  } elseif {$design_stage >= 5} {
    if { [grt::have_routes] } {
      log_cmd estimate_parasitics -global_routing
    } else {
      puts "No global routing results available, skipping estimate_parasitics"
      puts "Load $::global_route_congestion_report for details"
    }
  } elseif {$design_stage >= 3} {
    log_cmd estimate_parasitics -placement
  }

  puts -nonewline "Populating timing paths..."
  # Warm up OpenSTA, so clicking on timing related buttons reacts faster
  set _tmp [find_timing_paths]
  puts "OK"
}

if {[env_var_equals GUI_TIMING 1]} {
  puts "GUI_TIMING=1 reading timing, takes a little while for large designs..."
  read_timing $input_file

  gui::save_display_controls

  set height [[[ord::get_db_block] getBBox] getDY]
  set height [ord::dbu_to_microns $height]
  set resolution [expr $height / 1000]

  # FIXME IRDrop heatmap should be added, but it has to be skipped
  # when there is no IRDrop heatmap to be rendered.

  set block [ord::get_db_block]
  set insts [$block getInsts]
  set placed 1
  foreach inst $insts {
    set status [$inst getPlacementStatus]
    # status is not in the list of PLACED, LOCKED
    if {[lsearch {PLACED LOCKED} $status] == -1} {
      set placed 0
      break
    }
  }

  set have_routes [expr {$placed && [grt::have_routes]}]

  foreach heatmap {Placement Routing RUDY Power} {
    if {[string equal $heatmap Routing] && !$have_routes} {
      # Skipping $heatmap heatmap, no routes available
      continue
    }
    if {[string equal $heatmap IRDrop] &&
        (![env_var_exists_and_non_empty PWR_NETS_VOLTAGES] ||
         ![grt::have_routes])} {
      # Skipping $heatmap heatmap, no PWR_NETS_VOLTAGES available
      continue
    }
    if {[lsearch {RUDY Placement} $heatmap] != -1 && !$placed} {
      # Skipping $heatmap heatmap, not all instances are placed
      continue
    }
    puts "Prerendering $heatmap heatmap..."
    gui::set_heatmap $heatmap rebuild 1
    gui::dump_heatmap $heatmap $::env(REPORTS_DIR)/dummy.png
  }

  log_cmd gui::select_chart "Endpoint Slack"
  log_cmd gui::update_timing_report

  gui::clear_highlights -1
  gui::clear_selections
  gui::restore_display_controls
}

fast_route

if {[env_var_equals GUI_SHOW 1]} {
  # Show the GUI when it is ready; it is unresponsive(with modal requesters
  # saying it is unresponsive) until everything is loaded
  log_cmd gui::unminimize
}
