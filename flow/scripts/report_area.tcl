source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables floorplan
load_design 2_1_floorplan.odb 2_1_floorplan.sdc

set db [ord::get_db]
set chip [$db getChip]
set block [$chip getBlock]

set scale_to_um [expr [$block getDbUnitsPerMicron] * [$block getDbUnitsPerMicron]]

set insts [$block getInsts]

proc insts_area {insts} {
  global scale_to_um
  set area 0
  foreach inst $insts {
    set bbox [$inst getBBox]
    set area [expr $area + [$bbox getDX] * [$bbox getDY]]
  }
  return [expr $area / $scale_to_um]
}

proc module_area {module} {
  global scale_to_um
  set area 0
  set insts [$module getLeafInsts]
  foreach inst $insts {
    set bbox [$inst getBBox]
    set area [expr $area + [$bbox getDX] * [$bbox getDY]]
  }
  return [expr $area / $scale_to_um]
}

set f [open $::env(REPORTS_DIR)/2_area.txt w]
foreach module [$block getModules] {
  set area [module_area $module]
  puts $f "[$module getName] $area"
}   
close $f
