source $::env(SCRIPTS_DIR)/util.tcl

proc write_keep_hierarchy {} {
  if { ![env_var_equals SYNTH_HIERARCHICAL 1] } {
    set out_script_ptr [open $::env(SYNTH_STOP_MODULE_SCRIPT) w]
    close $out_script_ptr
    return
  }

  source $::env(SCRIPTS_DIR)/synth_preamble.tcl

  synthesize_check {}

  if { [env_var_exists_and_non_empty ADDER_MAP_FILE] && [file isfile $::env(ADDER_MAP_FILE)] } {
    techmap -map $::env(ADDER_MAP_FILE)
  }
  techmap
  if {[env_var_exists_and_non_empty DFF_LIB_FILE]} {
    dfflibmap -liberty $::env(DFF_LIB_FILE)
  } else {
    dfflibmap -liberty $::env(DONT_USE_SC_LIB)
  }
  puts "abc [join $abc_args " "]"
  abc {*}$abc_args

  tee -o $::env(REPORTS_DIR)/synth_hier_stat.txt stat {*}$stat_libs

  set ungroup_threshold 0
  if { [env_var_exists_and_non_empty MAX_UNGROUP_SIZE] && $::env(MAX_UNGROUP_SIZE) > 0 } {
    set ungroup_threshold $::env(MAX_UNGROUP_SIZE)
    puts "Ungroup modules of size $ungroup_threshold"
  }
  hierarchy -check -top $::env(DESIGN_NAME)
  set fptr [open $::env(REPORTS_DIR)/synth_hier_stat.txt r]
  set contents [read -nonewline $fptr]
  close $fptr
  set split_cont [split $contents "\n"]
  set hierarchy_section 0
  set module_list {}
  foreach line $split_cont {
    if {[regexp {=== design hierarchy ===} $line]} {
      set hierarchy_section 1
      continue
    }
    if {[regexp {   Number of wires.*} $line ]} {
      set hierarchy_section 0
      continue
    }
    if { $hierarchy_section == 1 } {
      if {[regexp { +(\S+) +.*} $line -> module_name]} {
        lappend module_list $module_name
        puts "Found module $module_name"
      }
    }
  }
  set out_script_ptr [open $::env(SYNTH_STOP_MODULE_SCRIPT) w]
  puts $out_script_ptr "hierarchy -check -top $::env(DESIGN_NAME)"
  foreach module $module_list {
    tee -o $::env(REPORTS_DIR)/synth_hier_stat_temp_module.txt stat -top "$module" {*}$stat_libs
    set fptr1 [open $::env(REPORTS_DIR)/synth_hier_stat_temp_module.txt r]
    set contents1 [read -nonewline $fptr1]
    close $fptr1
    set split_cont1 [split $contents1 "\n"]
    foreach line $split_cont1 {
      if {[regexp { +Chip area for top module '(\S+)': (.*)} $line -> module_name area]} {
        if {[expr $area > $ungroup_threshold]} {
            puts "Preserving module: $module_name (area: $area)"
            puts $out_script_ptr "select -module {$module_name}"
            puts $out_script_ptr "setattr -mod -set keep_hierarchy 1"
            puts $out_script_ptr "select -clear"
        } else {
          puts "Flattening module $module_name (area: $area)"
        }
      }
    }
    file delete -force $::env(REPORTS_DIR)/synth_hier_stat_temp_module.txt
  }
  close $out_script_ptr
}

write_keep_hierarchy
