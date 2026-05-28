proc lec_check_enabled { } {
  return [expr {
    [env_var_equals LEC_CHECK 1]
    && [info exists ::env(KEPLER_FORMAL_EXE)]
    && [file executable $::env(KEPLER_FORMAL_EXE)]
  }]
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
  set outfile [open "$::env(OBJECTS_DIR)/${step}_lec_test.yml" w]
  puts $outfile "format: verilog"
  puts $outfile "input_paths:"
  puts $outfile "  - $::env(RESULTS_DIR)/${file1}"
  puts $outfile "  - $::env(RESULTS_DIR)/${file2}"
  puts $outfile "liberty_files:"
  foreach libFile $::env(LIB_FILES) {
    puts $outfile " - $libFile"
  }
  puts $outfile "log_file: $::env(LOG_DIR)/${step}_lec_check.log"
  close $outfile
}

proc run_lec_test { step file1 file2 } {
  write_lec_script $step $file1 $file2
  # tclint-disable-next-line command-args
  eval exec $::env(KEPLER_FORMAL_EXE) --config $::env(OBJECTS_DIR)/${step}_lec_test.yml
  try {
    set count [exec grep -c "Found difference" $::env(LOG_DIR)/${step}_lec_check.log]
  } trap CHILDSTATUS {results options} {
    # This block executes if grep returns a non-zero exit code
    set count 0
  }
  if { $count > 0 } {
    error "Repair timing output failed lec test"
  } else {
    puts "Repair timing output passed lec test"
  }
}
