source $::env(DESIGN_DIR)/load.tcl

report_parasitic_annotation
report_power
read_vcd -scope TOP/MockArray $::env(RESULTS_DIR)/MockArrayTestbench.vcd

set ces {}
for {set x 0} {$x < 8} {incr x} {
  for {set y 0} {$y < 8} {incr y} {
    lappend ces ces_${x}_${y}
  }
}

report_power -instances [get_cells $ces]
report_power
