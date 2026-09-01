# KPI extraction instrument, vendored verbatim (modulo formatting) from
# the public bazel-orfs `macro-selector` branch,
# test/estimation_ladder/extract_lib.tcl.
#
# The archived swerv_wrapper reference numbers in
# score_vs_flow_swerv.json were measured with this exact sampling logic.
# A study that compares spreads across ensembles is only as good as the
# identity of its measurement, so this file must not be "improved" here:
# any change to it invalidates the comparison against those numbers.

# Record a path once, tagged with whether it touches a macro pin.
# Returns 1 if the path was new, 0 if it was a duplicate.
proc extract_add_path { sel_var seen_var clk_period path is_macro } {
  upvar 1 $sel_var selected $seen_var seen
  set sp [get_full_name [get_property $path startpoint]]
  set ep [get_full_name [get_property $path endpoint]]
  if { [dict exists $seen "$sp|$ep"] } { return 0 }
  dict set seen "$sp|$ep" 1
  set slack [get_property $path slack]
  set period [expr { $clk_period - $slack }]
  lappend selected [list $sp $ep $period $is_macro]
  return 1
}

# Macro pins as OpenSTA names them.  ODB escapes Verilog identifiers and
# OpenSTA does not, so the escapes have to come out or nothing matches.
proc extract_macro_pin_names { } {
  set blk [ord::get_db_block]
  set outs {}
  set ins {}
  foreach inst [$blk getInsts] {
    if { ![[$inst getMaster] isBlock] } { continue }
    set iname [string map {"\\" ""} [$inst getName]]
    foreach it [$inst getITerms] {
      if { [$it getSigType] ne "SIGNAL" } { continue }
      set pin "$iname/[[$it getMTerm] getName]"
      if { [$it getIoType] eq "OUTPUT" } {
        lappend outs $pin
      } else {
        lappend ins $pin
      }
    }
  }
  return [list $outs $ins]
}

# Sample the worst 25% of the min_period range plus the macro paths,
# de-duplicated by endpoint pair.  Requires the design in memory with
# parasitics already estimated.  Returns a dict:
#   clock_period   the period read back from STA (so a perturbed clock
#                  is reported as perturbed -- the nudge-landed guard)
#   wns            worst reg2reg slack
#   paths          list of {start end min_period is_macro}
proc extract_sample_paths { } {
  # The reg2reg path group is defined by the platform SDC. Note that a
  # "register" can be a macro, not just a flip-flop.
  set wns_path [find_timing_paths -path_group reg2reg -sort_by_slack \
    -group_path_count 1]
  if { [llength $wns_path] == 0 } {
    error "No reg2reg timing paths found!"
  }
  set wns [get_property [lindex $wns_path 0] slack]
  set clk_period [get_property [lindex [get_clocks] 0] period]

  puts "WNS: $wns, Clock Period: $clk_period"

  # Sample the worst 25% of the min_period range. min_period =
  # clk_period - slack, so the window [0.75 * max_period, max_period]
  # maps to slacks in [wns, wns + 0.25 * max_period].
  set max_period [expr { $clk_period - $wns }]
  set num_buckets 10
  set paths_per_bucket 10
  set step [expr { 0.25 * $max_period / $num_buckets }]
  set selected {}
  set seen [dict create]

  for { set i 0 } { $i < $num_buckets } { incr i } {
    set b_min [expr { $wns + ($i * $step) }]
    set b_max [expr { $wns + (($i + 1) * $step) }]

    set paths [find_timing_paths -path_group reg2reg \
      -slack_min $b_min -slack_max $b_max \
      -sort_by_slack -group_path_count $paths_per_bucket]
    foreach path $paths {
      extract_add_path selected seen $clk_period $path 0
    }
  }

  # The general spread above is worst-slack driven, and on a design that
  # is an array of macros it turns out to contain almost no macro pins
  # at all -- two paths in ninety-nine.  That characterises the design by
  # its top-level flop-to-flop logic and leaves the very thing the
  # design exists to exercise unmeasured, so sample the macro paths
  # explicitly as well and tag them, rather than hoping they fall out of
  # a slack ranking.
  lassign [extract_macro_pin_names] macro_outs macro_ins
  # Enough macro paths to support a study of their own rather than a tag
  # on a handful: they are a separate population with their own error
  # structure, and twenty-eight is too few to rank or fit anything on.
  set macro_target 80
  set macro_added 0
  puts "Macro pins: [llength $macro_outs] outputs, [llength $macro_ins] inputs"

  foreach {dir pins} [list -from $macro_outs -to $macro_ins] {
    if { [llength $pins] == 0 } { continue }
    if {
      [catch {
        set paths [find_timing_paths $dir $pins -path_group reg2reg \
          -sort_by_slack -group_path_count $macro_target]
      } err]
    } {
      puts "WARNING: macro path query $dir failed: $err"
      continue
    }
    foreach path $paths {
      incr macro_added [extract_add_path selected seen $clk_period $path 1]
    }
  }
  puts "Sampled $macro_added macro paths in addition to the general spread."

  if { [llength $selected] < 20 } {
    error "Found only [llength $selected] unique reg2reg paths in the\
            worst-25% window. Design is too trivial."
  }
  set n_macro 0
  foreach pt $selected { incr n_macro [lindex $pt 3] }
  puts "Sampled [llength $selected] reg2reg paths ($n_macro touching a macro pin)."

  return [dict create clock_period $clk_period wns $wns paths $selected]
}

# Area from the ODB rather than report_design_area's printed line, so the
# number is a value and not a regex.  Split std cell vs macro: the macros
# never change across a variance ensemble, while the repair stages buy
# timing with std-cell area -- which is exactly the trade a period-only
# KPI cannot see.
proc extract_design_area { } {
  set blk [ord::get_db_block]
  set dbu [$blk getDbUnitsPerMicron]
  set scale [expr { double($dbu) * double($dbu) }]
  set stdcell_um2 0.0
  set macro_um2 0.0
  set n_stdcell 0
  set n_macro 0
  foreach inst [$blk getInsts] {
    set master [$inst getMaster]
    set a [expr { [$master getWidth] * double([$master getHeight]) / $scale }]
    if { [$master isBlock] } {
      set macro_um2 [expr { $macro_um2 + $a }]
      incr n_macro
    } elseif { [$master isCore] } {
      set stdcell_um2 [expr { $stdcell_um2 + $a }]
      incr n_stdcell
    }
  }
  return [dict create \
    stdcell_um2 $stdcell_um2 \
    macro_um2 $macro_um2 \
    num_stdcells $n_stdcell \
    num_macros $n_macro]
}

# The "paths" JSON fragment shared by extract.tcl and the walk's leaves:
# same schema, so achieved() and every other consumer reads both.
proc extract_paths_json { paths } {
  set lines {}
  foreach pt $paths {
    lappend lines "  {\"start\": \"[lindex $pt 0]\", \"end\":\
\"[lindex $pt 1]\", \"min_period\": [lindex $pt 2], \"macro_path\":\
[lindex $pt 3]}"
  }
  return "\[\n[join $lines ",\n"]\n\]"
}

# The area/power JSON fragment.  Power is recorded equal to the std-cell
# area for now: the PPA KPI is three-dimensional, but a credible power
# number needs switching activity the flow does not have at grt.
# TODO(power): replace with a real power figure (e.g. report_power under
# a stated activity assumption) once the study needs it.
proc extract_ppa_json { area } {
  return "\"area\": {\"stdcell_um2\": [dict get $area stdcell_um2],\
 \"macro_um2\": [dict get $area macro_um2],\
 \"num_stdcells\": [dict get $area num_stdcells],\
 \"num_macros\": [dict get $area num_macros]},\n\"power_todo\":\
 [dict get $area stdcell_um2]"
}
