proc report_metrics { when {include_erc true}} {
  puts "\n=========================================================================="
  puts "$when report_tns"
  puts "--------------------------------------------------------------------------"
  report_tns

  puts "\n=========================================================================="
  puts "$when report_wns"
  puts "--------------------------------------------------------------------------"
  report_wns

  puts "\n=========================================================================="
  puts "$when report_worst_slack"
  puts "--------------------------------------------------------------------------"
  report_worst_slack

  puts "\n=========================================================================="
  puts "$when report_clock_skew"
  puts "--------------------------------------------------------------------------"
  report_clock_skew

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
    set max_slew_violation_count [sta::max_slew_violation_count]
    puts "max slew violation count $max_slew_violation_count"
    utl::metric_integer "timing__drv__max_slew" $max_slew_violation_count

    puts "\n=========================================================================="
    puts "$when max_fanout_violation_count"
    puts "--------------------------------------------------------------------------"
    set max_fanout_violation_count [sta::max_fanout_violation_count]
    puts "max fanout violation count $max_fanout_violation_count"
    utl::metric_integer "timing__drv__max_fanout" $max_slew_violation_count

    puts "\n=========================================================================="
    puts "$when max_cap_violation_count"
    puts "--------------------------------------------------------------------------"
    set max_capacitance_violation_count [sta::max_capacitance_violation_count]
    puts "max cap violation count $max_capacitance_violation_count"
    utl::metric_integer "timing__drv__max_cap" $max_capacitance_violation_count

    puts "\n=========================================================================="
    puts "$when setup_violation_count"
    puts "--------------------------------------------------------------------------"
    puts "setup violation count [llength [find_timing_paths -path_delay min -slack_max 0]]"

    puts "\n=========================================================================="
    puts "$when hold_violation_count"
    puts "--------------------------------------------------------------------------"
    puts "hold violation count [llength [find_timing_paths -path_delay max -slack_max 0]]"

    set path_delay [sta::format_time [[[lindex [find_timing_paths -sort_by_slack] 0] path] arrival] 4]
    puts "\n=========================================================================="
    puts "$when critical path delay"
    puts "--------------------------------------------------------------------------"
    puts "$path_delay"

    set path_slack [sta::format_time [[[lindex [find_timing_paths -sort_by_slack] 0] path] slack] 4]
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
  puts "$when report_power"
  puts "--------------------------------------------------------------------------"
  if {[info exists ::env(CORNERS)]} {
    foreach corner $::env(CORNERS) {
      puts "Corner: $corner"
      report_power -corner $corner
    }
    unset corner
  } else {
    report_power
  }

  puts "\n=========================================================================="
  puts "$when report_design_area"
  puts "--------------------------------------------------------------------------"
  report_design_area

  puts ""
}

# Ex. report_class = "timing__setup__tns"
proc map_when_to_json_key {when report_class} {
  switch $when {
    "floorplan final" {
      return "floorplan__${report_class}"
    }
    "global place" {
      return "globalplace__${report_class}"
    }
    "resizer" {
      return "placeopt__${report_class}"
    }
    "detailed place" {
      return "detailedplace__${report_class}"
    }
    "cts pre-repair" {
      return "cts__${report_class}__pre_repair"
    }
    "cts post-repair" {
      return "cts__${report_class}__post_repair"
    }
    "cts final" {
      return "cts__${report_class}"
    }
    "global route" {
      return "globalroute__${report_class}"
    }
    "finish" {
      return "finish__${report_class}"
    }
    "resizer pre" {
      return "placeopt_pre__${report_class}"
    }
  }
  puts "Unhandled report class: $when"
  return $when
}