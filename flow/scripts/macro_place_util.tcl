set_thread_count $::env(NUM_CORES)

proc find_macros {} {
  set macros ""

  set db [ord::get_db]
  set block [[$db getChip] getBlock]
  foreach inst [$block getInsts] {
    set inst_master [$inst getMaster]

    # BLOCK means MACRO cells
    if { [string match [$inst_master getType] "BLOCK"] } {
      append macros " " $inst
    }
  }
  return $macros
}

if {[find_macros] != ""} {
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

  lassign $::env(MACRO_PLACE_HALO) halo_x halo_y
  lassign $::env(MACRO_PLACE_CHANNEL) channel_x channel_y
  set halo_max [expr max($halo_x, $halo_y)]
  set channel_max [expr max($channel_x, $channel_y)]
  set blockage_width [expr max($halo_max, $channel_max/2)]

  
  if {[info exists ::env(MACRO_BLOCKAGE_HALO)]} {
    set blockage_width $::env(MACRO_BLOCKAGE_HALO)
  }

  if {[info exists ::env(MACRO_PLACEMENT_TCL)]} {
    source $::env(MACRO_PLACEMENT_TCL)
    puts "\[INFO\]\[FLOW-xxxx\] Using manual macro placement file $::env(MACRO_PLACEMENT_TCL)"
  } elseif {[info exists ::env(MACRO_PLACEMENT)]} {
    source $::env(SCRIPTS_DIR)/read_macro_placement.tcl
    puts "\[INFO\]\[FLOW-xxxx\] Using manual macro placement file $::env(MACRO_PLACEMENT)"
    read_macro_placement $::env(MACRO_PLACEMENT)
  } elseif {[info exists ::env(RTLMP_FLOW)]} {
    puts "HierRTLMP Flow enabled..."
    set additional_rtlmp_args ""

    # Generic Parameters
    if { [info exists ::env(RTLMP_MAX_MACRO)]} {
        append additional_rtlmp_args " -max_num_macro $env(RTLMP_MAX_MACRO)"
    }
    if { [info exists ::env(RTLMP_MIN_MACRO)]} {
        append additional_rtlmp_args " -min_num_macro $env(RTLMP_MIN_MACRO)"
    }
    if { [info exists ::env(RTLMP_MAX_INST)]} {
        append additional_rtlmp_args " -max_num_inst $env(RTLMP_MAX_INST)"
    }
    if { [info exists ::env(RTLMP_MIN_INST)]} {
        append additional_rtlmp_args " -min_num_inst $env(RTLMP_MIN_INST)"
    }
    if { [info exists ::env(RTLMP_TOLERANCE)]} {
      append additional_rtlmp_args " -tolerance $env(RTLMP_TOLERANCE)"
    }
    if { [info exists ::env(RTLMP_MAX_LEVEL)]} {
      append additional_rtlmp_args " -max_num_level $env(RTLMP_MAX_LEVEL)"
    }
    if { [info exists ::env(RTLMP_COARSENING_RATIO)]} {
      append additional_rtlmp_args " -coarsening_ratio $env(RTLMP_COARSENING_RATIO)"
    }
    if { [info exists ::env(RTLMP_NUM_BUNDLED_IOS)]} {
      append additional_rtlmp_args " -num_bundled_ios $env(RTLMP_NUM_BUNDLED_IOS)"
    }
    if { [info exists ::env(RTLMP_LARGE_NET_THRESHOLD)]} {
      append additional_rtlmp_args " -large_net_threshold $env(RTLMP_LARGE_NET_THRESHOLD)"
    }
    if { [info exists ::env(RTLMP_SIGNATURE_NET_THRESHOLD)]} {
      append additional_rtlmp_args " -signature_net_threshold $env(RTLMP_SIGNATURE_NET_THRESHOLD)"
    }
    append additional_rtlmp_args " -halo_width $halo_max"
    if { [info exists ::env(RTLMP_FENCE_LX)]} {
        append additional_rtlmp_args " -fence_lx $env(RTLMP_FENCE_LX)"
    }
    if { [info exists ::env(RTLMP_FENCE_LY)]} {
        append additional_rtlmp_args " -fence_ly $env(RTLMP_FENCE_LY)"
    }
    if { [info exists ::env(RTLMP_FENCE_UX)]} {
        append additional_rtlmp_args " -fence_ux $env(RTLMP_FENCE_UX)"
    }
    if { [info exists ::env(RTLMP_FENCE_UY)]} {
        append additional_rtlmp_args " -fence_uy $env(RTLMP_FENCE_UY)"
    }
    if { [info exists ::env(RTLMP_TARGET_UTIL)]} {
      append additional_rtlmp_args " -target_util $env(RTLMP_TARGET_UTIL)"
    }
    if { [info exists ::env(RTLMP_TARGET_DEAD_SPACE)]} {
      append additional_rtlmp_args " -target_dead_space $env(RTLMP_TARGET_DEAD_SPACE)"
    }
    if { [info exists ::env(RTLMP_MIN_AR)]} {
        append additional_rtlmp_args " -min_ar $env(RTLMP_MIN_AR)"
    }
    if { [info exists ::env(RTLMP_SNAP_LAYER)]} {
      append additional_rtlmp_args " -snap_layer $env(RTLMP_SNAP_LAYER)"
    }
    if { [info exists ::env(RTLMP_BUS_PLANNING_ON)]} {
      append additional_rtlmp_args " -bus_planning_on $env(RTLMP_BUS_PLANNING_ON)"
    }
    if { [info exists ::env(RTLMP_REPORT_DIRECTORY)]} {
      append additional_rtlmp_args " -report_directory $env(RTLMP_REPORT_DIRECTORY)"
    }
    if { [info exists ::env(RTLMP_WRITE_PLACEMENT)]} {
      append additional_rtlmp_args " -write_macro_placement $env(RTLMP_WRITE_PLACEMENT)"
    }

    # Simulated Annealing Weight Parameters
    if { [info exists ::env(RTLMP_AREA_WT)]} {
        append additional_rtlmp_args " -area_weight $env(RTLMP_AREA_WT)"
    }
    if { [info exists ::env(RTLMP_OUTLINE_WT)]} {
        append additional_rtlmp_args " -outline_weight $env(RTLMP_OUTLINE_WT)"
    }
    if { [info exists ::env(RTLMP_WIRELENGTH_WT)]} {
        append additional_rtlmp_args " -wirelength_weight $env(RTLMP_WIRELENGTH_WT)"
    }
    if { [info exists ::env(RTLMP_GUIDANCE_WT)]} {
        append additional_rtlmp_args " -guidance_weight $env(RTLMP_GUIDANCE_WT)"
    }
    if { [info exists ::env(RTLMP_FENCE_WT)]} {
        append additional_rtlmp_args " -fence_weight $env(RTLMP_FENCE_WT)"
    }
    if { [info exists ::env(RTLMP_BOUNDARY_WT)]} {
        append additional_rtlmp_args " -boundary_weight $env(RTLMP_BOUNDARY_WT)"
    }
    if { [info exists ::env(RTLMP_NOTCH_WT)]} {
        append additional_rtlmp_args " -notch_weight $env(RTLMP_NOTCH_WT)"
    }
    if { [info exists ::env(RTLMP_MACRO_BLOCKAGE_WT)]} {
      append additional_rtlmp_args " -macro_blockage_weight $env(RTLMP_MACRO_BLOCKAGE_WT)"
    }

    puts "Call Macro Placer $additional_rtlmp_args"

    rtl_macro_placer \
                 {*}$additional_rtlmp_args

    puts "Delete buffers for RTLMP flow..."
    remove_buffers
  } else {
    macro_placement \
      -halo $::env(MACRO_PLACE_HALO) \
      -channel $::env(MACRO_PLACE_CHANNEL)
  }

  source $::env(SCRIPTS_DIR)/placement_blockages.tcl
  block_channels $blockage_width 
} else {
  puts "No macros found: Skipping macro_placement"
}
