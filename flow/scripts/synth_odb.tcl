utl::set_metrics_stage "floorplan__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables synth
load_design 1_2_yosys.v 1_2_yosys.sdc
source_step_tcl PRE SYNTH

# Eliminate dead logic before writing the synthesis odb so that
# 1_synth.odb already reflects the live design.
#
# This matters for parallel synthesis flows (e.g., MegaBoom) where yosys
# only sees a slice of the design at a time and cannot prune logic that
# is dead only when looking at the whole design. In those flows this
# step can eliminate vast quantities of debug logic — for MegaBoom it
# has historically removed ~50% of the design.
eliminate_dead_logic

proc report_unused_masters { } {
  set db [ord::get_db]
  set libs [$db getLibs]
  set masters ""
  foreach lib $libs {
    foreach master [$lib getMasters] {
      # filter out non-block masters, or you can remove this conditional to detect any unused master
      if { [$master getType] == "BLOCK" } {
        lappend masters $master
      }
    }
  }

  set block [ord::get_db_block]
  set insts [$block getInsts]

  foreach inst $insts {
    set inst_master [$inst getMaster]
    set masters [lsearch -all -not -inline $masters $inst_master]
  }

  foreach master $masters {
    puts "Master [$master getName] is loaded but not used in the design"
  }
}

report_unused_masters

#Run check_setup
puts "\n=========================================================================="
puts "Synthesis check_setup"
puts "--------------------------------------------------------------------------"
check_setup

set num_instances [llength [get_cells -hier *]]
puts "number instances in verilog is $num_instances"

# repair_tie_fanout must run before remove_buffers and the timing-driven
# transforms below: a single tie that drives multiple buffers (each driving
# multiple loads) needs the fanout split per-buffer-load before remove_buffers
# collapses the buffers, otherwise the resulting tie fanout is a different
# netlist and cascades into worse setup TNS at CTS (~5x on asap7/ibex).
if { !$::env(SKIP_REPAIR_TIE_FANOUT) } {
  # Repair tie lo fanout
  puts "Repair tie lo fanout..."
  set tielo_cell_name [lindex $::env(TIELO_CELL_AND_PORT) 0]
  set tielo_lib_name [get_name [get_property [lindex [get_lib_cell $tielo_cell_name] 0] library]]
  set tielo_pin $tielo_lib_name/$tielo_cell_name/[lindex $::env(TIELO_CELL_AND_PORT) 1]
  repair_tie_fanout -separation $::env(TIE_SEPARATION) $tielo_pin

  # Repair tie hi fanout
  puts "Repair tie hi fanout..."
  set tiehi_cell_name [lindex $::env(TIEHI_CELL_AND_PORT) 0]
  set tiehi_lib_name [get_name [get_property [lindex [get_lib_cell $tiehi_cell_name] 0] library]]
  set tiehi_pin $tiehi_lib_name/$tiehi_cell_name/[lindex $::env(TIEHI_CELL_AND_PORT) 1]
  repair_tie_fanout -separation $::env(TIE_SEPARATION) $tiehi_pin
}

if { [env_var_exists_and_non_empty SWAP_ARITH_OPERATORS] } {
  # Enable sanity checker until replace_arith_modules becomes stable
  set_debug_level ODB replace_design_check_sanity 1
  replace_arith_modules
}

if { $::env(REMOVE_ABC_BUFFERS) } {
  # remove buffers inserted by yosys/abc
  remove_buffers
} else {
  # Skip clone & split
  repair_timing_helper -setup -skip_last_gasp -sequence "unbuffer,sizeup,swap,vt_swap"
}

source_step_tcl POST SYNTH
orfs_write_db $::env(RESULTS_DIR)/1_synth.odb
# Canonicalize 1_synth.sdc. The original SDC_FILE provided by
# the user could have dependencies, such as sourcing util.tcl,
# which are read in here and a canonicalized version is written
# out by OpenSTA that has no dependencies.
orfs_write_sdc $::env(RESULTS_DIR)/1_synth.sdc
