source $::env(SCRIPTS_DIR)/util.tcl

foreach libFile $::env(LIB_FILES) {
  if {[lsearch -exact $::env(ADDITIONAL_LIBS) $libFile] == -1} {
    read_liberty $libFile
  }
}

log_cmd read_verilog results/asap7/mock-array_Element/base/6_final.v
log_cmd read_verilog $::env(RESULTS_DIR)/6_final.v
log_cmd read_verilog $::env(PLATFORM_DIR)/verilog/stdcell/empty.v
log_cmd link_design MockArray

log_cmd read_sdc $::env(RESULTS_DIR)/6_final.sdc
log_cmd read_spef $::env(RESULTS_DIR)/6_final.spef
puts "read_spef for ces_*_* macros"
for {set x 0} {$x < 8} {incr x} {
  for {set y 0} {$y < 8} {incr y} {
    read_spef -path ces_${x}_${y} results/asap7/mock-array_Element/base/6_final.spef
  }
}

log_cmd report_power
log_cmd read_vcd -scope TOP/MockArray $::env(RESULTS_DIR)/MockArrayTestbench.vcd

set ces {}
for {set x 0} {$x < 8} {incr x} {
  for {set y 0} {$y < 8} {incr y} {
    lappend ces ces_${x}_${y}
  }
}

puts {report_power -instances [get_cells $ces]}
report_power -instances [get_cells $ces]
log_cmd report_power

log_cmd report_parasitic_annotation
log_cmd report_activity_annotation -report_unannotated
