if {![info exists standalone] || $standalone} {
  # Read lef
  read_lef $::env(TECH_LEF)
  read_lef $::env(SC_LEF)
  if {[info exist ::env(ADDITIONAL_LEFS)]} {
    foreach lef $::env(ADDITIONAL_LEFS) {
      read_lef $lef
    }
  }

  # Read liberty files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read verilog
  read_verilog $::env(RESULTS_DIR)/1_synth.v

  link_design $::env(DESIGN_NAME)
  read_sdc $::env(RESULTS_DIR)/1_synth.sdc
  if [file exists platforms/$::env(PLATFORM)/derate.tcl] {
    source platforms/$::env(PLATFORM)/derate.tcl
  }
  set num_instances [llength [get_cells -hier *]]
  puts "number instances in verilog is $num_instances"
}

# Initialize floorplan using ICeWall FOOTPRINT
# ----------------------------------------------------------------------------
if {[info exists ::env(FOOTPRINT)]} {

  ICeWall load_footprint $env(FOOTPRINT)

  initialize_floorplan \
    -die_area  [ICeWall get_die_area] \
    -core_area [ICeWall get_core_area] \
    -tracks    $::env(TRACKS_INFO_FILE) \
    -site      $::env(PLACE_SITE)

  ICeWall init_footprint $env(SIG_MAP_FILE)


# Initialize floorplan using CORE_UTILIZATION
# ----------------------------------------------------------------------------
} elseif {[info exists ::env(CORE_UTILIZATION)] && $::env(CORE_UTILIZATION) != "" } {
  initialize_floorplan -utilization $::env(CORE_UTILIZATION) \
                       -aspect_ratio $::env(CORE_ASPECT_RATIO) \
                       -core_space $::env(CORE_MARGIN) \
                       -tracks $::env(TRACKS_INFO_FILE) \
                       -site $::env(PLACE_SITE)

# Initialize floorplan using DIE_AREA/CORE_AREA
# ----------------------------------------------------------------------------
} else {
  initialize_floorplan -die_area $::env(DIE_AREA) \
                       -core_area $::env(CORE_AREA) \
                       -tracks $::env(TRACKS_INFO_FILE) \
                       -site $::env(PLACE_SITE)
}

# If wrappers defined replace macros with their wrapped version
# # ----------------------------------------------------------------------------
if {[info exists ::env(MACRO_WRAPPERS)]} {
  source $::env(MACRO_WRAPPERS)

  set wrapped_macros [dict keys [dict get $wrapper around]]
  set db [ord::get_db]
  set block [ord::get_db_block]

  foreach inst [$block getInsts] {
    if {[lsearch -exact $wrapped_macros [[$inst getMaster] getName]] > -1} {
      set new_master [dict get $wrapper around [[$inst getMaster] getName]]
      puts "Replacing [[$inst getMaster] getName] with $new_master for [$inst getName]"
      $inst swapMaster [$db findMaster $new_master]
    }
  }
}

# This shouldn't be conditional but it causes failures in nangate45
# that we aren't ready to address
if {[string match "gf14" $::env(PLATFORM)]} {
    remove_buffers
}

# pre report
log_begin $::env(REPORTS_DIR)/2_init.rpt

puts "\n=========================================================================="
puts "report_checks"
puts "--------------------------------------------------------------------------"
report_checks

puts "\n=========================================================================="
puts "report_tns"
puts "--------------------------------------------------------------------------"
report_tns

puts "\n=========================================================================="
puts "report_wns"
puts "--------------------------------------------------------------------------"
report_wns

puts "\n=========================================================================="
puts "report_design_area"
puts "--------------------------------------------------------------------------"
report_design_area

log_end


if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/2_1_floorplan.def
  write_verilog $::env(RESULTS_DIR)/2_floorplan.v
  write_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
  exit
}
