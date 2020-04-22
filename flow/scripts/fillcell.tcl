if {![info exists standalone] || $standalone} {
  # Read lef
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

  # Read design files
  read_def $::env(RESULTS_DIR)/5_route.def
}

filler_placement $::env(FILL_CELLS)
check_placement

# Clear routing blockages for final DEF
set db [ord::get_db]
set chip [$db getChip]
set block [$chip getBlock]
set obstructions [$block getObstructions]

foreach obstruction $obstructions {
  odb::dbObstruction_destroy $obstruction
}
puts "\[INFO\] Deleted [llength $obstructions] routing obstructions"


if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/6_final.def
  exit
}
