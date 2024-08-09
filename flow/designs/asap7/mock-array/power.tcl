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
read_power_activities -scope TOP/MockArray -vcd designs/src/mock-array/MockArrayTestbench.vcd
report_power

# FIXME add an automated test to check that the top-level power is
# smaller than the sum of the individual elements.
#
# ChatGPT: (4.11 Watts) is slightly greater than the sum of all
# the individual elements' power (4.0668 Watts).
# Therefore, the top-level power is not smaller than the sum
# of all the elements. ​

for {set x 0} {$x < 8} {incr x} {
  for {set y 0} {$y < 8} {incr y} {
    puts "Power for ces_${x}_${y}"
    report_power -instances ces_${x}_${y}
  }
}

# FIXME what is the name of the top-level, i.e. how do I do
# report_power -instances MockArray.
#
# Why is there a difference between the output format of
# "report_power" (top level):
#
# Group                  Internal  Switching    Leakage      Total
#                           Power      Power      Power      Power (Watts)
# ----------------------------------------------------------------
# Sequential             1.70e+00   7.59e-01   6.48e-06   2.46e+00  59.9%
# Combinational          8.28e-01   6.59e-01   4.74e-06   1.49e+00  36.2%
# Clock                  8.49e-02   7.69e-02   7.85e-07   1.62e-01   3.9%
# Macro                  0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
# Pad                    0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
# ----------------------------------------------------------------
# Total                  2.62e+00   1.49e+00   1.20e-05   4.11e+00 100.0%
#                           63.6%      36.4%       0.0%
#
# "report_power -instances ces_7_7"?
#
# Power for ces_7_7
#    Internal  Switching    Leakage      Total
#       Power      Power      Power      Power (Watts)
# --------------------------------------------
#    2.97e-02   1.56e-02   1.96e-07   4.53e-02 ces_7_7
