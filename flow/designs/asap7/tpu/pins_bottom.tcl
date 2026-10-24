# Every signal and clock pin on the bottom side: the one side a macro built
# to be abutted shows its parent.
set names {}
foreach bterm [[ord::get_db_block] getBTerms] {
  if { [$bterm getSigType] ne "SIGNAL" && [$bterm getSigType] ne "CLOCK" } { continue }
  lappend names [$bterm getName]
}
set_io_pin_constraint -region bottom:* -pin_names $names
puts "pins_bottom.tcl: [llength $names] pins on the bottom side"
