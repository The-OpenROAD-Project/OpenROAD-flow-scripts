source $::env(SCRIPTS_DIR)/util.tcl

source $::env(SCRIPTS_DIR)/report_metrics.tcl

# A step's input is the result of an earlier step of its stage.
proc load_design { design_file } {
  load_design_from $::env(RESULTS_DIR) $design_file
}

# A stage's input is the previous stage's result, read from the
# variant FLOW_INPUT_VARIANT names.
proc load_stage_input { design_file } {
  if { $::env(INPUT_RESULTS_DIR) ne $::env(RESULTS_DIR) } {
    if { $::env(AUTO_MEMORIES) } {
      error "AUTO_MEMORIES=1 reads the memories synthesised in this variant,\
        $::env(FLOW_VARIANT), and FLOW_INPUT_VARIANT=$::env(FLOW_INPUT_VARIANT)\
        reads the design from another"
    }
    if { [file exists $::env(RESULTS_DIR)/$design_file] } {
      error "$design_file is in both FLOW_VARIANT=$::env(FLOW_VARIANT) and\
        FLOW_INPUT_VARIANT=$::env(FLOW_INPUT_VARIANT). Run the stage that\
        reads another variant alone, then the stages after it with\
        FLOW_INPUT_VARIANT unset, and remove a copy left from an earlier run."
    }
  }
  load_design_from $::env(INPUT_RESULTS_DIR) $design_file
}

proc load_design_from { dir design_file } {
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
    # AUTO_MEMORIES: abstract LEFs generated pre-synthesis
    foreach lef [auto_memories_views .lef] {
      read_lef $lef
    }
    read_verilog $dir/$design_file
    log_cmd link_design {*}[hier_options] $::env(DESIGN_NAME)
  } elseif { $ext == ".odb" } {
    log_cmd read_db {*}[hier_options] $dir/$design_file
  } else {
    error "Unrecognized input file $design_file"
  }

  log_cmd read_sdc $dir/[sdc_file_of $design_file]

  if { [file exists $::env(PLATFORM_DIR)/derate.tcl] } {
    log_cmd source $::env(PLATFORM_DIR)/derate.tcl
  }

  if { [env_var_exists_and_non_empty LAYER_PARASITICS_FILE] } {
    log_cmd source $::env(LAYER_PARASITICS_FILE)
  } else {
    log_cmd source $::env(PLATFORM_DIR)/setRC.tcl
  }

  if { [env_var_exists_and_non_empty WIRE_LOAD_MODEL] } {
    # OpenSTA applies a wire-load model only to nets without parasitics.
    log_cmd set_wire_load_model -name $::env(WIRE_LOAD_MODEL)
  }

  use_ccs_delay_calculator
}
