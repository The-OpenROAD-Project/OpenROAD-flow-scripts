source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_2_floorplan_io.odb 1_synth.sdc

proc find_macros {} {
  set macros ""

  set db [::ord::get_db]
  set block [[$db getChip] getBlock]
  foreach inst [$block getInsts] {
    set inst_master [$inst getMaster]

    # BLOCK means MACRO cells
    if { [string match [$inst_master getType] "BLOCK"] } {
      append macros " " $inst
    }
  }
  return $macros
}

set_dont_use $::env(DONT_USE_CELLS)

if {[find_macros] != ""} {
  global_placement -density $::env(PLACE_DENSITY) \
                 -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
                 -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)
} else {
  puts "No macros found: Skipping global_placement"
}

write_db $::env(RESULTS_DIR)/2_3_floorplan_tdms.odb
