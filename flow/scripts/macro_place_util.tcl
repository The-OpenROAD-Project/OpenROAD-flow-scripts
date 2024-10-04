if {[find_macros] != ""} {
# If wrappers defined replace macros with their wrapped version
# # ----------------------------------------------------------------------------
  if {[env_var_exists_and_non_empty MACRO_WRAPPERS]} {
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

  
  if {[env_var_exists_and_non_empty MACRO_BLOCKAGE_HALO]} {
    set blockage_width $::env(MACRO_BLOCKAGE_HALO)
  }

  if {[env_var_exists_and_non_empty MACRO_PLACEMENT_TCL]} {
    source $::env(MACRO_PLACEMENT_TCL)
    puts "Using manual macro placement file $::env(MACRO_PLACEMENT_TCL)"
  } elseif {[env_var_exists_and_non_empty MACRO_PLACEMENT]} {
    source $::env(SCRIPTS_DIR)/read_macro_placement.tcl
    puts "Using manual macro placement file $::env(MACRO_PLACEMENT)"
    read_macro_placement $::env(MACRO_PLACEMENT)
  } elseif {[env_var_equals RTLMP_FLOW 1]} {
    puts "HierRTLMP Flow enabled..."
    set additional_rtlmp_args ""
    append_env_var additional_rtlmp_args RTLMP_MAX_LEVEL -max_num_level 1
    append_env_var additional_rtlmp_args RTLMP_MAX_INST -max_num_inst 1
    append_env_var additional_rtlmp_args RTLMP_MIN_INST -min_num_inst 1
    append_env_var additional_rtlmp_args RTLMP_MAX_MACRO -max_num_macro 1
    append_env_var additional_rtlmp_args RTLMP_MIN_MACRO -min_num_macro 1
    append additional_rtlmp_args " -halo_width $halo_x"
    append additional_rtlmp_args " -halo_height $halo_y"
    append_env_var additional_rtlmp_args RTLMP_MIN_AR -min_ar 1
    append_env_var additional_rtlmp_args RTLMP_SIGNATURE_NET_THRESHOLD -signature_net_threshold 1
    append_env_var additional_rtlmp_args RTLMP_AREA_WT -area_weight 1
    append_env_var additional_rtlmp_args RTLMP_WIRELENGTH_WT -wirelength_weight 1
    append_env_var additional_rtlmp_args RTLMP_OUTLINE_WT -outline_weight 1
    append_env_var additional_rtlmp_args RTLMP_BOUNDARY_WT -boundary_weight 1
    append_env_var additional_rtlmp_args RTLMP_NOTCH_WT -notch_weight 1
    append_env_var additional_rtlmp_args RTLMP_DEAD_SPACE -dead_space 1
    append_env_var additional_rtlmp_args RTLMP_CONFIG_FILE -config_file 1
    append_env_var additional_rtlmp_args RTLMP_RPT_DIR -report_directory 1
    append_env_var additional_rtlmp_args RTLMP_FENCE_LX -fence_lx 1
    append_env_var additional_rtlmp_args RTLMP_FENCE_LY -fence_ly 1
    append_env_var additional_rtlmp_args RTLMP_FENCE_UX -fence_ux 1
    append_env_var additional_rtlmp_args RTLMP_FENCE_UY -fence_uy 1

    source $::env(SCRIPTS_DIR)/set_place_density.tcl
    append additional_rtlmp_args " -target_util $place_density"

    set all_args $additional_rtlmp_args

    if { [env_var_exists_and_non_empty RTLMP_ARGS] } {
      set all_args $::env(RTLMP_ARGS)
    }

    log_cmd rtl_macro_placer {*}$all_args
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
