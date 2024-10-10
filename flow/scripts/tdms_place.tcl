source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables floorplan

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

if {!([env_var_exists_and_non_empty MACRO_PLACEMENT] ||
      [env_var_exists_and_non_empty MACRO_PLACEMENT_TCL]) &&
    ![env_var_equals RTLMP_FLOW 1]} {
  load_design 2_2_floorplan_io.odb 1_synth.sdc

  set_dont_use $::env(DONT_USE_CELLS)

  if {[find_macros] != ""} {
    log_cmd global_placement -density $::env(PLACE_DENSITY) \
                  -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
                  -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)
  } else {
    puts "No macros found: Skipping global_placement"
  }
  write_db $::env(RESULTS_DIR)/2_3_floorplan_tdms.odb
} else {
  log_cmd exec cp $::env(RESULTS_DIR)/2_2_floorplan_io.odb $::env(RESULTS_DIR)/2_3_floorplan_tdms.odb
}
