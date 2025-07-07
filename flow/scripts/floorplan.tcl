utl::set_metrics_stage "floorplan__{}"
source $::env(SCRIPTS_DIR)/load.tcl
erase_non_stage_variables floorplan
load_design 1_synth.v 1_synth.sdc

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

set use_floorplan_def [env_var_exists_and_non_empty FLOORPLAN_DEF]
set use_footprint [env_var_exists_and_non_empty FOOTPRINT]
set use_die_and_core_area [expr { [env_var_exists_and_non_empty DIE_AREA] && [env_var_exists_and_non_empty CORE_AREA] }]
set use_core_utilization [env_var_exists_and_non_empty CORE_UTILIZATION]

set methods_defined [expr { $use_floorplan_def + $use_footprint + $use_die_and_core_area + $use_core_utilization }]
if { $methods_defined > 1 } {
  puts "Error: Floorplan initialization methods are mutually exclusive, pick one."
  exit 1
}

if { $use_floorplan_def } {
  # Initialize floorplan by reading in floorplan DEF
  log_cmd read_def -floorplan_initialize $env(FLOORPLAN_DEF)
} elseif { $use_footprint } {
  # Initialize floorplan using ICeWall FOOTPRINT
  ICeWall load_footprint $env(FOOTPRINT)

  initialize_floorplan \
    -die_area [ICeWall get_die_area] \
    -core_area [ICeWall get_core_area] \
    -site $::env(PLACE_SITE)

  ICeWall init_footprint $env(SIG_MAP_FILE)
} elseif { $use_die_and_core_area } {
  initialize_floorplan -die_area $::env(DIE_AREA) \
    -core_area $::env(CORE_AREA) \
    -site $::env(PLACE_SITE) \
    {*}$additional_args
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

if { [env_var_exists_and_non_empty MAKE_TRACKS] } {
  log_cmd source $::env(MAKE_TRACKS)
} elseif { [file exists $::env(PLATFORM_DIR)/make_tracks.tcl] } {
  log_cmd source $::env(PLATFORM_DIR)/make_tracks.tcl
} else {
  make_tracks
}

if { [env_var_exists_and_non_empty FOOTPRINT_TCL] } {
  log_cmd source $::env(FOOTPRINT_TCL)
}

if { [env_var_equals REMOVE_ABC_BUFFERS 1] } {
  # remove buffers inserted by yosys/abc
  remove_buffers
} else {
  # Skip clone & split
  set ::env(SETUP_MOVE_SEQUENCE) "unbuffer,sizeup,swap,buffer"
  set ::env(SKIP_LAST_GASP) 1
  repair_timing_helper -setup
}

puts "Default units for flow"
report_units
report_units_metric
report_metrics 2 "floorplan final" false false

if { [env_var_exists_and_non_empty POST_FLOORPLAN_TCL] } {
  log_cmd source $::env(POST_FLOORPLAN_TCL)
}


if { [env_var_exists_and_non_empty IO_CONSTRAINTS] } {
  log_cmd source $::env(IO_CONSTRAINTS)
}

write_db $::env(RESULTS_DIR)/2_1_floorplan.odb
write_sdc -no_timestamp $::env(RESULTS_DIR)/2_1_floorplan.sdc
