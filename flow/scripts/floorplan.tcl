utl::set_metrics_stage "floorplan__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables floorplan
load_design 1_synth.odb 1_synth.sdc
source_step_tcl PRE FLOORPLAN

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
puts "Floorplan check_setup"
puts "--------------------------------------------------------------------------"
check_setup

set num_instances [llength [get_cells -hier *]]
puts "number instances in verilog is $num_instances"

set additional_args ""
append_env_var additional_args ADDITIONAL_SITES -additional_sites 1

# Check which floorplan initialization method is specified (mutually exclusive)
set use_floorplan_def [env_var_exists_and_non_empty FLOORPLAN_DEF]
set use_footprint [env_var_exists_and_non_empty FOOTPRINT]
set use_die_and_core_area \
  [expr { [env_var_exists_and_non_empty DIE_AREA] && [env_var_exists_and_non_empty CORE_AREA] }]
set use_core_utilization [env_var_exists_and_non_empty CORE_UTILIZATION]

# Enforce mutual exclusion - exactly one method must be specified
set methods_defined \
  [expr { $use_floorplan_def + $use_footprint + $use_die_and_core_area + $use_core_utilization }]
if { $methods_defined > 1 } {
  puts "Error: Floorplan initialization methods are mutually exclusive, pick one."
  exit 1
}

# Method 1: Use existing DEF file with floorplan data
if { $use_floorplan_def } {
  log_cmd read_def -floorplan_initialize $env(FLOORPLAN_DEF)
  # Method 2: Use ICeWall footprint file (platform-specific extension)
} elseif { $use_footprint } {
  ICeWall load_footprint $env(FOOTPRINT)

  initialize_floorplan \
    -die_area [ICeWall get_die_area] \
    -core_area [ICeWall get_core_area] \
    -site $::env(PLACE_SITE)

  ICeWall init_footprint $env(SIG_MAP_FILE)
  # Method 3: Use explicit die and core area coordinates
} elseif { $use_die_and_core_area } {
  initialize_floorplan -die_area $::env(DIE_AREA) \
    -core_area $::env(CORE_AREA) \
    -site $::env(PLACE_SITE) \
    {*}$additional_args
  # Method 4: Calculate core area from utilization, aspect ratio, and margins
} elseif { $use_core_utilization } {
  initialize_floorplan -utilization $::env(CORE_UTILIZATION) \
    -aspect_ratio $::env(CORE_ASPECT_RATIO) \
    -core_space $::env(CORE_MARGIN) \
    -site $::env(PLACE_SITE) \
    {*}$additional_args
} else {
  puts "Error: No floorplan initialization method specified"
  exit 1
}

# Create routing tracks: MAKE_TRACKS script, platform make_tracks.tcl, or make_tracks command
if { [env_var_exists_and_non_empty MAKE_TRACKS] } {
  log_cmd source $::env(MAKE_TRACKS)
} elseif { [file exists $::env(PLATFORM_DIR)/make_tracks.tcl] } {
  log_cmd source $::env(PLATFORM_DIR)/make_tracks.tcl
} else {
  make_tracks
}

# Configure global routing: FASTROUTE_TCL script or
# set_global_routing_layer_adjustment/set_routing_layers
if { [env_var_exists_and_non_empty FASTROUTE_TCL] } {
  log_cmd source $::env(FASTROUTE_TCL)
} else {
  log_cmd \
    set_global_routing_layer_adjustment \
    $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER) $::env(ROUTING_LAYER_ADJUSTMENT)
  log_cmd set_routing_layers -signal $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER)
}

source_env_var_if_exists FOOTPRINT_TCL

# The transforms below (repair_tie_fanout, replace_arith_modules,
# remove_buffers, repair_timing_helper) look like synthesis-stage
# operations: they all act on the netlist and don't touch placement.
# But they DO depend on having a floorplan in place — initialize_floorplan
# above placed the bterms on the die boundary and set_routing_layers
# configured the layer stack used for parasitic estimation. Without that
# context, top-level ports look like they're at (0,0) and timing analysis
# misjudges paths into/out of I/O.
#
# PR #4187 tried moving this block to synth_odb.tcl. It regressed setup
# TNS by 1.7-46x on I/O-heavy designs (asap7/aes-block 2.5x, asap7/jpeg_lvt
# 37x, asap7/swerv_wrapper 46x finish-hold-TNS, nangate45/ariane133 1.7x)
# while leaving internal-logic-dominated designs like asap7/ibex
# unchanged. The move was reverted; only eliminate_dead_logic stayed in
# synth_odb.tcl because it is a pure netlist transform that doesn't
# depend on placement or routing-layer context.
if { !$::env(SKIP_REPAIR_TIE_FANOUT) } {
  # This needs to come before any call to remove_buffers.  You could have one
  # tie driving multiple buffers that drive multiple outputs.
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

puts "Default units for flow"
report_units
report_units_metric
report_layer_rc
report_metrics 2 "floorplan final" false false

source_step_tcl POST FLOORPLAN
source_env_var_if_exists IO_CONSTRAINTS

orfs_write_db $::env(RESULTS_DIR)/2_1_floorplan.odb
orfs_write_sdc $::env(RESULTS_DIR)/2_1_floorplan.sdc
