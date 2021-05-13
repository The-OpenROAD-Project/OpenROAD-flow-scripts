# Write an SDC file with clock periods that result in slightly negative slack.

# slack margin as a percent of clock period
set margin 5

set clks [all_clocks]
if { [llength $clks] > 1 } {
  puts "\[ERROR FLW\] Only one clock supported."
} else {
  set clk [lindex $clks 0]
  set slack [sta::time_sta_ui [sta::worst_slack_cmd "max"]]
  set period [get_property $clk "period"]
  set ref_period [expr ($period - $slack) * (1.0 - $margin/100.0)]
  set clk_name [get_name $clk]
  puts "\[INFO FLW\] Clock $clk_name period [format %.2f $period] -> [format %.2f $ref_period]"
  puts "\[INFO FLW\] Clock $clk_name slack [format %.2f $slack]"
  set sources [$clk sources]
  create_clock -name $clk_name -period $ref_period $sources
  # Undo the set_propagated_clock so SDC at beginning of flow uses ideal clocks.
  unset_propagated_clock [all_clocks]
  write_sdc [file join $env(RESULTS_DIR) "updated_clks.sdc"]
}
