read_lef $::env(TECH_LEF)
read_lef $::env(SC_LEF)
if {[info exist ::env(ADDITIONAL_LEFS)]} {
  foreach lef $::env(ADDITIONAL_LEFS) {
    read_lef $lef
  }
}

# Read liberty files
foreach libFile $::env(LIB_FILES) {
  read_liberty $libFile
}
# Read def and sdc
read_def $::env(RESULTS_DIR)/6_final.def

set nets [[[[ord::get_db] getChip] getBlock] getNets]

foreach net $nets {
  set sigType [$net getSigType]
  if {"$sigType" eq "SIGNAL"} {
    odb::dbWire_destroy [$net getWire]
    #[$net getWire] -delete
  } elseif {"$sigType" eq "POWER" ||
            "$sigType" eq "GROUND"} {
    $net destroySWires
  }
}

write_def $::env(RESULTS_DIR)/6_final_only_clk.def
