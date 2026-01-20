proc write_lec_verilog { filename } {
  if { [env_var_exists_and_non_empty REMOVE_CELLS_FOR_EQY] } {
    write_verilog -remove_cells $::env(REMOVE_CELLS_FOR_EQY) $::env(RESULTS_DIR)/$filename
  } else {
    write_verilog $::env(RESULTS_DIR)/$filename
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
  eval exec kepler-formal --config $::env(OBJECTS_DIR)/${step}_lec_test.yml
  try {
    set count [exec grep -c "Found difference" $::env(LOG_DIR)/${step}_lec_check.log]]
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
