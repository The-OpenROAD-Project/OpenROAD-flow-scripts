source $::env(SCRIPTS_DIR)/util.tcl

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

log_cmd report_parasitic_annotation

log_cmd report_power
set vcd_file $::env(RESULTS_DIR)/MockArrayTestbench.vcd
log_cmd read_vcd -scope TOP/MockArray $vcd_file

puts "Total number of pins to be annotated: [llength [get_pins -hierarchical *]]"
set unannoted {}
foreach pin [get_pins -hierarchical *] {
  if {![sta::has_power_pin_activity $pin]} {
    set name [get_name $pin]
    lappend unannoted $pin
    if {[llength $unannoted] >= 10} {
      break
    }
  }
}

if {[llength $unannoted] > 0} {
  puts "Error: Listing [llength $unannoted] pins without user power activity from $vcd_file:"
  foreach pin $unannoted {
    puts "[get_full_name $pin]"
  }
  exit 1
}

set ces {}
for {set x 0} {$x < 8} {incr x} {
  for {set y 0} {$y < 8} {incr y} {
    lappend ces ces_${x}_${y}
  }
}

report_power -instances [get_cells $ces]
report_power
