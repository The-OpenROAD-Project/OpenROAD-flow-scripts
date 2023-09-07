proc load_design {design_file sdc_file msg} {
  if {![info exists standalone] || $standalone} {
    # Read liberty files
    source $::env(SCRIPTS_DIR)/read_liberty.tcl

    # Read design files
    set ext [file extension $design_file]
    if {$ext == ".v"} {
      read_lef $::env(TECH_LEF)
      read_lef $::env(SC_LEF)
      if {[info exist ::env(ADDITIONAL_LEFS)]} {
        foreach lef $::env(ADDITIONAL_LEFS) {
          read_lef $lef
        }
      }
      read_verilog $::env(RESULTS_DIR)/$design_file
      link_design $::env(DESIGN_NAME)
    } elseif {$ext == ".odb"} {
      read_db $::env(RESULTS_DIR)/$design_file
    } else {
      error "Unrecognized input file $design_file"
    }

    # Read SDC file
    read_sdc $::env(RESULTS_DIR)/$sdc_file

    if [file exists $::env(PLATFORM_DIR)/derate.tcl] {
      source $::env(PLATFORM_DIR)/derate.tcl
    }

    source $::env(PLATFORM_DIR)/setRC.tcl
  } else {
    puts $msg
  }
}

#===========================================================================================
# Routines to run equivalence tests when they are enabled. 

proc get_verilog_cells_for_design { } {
    set dir "$::env(PLATFORM_DIR)/work_around_yosys/"
    set cell_files [glob $dir/*]
}

proc write_eqy_golden_verilog {} {
    write_verilog before.v
}

proc write_eqy_script { } {
    set top_cell [current_design]
    set cell_files [get_verilog_cells_for_design]
    set outfile [open "eqy_test.eqy" w]
    # Gold netlist
    puts $outfile "\[gold]\nread_verilog -sv before.v $cell_files\n"
    puts $outfile "prep -top $top_cell -flatten\nmemory_map\n\n"
    # Modified netlist 
    puts $outfile "\[gate]\nread_verilog -sv after.v $cell_files\n"
    puts $outfile "prep -top $top_cell -flatten\nmemory_map\n\n"

    # Recommendation from eqy team on how to speed up a design
    puts $outfile "\[match *]\ngate-nomatch _*_.*\n\n"

    # Equivalence check recipe 1
    puts $outfile "\[strategy basic]\nuse sat\ndepth 10\n\n"
    # Equivalence check recipe 2
    puts $outfile "\[strategy sby]\nuse sby\ndepth 10\nengine smtbmc bitwuzla\n\n"

    # puts "[strategy sby]\nuse sby\ndepth 2\nengine smtbmc bitwuzla\n\n"
    # puts "[strategy sby2]\nuse sby\nengine abc pdr\ndepth 10\n\n"
    close $outfile
}

proc run_equivalence_test {} {
    write_verilog after.v 
    write_eqy_script
    
    exec rm -rf eqy_test    
    exec eqy eqy_test.eqy > output.log
    set count [exec grep -c "Successfully proved designs equivalent" output.log]
    if { $count == 0 } {
	puts "Repair timing output failed equivalence test"
    } else {
	puts "Repair timing output passed equivalence test"
    }
}
#===========================================================================================
