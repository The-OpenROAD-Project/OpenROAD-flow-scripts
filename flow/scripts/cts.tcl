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

  # Read design files
  read_def $::env(RESULTS_DIR)/3_place.def

  # Read SDC file
  read_sdc $::env(RESULTS_DIR)/3_place.sdc
  if [file exists $::env(PLATFORM_DIR)/derate.tcl] {
    source $::env(PLATFORM_DIR)/derate.tcl
  }
}

# Clone clock tree inverters next to register loads
# so cts does not try to buffer the inverted clocks.
repair_clock_inverters

# Run CTS
#

#--------------------------------------------------
# opt 1-1) non-LUT - no clustering
#configure_cts_characterization \
#                     -sqr_cap $::env(CTS_SQR_CAP) \
#                     -sqr_res $::env(CTS_SQR_RES) \
#                     -slew_inter $::env(CTS_SLEW_INTER) \
#                     -cap_inter $::env(CTS_CAP_INTER) \
#                     -max_slew $::env(CTS_SLEW_MAX) \
#                     -max_cap $::env(CTS_CAP_MAX)
#
#clock_tree_synthesis -buf_list "$::env(CTS_BUF_LIST)" \
#                     -distance_between_buffers "$::env(CTS_BUF_DISTANCE)"
#

# opt 1-2) non-LUT - do clustering
#configure_cts_characterization \
#                     -sqr_cap $::env(CTS_SQR_CAP) \
#                     -sqr_res $::env(CTS_SQR_RES) \
#                     -slew_inter $::env(CTS_SLEW_INTER) \
#                     -cap_inter $::env(CTS_CAP_INTER) \
#                     -max_slew $::env(CTS_SLEW_MAX) \
#                     -max_cap $::env(CTS_CAP_MAX)
#
#clock_tree_synthesis -buf_list "$::env(CTS_BUF_LIST)" \
#                     -distance_between_buffers "$::env(CTS_BUF_DISTANCE)" \
#                     -sink_clustering_enable \
#                     -sink_clustering_max_diameter 80
#--------------------------------------------------

# opt 2-1) using LUT - no clustering
clock_tree_synthesis -lut_file "$::env(CTS_TECH_DIR)/lut.txt" \
                     -sol_list "$::env(CTS_TECH_DIR)/sol_list.txt" \
                     -root_buf "$::env(CTS_BUF_CELL)" \
                     -wire_unit 20 \
                     -distance_between_buffers "$::env(CTS_BUF_DISTANCE)"


## opt 2-2) using LUT - do clustering
#clock_tree_synthesis -lut_file "$::env(CTS_TECH_DIR)/lut.txt" \
#                     -sol_list "$::env(CTS_TECH_DIR)/sol_list.txt" \
#                     -root_buf "$::env(CTS_BUF_CELL)" \
#                     -wire_unit 20 \
#                     -distance_between_buffers "$::env(CTS_BUF_DISTANCE)" \
#                     -sink_clustering_enable \
#                     -sink_clustering_max_diameter 80
#--------------------------------------------------


set_propagated_clock [all_clocks]

# This should be required, NOT conditional -cherry
if [file exists $::env(PLATFORM_DIR)/setRC.tcl] {
  source $::env(PLATFORM_DIR)/setRC.tcl
}

estimate_parasitics -placement
set_dont_use $::env(DONT_USE_CELLS)
repair_clock_nets -max_wire_length $::env(MAX_WIRE_LENGTH) -buffer_cell "$::env(CTS_BUF_CELL)"

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement

puts "Repair hold violations..."
estimate_parasitics -placement
repair_hold_violations -buffer_cell $::env(HOLD_BUF_CELL)


puts "\n=========================================================================="
puts "post cts report_checks -path_delay min"
puts "--------------------------------------------------------------------------"
report_checks -path_delay min -fields {slew cap input nets fanout} -format full_clock_expanded

puts "\n=========================================================================="
puts "post cts report_checks -path_delay max"
puts "--------------------------------------------------------------------------"
report_checks -path_delay max -fields {slew cap input nets fanout} -format full_clock_expanded

puts "\n=========================================================================="
puts "post cts report_checks -unconstrained"
puts "--------------------------------------------------------------------------"
report_checks -unconstrained -fields {slew cap input nets fanout} -format full_clock_expanded

puts "\n=========================================================================="
puts "post cts report_tns"
puts "--------------------------------------------------------------------------"
report_tns

puts "\n=========================================================================="
puts "post cts report_wns"
puts "--------------------------------------------------------------------------"
report_wns

puts "\n=========================================================================="
puts "post cts report_check_types -max_slew -violators"
puts "--------------------------------------------------------------------------"
report_check_types -max_slew -max_capacitance -max_fanout -violators

puts "\n=========================================================================="
puts "post cts report_clock_skew"
puts "--------------------------------------------------------------------------"
report_clock_skew

detailed_placement
check_placement

if {$::env(PLATFORM) == "gf12"} {
  puts "\[INFO-FLOW\] OpenROAD - post cts patch\n"
  
  #--------------------------------------------------------------------------------
  puts "\[INFO\] Adding routing blockages to address lonely vias"
  set db [::ord::get_db]
  set block [[$db getChip] getBlock]
  set tech [$db getTech]
  
  set master [$db findMaster IN12LP_GPIO18_13M9S30P_CORNER]
  
  if { $master != "NULL" } {
    set xList [list]
    set yList [list]
    foreach inst [$block getInsts] {
      if {[$inst getMaster] == $master} {
        set bbox [$inst getBBox]
        lappend xList [$bbox xMin]
        lappend yList [$bbox yMin]
        lappend xList [$bbox xMax]
        lappend yList [$bbox yMax]
      }
    }
    
    
    set layer_1 [$tech findLayer V1]
    set layer_2 [$tech findLayer V2]
    set layer_3 [$tech findLayer J3]
    set layer_4 [$tech findLayer A4]
    set layer_5 [$tech findLayer CK]
    set layer_6 [$tech findLayer U1]
    set layer_7 [$tech findLayer U2]
    
    set ioEdgeXmin  [lindex [lsort -real -unique $xList] 1] 
    set ioEdgeXmax  [lindex [lsort -real -unique $xList] 2] 
    set ioEdgeYmin  [lindex [lsort -real -unique $yList] 1] 
    set ioEdgeYmax  [lindex [lsort -real -unique $yList] 2] 
    set coreDB [ord::get_db_core]
    set coreXmin [$coreDB xMin]
    set coreYmin [$coreDB yMin]
    set coreXmax [$coreDB xMax]
    set coreYmax [$coreDB yMax]
    set offsetX1  [expr $coreXmin - $ioEdgeXmin]
    set offsetX2  [expr $ioEdgeXmax - $coreXmax]
    
    foreach {createOBS llx lly urx ury} [list \
                                          1 $ioEdgeXmin $ioEdgeYmin [expr $ioEdgeXmin + $offsetX1] $ioEdgeYmax \
                                          1 [expr $ioEdgeXmax - $offsetX2] $ioEdgeYmin $ioEdgeXmax $ioEdgeYmax \
                              ] {
    
      if { $createOBS } {
        set obs_1 [odb::dbObstruction_create $block $layer_1 $llx $lly $urx $ury]
        set obs_2 [odb::dbObstruction_create $block $layer_2 $llx $lly $urx $ury]
        set obs_3 [odb::dbObstruction_create $block $layer_3 $llx $lly $urx $ury]
        set obs_4 [odb::dbObstruction_create $block $layer_4 $llx $lly $urx $ury]
        set obs_5 [odb::dbObstruction_create $block $layer_5 $llx $lly $urx $ury]
      }
    }
  }
  #--------------------------------------------------------------------------------
  puts "\[INFO-FLOW\] OpenROAD - end post cts patch\n"
}

if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/4_1_cts.def
  write_verilog $::env(RESULTS_DIR)/4_cts.v
  write_sdc $::env(RESULTS_DIR)/4_cts.sdc
  exit
}
