source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_3_floorplan_tdms.odb 1_synth.sdc "Starting macro placement"

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

  if {[info exists ::env(RTLMP_FLOW)]} {
    puts "HierRTLMP Flow enabled..."
    set additional_rtlmp_args ""
    if { [info exists ::env(RTLMP_MAX_LEVEL)]} {
        append additional_rtlmp_args " -max_num_level $env(RTLMP_MAX_LEVEL)"
    }
    if { [info exists ::env(RTLMP_MAX_INST)]} {
        append additional_rtlmp_args " -max_num_inst $env(RTLMP_MAX_INST)"
    }
    if { [info exists ::env(RTLMP_MIN_INST)]} {
        append additional_rtlmp_args " -min_num_inst $env(RTLMP_MIN_INST)"
    }
    if { [info exists ::env(RTLMP_MAX_MACRO)]} {
        append additional_rtlmp_args " -max_num_macro $env(RTLMP_MAX_MACRO)"
    }
    if { [info exists ::env(RTLMP_MIN_MACRO)]} {
        append additional_rtlmp_args " -min_num_macro $env(RTLMP_MIN_MACRO)"
    }
    
    append additional_rtlmp_args " -halo_width $halo_max"

    if { [info exists ::env(RTLMP_MIN_AR)]} {
        append additional_rtlmp_args " -min_ar $env(RTLMP_MIN_AR)"
    }
    if { [info exists ::env(RTLMP_AREA_WT)]} {
        append additional_rtlmp_args " -area_weight $env(RTLMP_AREA_WT)"
    }
    if { [info exists ::env(RTLMP_WIRELENGTH_WT)]} {
        append additional_rtlmp_args " -wirelength_weight $env(RTLMP_WIRELENGTH_WT)"
    }
    if { [info exists ::env(RTLMP_OUTLINE_WT)]} {
        append additional_rtlmp_args " -outline_weight $env(RTLMP_OUTLINE_WT)"
    }
    if { [info exists ::env(RTLMP_BOUNDARY_WT)]} {
        append additional_rtlmp_args " -boundary_weight $env(RTLMP_BOUNDARY_WT)"
    }

    if { [info exists ::env(RTLMP_NOTCH_WT)]} {
        append additional_rtlmp_args " -notch_weight $env(RTLMP_NOTCH_WT)"
    }

    if { [info exists ::env(RTLMP_DEAD_SPACE)]} {
        append additional_rtlmp_args " -dead_space $env(RTLMP_DEAD_SPACE)"
    }
    if { [info exists ::env(RTLMP_CONFIG_FILE)]} {
        append additional_rtlmp_args " -config_file $env(RTLMP_CONFIG_FILE)"
    }
    if { [info exists ::env(RTLMP_RPT_DIR)]} {
        append additional_rtlmp_args " -report_directory $env(RTLMP_RPT_DIR)"
    }


    puts "Call Macro Placer $additional_rtlmp_args"

    rtl_macro_placer \
                 {*}$additional_rtlmp_args

    puts "Delete buffers for RTLMP flow..."
    remove_buffers
  } else {
    if {[info exists ::env(MACRO_PLACEMENT_TCL)]} {
      source $::env(MACRO_PLACEMENT_TCL)
      puts "\[INFO\]\[FLOW-xxxx\] Using manual macro placement file $::env(MACRO_PLACEMENT_TCL)"
    } elseif {[info exists ::env(MACRO_PLACEMENT)]} {
      source $::env(SCRIPTS_DIR)/read_macro_placement.tcl
      puts "\[INFO\]\[FLOW-xxxx\] Using manual macro placement file $::env(MACRO_PLACEMENT)"
      read_macro_placement $::env(MACRO_PLACEMENT)
    } else {
      macro_placement \
        -halo $::env(MACRO_PLACE_HALO) \
        -channel $::env(MACRO_PLACE_CHANNEL)
    }
  }

  source $::env(SCRIPTS_DIR)/placement_blockages.tcl
  block_channels $blockage_width 
} else {
  puts "No macros found: Skipping macro_placement"
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/2_4_floorplan_macro.odb
}
