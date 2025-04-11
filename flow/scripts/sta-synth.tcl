source $::env(SCRIPTS_DIR)/load.tcl
load_design 1_synth.v 1_synth.sdc

if {[env_var_equals GUI_TIMING 1]} {
  puts "GUI_TIMING=1 reading timing, takes a little while for large designs..."
  set openroad [expr [llength [info commands ord::openroad_version]] > 0]

  if {$openroad && [gui::enabled]} {
    gui::select_chart "Endpoint Slack"
    log_cmd gui::update_timing_report
  } else {
    report_checks
  }
}
