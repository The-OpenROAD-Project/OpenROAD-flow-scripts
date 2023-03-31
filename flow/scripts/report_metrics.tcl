proc report_metrics { when {include_erc true} {include_clock_skew true} } {
  puts "\n=========================================================================="
  puts "$when check_setup"
  puts "--------------------------------------------------------------------------"
  check_setup

  puts "\n=========================================================================="
  puts "$when report_tns"
  puts "--------------------------------------------------------------------------"
  report_tns
  report_tns_metric

  puts "\n=========================================================================="
  puts "$when report_wns"
  puts "--------------------------------------------------------------------------"
  report_wns

  puts "\n=========================================================================="
  puts "$when report_worst_slack"
  puts "--------------------------------------------------------------------------"
  report_worst_slack
  report_worst_slack_metric

  if {$include_clock_skew} {
    puts "\n=========================================================================="
    puts "$when report_clock_skew"
    puts "--------------------------------------------------------------------------"
    report_clock_skew
    report_clock_skew_metric
    report_clock_skew_metric -hold
  }
  
  puts "\n=========================================================================="
  puts "$when report_checks -path_delay min"
  puts "--------------------------------------------------------------------------"
  report_checks -path_delay min -fields {slew cap input nets fanout} -format full_clock_expanded

  puts "\n=========================================================================="
  puts "$when report_checks -path_delay max"
  puts "--------------------------------------------------------------------------"
  report_checks -path_delay max -fields {slew cap input nets fanout} -format full_clock_expanded

  puts "\n=========================================================================="
  puts "$when report_checks -unconstrained"
  puts "--------------------------------------------------------------------------"
  report_checks -unconstrained -fields {slew cap input nets fanout} -format full_clock_expanded

  if {$include_erc} {
    puts "\n=========================================================================="
    puts "$when report_check_types -max_slew -max_cap -max_fanout -violators"
    puts "--------------------------------------------------------------------------"
    report_check_types -max_slew -max_capacitance -max_fanout -violators
    report_erc_metrics

    puts "\n=========================================================================="
    puts "$when max_slew_check_slack"
    puts "--------------------------------------------------------------------------"
    puts "[sta::max_slew_check_slack]"

    puts "\n=========================================================================="
    puts "$when max_slew_check_limit"
    puts "--------------------------------------------------------------------------"
    puts "[sta::max_slew_check_limit]"

    if {[sta::max_slew_check_limit] < 1e30} {
      puts "\n=========================================================================="
      puts "$when max_slew_check_slack_limit"
      puts "--------------------------------------------------------------------------"
      puts [format "%.4f" [sta::max_slew_check_slack_limit]]
    }

    puts "\n=========================================================================="
    puts "$when max_fanout_check_slack"
    puts "--------------------------------------------------------------------------"
    puts "[sta::max_fanout_check_slack]"

    puts "\n=========================================================================="
    puts "$when max_fanout_check_limit"
    puts "--------------------------------------------------------------------------"
    puts "[sta::max_fanout_check_limit]"

    if {[sta::max_fanout_check_limit] < 1e30} {
      puts "\n=========================================================================="
      puts "$when max_fanout_check_slack_limit"
      puts "--------------------------------------------------------------------------"
      puts [format "%.4f" [sta::max_fanout_check_slack_limit]]
    }

    puts "\n=========================================================================="
    puts "$when max_capacitance_check_slack"
    puts "--------------------------------------------------------------------------"
    puts "[sta::max_capacitance_check_slack]"

    puts "\n=========================================================================="
    puts "$when max_capacitance_check_limit"
    puts "--------------------------------------------------------------------------"
    puts "[sta::max_capacitance_check_limit]"

    if {[sta::max_capacitance_check_limit] < 1e30} {
      puts "\n=========================================================================="
      puts "$when max_capacitance_check_slack_limit"
      puts "--------------------------------------------------------------------------"
      puts [format "%.4f" [sta::max_capacitance_check_slack_limit]]
    }

    puts "\n=========================================================================="
    puts "$when max_slew_violation_count"
    puts "--------------------------------------------------------------------------"
    puts "max slew violation count [sta::max_slew_violation_count]"

    puts "\n=========================================================================="
    puts "$when max_fanout_violation_count"
    puts "--------------------------------------------------------------------------"
    puts "max fanout violation count [sta::max_fanout_violation_count]"

    puts "\n=========================================================================="
    puts "$when max_cap_violation_count"
    puts "--------------------------------------------------------------------------"
    puts "max cap violation count [sta::max_capacitance_violation_count]"

    puts "\n=========================================================================="
    puts "$when setup_violation_count"
    puts "--------------------------------------------------------------------------"
    puts "setup violation count [llength [find_timing_paths -path_delay max -slack_max 0]]"

    puts "\n=========================================================================="
    puts "$when hold_violation_count"
    puts "--------------------------------------------------------------------------"
    puts "hold violation count [llength [find_timing_paths -path_delay min -slack_max 0]]"

    set critical_path [lindex [find_timing_paths -sort_by_slack] 0]
    if {$critical_path != ""} {
      set path_delay [sta::format_time [[$critical_path path] arrival] 4]
      set path_slack [sta::format_time [[$critical_path path] slack] 4]
    } else {
      set path_delay -1
      set path_slack 0
    }
    puts "\n=========================================================================="
    puts "$when critical path delay"
    puts "--------------------------------------------------------------------------"
    puts "$path_delay"

    puts "\n=========================================================================="
    puts "$when critical path slack"
    puts "--------------------------------------------------------------------------"
    puts "$path_slack"

    puts "\n=========================================================================="
    puts "$when slack div critical path delay"
    puts "--------------------------------------------------------------------------"
    puts "[format "%4f" [expr $path_slack / $path_delay * 100]]"
  }

  puts "\n=========================================================================="
  puts "$when report_design_area"
  puts "--------------------------------------------------------------------------"
  report_design_area
  report_design_area_metrics

  puts ""
}
