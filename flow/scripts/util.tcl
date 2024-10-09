proc log_cmd {cmd args} {
  puts "$cmd [join $args " "]"
  $cmd {*}$args
}

proc fast_route {} {
  if {[env_var_exists_and_non_empty FASTROUTE_TCL]} {
    source $::env(FASTROUTE_TCL)
  } else {
    set_global_routing_layer_adjustment $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) $::env(ROUTING_LAYER_ADJUSTMENT)
    set_routing_layers -signal $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER)
    if {[env_var_exists_and_non_empty MACRO_EXTENSION]} {
      set_macro_extension $::env(MACRO_EXTENSION)
    }
  }
}

# -hold_margin is only set when hold_margin is set, default 1
proc repair_timing_helper { {hold_margin 1} } {
  set additional_args "-verbose"
  append_env_var additional_args SETUP_SLACK_MARGIN -setup_margin 1
  if {$hold_margin} {
    append_env_var additional_args HOLD_SLACK_MARGIN -hold_margin 1
  }
  append_env_var additional_args TNS_END_PERCENT -repair_tns 1
  append_env_var additional_args SKIP_PIN_SWAP -skip_pin_swap 0
  append_env_var additional_args SKIP_GATE_CLONING -skip_gate_cloning 0
  append_env_var additional_args SKIP_BUFFER_REMOVAL -skip_buffer_removal 0
  puts "repair_timing [join $additional_args " "]"
  repair_timing {*}$additional_args
}

proc recover_power {} {
  if { $::env(RECOVER_POWER) == 0 } {
    return
  }
  puts "Downsizing/switching to higher Vt for non critical gates for power recovery"
  puts "Percent of paths optimized $::env(RECOVER_POWER)"
  report_tns
  report_wns
  report_power
  repair_timing -recover_power $::env(RECOVER_POWER)
  report_tns
  report_wns
  report_power
}

proc find_sdc_file {input_file} {
    # Determine design stage (1 ... 6)
    set input_pieces [split [file tail $input_file] "_"]
    set design_stage [lindex $input_pieces 0]
    if { [llength $input_pieces] == 3 } {
      set start [expr $design_stage - 1]
    } else {
      set start $design_stage
    }
    # Read SDC, first try to find the most recent SDC file for the stage
    set sdc_file ""
    for {set s $start} {$s > 0} {incr s -1} {
        set sdc_file [glob -nocomplain -directory $::env(RESULTS_DIR) -types f "${s}_\[A-Za-z\]*\.sdc"]
        if {$sdc_file != ""} {
            break
        }
    }
    return [list $design_stage $sdc_file]
}

proc env_var_equals {env_var value} {
    return [expr {[info exists ::env($env_var)] && $::env($env_var) == $value}]
}

proc env_var_exists_and_non_empty {env_var} {
    return [expr {[info exists ::env($env_var)] && ![string equal $::env($env_var) ""]}]
}

proc append_env_var {list_name var_name prefix has_arg} {
  upvar $list_name list
  if {(!$has_arg && [env_var_equals $var_name 1]) ||
      ($has_arg && [env_var_exists_and_non_empty $var_name])} {
    lappend list $prefix
    if {$has_arg} {
      lappend list $::env($var_name)
    }
  }
}

proc find_macros {} {
  set macros ""

  set db [ord::get_db]
  set block [[$db getChip] getBlock]
  foreach inst [$block getInsts] {
    set inst_master [$inst getMaster]

    # BLOCK means MACRO cells
    if { [string match [$inst_master getType] "BLOCK"] } {
      append macros " " $inst
    }
  }
  return $macros
}

proc erase_non_stage_variables {stage_name} {
  # "$::env(SCRIPTS_DIR)/stage_variables.py stage_name" returns list of
  # variables to erase.
  # 
  # Tcl yaml package can't be imported in the sta/openroad environment:
  # 
  # https://github.com/The-OpenROAD-Project/OpenROAD/issues/5875
  set variables [exec $::env(SCRIPTS_DIR)/non_stage_variables.py $stage_name]
  foreach var $variables {
    if {[info exists ::env($var)]} {
      unset ::env($var)
    }
  }
}

