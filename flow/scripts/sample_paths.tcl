# Aggregate period instrument for AUTO_FLOORPLAN candidate scoring.
#
# Ported from bazel-orfs test/estimation_ladder/extract_lib.tcl so the
# flow scores candidates with the same instrument the estimation-ladder
# study used to establish that the score ranks. Two deliberate changes
# from that copy, both about running on every design rather than on one
# hand-picked study target -- see af_sample_paths.
#
# Why an aggregate and not WNS: the achieved period is a max, and a max
# is dominated by one path that repair_timing will usually rescue. On the
# mean of the sampled worst-25% paths, good and deliberately scrambled
# placements separate cleanly; on WNS they overlap. Scoring a floorplan
# candidate on WNS scores noise.

# Record a path once, tagged with whether it touches a macro pin.
# Returns 1 if the path was new, 0 if it was a duplicate.
proc af_add_path { sel_var seen_var clk_period path is_macro } {
  upvar 1 $sel_var selected $seen_var seen
  set sp [get_full_name [get_property $path startpoint]]
  set ep [get_full_name [get_property $path endpoint]]
  if { [dict exists $seen "$sp|$ep"] } {
    return 0
  }
  dict set seen "$sp|$ep" 1
  set slack [get_property $path slack]
  set period [expr { $clk_period - $slack }]
  lappend selected [list $sp $ep $period $is_macro]
  return 1
}

# Macro pins as OpenSTA names them. ODB escapes Verilog identifiers and
# OpenSTA does not, so the escapes have to come out or nothing matches.
proc af_macro_pin_names { } {
  set blk [ord::get_db_block]
  set outs {}
  set ins {}
  foreach inst [$blk getInsts] {
    if { ![[$inst getMaster] isBlock] } {
      continue
    }
    set iname [string map {"\\" ""} [$inst getName]]
    foreach it [$inst getITerms] {
      if { [$it getSigType] ne "SIGNAL" } {
        continue
      }
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
# de-duplicated by endpoint pair. Requires the design in memory with
# parasitics already estimated.
#
# Returns a dict: clock_period, wns, paths {start end min_period
# is_macro}, n_paths, and `degraded` -- 1 when the design yielded too few
# unique paths for the aggregate to mean anything.
#
# Change from the bazel-orfs original #1: it raises "Design is too
# trivial" below 20 paths. That is right for a study that picked its
# target; here the same code has to run on gcd (476 cells) as well as on
# cva6, and a hard error would make AUTO_FLOORPLAN unusable on exactly
# the designs that are cheapest to race. Below the threshold we report
# degraded and let the caller fall back to WNS, which on a design that
# small is not meaningfully worse -- there are few enough paths that the
# max and the mean are nearly the same statistic.
#
# Change #2: no reg2reg path group is guaranteed to exist on every
# platform's SDC, so its absence is a degraded result, not an error.
proc af_sample_paths { { min_paths 20 } } {
  set wns_path [find_timing_paths -path_group reg2reg -sort_by_slack \
    -group_path_count 1]
  if { [llength $wns_path] == 0 } {
    return [dict create degraded 1 reason "no reg2reg paths" \
      clock_period 0 wns 0 paths {} n_paths 0]
  }
  set wns [get_property [lindex $wns_path 0] slack]
  set clks [get_clocks]
  if { [llength $clks] == 0 } {
    return [dict create degraded 1 reason "no clocks" \
      clock_period 0 wns $wns paths {} n_paths 0]
  }
  set clk_period [get_property [lindex $clks 0] period]

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
    if {
      [catch {
        set paths [find_timing_paths -path_group reg2reg \
          -slack_min $b_min -slack_max $b_max \
          -sort_by_slack -group_path_count $paths_per_bucket]
      }]
    } {
      continue
    }
    foreach path $paths {
      af_add_path selected seen $clk_period $path 0
    }
  }

  # A worst-slack spread over an array of macros turns out to contain
  # almost no macro pins at all, which characterises the design by its
  # top-level flop-to-flop logic and leaves the thing the design exists
  # to exercise unmeasured. Sample macro paths explicitly and tag them
  # rather than hoping they fall out of a slack ranking.
  lassign [af_macro_pin_names] macro_outs macro_ins
  set macro_target 80
  set macro_added 0
  foreach { dir pins } [list -from $macro_outs -to $macro_ins] {
    if { [llength $pins] == 0 } {
      continue
    }
    if {
      [catch {
        set paths [find_timing_paths $dir $pins -path_group reg2reg \
          -sort_by_slack -group_path_count $macro_target]
      } err]
    } {
      puts "AUTO_FLOORPLAN: macro path query $dir failed: $err"
      continue
    }
    foreach path $paths {
      incr macro_added [af_add_path selected seen $clk_period $path 1]
    }
  }

  set n [llength $selected]
  set degraded [expr { $n < $min_paths }]
  set n_macro 0
  foreach pt $selected {
    incr n_macro [lindex $pt 3]
  }
  puts "AUTO_FLOORPLAN: sampled $n reg2reg paths ($n_macro macro,\
$macro_added added explicitly), wns $wns, period $clk_period"
  if { $degraded } {
    puts "AUTO_FLOORPLAN: only $n unique paths (< $min_paths);\
scoring falls back to WNS"
  }

  return [dict create degraded $degraded reason "" \
    clock_period $clk_period wns $wns paths $selected n_paths $n]
}

# The scalar the race minimises: the mean min_period over the sampled
# non-macro paths, in the design's own time unit. Falls back to the
# achieved period (clock_period - wns) when the sample is degraded, so a
# caller always gets a comparable number and the evidence file records
# which one it was.
proc af_score_from_paths { sampled } {
  if { [dict get $sampled degraded] } {
    return [expr { [dict get $sampled clock_period] - [dict get $sampled wns] }]
  }
  set sum 0.0
  set n 0
  foreach pt [dict get $sampled paths] {
    if { [lindex $pt 3] } {
      continue
    }
    set sum [expr { $sum + [lindex $pt 2] }]
    incr n
  }
  if { $n == 0 } {
    # Every sampled path touched a macro: score on those instead of
    # returning a meaningless zero.
    foreach pt [dict get $sampled paths] {
      set sum [expr { $sum + [lindex $pt 2] }]
      incr n
    }
  }
  if { $n == 0 } {
    return [expr { [dict get $sampled clock_period] - [dict get $sampled wns] }]
  }
  return [expr { $sum / $n }]
}

# Mean min_period over the macro-tagged paths, or -1 when there are none.
# Reported as a diagnostic next to the score: on a macro design this is
# where a floorplan change shows up first.
proc af_macro_score_from_paths { sampled } {
  set sum 0.0
  set n 0
  foreach pt [dict get $sampled paths] {
    if { ![lindex $pt 3] } {
      continue
    }
    set sum [expr { $sum + [lindex $pt 2] }]
    incr n
  }
  if { $n == 0 } {
    return -1
  }
  return [expr { $sum / $n }]
}

# Area from the ODB rather than report_design_area's printed line, so the
# number is a value and not a regex. Split std cell vs macro: macros do
# not change across candidates, while repair buys timing with std-cell
# area -- exactly the trade a period-only KPI cannot see.
proc af_design_area { } {
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
  set core [$blk getCoreArea]
  set core_um2 [expr { [$core dx] * double([$core dy]) / $scale }]
  return [dict create \
    stdcell_um2 $stdcell_um2 \
    macro_um2 $macro_um2 \
    core_um2 $core_um2 \
    num_stdcells $n_stdcell \
    num_macros $n_macro]
}
