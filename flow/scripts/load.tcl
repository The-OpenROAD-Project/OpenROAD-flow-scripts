proc load_design {design_file sdc_file msg} {
  if {![info exists standalone] || $standalone} {
    set ext [file extension $design_file]
    switch -exact $ext {
      ".v" {
        source $::env(SCRIPTS_DIR)/read_liberty.tcl
        read_lef $::env(TECH_LEF) $::env(SC_LEF] {*}$::env(ADDITIONAL_LEFS)
        read_verilog $::env(RESULTS_DIR)/$design_file
        link_design $::env(DESIGN_NAME)
      }
      ".odb" {
        read_db $::env(RESULTS_DIR)/$design_file
      }
      default {
        error "Unrecognized input file $design_file"
      }
    }
    read_sdc $::env(RESULTS_DIR)/$sdc_file
    if {[file exists $::env(PLATFORM_DIR)/derate.tcl]} {
      source $::env(PLATFORM_DIR)/derate.tcl
    }
    source $::env(PLATFORM_DIR)/setRC.tcl
  } else {
    puts $msg
  }
}
