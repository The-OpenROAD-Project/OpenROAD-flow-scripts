source $::env(SCRIPTS_DIR)/util.tcl
# Read liberty files
source $::env(SCRIPTS_DIR)/read_liberty.tcl

# Read def
if {[env_var_exists_and_non_empty DEF_FILE]} {
    # Read lef
    read_lef $::env(TECH_LEF)
    read_lef $::env(SC_LEF)
    if {[env_var_exists_and_non_empty ADDITIONAL_LEFS]} {
      foreach lef $::env(ADDITIONAL_LEFS) {
        read_lef $lef
      }
    }
    set input_file $::env(DEF_FILE)
    read_def $input_file
} else {
    set input_file $::env(ODB_FILE)
    read_db $input_file
}

proc read_timing {input_file} {
  set result [find_sdc_file $input_file]
  set design_stage [lindex $result 0]
  set sdc_file [lindex $result 1]

  if {$sdc_file == ""} {
    set sdc_file $::env(SDC_FILE)
  }
  read_sdc $sdc_file
  if [file exists $::env(PLATFORM_DIR)/derate.tcl] {
    source $::env(PLATFORM_DIR)/derate.tcl
  }
  
  source $::env(PLATFORM_DIR)/setRC.tcl
  if {$design_stage >= 4} {
    # CTS has run, so propagate clocks
    set_propagated_clock [all_clocks]
  }
  
  if {$design_stage >= 6 && [file exist $::env(RESULTS_DIR)/6_final.spef]} {
    log_cmd read_spef $::env(RESULTS_DIR)/6_final.spef
  } elseif {$design_stage >= 5} {
    log_cmd estimate_parasitics -global_routing
  } elseif {$design_stage >= 3} {
    log_cmd estimate_parasitics -placement
  }

  fast_route
}

if {![env_var_equals GUI_NO_TIMING 1]} {
  read_timing $input_file
}

if {[env_var_exists_and_non_empty GUI_PRELOAD]} {
  # Run commands to "prime" the GUI, this moves waiting to the
  # headless part of the flow.
  #
  # Also, it can be combined with criu
  # to save the state of the GUI after the preload commands have
  # completed, but before the GUI starts(minimizes criu snapshot trouble)
  # such that a preloaded dumped headless process can be launched
  # from an artifact downloaded from a build server.
  #
  # Use-case in scripting with criu:
  #
  # - Run "make open_final GUI_PRELOAD"
  # - Wait for "openroad> " prompt
  # - Run "criu dump -t <PID> -D <DUMP_DIR>"
  # - Run "criu restore -D <DUMP_DIR>"
  # - Run gui::show
  #
  # Example of how this is used with bazel-orfs:
  #
  # bazel run SomeTarget_cts -- $(pwd)/tmp gui_cts
  #
  # If criu was installed on the server and a snapshot exists,
  # then bazel-orfs detects the gui_ targets and restores a snapshot
  # and the user has to type gui::show to start the GUI.
  report_checks
  # Other things that would be nice to preload, if there aren't commands
  # to do so, can they be added?
  # - Timing Report => Update
  # - Charts -> End point slack histogram
  # - Clock Tree Viewer
  # - report_min_period
  # - more?
}
