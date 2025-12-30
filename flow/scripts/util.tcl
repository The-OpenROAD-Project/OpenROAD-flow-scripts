proc log_cmd { cmd args } {
  # log the command, escape arguments with spaces
  set log_cmd "$cmd[join [lmap arg $args { format " %s" [expr { [string match {* *} $arg] ? "\"$arg\"" : "$arg" }] }] ""]" ;# tclint-disable-line line-length
  puts $log_cmd
  set start [clock seconds]
  set result [uplevel 1 [list $cmd {*}$args]]
  set time [expr { [clock seconds] - $start }]
  if { $time >= 5 } {
    # Ideally we'd use a single line, but the command can output text
    # and we don't want to mix it with the log, so output the time it took afterwards.
    puts "Took $time seconds: $log_cmd"
  }
  return $result
}

proc repair_timing_helper { args } {
  set additional_args {}
  append_env_var additional_args SETUP_SLACK_MARGIN -setup_margin 1
  append_env_var additional_args HOLD_SLACK_MARGIN -hold_margin 1
  append_env_var additional_args SETUP_MOVE_SEQUENCE -sequence 1
  append_env_var additional_args TNS_END_PERCENT -repair_tns 1
  append_env_var additional_args SKIP_PIN_SWAP -skip_pin_swap 0
  append_env_var additional_args SKIP_GATE_CLONING -skip_gate_cloning 0
  append_env_var additional_args SKIP_BUFFER_REMOVAL -skip_buffer_removal 0
  append_env_var additional_args SKIP_LAST_GASP -skip_last_gasp 0
  append_env_var additional_args SKIP_VT_SWAP -skip_vt_swap 0
  append_env_var additional_args SKIP_CRIT_VT_SWAP -skip_crit_vt_swap 0
  append_env_var additional_args MATCH_CELL_FOOTPRINT -match_cell_footprint 0
  lappend additional_args {*}$args -verbose

  log_cmd repair_timing {*}$additional_args
}

proc repair_design_helper { } {
  puts "Perform buffer insertion and gate resizing..."

  set additional_args "-verbose"
  append_env_var additional_args CAP_MARGIN -cap_margin 1
  append_env_var additional_args SLEW_MARGIN -slew_margin 1
  append_env_var additional_args MATCH_CELL_FOOTPRINT -match_cell_footprint 0
  log_cmd repair_design {*}$additional_args
}

proc recover_power_helper { } {
  if { $::env(RECOVER_POWER) == 0 } {
    return
  }
  puts "Downsizing/switching to higher Vt for non critical gates for power recovery"
  puts "Percent of paths optimized $::env(RECOVER_POWER)"
  report_tns
  report_wns
  report_power
  set additional_args "-verbose"
  append_env_var additional_args RECOVER_POWER -recover_power 1
  append_env_var additional_args MATCH_CELL_FOOTPRINT -match_cell_footprint 0
  log_cmd repair_timing {*}$additional_args
  report_tns
  report_wns
  report_power
}

proc extract_stage { input_file } {
  if { ![regexp {/([0-9])_(([0-9])_)?} $input_file match num1 _ num2] } {
    puts "Error: Could not determine design stage from $input_file"
    exit 1
  }
  lappend number_groups $num1
  if { $num2 != "" } {
    lappend number_groups $num2
  } else {
    lappend number_groups "0"
  }
}

proc find_sdc_file { input_file } {
  # canonicalize input file, sometimes it is called with an input
  # file relative to $::env(RESULTS_DIR), other times with
  # an absolute path
  if { ![file exists $input_file] } {
    set input_file [file join $::env(RESULTS_DIR) $input_file]
  }
  set input_file [file normalize $input_file]

  set stage [extract_stage $input_file]
  set design_stage [lindex $stage 0]
  set sdc_file ""

  set exact_sdc [string map {.odb .sdc} $input_file]
  set sdc_files \
    [glob -nocomplain -directory $::env(RESULTS_DIR) -types f "\[1-9+\]_\[1-9_A-Za-z\]*\.sdc"]
  set sdc_files [lsort -decreasing -dictionary $sdc_files]
  set sdc_files [lmap file $sdc_files { file normalize $file }]
  foreach name $sdc_files {
    if { [lindex [lsort -decreasing -dictionary [list $name $exact_sdc]] 0] == $exact_sdc } {
      set sdc_file $name
      break
    }
  }
  return [list $design_stage $sdc_file]
}

proc env_var_equals { env_var value } {
  return [expr { [info exists ::env($env_var)] && $::env($env_var) == $value }]
}

proc env_var_exists_and_non_empty { env_var } {
  return [expr { [info exists ::env($env_var)] && ![string equal $::env($env_var) ""] }]
}

proc append_env_var { list_name var_name prefix has_arg } {
  upvar $list_name list
  if {
    (!$has_arg && [env_var_equals $var_name 1]) ||
    ($has_arg && [env_var_exists_and_non_empty $var_name])
  } {
    lappend list $prefix
    if { $has_arg } {
      lappend list $::env($var_name)
    }
  }
}

# Non-empty defaults should go into variables.yaml, generally
proc env_var_or_empty { env_var } {
  if { [env_var_exists_and_non_empty $env_var] } {
    return $::env($env_var)
  }
  return ""
}

proc find_macros { } {
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

proc erase_non_stage_variables { stage_name } {
  if { $::env(KEEP_VARS) } {
    return
  }
  # "$::env(SCRIPTS_DIR)/stage_variables.py stage_name" returns list of
  # variables to erase.
  #
  # Tcl yaml package can't be imported in the sta/openroad environment:
  #
  # https://github.com/The-OpenROAD-Project/OpenROAD/issues/5875
  set variables [exec $::env(SCRIPTS_DIR)/non_stage_variables.py $stage_name]
  foreach var $variables {
    if { [info exists ::env($var)] } {
      unset ::env($var)
    }
  }
}

set global_route_congestion_report $::env(REPORTS_DIR)/congestion.rpt

proc place_density_with_lb_addon { } {
  if { [env_var_exists_and_non_empty PLACE_DENSITY_LB_ADDON] } {
    # check the lower boundary of the PLACE_DENSITY and add PLACE_DENSITY_LB_ADDON
    set place_density_lb [gpl::get_global_placement_uniform_density \
      -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
      -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)]
    set place_density \
      [expr $place_density_lb + ((1.0 - $place_density_lb) * $::env(PLACE_DENSITY_LB_ADDON)) + 0.01]
    if { $place_density > 1.0 } {
      utl::error FLW 24 \
        "Place density exceeds 1.0 (current PLACE_DENSITY_LB_ADDON = \
         $::env(PLACE_DENSITY_LB_ADDON)). Please check if the value of \
         PLACE_DENSITY_LB_ADDON is between 0 and 0.99."
    }
    puts "Placement density is $place_density, computed from PLACE_DENSITY_LB_ADDON \
      $::env(PLACE_DENSITY_LB_ADDON) and lower bound $place_density_lb"
  } else {
    set place_density $::env(PLACE_DENSITY)
  }
  return $place_density
}

proc source_env_var_if_exists { env_var } {
  if { [env_var_exists_and_non_empty $env_var] } {
    log_cmd source $::env($env_var)
  }
}

# Feature toggle for now, eventually the -hier option
# will be default and this code will be deleted.
proc hier_options { } {
  if {
    [env_var_exists_and_non_empty SYNTH_WRAPPED_OPERATORS] ||
    [env_var_exists_and_non_empty SWAP_ARITH_OPERATORS] ||
    $::env(OPENROAD_HIERARCHICAL)
  } {
    return "-hier"
  } else {
    return ""
  }
}

proc is_physical_only_master { master } {
  set physical_only_type_patterns [list \
    "COVER" \
    "COVER_BUMP" \
    "RING" \
    "PAD_SPACER" \
    "CORE_FEEDTHROUGH" \
    "CORE_SPACER" \
    "CORE_ANTENNACELL" \
    "CORE_WELLTAP" \
    "ENDCAP*"]
  set master_type [$master getType]
  foreach pattern $physical_only_type_patterns {
    if { [string match $pattern $master_type] } {
      return 1
    }
  }
  return 0
}

# Finds all physical-only masters in the current database and
# returns their names.
proc find_physical_only_masters { } {
  set db [::ord::get_db]
  set libs [$db getLibs]
  set physical_only_masters [list]
  foreach lib $libs {
    foreach master [$lib getMasters] {
      if { [is_physical_only_master $master] } {
        lappend physical_only_masters [$master getName]
      }
    }
  }
  return $physical_only_masters
}

proc orfs_write_db { output_file } {
  if { !$::env(WRITE_ODB_AND_SDC_EACH_STAGE) } {
    return
  }
  log_cmd write_db $output_file
}

proc orfs_write_sdc { output_file } {
  if { !$::env(WRITE_ODB_AND_SDC_EACH_STAGE) } {
    return
  }
  log_cmd write_sdc -no_timestamp $output_file
}
