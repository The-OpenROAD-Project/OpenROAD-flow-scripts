utl::set_metrics_stage "power__{}"

source $::env(SCRIPTS_DIR)/load.tcl

source $::env(SCRIPTS_DIR)/read_liberty.tcl
read_lef $::env(TECH_LEF)
read_lef $::env(SC_LEF)

puts "Reading results/asap7/mock-array_Element/base/6_final.v"
read_verilog results/asap7/mock-array_Element/base/6_final.v
puts "Reading $::env(RESULTS_DIR)/6_final.v"
read_verilog $::env(RESULTS_DIR)/6_final.v

link_design MockArray

read_sdc $::env(RESULTS_DIR)/6_final.sdc
# FIXME what about Element
read_spef $::env(RESULTS_DIR)/6_final.spef

report_power
read_power_activities -scope TOP/MockArrayTestbench/postSynthesis -vcd designs/src/mock-array/MockArrayTestBench.vcd
report_power
