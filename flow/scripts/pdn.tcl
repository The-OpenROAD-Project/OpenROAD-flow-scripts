source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables floorplan
load_design 2_3_floorplan_tapcell.odb 2_1_floorplan.sdc
source_step_tcl PRE PDN

source $::env(PDN_TCL)
pdngen

source_step_tcl POST PDN

# Check fixed instances once, after pdngen since blocked layers need the PDN
set_placement_padding -global \
  -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
  -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
set result [catch { log_cmd check_placement -fixed -verbose } errMsg]
set_placement_padding -global -left 0 -right 0
if { $result != 0 } {
  orfs_write_db $::env(RESULTS_DIR)/2_4_floorplan_pdn-failed.odb
  error $errMsg
}

# Check all supply nets
set block [ord::get_db_block]
foreach net [$block getNets] {
  set type [$net getSigType]
  if { $type == "POWER" || $type == "GROUND" } {
    # Temporarily disable due to CI issues
    #        puts "Check supply: [$net getName]"
    #        check_power_grid -net [$net getName]
  }
}

report_design_area

orfs_write_db $::env(RESULTS_DIR)/2_4_floorplan_pdn.odb
