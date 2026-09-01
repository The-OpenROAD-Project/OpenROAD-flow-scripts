# The production flow from floorplan to finish, in one OpenROAD process.
#
# This is scripts/flow.tcl with its synthesis stage removed. A floorplan
# derivation evaluates several candidate outlines against the same
# netlist, so synthesis is run once into a shared 1_synth.odb and each
# candidate starts from there; re-running it per candidate would be the
# most expensive part of the walk and would measure nothing.
#
# The stage sequence below is duplicated from flow.tcl rather than
# derived from it, because flow.tcl defines its own helpers and runs
# immediately on source, leaving no seam to enter at. Duplication of a
# sequence that must stay in step is exactly the kind of thing that
# rots, so auto_floorplan_flow_test.py extracts the stage order from
# both files and fails if this one stops being flow.tcl's tail.

set ::env(KEEP_VARS) 1
set ::env(WRITE_ODB_AND_SDC_EACH_STAGE) 0

set ::flow_expected [glob -nocomplain -directory $::env(RESULTS_DIR) *.odb *.sdc]

proc flow_source { script } {
  # Source in the global scope: stage scripts set top-level variables
  # that later stages read via $::, which a proc-scoped source would
  # silently shadow.
  uplevel #0 [list source $::env(SCRIPTS_DIR)/$script]
  foreach f [glob -nocomplain -directory $::env(RESULTS_DIR) *.odb *.sdc] {
    if { [lsearch -exact $::flow_expected $f] == -1 } {
      error "$script wrote $f: with WRITE_ODB_AND_SDC_EACH_STAGE=0 stage\
             scripts must not write .odb/.sdc files"
    }
  }
}

proc flow_write_db { name } {
  set path [file join $::env(RESULTS_DIR) $name]
  log_cmd write_db $path
  lappend ::flow_expected $path
}

proc flow_write_sdc { name } {
  set path [file join $::env(RESULTS_DIR) $name]
  log_cmd write_sdc -no_timestamp $path
  lappend ::flow_expected $path
}

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
# Hook for the derivation: the placement density production just used.
# It cannot be captured by wrapping place_density_with_lb_addon, because
# load.tcl re-sources util.tcl at the top of every stage script and would
# redefine the wrapper away. Called here because
# gpl::get_global_placement_uniform_density is instance-area over
# whitespace and so does not depend on the placement that just ran --
# the number is the same one global_place.tcl resolved.
if { [info procs af_after_global_place] ne "" } {
  af_after_global_place
}
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
flow_source final_connect.tcl
flow_write_db 6_final.odb
flow_write_sdc 6_final.sdc
flow_source final_outputs.tcl
