source $::env(SCRIPTS_DIR)/util.tcl
# Read liberty files
source $::env(SCRIPTS_DIR)/read_liberty.tcl

# Read def
if {[info exist ::env(DEF_FILE)]} {
    # Read lef
    read_lef $::env(TECH_LEF)
    read_lef $::env(SC_LEF)
    if {[info exist ::env(ADDITIONAL_LEFS)]} {
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

if {![info exist ::env(GUI_NO_TIMING)]} {
  # Determine design stage (1 ... 6)
  set design_stage [lindex [split [file tail $input_file] "_"] 0]
  
  # Read SDC, first try to find the most recent SDC file for the stage
  set sdc_file ""
  for {set s $design_stage} {$s > 0} {incr s -1} {
    set sdc_file [glob -nocomplain -directory $::env(RESULTS_DIR) -types f "${s}_\[A-Za-z\]*\.sdc"]
    if {$sdc_file != ""} {
      break
    }
  }
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
    log_cmd estimate_parasitics -global_routing
  } elseif {$design_stage >= 3} {
    log_cmd estimate_parasitics -placement
  }

  if {[info exist env(FASTROUTE_TCL)]} {
    source $env(FASTROUTE_TCL)
  } else {
    set_global_routing_layer_adjustment $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER) 0.5
    set_routing_layers -signal $env(MIN_ROUTING_LAYER)-$env(MAX_ROUTING_LAYER)
    if {[info exist env(MACRO_EXTENSION)]} {
      set_macro_extension $env(MACRO_EXTENSION)
    }
  }
  
  # Cleanup temporary variables
  unset sdc_file s design_stage
}
