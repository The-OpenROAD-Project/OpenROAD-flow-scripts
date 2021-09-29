proc report_metrics { when {include_erc true} } {
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
  }

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
  puts "$when report_power"
  puts "--------------------------------------------------------------------------"
  report_power

  puts "\n=========================================================================="
  puts "$when report_design_area"
  puts "--------------------------------------------------------------------------"
  report_design_area

  puts ""
}

proc report_fmax { when } {
  puts "report fmax at $when"
  set time_unit [sta::unit_scale_abreviation "time"]
  set slack_scale_factor 1
  if {$time_unit == "p"} {
    set slack_scale_factor 0.001
  }

  foreach clk [all_clocks] {
    set clk_name [get_name $clk]
    set clk_period [get_property $clk "period"]
    report_checks -path_delay max -format full_clock_expanded -path_group $clk_name
    set clk_slack [sta::time_sta_ui [sta::worst_slack_cmd "max"]]
    set clk_fmax_period [expr $clk_period - $clk_slack]
    set clk_normalized_period [expr $clk_fmax_period * $slack_scale_factor]
    set clk_fmax [expr 1000.0 / $clk_normalized_period]
    puts "fmax $clk_name [format %.2f $clk_fmax] Mhz"
  }
}
