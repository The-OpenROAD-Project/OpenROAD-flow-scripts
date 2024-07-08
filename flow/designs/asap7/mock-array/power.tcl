foreach libFile $::env(LIB_FILES) {
read_liberty $libFile
}

read_verilog results/asap7/mock-array_Element/base/6_final.v
read_verilog $::env(RESULTS_DIR)/6_final.v
read_verilog designs/src/mock-array/post/empty.v

link_design MockArray

read_sdc $::env(RESULTS_DIR)/6_final.sdc
read_spef $::env(RESULTS_DIR)/6_final.spef
# FIXME lots of warnings
#read_spef results/asap7/mock-array_Element/base/6_final.spef

report_power
read_power_activities -scope TOP/MockArrayTestbench/postSynthesis -vcd designs/src/mock-array/MockArrayTestbench.vcd
report_power
