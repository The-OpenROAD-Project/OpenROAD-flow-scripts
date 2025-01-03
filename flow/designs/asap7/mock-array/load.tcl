foreach libFile $::env(LIB_FILES) {
  if {[lsearch -exact $::env(ADDITIONAL_LIBS) $libFile] == -1} {
    read_liberty $libFile
  }
}

read_verilog results/asap7/mock-array_Element/base/6_final.v
read_verilog $::env(RESULTS_DIR)/6_final.v
read_verilog $::env(PLATFORM_DIR)/verilog/stdcell/empty.v

link_design MockArray

read_spef $::env(RESULTS_DIR)/6_final.spef
for {set x 0} {$x < 8} {incr x} {
  for {set y 0} {$y < 8} {incr y} {
    read_spef -path ces_${x}_${y} results/asap7/mock-array_Element/base/6_final.spef
  }
}

read_sdc $::env(DESIGN_DIR)/constraints.sdc
set_propagated_clock [get_clocks {clock}]
