proc lec_check_enabled { } {
  return [expr {
    [env_var_equals LEC_CHECK 1]
    && [info exists ::env(KEPLER_FORMAL_EXE)]
    && [file executable $::env(KEPLER_FORMAL_EXE)]
  }]
}

# Synthesis (RTL vs netlist) LEC is a separate opt-in: the RTL side needs
# kepler-formal's experimental SystemVerilog frontend, which does not yet
# support all RTL constructs, so it must not ride LEC_CHECK's
# auto-enable-when-installed behavior (flow/settings.mk).
proc synth_lec_check_enabled { } {
  return [expr {
    [env_var_equals SYNTH_LEC_CHECK 1]
    && [info exists ::env(KEPLER_FORMAL_EXE)]
    && [file executable $::env(KEPLER_FORMAL_EXE)]
  }]
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
  set outfile [open "$::env(OBJECTS_DIR)/${step}_lec_test.yml" w]
  puts $outfile "format: verilog"
  puts $outfile "input_paths:"
  puts $outfile "  - $::env(RESULTS_DIR)/${file1}"
  puts $outfile "  - $::env(RESULTS_DIR)/${file2}"
  puts $outfile "liberty_files:"
  foreach libFile $::env(LIB_FILES) {
    puts $outfile " - $libFile"
  }
  puts $outfile "log_file: $::env(LOG_DIR)/${step}_lec_check.log"
  close $outfile
}

# Run kepler-formal on a previously written ${step}_lec_test.yml and
# fail with a message naming `what` if the log reports a difference.
proc run_lec_config { step what } {
  # tclint-disable-next-line command-args
  eval exec $::env(KEPLER_FORMAL_EXE) --config $::env(OBJECTS_DIR)/${step}_lec_test.yml
  try {
    set count [exec grep -c "Found difference" $::env(LOG_DIR)/${step}_lec_check.log]
  } trap CHILDSTATUS {results options} {
    # This block executes if grep returns a non-zero exit code
    set count 0
  }
  if { $count > 0 } {
    error "$what failed lec test"
  } else {
    puts "$what passed lec test"
  }
}

proc run_lec_test { step file1 file2 } {
  write_lec_script $step $file1 $file2
  run_lec_config $step "Repair timing output"
}

# Write a slang command file describing the design RTL exactly as
# synth_syn.tcl elaborates it, so kepler-formal's SystemVerilog frontend
# sees the same design. Not replicated (slang defaults differ):
# --compat=vcs, --ignore-assertions, --no-implicit-memories, --std;
# designs that depend on those may fail LEC for frontend reasons.
proc write_sv_rtl_flist { path } {
  set out [open $path w]
  puts $out "-D SYNTHESIS"
  if { [env_var_exists_and_non_empty VERILOG_DEFINES] } {
    # Flag/value token stream (e.g. "-D NAME"); keep on one line.
    puts $out $::env(VERILOG_DEFINES)
  }
  if { [env_var_exists_and_non_empty VERILOG_INCLUDE_DIRS] } {
    foreach dir $::env(VERILOG_INCLUDE_DIRS) {
      puts $out "+incdir+$dir"
    }
  }
  dict for {key value} [env_var_or_empty VERILOG_TOP_PARAMS] {
    puts $out "-G $key=$value"
  }
  if { [env_var_exists_and_non_empty SYNTH_SLANG_ARGS] } {
    puts $out $::env(SYNTH_SLANG_ARGS)
  }
  foreach fn $::env(VERILOG_FILES) {
    puts $out [string trim $fn]
  }
  close $out
}

# YAML config comparing the input RTL (slang frontend) against a
# gate-level netlist + liberty models.
proc write_sv_lec_script { step rtl_flist gate_flist } {
  set outfile [open "$::env(OBJECTS_DIR)/${step}_lec_test.yml" w]
  puts $outfile "format: systemverilog"
  puts $outfile "sv_design1_flist: $rtl_flist"
  puts $outfile "sv_design1_top: $::env(DESIGN_NAME)"
  puts $outfile "sv_design2_flist: $gate_flist"
  puts $outfile "sv_design2_top: $::env(DESIGN_NAME)"
  puts $outfile "liberty_files:"
  foreach libFile $::env(LIB_FILES) {
    puts $outfile " - $libFile"
  }
  puts $outfile "log_file: $::env(LOG_DIR)/${step}_lec_check.log"
  close $outfile
}

# Pre- vs post-synthesis LEC: input RTL against the 1_synth.v netlist
# written by synth_syn.tcl. Caller guards with lec_check_enabled.
proc run_synth_lec_test { } {
  set rtl_flist $::env(OBJECTS_DIR)/1_synth_rtl.f
  set gate_flist $::env(OBJECTS_DIR)/1_synth_gate.f
  write_sv_rtl_flist $rtl_flist
  set out [open $gate_flist w]
  puts $out "$::env(RESULTS_DIR)/1_synth.v"
  close $out
  write_sv_lec_script 1_synth $rtl_flist $gate_flist
  run_lec_config 1_synth "Synthesis output"
}
