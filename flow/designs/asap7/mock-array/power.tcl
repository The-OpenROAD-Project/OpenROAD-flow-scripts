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
set no_vcd_activity {}
set pins [get_pins -hierarchical *]
foreach pin $pins {
  set activity [get_property $pin activity]
  set activity_origin [lindex $activity 2]
  if {$activity_origin == "vcd"} {
    continue
  }
  if {$activity_origin == "clock"} {
    continue
  }
  set direction [get_property $pin direction]
  if {$direction == "internal"} {
    continue
  }
  lappend no_vcd_activity "[get_full_name $pin] $activity $direction"
  if {[llength $no_vcd_activity] >= 10} {
    break
  }
}

if {[llength $no_vcd_activity] > 0} {
  puts "Error: Listing [llength $no_vcd_activity] pins without activity from $vcd_file:"
  foreach pin $no_vcd_activity {
    puts $pin
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
