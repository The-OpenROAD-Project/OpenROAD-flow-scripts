if {![info exists standalone] || $standalone} {
  # Read lef
  read_lef $::env(TECH_LEF)
  read_lef $::env(SC_LEF)
  if {[info exist ::env(ADDITIONAL_LEFS)]} {
    foreach lef $::env(ADDITIONAL_LEFS) {
      read_lef $lef
    }
  }

  # Read design files
  read_def $::env(RESULTS_DIR)/2_floorplan.def
} else {
  puts "Starting global placement"
}


set db [ord::get_db]
set block [[$db getChip] getBlock]

# file write
set fp [open $::env(RESULTS_DIR)/3_1_erase_io_tmp.txt w]

set bTerms [$block getBTerms]
foreach origBTerm $bTerms {
  set net [$origBTerm getNet]
  # puts "[$net getConstName] [$origBTerm getConstName]_$i"
  
  set lx -1e30
  set ly -1e30
  set ux 1e30
  set uy 1e30

  set techLayer 0

  foreach bPin [$origBTerm getBPins] {
    foreach bBox [$bPin getBoxes] {

      set lx [expr max($lx, [$bBox xMin])]
      set ly [expr max($ly, [$bBox yMin])]

      set ux [expr min($ux, [$bBox xMax])]
      set uy [expr min($uy, [$bBox yMax])]

      # just pick a one techLayer from dbBox
      set techLayer [$bBox getTechLayer]
    }
  }
 
  puts $fp "[$origBTerm getConstName] [$net getConstName] [$origBTerm getIoType] [$origBTerm getSigType] [$techLayer getConstName]"
}  

close $fp

foreach bTerm $bTerms {
  odb::dbBTerm_destroy $bTerm 
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_def $::env(RESULTS_DIR)/3_1_erase_io.def
}
