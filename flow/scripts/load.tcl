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
