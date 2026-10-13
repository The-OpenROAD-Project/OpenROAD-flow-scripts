proc check_kepler_formal { } {
  if {
    ![info exists ::env(KEPLER_FORMAL_EXE)]
    || ![file executable $::env(KEPLER_FORMAL_EXE)]
  } {
    error "Kepler Formal not found. Install Kepler Formal or set KEPLER_FORMAL_EXE."
  }
}

proc lec_check_enabled { } {
  if { ![env_var_equals LEC_CHECK 1] } {
    return 0
  }
  check_kepler_formal
  return 1
}

proc write_lec_verilog { filename } {
  set remove_cells [find_physical_only_masters]
  if { [env_var_exists_and_non_empty REMOVE_CELLS_FOR_LEC] } {
    lappend remove_cells {*}$::env(REMOVE_CELLS_FOR_LEC)
  }
  set out_file $::env(RESULTS_DIR)/$filename
  write_verilog -remove_cells $remove_cells $out_file

  # Add auxiliary Verilog files (e.g., blackbox stubs) for LEC
  if { [env_var_exists_and_non_empty LEC_AUX_VERILOG_FILES] } {
    set out [open $out_file a]
    foreach aux_file $::env(LEC_AUX_VERILOG_FILES) {
      if { ![file exists $aux_file] } {
        close $out
        error "LEC auxiliary Verilog file not found: $aux_file"
      }
      puts $out "\n// ORFS auxiliary Verilog for Kepler LEC: $aux_file"
      set in [open $aux_file r]
      fcopy $in $out
      close $in
      puts $out ""
    }
    close $out
  }
}

proc write_lec_script { step file1 file2 } {
  # Exclude select Liberty files from being passed to kepler-formal
  if { [env_var_exists_and_non_empty REMOVE_LIBS_FOR_LEC] } {
    foreach lib_to_remove $::env(REMOVE_LIBS_FOR_LEC) {
      set remove_libs_set($lib_to_remove) 1
    }
    set lib_list [lmap item $::env(LIB_FILES) {
      if { [info exists remove_libs_set($item)] } { continue }
      set item
    }]
  } else {
    set lib_list $::env(LIB_FILES)
  }
  set outfile [open "$::env(OBJECTS_DIR)/${step}_lec_test.yml" w]
  puts $outfile "format: verilog"
  puts $outfile "input_paths:"
  puts $outfile "  - $::env(RESULTS_DIR)/${file1}"
  puts $outfile "  - $::env(RESULTS_DIR)/${file2}"
  puts $outfile "liberty_files:"
  foreach libFile $lib_list {
    puts $outfile " - $libFile"
  }
  puts $outfile "log_file: $::env(LOG_DIR)/${step}_lec_check.log"
  close $outfile
}

proc write_sec_script { step file1 file2 } {
  set outfile [open "$::env(OBJECTS_DIR)/${step}_sec_test.yml" w]
  puts $outfile "format: verilog"
  puts $outfile "verification: sec"
  puts $outfile "sec_engine: pdr"
  puts $outfile "input_paths:"
  puts $outfile "  - $::env(RESULTS_DIR)/${file1}"
  puts $outfile "  - $::env(RESULTS_DIR)/${file2}"
  puts $outfile "liberty_files:"
  foreach libFile $::env(LIB_FILES) {
    puts $outfile " - $libFile"
  }
  puts $outfile "log_file: $::env(LOG_DIR)/${step}_sec_check.log"
  close $outfile
}

proc formal_check_label { step } {
  if { [string equal $step 4_rsz] } {
    return "Repair timing output"
  }
  return "Global output"
}

# Run kepler-formal through run_command.py, as the flow runs yosys and
# openroad, so its stdout and elapsed time/peak memory land in
# $LOG_DIR/${step}_${kind}.log. kepler-formal still writes its detailed
# log to the ${step}_${kind}_check.log named in its config.
proc run_kepler_formal { step kind } {
  if { [env_var_exists_and_non_empty RUN_CMD] } {
    set run_cmd $::env(RUN_CMD)
  } else {
    set run_cmd [list $::env(PYTHON_EXE) $::env(SCRIPTS_DIR)/run_command.py]
  }
  # run_command.py reports the elapsed time on stderr, which exec would
  # otherwise treat as an error.
  exec {*}$run_cmd --log $::env(LOG_DIR)/${step}_${kind}.log -- \
    {*}$::env(KEPLER_FORMAL_EXE) --config $::env(OBJECTS_DIR)/${step}_${kind}_test.yml \
    2>@ stderr
}

proc run_lec_test { step file1 file2 } {
  check_kepler_formal
  write_lec_script $step $file1 $file2
  run_kepler_formal $step lec
  try {
    set count [exec grep -c "Found difference" $::env(LOG_DIR)/${step}_lec_check.log]
  } trap CHILDSTATUS {results options} {
    # This block executes if grep returns a non-zero exit code
    set count 0
  }
  set label [formal_check_label $step]
  if { $count > 0 } {
    error "$label failed lec test"
  } else {
    puts "$label passed lec test"
  }
}

proc run_sec_test { step file1 file2 } {
  check_kepler_formal
  write_sec_script $step $file1 $file2
  run_kepler_formal $step sec
  try {
    set count [exec grep -c "SEC found a counterexample" $::env(LOG_DIR)/${step}_sec_check.log]
  } trap CHILDSTATUS {results options} {
    # This block executes if grep returns a non-zero exit code
    set count 0
  }
  if { $count > 0 } {
    error "Global output failed sec test"
  } else {
    puts "Global output passed sec test"
  }
}
