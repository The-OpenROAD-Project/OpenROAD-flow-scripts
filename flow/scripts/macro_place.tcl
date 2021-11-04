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
  if {[info exists ::env(RTLMP_FLOW)]} {
    puts "RTLMP flow.. read verilog and floorplan def"
    read_verilog $::env(RESULTS_DIR)/1_synth.v
    link_design $::env(DESIGN_NAME)
    read_def $::env(FLOORPLAN_DEF) -floorplan_initialize
  } else {
    read_def $::env(RESULTS_DIR)/2_3_floorplan_tdms.def
  }
  read_sdc $::env(RESULTS_DIR)/1_synth.sdc
  if [file exists $::env(PLATFORM_DIR)/derate.tcl] {
    source $::env(PLATFORM_DIR)/derate.tcl
  }
} else {
  puts "Starting macro placement"
}

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
  if {[info exists ::env(RTLMP_FLOW)]} {
    puts "RTLMP Flow enabled..."
    partition_design -max_num_inst $env(RTLMP_MAX_INST) \
                    -min_num_inst $env(RTLMP_MIN_INST) \
                    -max_num_macro $env(RTLMP_MAX_MACRO) \
                    -min_num_macro $env(RTLMP_MIN_MACRO) \
                    -net_threshold 5 -virtual_weight 500 \
                    -num_hop 5 -timing_weight 1 \
                    -report_directory $env(RTLMP_RPT_DIR) \
                    -report_file $env(RTLMP_RPT_FILE)
 
    rtl_macro_placer -config_file $env(RTLMP_CONFIG_FILE) \
                     -macro_blockage_file $env(RTLMP_BLOCKAGE_FILE) \
                     -report_directory $env(RTLMP_RPT_DIR) \
                     -report_file $env(RTLMP_RPT_FILE)]
    puts "Delete buffers for RTLMP flow..."
    remove_buffers
  } else {
    if {[info exists ::env(MACRO_PLACEMENT)]} {
      source $::env(SCRIPTS_DIR)/read_macro_placement.tcl
      puts "\[INFO\]\[FLOW-xxxx\] Using manual macro placement file $::env(MACRO_PLACEMENT)"
      read_macro_placement $::env(MACRO_PLACEMENT)
    } else {
      macro_placement \
        -halo $::env(MACRO_PLACE_HALO) \
        -channel $::env(MACRO_PLACE_CHANNEL)
    }
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

  if {[info exists ::env(MACRO_BLOCKAGE_HALO)]} {
    source $::env(SCRIPTS_DIR)/placement_blockages.tcl
    block_channels $::env(MACRO_BLOCKAGE_HALO)
  }
} else {
  puts "No macros found: Skipping macro_placement"
}

if {![info exists standalone] || $standalone} {
  write_def $::env(RESULTS_DIR)/2_4_floorplan_macro.def
  exit
}
