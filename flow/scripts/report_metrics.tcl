proc report_puts { out } {
    upvar 1 when when
    upvar 1 filename filename
    set fileId [open $filename a]
    puts $fileId $out
    close $fileId
}

proc report_metrics { stage when {include_erc true} {include_clock_skew true} } {
  set filename $::env(REPORTS_DIR)/${stage}_[string map {" " "_"} $when].rpt
  set fileId [open $filename w]
  close $fileId
  report_puts "\n=========================================================================="
  report_puts "$when check_setup"
  report_puts "--------------------------------------------------------------------------"
  report_puts [check_setup]

  report_puts "\n=========================================================================="
  report_puts "$when report_tns"
  report_puts "--------------------------------------------------------------------------"
  report_tns >> $filename
  report_tns_metric >> $filename

  report_puts "\n=========================================================================="
  report_puts "$when report_wns"
  report_puts "--------------------------------------------------------------------------"
  report_wns >> $filename

  report_puts "\n=========================================================================="
  report_puts "$when report_worst_slack"
  report_puts "--------------------------------------------------------------------------"
  report_worst_slack >> $filename
  report_worst_slack_metric >> $filename

  if {$include_clock_skew} {
    report_puts "\n=========================================================================="
    report_puts "$when report_clock_skew"
    report_puts "--------------------------------------------------------------------------"
    report_clock_skew >> $filename
    report_clock_skew_metric >> $filename
    report_clock_skew_metric -hold >> $filename
  }

  report_puts "\n=========================================================================="
  report_puts "$when report_checks -path_delay min"
  report_puts "--------------------------------------------------------------------------"
  report_checks -path_delay min -fields {slew cap input nets fanout} -format full_clock_expanded >> $filename

  report_puts "\n=========================================================================="
  report_puts "$when report_checks -path_delay max"
  report_puts "--------------------------------------------------------------------------"
  report_checks -path_delay max -fields {slew cap input nets fanout} -format full_clock_expanded >> $filename

  report_puts "\n=========================================================================="
  report_puts "$when report_checks -unconstrained"
  report_puts "--------------------------------------------------------------------------"
  report_checks -unconstrained -fields {slew cap input nets fanout} -format full_clock_expanded >> $filename

  if {$include_erc} {
    report_puts "\n=========================================================================="
    report_puts "$when report_check_types -max_slew -max_cap -max_fanout -violators"
    report_puts "--------------------------------------------------------------------------"
    report_check_types -max_slew -max_capacitance -max_fanout -violators >> $filename

    report_erc_metrics

    report_puts "\n=========================================================================="
    report_puts "$when max_slew_check_slack"
    report_puts "--------------------------------------------------------------------------"
    report_puts "[sta::max_slew_check_slack]"

    report_puts "\n=========================================================================="
    report_puts "$when max_slew_check_limit"
    report_puts "--------------------------------------------------------------------------"
    report_puts "[sta::max_slew_check_limit]"

    if {[sta::max_slew_check_limit] < 1e30} {
      report_puts "\n=========================================================================="
      report_puts "$when max_slew_check_slack_limit"
      report_puts "--------------------------------------------------------------------------"
      report_puts [format "%.4f" [sta::max_slew_check_slack_limit]]
    }

    report_puts "\n=========================================================================="
    report_puts "$when max_fanout_check_slack"
    report_puts "--------------------------------------------------------------------------"
    report_puts "[sta::max_fanout_check_slack]"

    report_puts "\n=========================================================================="
    report_puts "$when max_fanout_check_limit"
    report_puts "--------------------------------------------------------------------------"
    report_puts "[sta::max_fanout_check_limit]"

    if {[sta::max_fanout_check_limit] < 1e30} {
      report_puts "\n=========================================================================="
      report_puts "$when max_fanout_check_slack_limit"
      report_puts "--------------------------------------------------------------------------"
      report_puts [format "%.4f" [sta::max_fanout_check_slack_limit]]
    }

    report_puts "\n=========================================================================="
    report_puts "$when max_capacitance_check_slack"
    report_puts "--------------------------------------------------------------------------"
    report_puts "[sta::max_capacitance_check_slack]"

    report_puts "\n=========================================================================="
    report_puts "$when max_capacitance_check_limit"
    report_puts "--------------------------------------------------------------------------"
    report_puts "[sta::max_capacitance_check_limit]"

    if {[sta::max_capacitance_check_limit] < 1e30} {
      report_puts "\n=========================================================================="
      report_puts "$when max_capacitance_check_slack_limit"
      report_puts "--------------------------------------------------------------------------"
      report_puts [format "%.4f" [sta::max_capacitance_check_slack_limit]]
    }

    report_puts "\n=========================================================================="
    report_puts "$when max_slew_violation_count"
    report_puts "--------------------------------------------------------------------------"
    report_puts "max slew violation count [sta::max_slew_violation_count]"

    report_puts "\n=========================================================================="
    report_puts "$when max_fanout_violation_count"
    report_puts "--------------------------------------------------------------------------"
    report_puts "max fanout violation count [sta::max_fanout_violation_count]"

    report_puts "\n=========================================================================="
    report_puts "$when max_cap_violation_count"
    report_puts "--------------------------------------------------------------------------"
    report_puts "max cap violation count [sta::max_capacitance_violation_count]"

    report_puts "\n=========================================================================="
    report_puts "$when setup_violation_count"
    report_puts "--------------------------------------------------------------------------"
    report_puts "setup violation count [sta::endpoint_violation_count max]"

    report_puts "\n=========================================================================="
    report_puts "$when hold_violation_count"
    report_puts "--------------------------------------------------------------------------"
    report_puts "hold violation count [sta::endpoint_violation_count min]"

    set critical_path [lindex [find_timing_paths -sort_by_slack] 0]
    if {$critical_path != ""} {
      set path_delay [sta::format_time [[$critical_path path] arrival] 4]
      set path_slack [sta::format_time [[$critical_path path] slack] 4]
    } else {
      set path_delay -1
      set path_slack 0
    }
    report_puts "\n=========================================================================="
    report_puts "$when critical path delay"
    report_puts "--------------------------------------------------------------------------"
    report_puts "$path_delay"

    report_puts "\n=========================================================================="
    report_puts "$when critical path slack"
    report_puts "--------------------------------------------------------------------------"
    report_puts "$path_slack"

    report_puts "\n=========================================================================="
    report_puts "$when slack div critical path delay"
    report_puts "--------------------------------------------------------------------------"
    report_puts "[format "%4f" [expr $path_slack / $path_delay * 100]]"
  }

  report_puts "\n=========================================================================="
  report_puts "$when report_power"
  report_puts "--------------------------------------------------------------------------"
  if {[info exists ::env(CORNERS)]} {
    foreach corner $::env(CORNERS) {
      report_puts "Corner: $corner"
      report_power -corner $corner >> $filename
      report_power_metric -corner $corner >> $filename
    }
    unset corner
  } else {
    report_power >> $filename
    report_power_metric >> $filename
  }

  # TODO these only work to stdout, whereas we want to append to the $filename
  puts "\n=========================================================================="
  puts "$when report_design_area"
  puts "--------------------------------------------------------------------------"
  report_design_area
  report_design_area_metrics
}
