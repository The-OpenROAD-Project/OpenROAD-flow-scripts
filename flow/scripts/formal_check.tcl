proc check_kepler_formal { } {
  if {
    ![info exists ::env(KEPLER_FORMAL_EXE)]
    || ![file executable $::env(KEPLER_FORMAL_EXE)]
  } {
    error "Kepler Formal not found. Install Kepler Formal or set KEPLER_FORMAL_EXE."
  }
}

proc lec_check_enabled { } {
  if { ![env_var_equals LEC_CHECK 1] } {
    return 0
  }
  check_kepler_formal
  return 1
}

proc write_lec_verilog { filename } {
  set remove_cells [find_physical_only_masters]
  if { [env_var_exists_and_non_empty REMOVE_CELLS_FOR_LEC] } {
    lappend remove_cells {*}$::env(REMOVE_CELLS_FOR_LEC)
  }
  set out_file $::env(RESULTS_DIR)/$filename
  write_verilog -remove_cells $remove_cells $out_file

  # Add auxiliary Verilog files (e.g., blackbox stubs) for LEC
  if { [env_var_exists_and_non_empty LEC_AUX_VERILOG_FILES] } {
    set out [open $out_file a]
    foreach aux_file $::env(LEC_AUX_VERILOG_FILES) {
      if { ![file exists $aux_file] } {
        close $out
        error "LEC auxiliary Verilog file not found: $aux_file"
      }
      puts $out "\n// ORFS auxiliary Verilog for Kepler LEC: $aux_file"
      set in [open $aux_file r]
      fcopy $in $out
      close $in
      puts $out ""
    }
    close $out
  }
}

proc write_lec_script { step file1 file2 } {
  # Exclude select Liberty files from being passed to kepler-formal
  if { [env_var_exists_and_non_empty REMOVE_LIBS_FOR_LEC] } {
    foreach lib_to_remove $::env(REMOVE_LIBS_FOR_LEC) {
      set remove_libs_set($lib_to_remove) 1
    }
    set lib_list [lmap item $::env(LIB_FILES) {
      if { [info exists remove_libs_set($item)] } { continue }
      set item
    }]
  } else {
    set lib_list $::env(LIB_FILES)
  }
  set outfile [open "$::env(OBJECTS_DIR)/${step}_lec_test.yml" w]
  puts $outfile "format: verilog"
  puts $outfile "input_paths:"
  puts $outfile "  - $::env(RESULTS_DIR)/${file1}"
  puts $outfile "  - $::env(RESULTS_DIR)/${file2}"
  puts $outfile "liberty_files:"
  foreach libFile $lib_list {
    puts $outfile " - $libFile"
  }
  puts $outfile "log_file: $::env(LOG_DIR)/${step}_lec_check.log"
  close $outfile
}

# Hardened sub-blocks (BLOCKS) enter the parent netlist as timing-only
# abstracts with no logic model, so a formal check would treat every output
# cone that reaches one as opaque. Return the instance paths of all block
# instances in the loaded design; both netlists come from the same run, so the
# same path exists in both and each instance can be paired with itself.
# Escapes every unescaped `/` in an instance name as `\/`, the OpenSTA SDC
# convention kepler-formal reads: `/` separates hierarchy levels and `\/` is a
# literal slash inside one name. Existing escapes are kept as they are.
proc formal_escape_slashes { name } {
  set escaped ""
  set length [string length $name]
  for { set i 0 } { $i < $length } { incr i } {
    set ch [string index $name $i]
    if { $ch eq "\\" } {
      incr i
      append escaped "\\" [string index $name $i]
    } elseif { $ch eq "/" } {
      append escaped "\\/"
    } else {
      append escaped $ch
    }
  }
  return $escaped
}

# Mirrors dbNetwork::stripParentPrefix: in a hierarchical database write_verilog
# names a leaf by what follows the last unescaped `/` of its database name.
proc formal_strip_parent_prefix { name } {
  set pos [string last "/" $name]
  while { $pos >= 0 } {
    if { $pos == 0 || [string index $name [expr { $pos - 1 }]] ne "\\" } {
      return [string range $name [expr { $pos + 1 }] end]
    }
    set pos [string last "/" $name [expr { $pos - 2 }]]
  }
  return $name
}

# Boundary path of a block instance exactly as write_verilog names it: in a flat
# database the whole instance name is one leaf (`\u0/r0 ` in Verilog, so the
# path is `u0\/r0`); in a hierarchical database the leaf keeps its module
# instance path and loses the parent prefix. Paths are never reinterpreted.
proc formal_boundary_path { inst } {
  set name [$inst getName]
  set prefix ""
  if { [[ord::get_db] hasHierarchy] } {
    set mod_inst [[$inst getModule] getModInst]
    if { $mod_inst != "NULL" } {
      set prefix "[$mod_inst getHierarchicalName]/"
    }
    set name [formal_strip_parent_prefix $name]
  }
  return "$prefix[formal_escape_slashes $name]"
}

proc formal_block_instance_paths { } {
  set paths {}
  if { ![env_var_exists_and_non_empty BLOCKS] } {
    return $paths
  }
  set block [ord::get_db_block]
  foreach inst [$block getInsts] {
    set master [[$inst getMaster] getName]
    if { [lsearch -exact $::env(BLOCKS) $master] >= 0 } {
      lappend paths [formal_boundary_path $inst]
    }
  }
  return [lsort $paths]
}

proc formal_yaml_quote { text } {
  return "\"[string map {\\ \\\\ \" \\\"} $text]\""
}

proc write_sec_script { step file1 file2 } {
  set outfile [open "$::env(OBJECTS_DIR)/${step}_sec_test.yml" w]
  puts $outfile "format: verilog"
  puts $outfile "verification: sec"
  puts $outfile "sec_engine: pdr"
  puts $outfile "input_paths:"
  puts $outfile "  - $::env(RESULTS_DIR)/${file1}"
  puts $outfile "  - $::env(RESULTS_DIR)/${file2}"
  puts $outfile "liberty_files:"
  foreach libFile $::env(LIB_FILES) {
    puts $outfile " - $libFile"
  }
  # Each block instance becomes a proof boundary: its input pins are compared
  # across the two netlists and its output pins are shared free inputs, so the
  # block is checked as a black box instead of hiding the cones behind it.
  set boundaries [formal_block_instance_paths]
  if { [llength $boundaries] > 0 } {
    puts $outfile "set_as_boundary:"
    foreach path $boundaries {
      set quoted [formal_yaml_quote $path]
      puts $outfile "  - \[$quoted, $quoted\]"
    }
  }
  puts $outfile "log_file: $::env(LOG_DIR)/${step}_sec_check.log"
  close $outfile
}

proc formal_check_label { step } {
  if { [string equal $step 4_rsz] } {
    return "Repair timing output"
  }
  return "Global output"
}

proc run_lec_test { step file1 file2 } {
  check_kepler_formal
  write_lec_script $step $file1 $file2
  # tclint-disable-next-line command-args
  eval exec $::env(KEPLER_FORMAL_EXE) --config $::env(OBJECTS_DIR)/${step}_lec_test.yml
  try {
    set count [exec grep -c "Found difference" $::env(LOG_DIR)/${step}_lec_check.log]
  } trap CHILDSTATUS {results options} {
    # This block executes if grep returns a non-zero exit code
    set count 0
  }
  set label [formal_check_label $step]
  if { $count > 0 } {
    error "$label failed lec test"
  } else {
    puts "$label passed lec test"
  }
}

proc run_sec_test { step file1 file2 } {
  check_kepler_formal
  write_sec_script $step $file1 $file2
  # tclint-disable-next-line command-args
  eval exec $::env(KEPLER_FORMAL_EXE) --config $::env(OBJECTS_DIR)/${step}_sec_test.yml
  try {
    set count [exec grep -c "SEC found a counterexample" $::env(LOG_DIR)/${step}_sec_check.log]
  } trap CHILDSTATUS {results options} {
    # This block executes if grep returns a non-zero exit code
    set count 0
  }
  if { $count > 0 } {
    error "Global output failed sec test"
  } else {
    puts "Global output passed sec test"
  }
}
