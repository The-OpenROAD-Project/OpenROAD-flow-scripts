# Gather statistics, if needed. Gathering the statistics is
# time consuming, because it requires a full synthesis run.
#
# The statistics is needed for SYNTH_HIERARCHICAL=1 flattening/keep
# module policy, and write to $::env(SYNTH_STATS)
source $::env(SCRIPTS_DIR)/util.tcl

proc write_keep_hierarchy {} {
  if { ![env_var_equals SYNTH_HIERARCHICAL 1] } {
    set out_script_ptr [open $::env(SYNTH_STATS) w]
    close $out_script_ptr
    return
  }

  source $::env(SCRIPTS_DIR)/synth_preamble.tcl

  synthesize_check mem_hierarchical {}

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

  set areas {}
  foreach module $module_list {
    tee -o $::env(OBJECTS_DIR)/synth_stat_temp_module.txt stat -top "$module" {*}$stat_libs
    set fptr1 [open $::env(OBJECTS_DIR)/synth_stat_temp_module.txt r]
    set contents1 [read -nonewline $fptr1]
    close $fptr1
    set split_cont1 [split $contents1 "\n"]
    foreach line $split_cont1 {
      if {[regexp { +Chip area for top module '(\S+)': (.*)} $line -> module_name area]} {
        lappend areas "$area $module_name"
      }
    }
    file delete -force $::env(OBJECTS_DIR)/synth_stat_temp_module.txt
  }
  set areas [lsort -index 0 -real $areas]

  set out_script_ptr [open $::env(SYNTH_STATS) w]
  foreach {line} $areas {
    puts $out_script_ptr $line
  }
  close $out_script_ptr
}

write_keep_hierarchy
