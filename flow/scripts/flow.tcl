# Runs all OpenROAD stages of the flow, from the yosys netlist through
# the final report, in a single OpenROAD process.
#
# With WRITE_ODB_AND_SDC_EACH_STAGE=0 the per-stage orfs_write_db /
# orfs_write_sdc / orfs_copy_db helpers are no-ops, so this top level is
# the sole writer of .odb/.sdc files. flow_write_db/flow_write_sdc
# produce the same file set as the stage-per-process make flow (the
# extra writes after a stage's own mirror the Makefile do-copy
# recipes), and flow_source enforces that stage scripts write no
# .odb/.sdc files themselves.

# Enable keeping variables between stages
set ::env(KEEP_VARS) 1
set ::env(WRITE_ODB_AND_SDC_EACH_STAGE) 0

set ::flow_expected [glob -nocomplain -directory $::env(RESULTS_DIR) *.odb *.sdc]

proc flow_source { script } {
  # Source in the global scope: stage scripts set top-level variables
  # (e.g. util.tcl's global_route_congestion_report) that later stages
  # read via $::, which a proc-scoped source would silently shadow.
  uplevel #0 [list source $::env(SCRIPTS_DIR)/$script]
  foreach f [glob -nocomplain -directory $::env(RESULTS_DIR) *.odb *.sdc] {
    if { [lsearch -exact $::flow_expected $f] == -1 } {
      error "$script wrote $f: with WRITE_ODB_AND_SDC_EACH_STAGE=0 stage\
             scripts must not write .odb/.sdc files"
    }
  }
}

proc flow_write_db { name } {
  set path $::env(RESULTS_DIR)/$name
  log_cmd write_db $path
  lappend ::flow_expected $path
}

proc flow_write_sdc { name } {
  set path $::env(RESULTS_DIR)/$name
  log_cmd write_sdc -no_timestamp $path
  lappend ::flow_expected $path
}

# Synthesis odb (from the yosys netlist)
flow_source synth_odb.tcl
flow_write_db 1_synth.odb
flow_write_sdc 1_synth.sdc

# Floorplan
flow_source floorplan.tcl
flow_write_db 2_1_floorplan.odb
flow_write_sdc 2_1_floorplan.sdc
flow_source macro_place.tcl
flow_write_db 2_2_floorplan_macro.odb
flow_source tapcell.tcl
flow_write_db 2_3_floorplan_tapcell.odb
flow_source pdn.tcl
flow_write_db 2_4_floorplan_pdn.odb
flow_write_db 2_floorplan.odb
flow_write_sdc 2_floorplan.sdc

# Place
flow_source global_place_skip_io.tcl
flow_write_db 3_1_place_gp_skip_io.odb
flow_source io_placement.tcl
flow_write_db 3_2_place_iop.odb
flow_source global_place.tcl
flow_write_db 3_3_place_gp.odb
flow_source resize.tcl
flow_write_db 3_4_place_resized.odb
flow_source detail_place.tcl
flow_write_db 3_5_place_dp.odb
flow_write_db 3_place.odb
flow_write_sdc 3_place.sdc

# CTS
flow_source cts.tcl
flow_write_db 4_1_cts.odb
flow_write_db 4_cts.odb
flow_write_sdc 4_cts.sdc

# Route
flow_source global_route.tcl
flow_write_db 5_1_grt.odb
flow_write_sdc 5_1_grt.sdc
flow_source detail_route.tcl
flow_write_db 5_2_route.odb
flow_source fillcell.tcl
flow_write_db 5_3_fillcell.odb
flow_write_db 5_route.odb
flow_write_sdc 5_route.sdc

# Finish. final_report.tcl is split around its 6_final.odb write so
# this top level can write at the same point.
flow_source density_fill.tcl
flow_write_db 6_1_fill.odb
flow_write_sdc 6_1_fill.sdc
flow_write_sdc 6_final.sdc
flow_source final_connect.tcl
flow_write_db 6_final.odb
flow_source final_outputs.tcl
