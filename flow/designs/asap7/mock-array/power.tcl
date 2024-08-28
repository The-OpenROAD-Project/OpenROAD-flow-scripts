foreach libFile $::env(LIB_FILES) {
  if {[lsearch -exact $::env(ADDITIONAL_LIBS) $libFile] == -1} {
    read_liberty $libFile
  }
}

read_verilog results/asap7/mock-array_Element/base/6_final.v
read_verilog $::env(RESULTS_DIR)/6_final.v
read_verilog $::env(PLATFORM_DIR)/verilog/stdcell/empty.v

link_design MockArray

read_sdc $::env(RESULTS_DIR)/6_final.sdc
read_spef $::env(RESULTS_DIR)/6_final.spef
for {set x 0} {$x < 8} {incr x} {
  for {set y 0} {$y < 8} {incr y} {
    read_spef -path ces_${x}_${y} results/asap7/mock-array_Element/base/6_final.spef
  }
}

report_parasitic_annotation
report_power
read_power_activities -scope TOP/MockArray -vcd $::env(RESULTS_DIR)/MockArrayTestbench.vcd
report_power

# FIXME add an automated test to check that the top-level power is
# smaller than the sum of the individual elements.

for {set x 0} {$x < 8} {incr x} {
  for {set y 0} {$y < 8} {incr y} {
    puts "Power for ces_${x}_${y}"
    report_power -instances ces_${x}_${y}
  }
}
