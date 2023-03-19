source $::env(SCRIPTS_DIR)/synth_preamble.tcl

set constr [open $::env(OBJECTS_DIR)/abc.constr w]
puts $constr "set_driving_cell $::env(ABC_DRIVER_CELL)"
puts $constr "set_load $::env(ABC_LOAD_IN_FF)"
close $constr

# Hierarchical synthesis
synth  -top $::env(DESIGN_NAME)
if { [info exist ::env(ADDER_MAP_FILE)] && [file isfile $::env(ADDER_MAP_FILE)] } {
  techmap -map $::env(ADDER_MAP_FILE)
}
techmap
if {[info exist ::env(DFF_LIB_FILE)]} {
  dfflibmap -liberty $::env(DFF_LIB_FILE)
} else {
  dfflibmap -liberty $::env(DONT_USE_SC_LIB)
}
abc -liberty $::env(DONT_USE_SC_LIB) \
    -constr $::env(OBJECTS_DIR)/abc.constr

# Create argument list for stat
set stat_libs ""
foreach lib $::env(DONT_USE_LIBS) {
  append stat_libs "-liberty $lib "
}
tee -o $::env(REPORTS_DIR)/synth_hier_stat.txt stat {*}$stat_libs

if { [info exist ::env(REPORTS_DIR)] && [file isfile $::env(REPORTS_DIR)/synth_hier_stat.txt] } {
  set ungroup_threshold 0
  if { [info exist ::env(MAX_UNGROUP_SIZE)] && $::env(MAX_UNGROUP_SIZE) > 0 } {
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
  set out_script_ptr [open $::env(OBJECTS_DIR)/mark_hier_stop_modules.tcl w]
  puts $out_script_ptr "hierarchy -check -top $::env(DESIGN_NAME)"
  foreach module $module_list {
    tee -o $::env(REPORTS_DIR)/synth_hier_stat_temp_module.txt stat -top "$module" {*}$stat_libs
    set fptr1 [open $::env(REPORTS_DIR)/synth_hier_stat_temp_module.txt r]
    set contents1 [read -nonewline $fptr1]
    close $fptr1
    set split_cont1 [split $contents1 "\n"]
    foreach line $split_cont1 {
      if {[regexp { +Chip area for top module '(\S+)': (.*)} $line -> module_name area]} {
        puts "Area of module $module_name is $area"
        if {[expr $area > $ungroup_threshold]} {
           puts "Preserving hierarchical module: $module_name"
           puts $out_script_ptr "select -module {$module_name}"
           puts $out_script_ptr "setattr -mod -set keep_hierarchy 1"
           puts $out_script_ptr "select -clear"
        }
      }
    }
    file delete -force $::env(REPORTS_DIR)/synth_hier_stat_temp_module.txt
  }
  close $out_script_ptr
}

