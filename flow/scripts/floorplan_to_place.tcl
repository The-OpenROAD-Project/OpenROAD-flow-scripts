utl::set_metrics_stage "floorplan__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 1_synth.odb 1_synth.sdc

# Floorplan

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

if { ![env_var_equal SKIP_REPAIR_TIE_FANOUT 1] } {
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
  estimate_parasitics -placement
  replace_arith_modules
}

if { [env_var_equals REMOVE_ABC_BUFFERS 1] } {
  # remove buffers inserted by yosys/abc
  remove_buffers
} else {
  # Skip clone & split
  set ::env(SETUP_MOVE_SEQUENCE) "unbuffer,sizeup,swap,buffer,vt_swap"
  set ::env(SKIP_LAST_GASP) 1
  set additional_args_repair_timing ""
  append_env_var additional_args_repair_timing MAX_REPAIR_TIMING_ITER -max_iterations 1
  repair_timing_helper -setup {*}$additional_args_repair_timing
}

puts "Default units for flow"
report_units
report_units_metric
report_metrics 2 "floorplan final" false false

source_env_var_if_exists POST_FLOORPLAN_TCL
source_env_var_if_exists IO_CONSTRAINTS

write_db $::env(RESULTS_DIR)/2_1_floorplan.odb
write_sdc -no_timestamp $::env(RESULTS_DIR)/2_1_floorplan.sdc


# Macro placement
source $::env(SCRIPTS_DIR)/macro_place_util.tcl

write_db $::env(RESULTS_DIR)/2_2_floorplan_macro.odb
write_macro_placement $::env(RESULTS_DIR)/2_2_floorplan_macro.tcl


# Tapcell insertion
if { [env_var_exists_and_non_empty TAPCELL_TCL] } {
  source $::env(TAPCELL_TCL)
} else {
  cut_rows
}

write_db $::env(RESULTS_DIR)/2_3_floorplan_tapcell.odb

# PDN
source $::env(PDN_TCL)
pdngen

source_env_var_if_exists POST_PDN_TCL

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

write_db $::env(RESULTS_DIR)/2_4_floorplan_pdn.odb

# Global placement skipping IOs
if { [env_var_exists_and_non_empty FLOORPLAN_DEF] } {
  puts "FLOORPLAN_DEF is set. Skipping global placement without IOs"
} elseif { [all_pins_placed] } {
  puts "All pins are placed. Skipping global placement without IOs"
} else {
  log_cmd global_placement -skip_io -density [place_density_with_lb_addon] \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    {*}[env_var_or_empty GLOBAL_PLACEMENT_ARGS]
}

write_db $::env(RESULTS_DIR)/3_1_place_gp_skip_io.odb

# IO placement
if {
  ![env_var_exists_and_non_empty FLOORPLAN_DEF] &&
  ![env_var_exists_and_non_empty FOOTPRINT] &&
  ![env_var_exists_and_non_empty FOOTPRINT_TCL]
} {
  # load_design 3_1_place_gp_skip_io.odb 2_floorplan.sdc
  log_cmd place_pins \
    -hor_layers $::env(IO_PLACER_H) \
    -ver_layers $::env(IO_PLACER_V) \
    {*}[env_var_or_empty PLACE_PINS_ARGS]
  write_db $::env(RESULTS_DIR)/3_2_place_iop.odb
  write_pin_placement $::env(RESULTS_DIR)/3_2_place_iop.tcl
} else {
  log_cmd exec cp $::env(RESULTS_DIR)/3_1_place_gp_skip_io.odb $::env(RESULTS_DIR)/3_2_place_iop.odb
}

# Global placement
utl::set_metrics_stage "globalplace__{}"
set_dont_use $::env(DONT_USE_CELLS)

if { $::env(GPL_TIMING_DRIVEN) } {
  remove_buffers
}

# Do not buffer chip-level designs
# by default, IO ports will be buffered
# to not buffer IO ports, set environment variable
# DONT_BUFFER_PORT = 1
if { ![env_var_exists_and_non_empty FOOTPRINT] } {
  if { ![env_var_equals DONT_BUFFER_PORTS 1] } {
    puts "Perform port buffering..."
    buffer_ports {*}[env_var_or_empty BUFFER_PORTS_ARGS]
  }
}

set global_placement_args {}

# Parameters for routability mode in global placement
append_env_var global_placement_args GPL_ROUTABILITY_DRIVEN -routability_driven 0

# Parameters for timing driven mode in global placement
if { $::env(GPL_TIMING_DRIVEN) } {
  lappend global_placement_args {-timing_driven}
  if { [info exists ::env(GPL_KEEP_OVERFLOW)] } {
    lappend global_placement_args -keep_resize_below_overflow $::env(GPL_KEEP_OVERFLOW)
  }
}

proc do_placement { global_placement_args } {
  set all_args [concat [list -density [place_density_with_lb_addon] \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)] \
    $global_placement_args]

  lappend all_args {*}[env_var_or_empty GLOBAL_PLACEMENT_ARGS]

  log_cmd global_placement {*}$all_args
}

set result [catch { do_placement $global_placement_args } errMsg]
if { $result != 0 } {
  write_db $::env(RESULTS_DIR)/3_3_place_gp-failed.odb
  error $errMsg
}

estimate_parasitics -placement

if { [env_var_equals CLUSTER_FLOPS 1] } {
  cluster_flops
  estimate_parasitics -placement
}

report_metrics 3 "global place" false false

write_db $::env(RESULTS_DIR)/3_3_place_gp.odb

# Resizing
utl::set_metrics_stage "placeopt__{}"
estimate_parasitics -placement

set instance_count_before [sta::network_leaf_instance_count]
set pin_count_before [sta::network_leaf_pin_count]

set_dont_use $::env(DONT_USE_CELLS)

if { [env_var_exists_and_non_empty EARLY_SIZING_CAP_RATIO] } {
  log_cmd set_opt_config -set_early_sizing_cap_ratio $env(EARLY_SIZING_CAP_RATIO)
}

if { [env_var_exists_and_non_empty SWAP_ARITH_OPERATORS] } {
  replace_arith_modules
}

repair_design_helper

# hold violations are not repaired until after CTS

# post report

puts "Floating nets: "
report_floating_nets

report_metrics 3 "resizer" true false

puts "Instance count before $instance_count_before, after [sta::network_leaf_instance_count]"
puts "Pin count before $pin_count_before, after [sta::network_leaf_pin_count]"

write_db $::env(RESULTS_DIR)/3_4_place_resized.odb

# Detailed placement
utl::set_metrics_stage "detailedplace__{}"

source $::env(PLATFORM_DIR)/setRC.tcl

proc do_dpl { } {
  # Only for use with hybrid rows
  if { [env_var_equals BALANCE_ROWS 1] } {
    balance_row_usage
  }

  set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
  detailed_placement

  if { [env_var_equals ENABLE_DPO 1] } {
    if { [env_var_exists_and_non_empty DPO_MAX_DISPLACEMENT] } {
      improve_placement -max_displacement $::env(DPO_MAX_DISPLACEMENT)
    } else {
      improve_placement
    }
  }
  optimize_mirroring

  utl::info FLW 12 "Placement violations [check_placement -verbose]."

  estimate_parasitics -placement
}

set result [catch { do_dpl } errMsg]
if { $result != 0 } {
  write_db $::env(RESULTS_DIR)/3_5_place_dp-failed.odb
  error $errMsg
}

report_metrics 3 "detailed place" true false

write_db $::env(RESULTS_DIR)/3_5_place_dp.odb

# Repair timing after placement
utl::set_metrics_stage "place_repair_timing__{}"

set_placement_padding -global \
  -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
  -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)

puts "Repair setup and hold violations"
estimate_parasitics -placement

set additional_args_repair_timing ""
append_env_var additional_args_repair_timing MAX_REPAIR_TIMING_ITER -max_iterations 1

log_cmd repair_timing -repair_tns $::env(TNS_END_PERCENT) \
  {*}$additional_args_repair_timing

# Legalize placement after timing repair
detailed_placement

puts "Estimate parasitics"
estimate_parasitics -placement
report_metrics 3 "place repair timing" true false

write_db $::env(RESULTS_DIR)/3_6_place_repair_timing.odb
