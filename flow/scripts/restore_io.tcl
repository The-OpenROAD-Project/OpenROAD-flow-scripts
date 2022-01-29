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
  read_def $::env(RESULTS_DIR)/3_2_place_gp.def
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
} else {
  puts "Starting global placement"
}

set db [ord::get_db]
set block [[$db getChip] getBlock]

set fp [open $::env(RESULTS_DIR)/3_1_erase_io_tmp.txt r]
set file_data [read $fp]
close $fp

set data [split $file_data "\n"]
foreach line $data {
  set words [split $line " "]
  if {[llength $words] <= 1 } {
    continue
  }
  
  set bTermName [lindex $words 0]
  set netName [lindex $words 1]
  set ioType [lindex $words 2]
  set sigType [lindex $words 3]
  set layerName [lindex $words 4]

  set net [$block findNet $netName]
  set newBTerm [odb::dbBTerm_create $net $bTermName]
  $newBTerm setIoType $ioType
  $newBTerm setSigType $sigType
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_def $::env(RESULTS_DIR)/3_3_restore_io.def
}
