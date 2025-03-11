source $::env(SCRIPTS_DIR)/yosys_load.tcl

proc convert_liberty_areas {} {
  cellmatch -derive_luts =A:liberty_cell
  # find a reference nand2 gate
  set found_cell ""
  set found_cell_area ""
  # iterate over all cells with a nand2 signature
  foreach cell [tee -q -s result.string select -list-mod =*/a:lut=4'b0111 %m] {
    if {! [rtlil::has_attr -mod $cell area]} {
      puts "Cell $cell missing area information"
      continue
    }
    set area [rtlil::get_attr -string -mod $cell area]
    if {$found_cell == "" || [expr $area < $found_cell_area]} {
      set found_cell $cell
      set found_cell_area $area
    }
  }
  if {$found_cell == ""} {
    error "reference nand2 cell not found"
  }

  # convert the area on all Liberty cells to a gate number equivalent
  foreach box [tee -q -s result.string select -list-mod =A:area =A:liberty_cell %i] {
    set area [rtlil::get_attr -mod -string $box area]
    set gate_eq [expr int($area / $found_cell_area)]
    rtlil::set_attr -mod -uint $box gate_cost_equivalent $gate_eq
  }
}

convert_liberty_areas

setattr -unset A:keep_hierarchy=1

# Don't know how to enumerate gate equivalents for cells in the design
# so set keep threshold to one and parse log for now
tee -o $::env(OBJECTS_DIR)/1_gates.txt keep_hierarchy -min_cost 1
set f [open $::env(OBJECTS_DIR)/1_gates.txt r]
set keep_hierarchy [read $f]
close $f
set f [open $::env(REPORTS_DIR)/1_gates.txt w]
foreach line [split $keep_hierarchy \n] {
  if {[regexp {Keeping (\S+) \(estimated size above threshold: (\d+) >} $line _ cell size]} {
    puts $f "$cell $size"
  }
}
close $f
