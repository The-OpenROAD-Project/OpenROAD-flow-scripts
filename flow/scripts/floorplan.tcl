utl::set_metrics_stage "floorplan__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 1_synth.v 1_synth.sdc "Starting floorplan"

set num_instances [llength [get_cells -hier *]]
puts "number instances in verilog is $num_instances"

# Initialize floorplan using ICeWall FOOTPRINT
# ----------------------------------------------------------------------------

if {[info exists ::env(FOOTPRINT)]} {

  ICeWall load_footprint $env(FOOTPRINT)

  initialize_floorplan \
    -die_area  [ICeWall get_die_area] \
    -core_area [ICeWall get_core_area] \
    -site      $::env(PLACE_SITE)

  ICeWall init_footprint $env(SIG_MAP_FILE)


# Initialize floorplan using CORE_UTILIZATION
# ----------------------------------------------------------------------------
} elseif {[info exists ::env(CORE_UTILIZATION)] && $::env(CORE_UTILIZATION) != "" } {
  initialize_floorplan -utilization $::env(CORE_UTILIZATION) \
                       -aspect_ratio $::env(CORE_ASPECT_RATIO) \
                       -core_space $::env(CORE_MARGIN) \
                       -site $::env(PLACE_SITE)

# Initialize floorplan using DIE_AREA/CORE_AREA
# ----------------------------------------------------------------------------
} else {
  initialize_floorplan -die_area $::env(DIE_AREA) \
                       -core_area $::env(CORE_AREA) \
                       -site $::env(PLACE_SITE)
}

if { [info exists ::env(MAKE_TRACKS)] } {
  source $::env(MAKE_TRACKS)
} elseif {[file exists $::env(PLATFORM_DIR)/make_tracks.tcl]} {
  source $::env(PLATFORM_DIR)/make_tracks.tcl
} else {
  make_tracks
}

if {[info exists ::env(FOOTPRINT_TCL)]} {
  source $::env(FOOTPRINT_TCL)
  initialize_padring
}

# remove buffers inserted by yosys/abc
remove_buffers

##### Restructure for timing #########
if { [info exist ::env(RESYNTH_TIMING_RECOVER)] && $::env(RESYNTH_TIMING_RECOVER) == 1 } {
  repair_design
  repair_timing
  # pre restructure area/timing report (ideal clocks)
  puts "Post synth-opt area"
  report_design_area
  report_worst_slack -min -digits 3
  puts "Post synth-opt wns"
  report_worst_slack -max -digits 3
  puts "Post synth-opt tns"
  report_tns -digits 3

  if {![info exists save_checkpoint] || $save_checkpoint} {
    write_verilog $::env(RESULTS_DIR)/2_pre_abc_timing.v
  }

  restructure -target timing -liberty_file $::env(DONT_USE_SC_LIB) \
              -work_dir $::env(RESULTS_DIR)

  if {![info exists save_checkpoint] || $save_checkpoint} {
    write_verilog $::env(RESULTS_DIR)/2_post_abc_timing.v
  }

  # post restructure area/timing report (ideal clocks)
  remove_buffers
  repair_design
  repair_timing

  puts "Post restructure-opt wns"
  report_worst_slack -max -digits 3
  puts "Post restructure-opt tns"
  report_tns -digits 3

  # remove buffers inserted by optimization
  remove_buffers
}


puts "Default units for flow"
report_units
report_units_metric
source $::env(SCRIPTS_DIR)/report_metrics.tcl
report_metrics "floorplan final" false

if { [info exist ::env(RESYNTH_AREA_RECOVER)] && $::env(RESYNTH_AREA_RECOVER) == 1 } {

  utl::push_metrics_stage "floorplan__{}__pre_restruct"
  set num_instances [llength [get_cells -hier *]]
  puts "number instances before restructure is $num_instances"
  puts "Design Area before restructure"
  report_design_area
  report_design_area_metrics
  utl::pop_metrics_stage

  if {![info exists save_checkpoint] || $save_checkpoint} {
    write_verilog $::env(RESULTS_DIR)/2_pre_abc.v
  }

  set tielo_cell_name [lindex $env(TIELO_CELL_AND_PORT) 0]
  set tielo_lib_name [get_name [get_property [lindex [get_lib_cell $tielo_cell_name] 0] library]]
  set tielo_port $tielo_lib_name/$tielo_cell_name/[lindex $env(TIELO_CELL_AND_PORT) 1]

  set tiehi_cell_name [lindex $env(TIEHI_CELL_AND_PORT) 0]
  set tiehi_lib_name [get_name [get_property [lindex [get_lib_cell $tiehi_cell_name] 0] library]]
  set tiehi_port $tiehi_lib_name/$tiehi_cell_name/[lindex $env(TIEHI_CELL_AND_PORT) 1]

  restructure -liberty_file $::env(DONT_USE_SC_LIB) -target "area" \
        -tiehi_port $tiehi_port \
        -tielo_port $tielo_port \
        -work_dir $::env(RESULTS_DIR)

  # remove buffers inserted by abc
  remove_buffers

  if {![info exists save_checkpoint] || $save_checkpoint} {
    write_verilog $::env(RESULTS_DIR)/2_post_abc.v
  }
  utl::push_metrics_stage "floorplan__{}__post_restruct
  set num_instances [llength [get_cells -hier *]]
  puts "number instances after restructure is $num_instances"
  puts "Design Area after restructure"
  report_design_area
  report_design_area_metrics
  utl::pop_metrics_stage
}

if { [info exists ::env(POST_FLOORPLAN_TCL)] } {
  source $::env(POST_FLOORPLAN_TCL)
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  if {[info exists ::env(GALLERY_REPORT)]  && $::env(GALLERY_REPORT) != 0} {
      write_def $::env(RESULTS_DIR)/2_1_floorplan.def
  }
  write_db $::env(RESULTS_DIR)/2_1_floorplan.odb
  write_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
}
