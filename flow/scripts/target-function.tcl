# Evaluate placement by tightening clocks and measuring WNS

if { [info exists ::env(TIGHTEN_CLOCK_PERIOD)] } {
  foreach clk [all_clocks] {
    set period [get_property $clk period]
    set uncertainty [expr {$period * $::env(TIGHTEN_CLOCK_PERIOD)}]
    set_clock_uncertainty -setup $uncertainty $clk
    puts "TIGHTEN_CLOCK_PERIOD: Set setup uncertainty for clock [get_property $clk name] to $uncertainty"
  }
}

estimate_parasitics -placement
set wns [sta::time_sta_ui [sta::worst_slack_cmd "max"]]
puts "Target Function WNS: $wns"

set f [open [file join $::env(RESULTS_DIR) "target_function.txt"] w]
puts $f $wns
close $f
