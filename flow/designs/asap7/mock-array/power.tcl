source $::env(SCRIPTS_DIR)/util.tcl

foreach libFile $::env(LIB_FILES) {
  if {[lsearch -exact $::env(ADDITIONAL_LIBS) $libFile] == -1} {
    # Do not load the macros as we want to flatten the design
    # to get timing numbers
    log_cmd read_liberty $libFile
  }
}

log_cmd read_verilog results/asap7/mock-array_Element/base/6_final.v
log_cmd read_verilog $::env(RESULTS_DIR)/6_final.v
log_cmd read_verilog $::env(PLATFORM_DIR)/verilog/stdcell/empty.v

if {[llength [info procs read_lef]]} {
  # OpenROAD requires .lef files, OpenSTA doesn't
  read_lef $::env(TECH_LEF)
  read_lef $::env(SC_LEF)
  # if {[env_var_exists_and_non_empty ADDITIONAL_LEFS]} {
  #   foreach lef $::env(ADDITIONAL_LEFS) {
  #     read_lef $lef
  #   }
  # }
}
log_cmd link_design MockArray

read_sdc $::env(RESULTS_DIR)/6_final.sdc
read_spef $::env(RESULTS_DIR)/6_final.spef
for {set x 0} {$x < 8} {incr x} {
  for {set y 0} {$y < 8} {incr y} {
    read_spef -path ces_${x}_${y} results/asap7/mock-array_Element/base/6_final.spef
  }
}

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
report_power > $::env(OBJECTS_DIR)/power.rpt
