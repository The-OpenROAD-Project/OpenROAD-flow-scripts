source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables floorplan
load_design 2_1_floorplan.odb 2_1_floorplan.sdc
source_step_tcl PRE MACRO_PLACE

# A register file in `mode netlist` dissolves onto the parent's rows
# after macro placement, and the rows are then cut MACRO_ROWS_HALO_X/Y
# around every other macro: a halo that wide keeps them off its core,
# which fills its outline to the edge.
set regfile_masters [auto_memories_names regfiles.txt]
if { [llength $regfile_masters] > 0 } {
  set dbu [[ord::get_db_tech] getDbUnitsPerMicron]
  set halo {}
  foreach v {MACRO_ROWS_HALO_X MACRO_ROWS_HALO_Y} {
    set um [expr { [env_var_exists_and_non_empty $v] ? $::env($v) : 0 }]
    lappend halo [expr { round($um * $dbu) }]
  }
  lassign $halo x y
  foreach inst [[ord::get_db_block] getInsts] {
    if { [[$inst getMaster] getName] in $regfile_masters } {
      # the instance's own halo, left bottom right top, which the macro
      # placer keeps clear of other macros
      odb::dbBox_create $inst $x $y $x $y
    }
  }
}

source $::env(SCRIPTS_DIR)/macro_place_util.tcl

source_step_tcl POST MACRO_PLACE

# register files in `mode netlist` become their cells
source $::env(SCRIPTS_DIR)/regfile_dissolve.tcl

report_design_area

orfs_write_db $::env(RESULTS_DIR)/2_2_floorplan_macro.odb
write_macro_placement $::env(RESULTS_DIR)/2_2_floorplan_macro.tcl
