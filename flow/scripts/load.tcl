source $::env(SCRIPTS_DIR)/util.tcl

source $::env(SCRIPTS_DIR)/report_metrics.tcl

proc load_design { design_file sdc_file } {
  source_env_var_if_exists PLATFORM_TCL

  source $::env(SCRIPTS_DIR)/read_liberty.tcl

  # Read design files
  set ext [file extension $design_file]
  if { $ext == ".v" } {
    read_lef $::env(TECH_LEF)
    read_lef $::env(SC_LEF)
    if { [env_var_exists_and_non_empty ADDITIONAL_LEFS] } {
      foreach lef $::env(ADDITIONAL_LEFS) {
        read_lef $lef
      }
    }
    read_verilog $::env(RESULTS_DIR)/$design_file
    if {
      [env_var_exists_and_non_empty SYNTH_WRAPPED_OPERATORS] ||
      [env_var_exists_and_non_empty SWAP_ARITH_OPERATORS]
    } {
      link_design -hier $::env(DESIGN_NAME)
    } else {
      link_design $::env(DESIGN_NAME)
    }
  } elseif { $ext == ".odb" } {
    if {
      [env_var_exists_and_non_empty SYNTH_WRAPPED_OPERATORS] ||
      [env_var_exists_and_non_empty SWAP_ARITH_OPERATORS]
    } {
      read_db -hier $::env(RESULTS_DIR)/$design_file
    } else {
      read_db $::env(RESULTS_DIR)/$design_file
    }
  } else {
    error "Unrecognized input file $design_file"
  }

  # Read SDC file
  read_sdc $::env(RESULTS_DIR)/$sdc_file

  if { [file exists $::env(PLATFORM_DIR)/derate.tcl] } {
    log_cmd source $::env(PLATFORM_DIR)/derate.tcl
  }

  source $::env(PLATFORM_DIR)/setRC.tcl

  if { [env_var_equals LIB_MODEL CCS] } {
    puts "Using CCS delay calculation"
    set_delay_calculator prima
  }
}

#===========================================================================================
# Routines to run equivalence tests when they are enabled.

proc get_verilog_cells_for_design { } {
  if {![env_var_exists_and_non_empty EQUIVALENCE_CHECK_USE_LIBS] || [env_var_equals EQUIVALENCE_CHECK_USE_LIBS 0]} {
    set dir "$::env(PLATFORM_DIR)/work_around_yosys/"
    set cell_files [glob $dir/*.v]
  }  
}

proc write_eqy_verilog { filename } {
  # Filter out cells with no verilog/not needed for equivalence such
  # as fillers and tap cells
  if { [env_var_exists_and_non_empty REMOVE_CELLS_FOR_EQY] } {
    write_verilog -remove_cells $::env(REMOVE_CELLS_FOR_EQY) $::env(RESULTS_DIR)/$filename
  } else {
    write_verilog $::env(RESULTS_DIR)/$filename
  }
}

proc write_eqy_script_for_sky130hd { } {
  error "this routine is not yet implemented"
  #[gold]
  #read_verilog -sv ./before.v ./formal_pdk.v

  #[gate]
  #read_verilog -sv ./after.v ./formal_pdk.v

  #[script]
  #prep -top aes_cipher_top -flatten

  ## Using `rename -hide` is a better performing choice than nomatch
  ##   if the signal names have no meaning at all
  #rename -hide */_*_.*

  ## This removes unused signals before partitioning so no partitions are created for them
  #opt_clean -purge
  #memory_map

  #[collect *]
  ## This groups signals like `some_signal[0]`, `some_signal[1]`, ... that only differ in the index
  #group *[] \1[]

  #[strategy basic]
  #use sat
  #depth 2
}


proc write_eqy_script { } {
  set top_cell [current_design]
  set cell_files [get_verilog_cells_for_design]
  set outfile [open "$::env(OBJECTS_DIR)/4_eqy_test.eqy" w]
  puts "Generating equivalence checking script: $::env(OBJECTS_DIR)/4_eqy_test.eqy"
  # Gold netlist
  puts $outfile "\[gold]"
  if { [env_var_exists_and_non_empty EQUIVALENCE_CHECK_USE_LIBS] } {
    if { [env_var_equals EQUIVALENCE_CHECK_USE_LIBS 1] } {
      puts "Using .lib files to determine function definitions of cells in gold design: $::env(LIB_FILES)"
      puts $outfile "read_liberty -ignore_miss_func $::env(LIB_FILES)"
    } elseif {[env_var_equals EQUIVALENCE_CHECK_USE_LIBS 0]} {
      puts "Using verilog simulation models to determine function definitions of cells in gold design: $cell_files"
      puts $outfile "read_verilog -sv $cell_files"
    } else {
      puts "Using .lib files to determine function definitions of cells in gold design: $::env(EQUIVALENCE_CHECK_USE_LIBS)"
      puts $outfile "read_liberty -ignore_miss_func $::env(EQUIVALENCE_CHECK_USE_LIBS)"
    }
  } else {
    puts "Using verilog simulation models for gold design: $cell_files"
    puts $outfile "read_verilog -sv $cell_files"
  }
  puts $outfile "read_verilog -sv $::env(RESULTS_DIR)/4_before_rsz.v \n"
  puts $outfile "prep -top $top_cell -flatten\nmemory_map\n\n"
  # Modified netlist
  puts $outfile "\[gate]"
  if { [env_var_exists_and_non_empty EQUIVALENCE_CHECK_USE_LIBS] } {
    if { [env_var_equals EQUIVALENCE_CHECK_USE_LIBS 1] } {
      puts "Using .lib files to determine function definitions of cells in modified design: $::env(LIB_FILES)"
      puts $outfile "read_liberty -ignore_miss_func $::env(LIB_FILES)"
    } elseif {[env_var_equals EQUIVALENCE_CHECK_USE_LIBS 0]} {
      puts "Using verilog simulation models to determine function definitions of cells in modified design: $cell_files"
      puts $outfile "read_verilog -sv $cell_files"
    } else {
      puts "Using .lib files to determine function definitions of cells in modified design: $::env(EQUIVALENCE_CHECK_USE_LIBS)"
      puts $outfile "read_liberty -ignore_miss_func $::env(EQUIVALENCE_CHECK_USE_LIBS)"
    }
  } else {
    puts "Using verilog simulation models for modified design: $cell_files"
    puts $outfile "read_verilog -sv $cell_files"
  }
  puts $outfile "read_verilog -sv $::env(RESULTS_DIR)/4_after_rsz.v \n"
  puts $outfile "prep -top $top_cell -flatten\nmemory_map\n\n"

  # Recommendation from eqy team on how to speed up a design
  puts $outfile "\[match *]\ngate-nomatch _*_.*"

  # See issue OpenROAD#6545 "Equivalence check failure due to non-unique resizer nets"
  puts $outfile "gate-nomatch net*"

  # Forbid matching on buffer instances or cloned instances to make it less
  # likely EQY will fail to prove equivalence because of its assuming structural
  # similarity between gold and gate netlists. This doesn't remove coverage.
  puts $outfile "gate-nomatch clone*"
  puts $outfile "gate-nomatch place*"
  puts $outfile "gate-nomatch rebuffer*"
  puts $outfile "gate-nomatch wire*"
  puts $outfile "gate-nomatch place*\n\n"

  # Equivalence check recipe 1
  puts $outfile "\[strategy basic]\nuse sat\ndepth 10\n\n"
  # Equivalence check recipe 2
  puts $outfile "\[strategy sby]\nuse sby\ndepth 10\nengine smtbmc bitwuzla\n\n"

  close $outfile
}

proc run_equivalence_test { } {
  write_eqy_verilog 4_after_rsz.v
  write_eqy_script

  # tclint-disable-next-line command-args
  eval exec eqy -d $::env(LOG_DIR)/4_eqy_output \
    --force \
    --jobs $::env(NUM_CORES) \
    $::env(OBJECTS_DIR)/4_eqy_test.eqy \
    > $::env(LOG_DIR)/4_equivalence_check.log
  set count \
    [exec grep -c "Successfully proved designs equivalent" $::env(LOG_DIR)/4_equivalence_check.log]
  if { $count == 0 } {
    error "Repair timing output failed equivalence test"
  } else {
    puts "Repair timing output passed equivalence test"
  }
}
