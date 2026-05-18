source $::env(SCRIPTS_DIR)/util.tcl

source $::env(SCRIPTS_DIR)/report_metrics.tcl

proc load_design { design_file sdc_file } {
  # Do not reload if design is already loaded
  set db [ord::get_db]
  if { [$db getChip] != "NULL" && [[$db getChip] getBlock] != "NULL" } {
    return
  }

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
    log_cmd link_design {*}[hier_options] $::env(DESIGN_NAME)
  } elseif { $ext == ".odb" } {
    log_cmd read_db {*}[hier_options] $::env(RESULTS_DIR)/$design_file
  } else {
    error "Unrecognized input file $design_file"
  }

  # Read SDC file
  log_cmd read_sdc $::env(RESULTS_DIR)/$sdc_file

  if { [file exists $::env(PLATFORM_DIR)/derate.tcl] } {
    log_cmd source $::env(PLATFORM_DIR)/derate.tcl
  }

  if { [env_var_exists_and_non_empty LAYER_PARASITICS_FILE] } {
    log_cmd source $::env(LAYER_PARASITICS_FILE)
  } else {
    log_cmd source $::env(PLATFORM_DIR)/setRC.tcl
  }

  if { [env_var_equals LIB_MODEL CCS] } {
    puts "Using CCS delay calculation"
    set_delay_calculator prima
  }
}
