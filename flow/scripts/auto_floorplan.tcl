# AUTO_FLOORPLAN driver: measure the floorplan shape instead of reading it.
#
# Sourced from floorplan.tcl before the init-method selection, with the
# synthesised design already loaded. Races candidate outlines and
# densities in parallel subprocesses, picks a winner, and overwrites the
# floorplan variables in ::env so the ordinary stage code downstream runs
# at the measured coordinates.
#
# WHY THIS EXISTS
#
# CORE_UTILIZATION, CORE_ASPECT_RATIO and PLACE_DENSITY (or its
# PLACE_DENSITY_LB_ADDON form) are the last hand-carried numbers in a
# config.mk. Each is a human prediction of downstream behaviour standing
# where a measurement should be: the right utilization is "the smallest
# core in which this netlist still closes", which is a question about
# repair_design, CTS and routing -- none of which have happened when the
# number is read. ORFS already computes the honest half of the density
# answer (place_density_with_lb_addon's measured lower bound) and then
# adds a guessed margin on top.
#
# THE OVERFITTING PROBLEM, AND WHAT GUARDS AGAINST IT
#
# Racing hard on a cheap pre-route proxy overfits: the winner scores well
# before routing and then produces DRC errors or a repair explosion. So
# the selection rule is deliberately not "minimise the score":
#
#   1. Feasibility guards are hard filters, not score terms. A candidate
#      that fails to produce a placement, or whose post-placement
#      utilization exceeds AF_MAX_UTIL_POST, is eliminated outright. No
#      score buys past a guard.
#   2. Among survivors, minimise the aggregate period KPI -- the mean of
#      the sampled worst-quartile paths, never WNS. A max is dominated by
#      one path repair usually rescues; the aggregate is what transmits.
#   3. Ties break toward headroom. Candidates within delta_tie of the
#      best are interchangeable, so take the loosest of them: lowest
#      density, then largest core. When the measurement cannot separate
#      two candidates, take the one with more room for the repair, CTS
#      and hold-fixing growth the proxy never saw.
#
# Rule 3 is the anti-overfit rule and it is why this is not a search.
#
# SEARCH SHAPE
#
# Coordinate descent, not a grid: utilization, then density, then aspect,
# each at the previous winner. A full cross product of the three ladders
# is 75 candidates; this is ~14. The cost is that interactions between
# the coordinates are not explored -- a genuine limitation, recorded in
# the evidence file rather than papered over. The incumbent config.mk
# values are always candidate 0, so a design whose folklore was already
# good keeps it.
#
# All ladders are dimensionless fractions. There is no per-design
# constant anywhere in this file.

source $::env(SCRIPTS_DIR)/sample_paths.tcl

proc af_env { name { default "" } } {
  if { [info exists ::env($name)] && $::env($name) ne "" } {
    return $::env($name)
  }
  return $default
}

# Fractions of the incumbent utilization to try. Above 1.0 is a smaller
# core (utilization is cells/core, so higher is denser); one point below
# is kept as a control, so the walk can report that loosening was better
# rather than only ever being able to tighten.
set ::af_util_ladder {0.9 1.0 1.1 1.2 1.3 1.4}

# Fractions of the available headroom above the measured density lower
# bound. This is exactly what PLACE_DENSITY_LB_ADDON means today; the
# ladder makes it measured instead of guessed.
set ::af_addon_ladder {0.00 0.05 0.10 0.15 0.20}

# Aspect ratios (height/width) to try at the winning area point.
set ::af_aspect_ladder {0.8 1.0 1.25}

# Feasibility guard: post-placement utilization above this is treated as
# not placeable rather than as a cheap floorplan.
set ::af_max_util_post [af_env AF_MAX_UTIL_POST 0.98]

# Placer seeds used to measure this design's own noise floor.
set ::af_tie_seeds {1 2 3}

proc af_log { msg } {
  puts "AUTO_FLOORPLAN: $msg"
}

# Run a batch of candidates as parallel subprocesses, bounded by
# AF_JOBS. Each element of `cands` is a dict with util/aspect/margin/
# addon/seed/tag. Returns a list of result dicts for the ones that
# produced a parseable result.
proc af_run_batch { cands work } {
  set jobs [af_env AF_JOBS ""]
  if { $jobs eq "" } {
    set jobs [af_env NUM_CORES 8]
    # Candidates are single-threaded; leave a little room rather than
    # launching exactly nproc heavy OpenROAD processes.
    if { $jobs > 8 } {
      set jobs [expr { $jobs / 2 }]
    }
  }
  af_log "running [llength $cands] candidates, $jobs at a time"

  set pending $cands
  set running {}
  set results {}

  while { [llength $pending] > 0 || [llength $running] > 0 } {
    while { [llength $pending] > 0 && [llength $running] < $jobs } {
      set c [lindex $pending 0]
      set pending [lrange $pending 1 end]
      set tag [dict get $c tag]
      set cwork [file join $work $tag]
      set result [file join $work "$tag.json"]
      set done [file join $work "$tag.done"]
      file delete -force $result $done

      set env_pairs [list \
        AF_UTIL [dict get $c util] \
        AF_ASPECT [dict get $c aspect] \
        AF_MARGIN [dict get $c margin] \
        AF_ADDON [dict get $c addon] \
        AF_SEED [dict get $c seed] \
        AF_WORK $cwork \
        AF_RESULT $result \
        AF_SRC_RESULTS $::env(RESULTS_DIR)]

      # A wrapper shell so a crashed or non-zero candidate still records
      # a status: the driver must be able to tell "eliminated" from
      # "still running" without a timeout heuristic.
      set assigns {}
      foreach { k v } $env_pairs {
        lappend assigns "$k=[af_shell_quote $v]"
      }
      set cmd "[join $assigns { }] \
[af_shell_quote $::env(OPENROAD_EXE)] -no_init -exit \
[af_shell_quote $::env(SCRIPTS_DIR)/auto_floorplan_candidate.tcl] \
> [af_shell_quote $work/$tag.log] 2>&1; echo \$? > [af_shell_quote $done]"
      exec sh -c $cmd &
      lappend running [list $tag $result $done]
    }

    # Poll. The candidates are minutes long, so a coarse interval costs
    # nothing and keeps this loop off the CPU.
    after 500
    set still {}
    foreach r $running {
      lassign $r tag result done
      if { ![file exists $done] } {
        lappend still $r
        continue
      }
      set fh [open $done r]
      set rc [string trim [read $fh]]
      close $fh
      if { $rc ne "0" || ![file exists $result] } {
        # The candidate's own log lives in a scratch dir that a sandboxed
        # build discards, so a bare "it failed" would be undebuggable.
        # Echo its tail into the stage log, which is a declared output.
        af_log "candidate $tag eliminated (exit $rc); last lines of its log:"
        af_log_tail [file join $work "$tag.log"] 15
        continue
      }
      set fh [open $result r]
      set json [read $fh]
      close $fh
      set d [af_parse_result $json]
      if { $d eq "" } {
        af_log "candidate $tag eliminated (unparseable result)"
        continue
      }
      dict set d tag $tag
      if { ![dict get $d ok] } {
        af_log "candidate $tag eliminated ([dict get $d reason])"
        continue
      }
      lappend results $d
    }
    set running $still
  }
  return $results
}

# Echo the last n lines of a candidate log, prefixed so it is obvious
# which process they came from.
proc af_log_tail { path n } {
  if { ![file exists $path] } {
    af_log "  (no log at $path)"
    return
  }
  set fh [open $path r]
  set lines [split [string trimright [read $fh]] "\n"]
  close $fh
  set start [expr { [llength $lines] - $n }]
  if { $start < 0 } {
    set start 0
  }
  foreach line [lrange $lines $start end] {
    puts "  | $line"
  }
}

proc af_shell_quote { s } {
  return "'[string map {' '\\''} $s]'"
}

# The candidate writes a flat one-line JSON object of numbers and short
# strings; a full parser would be a dependency for no gain.
# The candidate writes a Tcl dict literal, so reading it is just a
# validity check. Returns "" when the record is not a well-formed dict.
proc af_parse_result { text } {
  set text [string trim $text]
  if { [catch { dict size $text }] } {
    return ""
  }
  if { ![dict exists $text ok] } {
    return ""
  }
  if { ![dict exists $text reason] } {
    dict set text reason ""
  }
  return $text
}

# Area is never scored against period -- a bigger core always makes
# period easier, so any blended objective just inflates the die (or, as
# measured on gcd with the first version of this file, deflates it and
# quietly sells the period away). Area is a budget and period is the goal
# axis, so the utilization phase is constraint satisfaction, not
# minimisation: take the SMALLEST core whose score is still within
# delta_tie of the reference, and if none qualifies, keep the reference.
#
# The reference is the incumbent's own achieved score. It is the only
# period this design is known to reach, so "do not get worse than what
# you already had" is a target that exists for every design -- including
# the many that never meet their SDC period. See
# docs/user/AutoFloorplan.md on why the SDC period is not the gate.
# Did the ladder resolve anything? If the spread of scores across the
# candidates does not exceed the design's own noise floor, then every
# candidate is interchangeable with every other and the measurement has
# answered nothing. That is a legal outcome, not a failure -- but the
# honest response to it is to keep the incumbent, NOT to take the
# smallest core.
#
# This guard is load-bearing. Without it, a large delta_tie makes the
# admission test (score <= ref + delta_tie) vacuous, every candidate
# qualifies, and the rule silently degenerates into pure area
# minimisation with no period protection at all. Measured on the asap7
# sweep: ethmac's noise floor came out at 525% of its clock period and
# aes's at 31%, with ladder spreads smaller than the floor in both cases
# -- and both duly shrank their core and gave up large amounts of TNS
# for a score difference that was indistinguishable from noise.
proc af_ladder_resolves { results delta_tie } {
  if { [llength $results] < 2 } {
    return 0
  }
  set lo [dict get [lindex $results 0] score]
  set hi $lo
  foreach r $results {
    set v [dict get $r score]
    if { $v < $lo } {
      set lo $v
    }
    if { $v > $hi } {
      set hi $v
    }
  }
  return [expr { ($hi - $lo) > $delta_tie }]
}

proc af_select_smallest_within { results ref_score } {
  set best ""
  foreach r $results {
    # The tolerance here is zero: a candidate must be no worse than the
    # incumbent on the point estimate, not merely within delta_tie of it.
    # Spending the noise floor as an admission budget is what hollowed
    # this rule out on the asap7 sweep -- ibex's floor is 17% of its
    # clock period, so "within delta_tie" licensed handing over a sixth
    # of the period in exchange for area. delta_tie still decides what
    # counts as resolved and what counts as a tie; it is not a slack
    # allowance to be spent.
    if { [dict get $r score] > $ref_score } {
      continue
    }
    if { $best eq "" || [dict get $r core_um2] < [dict get $best core_um2] } {
      set best $r
    }
  }
  return $best
}

# Survivors of the feasibility guards, in the order given.
proc af_survivors { results } {
  set out {}
  foreach r $results {
    if { [dict get $r util_post] > $::af_max_util_post } {
      af_log "candidate [dict get $r tag] eliminated: post-placement\
utilization [format %.3f [dict get $r util_post]] >\
$::af_max_util_post"
      continue
    }
    lappend out $r
  }
  return $out
}

# Rule 2 + rule 3: best score, then loosest among everything tied with
# it. "Loosest" is lowest density first, largest core second -- both are
# headroom for growth the scorer did not see.
proc af_select { results delta_tie } {
  if { [llength $results] == 0 } {
    return ""
  }
  set best ""
  foreach r $results {
    if { $best eq "" || [dict get $r score] < [dict get $best score] } {
      set best $r
    }
  }
  set best_score [dict get $best score]
  set tied {}
  foreach r $results {
    if { [dict get $r score] - $best_score <= $delta_tie } {
      lappend tied $r
    }
  }
  set pick [lindex $tied 0]
  foreach r $tied {
    set dr [dict get $r density]
    set dp [dict get $pick density]
    if { $dr < $dp || ($dr == $dp && [dict get $r core_um2] > [dict get $pick core_um2]) } {
      set pick $r
    }
  }
  if { [llength $tied] > 1 } {
    af_log "[llength $tied] candidates tied within delta_tie\
[format %.4g $delta_tie]; took the loosest ([dict get $pick tag])"
  }
  return $pick
}

# Utilization the design would have used, as a percentage. Designs that
# specify DIE_AREA/CORE_AREA instead get an equivalent derived from the
# core rectangle they asked for, so every design enters the race with its
# own configuration as candidate 0 regardless of which form it used.
proc af_incumbent_util { } {
  if { [env_var_exists_and_non_empty CORE_UTILIZATION] } {
    return $::env(CORE_UTILIZATION)
  }
  if { [env_var_exists_and_non_empty CORE_AREA] } {
    lassign $::env(CORE_AREA) x1 y1 x2 y2
    set core_um2 [expr { ($x2 - $x1) * ($y2 - $y1) }]
    set blk [ord::get_db_block]
    set dbu [$blk getDbUnitsPerMicron]
    set scale [expr { double($dbu) * double($dbu) }]
    set cell_um2 0.0
    foreach inst [$blk getInsts] {
      set m [$inst getMaster]
      if { [$m isBlock] || [$m isCore] } {
        set cell_um2 [expr {
          $cell_um2 +
          [$m getWidth] * double([$m getHeight]) / $scale
        }]
      }
    }
    if { $core_um2 > 0 && $cell_um2 > 0 } {
      return [expr { 100.0 * $cell_um2 / $core_um2 }]
    }
  }
  return 50.0
}

proc af_incumbent_aspect { } {
  if { [env_var_exists_and_non_empty CORE_ASPECT_RATIO] } {
    return $::env(CORE_ASPECT_RATIO)
  }
  return 1.0
}

proc af_incumbent_margin { } {
  if { [env_var_exists_and_non_empty CORE_MARGIN] } {
    return $::env(CORE_MARGIN)
  }
  return 1.0
}

# The incumbent headroom fraction: the design's own LB_ADDON if it uses
# that form, otherwise the fraction its fixed PLACE_DENSITY sits at. The
# latter cannot be known before a floorplan exists (the lower bound needs
# core rows), so the fixed-density case enters the race by absolute
# density instead and its addon is recorded as -1.
proc af_incumbent_addon { } {
  if { [env_var_exists_and_non_empty PLACE_DENSITY_LB_ADDON] } {
    return $::env(PLACE_DENSITY_LB_ADDON)
  }
  return ""
}

proc af_cand { tag util aspect margin addon seed } {
  return [dict create tag $tag util [format %.4g $util] aspect $aspect \
    margin $margin addon $addon seed $seed]
}

# delta_tie: the design's own noise floor, measured by re-running the
# winning candidate under different placer seeds. Measured, never
# searched -- a threshold that came from anywhere else would let the
# selector be rewarded for predicting noise.
proc af_measure_delta_tie { winner work { clk 0 } } {
  set cands {}
  foreach seed [lrange $::af_tie_seeds 1 end] {
    lappend cands [af_cand "tie_s$seed" [dict get $winner util] \
      [dict get $winner aspect] [dict get $winner margin] \
      [dict get $winner addon] $seed]
  }
  set res [af_run_batch $cands $work]
  set scores [list [dict get $winner score]]
  foreach r $res {
    lappend scores [dict get $r score]
  }
  if { [llength $scores] < 2 } {
    af_log "noise floor could not be measured (n=[llength $scores]);\
treating every difference as real"
    return [list 0.0 [llength $scores]]
  }
  set lo [lindex $scores 0]
  set hi $lo
  foreach s $scores {
    if { $s < $lo } {
      set lo $s
    }
    if { $s > $hi } {
      set hi $s
    }
  }
  set spread [expr { $hi - $lo }]
  set pct_score [format %.2f [expr { 100.0 * $spread / $hi }]]
  set pct_clk [format %.2f [expr { $clk > 0 ? 100.0 * $spread / $clk : -1 }]]
  af_log "noise floor over [llength $scores] seeds: spread\
 [format %.4g $spread] (${pct_score}% of score, ${pct_clk}% of the clock\
 period). A floor that is a large fraction of the clock means this\
 design's proxy cannot resolve small period differences at all."
  return [list $spread [llength $scores]]
}

# A candidate produced by an older script may lack a field; -1 records
# "not measured" rather than silently reading as a real zero, which is
# how a stale cached action first went unnoticed here.
proc af_dict_get_or { d key default } {
  if { [dict exists $d $key] } {
    return [dict get $d $key]
  }
  return $default
}

proc af_json_num { v } {
  if { $v eq "" } {
    return "null"
  }
  if { [string is double -strict $v] } {
    return [format %.10g $v]
  }
  return $v
}

# Write the evidence: every candidate, its score, why it was eliminated
# if it was, the measured noise floor, and the winner. A verdict without
# its evidence is an assertion.
# Render one JSON object from a list of key/value pairs. Building the
# string in one piece per field keeps every value adjacent to its key,
# which a multi-line quoted string with continuations did not.
# Write one JSON object straight to a channel, field by field.
#
# Deliberately NOT built as one Tcl string and printed: constructing a
# long line with lappend + join corrupted it under OpenROAD's Tcl --
# elements came back spliced with fragments of themselves
# ("inst_after": 18704,ter": 18704,) once the record grew past a few
# hundred characters. The same code is correct under stock tclsh. Writing
# incrementally keeps every string short and sidesteps it.
proc af_json_obj_to { fh pairs } {
  puts -nonewline $fh "{"
  set first 1
  foreach { k v } $pairs {
    if { $v eq "" } {
      set v "null"
    } elseif { [string is double -strict $v] } {
      set v [format %.10g $v]
    }
    if { !$first } {
      puts -nonewline $fh ", "
    }
    set first 0
    puts -nonewline $fh "\"$k\": $v"
  }
  puts -nonewline $fh "}"
}

proc af_json_num { v } {
  if { $v eq "" } {
    return "null"
  }
  if { [string is double -strict $v] } {
    return [format %.10g $v]
  }
  return $v
}

# Write the evidence: every candidate, its score, why it was eliminated
# if it was, the measured noise floor, and the winner. A verdict without
# its evidence is an assertion.
proc af_write_evidence { path phases winner delta_tie tie_n incumbent regime } {
  set fields {
    util aspect density addon score macro_score degraded n_paths
    core_um2 util_post repair_growth inst_before inst_after
    repair_ms grt_ms total_ms
  }
  set fh [open $path w]
  puts $fh "{"
  puts $fh "  \"design\": \"$::env(DESIGN_NAME)\","
  puts $fh "  \"platform\": \"$::env(PLATFORM)\","
  puts $fh "  \"search\": \"coordinate-descent: utilization, then density, then aspect\","
  puts $fh "  \"intent\": \"design-space exploration, not tapeout sign-off\","
  puts $fh "  \"delta_tie\": [af_json_num $delta_tie],"
  puts $fh "  \"delta_tie_n\": $tie_n,"
  puts -nonewline $fh "  \"period\": "
  af_json_obj_to $fh [list \
    sdc_target [af_json_num [dict get $regime target]] \
    achieved [af_json_num [dict get $regime achieved]] \
    gap [af_json_num [dict get $regime gap]] \
    gap_in_delta_tie [af_json_num [dict get $regime gap_ties]]]
  puts $fh ","
  puts -nonewline $fh "  \"incumbent\": "
  af_json_obj_to $fh [list \
    util [af_json_num [dict get $incumbent util]] \
    aspect [af_json_num [dict get $incumbent aspect]] \
    addon [af_json_num [dict get $incumbent addon]]]
  puts $fh ","
  puts -nonewline $fh "  \"winner\": "
  if { $winner eq "" } {
    puts -nonewline $fh "null"
  } else {
    set wp [list tag "\"[dict get $winner tag]\""]
    foreach f { util aspect margin density addon score core_um2 } {
      lappend wp $f [af_dict_get_or $winner $f -1]
    }
    af_json_obj_to $fh $wp
  }
  puts $fh ","
  puts $fh "  \"candidates\": \["
  set first 1
  foreach ph $phases {
    lassign $ph name results
    foreach r $results {
      if { !$first } {
        puts $fh ","
      }
      set first 0
      set pairs [list phase "\"$name\"" tag "\"[dict get $r tag]\""]
      foreach f $fields {
        lappend pairs $f [af_dict_get_or $r $f -1]
      }
      puts -nonewline $fh "    "
      af_json_obj_to $fh $pairs
    }
  }
  puts $fh ""
  puts $fh "  \]"
  puts $fh "}"
  close $fh

  # Also echo it into the stage log. Files written to REPORTS_DIR are not
  # declared build outputs, so a sandboxed build discards them and the
  # evidence for a verdict would vanish exactly where it is most needed --
  # in CI. The stage log is a declared output, so the record survives
  # there. The AUTO_FLOORPLAN-EVIDENCE markers make it machine-extractable.
  # Echo line by line, never as one blob. Every corruption seen while
  # developing this landed just past offset 4096 -- a single puts of a
  # string larger than the channel buffer came back with fragments of
  # itself spliced in. Short writes are unaffected.
  set fh [open $path r]
  puts "AUTO_FLOORPLAN-EVIDENCE-BEGIN"
  while { [gets $fh line] >= 0 } {
    puts $line
  }
  close $fh
  puts "AUTO_FLOORPLAN-EVIDENCE-END"
}

# Entry point. Returns 1 if the floorplan variables were overridden.
proc af_run { } {
  set mode [af_env AUTO_FLOORPLAN 0]
  if { $mode eq "0" || $mode eq "" } {
    return 0
  }
  # A die that is a constraint is not a choice: a DEF-initialised
  # floorplan or an ICeWall footprint describes a package and pad ring,
  # and racing the outline underneath it would be meaningless.
  if {
    [env_var_exists_and_non_empty FLOORPLAN_DEF] ||
    [env_var_exists_and_non_empty FOOTPRINT]
  } {
    af_log "FLOORPLAN_DEF/FOOTPRINT set: the die is a constraint, not raced"
    return 0
  }
  if { $mode ne "1" } {
    utl::error FLW 25 "AUTO_FLOORPLAN=$mode is not supported yet (0 or 1)"
  }

  set work [file join $::env(OBJECTS_DIR) auto_floorplan]
  file mkdir $work

  set u0 [af_incumbent_util]
  set a0 [af_incumbent_aspect]
  set m0 [af_incumbent_margin]
  set addon0 [af_incumbent_addon]
  set incumbent [dict create util $u0 aspect $a0 addon [expr { $addon0 eq "" ? -1 : $addon0 }]]
  af_log "incumbent: utilization $u0, aspect $a0, margin $m0, addon\
[expr { $addon0 eq "" ? "(fixed PLACE_DENSITY)" : $addon0 }]"

  # The addon the utilization phase holds constant. A design with a fixed
  # PLACE_DENSITY has no incumbent headroom fraction, so the phase runs at
  # the middle rung and the density phase then measures the real one.
  set hold_addon [expr { $addon0 eq "" ? 0.10 : $addon0 }]

  # --- phase 1: utilization ---------------------------------------------
  set cands {}
  foreach f $::af_util_ladder {
    set u [expr { $u0 * $f }]
    if { $u >= 100.0 } {
      continue
    }
    lappend cands [af_cand "u[string map {. p} $f]" $u $a0 $m0 $hold_addon 1]
  }
  set r_util [af_survivors [af_run_batch $cands $work]]
  if { [llength $r_util] == 0 } {
    af_log "no utilization candidate survived; leaving config.mk values in place"
    af_write_evidence [file join $::env(REPORTS_DIR) auto_floorplan.json] \
      [list [list utilization $r_util]] "" 0.0 0 $incumbent \
      [dict create target 0 achieved 0 gap 0 gap_ties -1]
    return 0
  }
  # The noise floor has to be known before area can be traded against
  # period, so it is measured here, on the incumbent, rather than at the
  # end of the walk.
  set inc_cand ""
  foreach r $r_util {
    if { [dict get $r util] == [format %.4g $u0] } {
      set inc_cand $r
      break
    }
  }
  if { $inc_cand eq "" } {
    set inc_cand [lindex $r_util 0]
  }
  lassign [af_measure_delta_tie $inc_cand $work \
    [dict get $inc_cand clock_period]] delta_tie tie_n
  set ref_score [dict get $inc_cand score]

  # How far is this design from the period it was asked for? The gap is
  # reported in units of the design's own noise floor, so the statement
  # is dimensionless and needs no threshold to be meaningful.
  #
  # It matters because it says what the verdict below IS. A design sitting
  # a few noise floors off its SDC period is being closed, and giving up
  # period to buy area is a real cost. A design sitting hundreds of noise
  # floors off is not going to be closed by the backend at all -- that gap
  # gets fixed in the RTL -- and its period number is a gradient for
  # design-space exploration, not a sign-off margin. AUTO_FLOORPLAN is
  # documented as the exploration tool, so it does not change its rule
  # between the two; it reports which one you are in, and never trades
  # period away in either.
  set af_target [dict get $inc_cand clock_period]
  set af_achieved [expr { $af_target - [dict get $inc_cand wns] }]
  set af_gap [expr { $af_achieved - $af_target }]
  set af_gap_ties [expr { $delta_tie > 0 ? $af_gap / $delta_tie : -1 }]
  if { $af_gap <= 0 } {
    af_log "design meets its SDC period ([format %.4g $af_achieved] vs\
 [format %.4g $af_target]); period here is a sign-off margin"
  } else {
    af_log "design misses its SDC period by [format %.4g $af_gap]\
 ([format %.4g $af_achieved] vs [format %.4g $af_target]) =\
 [format %.0f $af_gap_ties] noise floors; period here is a DSE gradient,\
 not a sign-off margin"
  }

  if { ![af_ladder_resolves $r_util $delta_tie] } {
    set w $inc_cand
    af_log "utilization ladder did not resolve: its score spread is within\
 delta_tie [format %.4g $delta_tie], so every candidate is\
 interchangeable. Keeping the incumbent rather than picking on noise."
  } else {
    set w [af_select_smallest_within $r_util $ref_score]
  }
  if { $w eq "" } {
    set w $inc_cand
    af_log "no smaller core holds the incumbent's period within delta_tie;\
 keeping utilization [dict get $w util]"
  } elseif { [dict get $w util] != [dict get $inc_cand util] } {
    af_log "utilization phase: [dict get $w util] is the smallest core\
 holding period within delta_tie [format %.4g $delta_tie] ([format %.4g \
  [dict get $w core_um2]] um2 vs [format %.4g [dict get $inc_cand core_um2]]\
 um2 at the incumbent)"
  }

  # --- phase 2: density -------------------------------------------------
  set cands {}
  foreach f $::af_addon_ladder {
    lappend cands [af_cand "d[string map {. p} $f]" [dict get $w util] \
      $a0 $m0 $f 1]
  }
  set r_dens [af_survivors [af_run_batch $cands $work]]
  set w2 [af_select $r_dens 0.0]
  if { $w2 ne "" } {
    set w $w2
    af_log "density phase: addon [dict get $w addon] wins (density\
[format %.4g [dict get $w density]], score [format %.5g [dict get $w score]])"
  }

  # --- phase 3: aspect --------------------------------------------------
  set cands {}
  foreach ar $::af_aspect_ladder {
    if { $ar == $a0 } {
      continue
    }
    lappend cands [af_cand "a[string map {. p} $ar]" [dict get $w util] \
      $ar $m0 [dict get $w addon] 1]
  }
  set r_asp [af_survivors [af_run_batch $cands $work]]

  # --- selection, at the chosen area only -------------------------------
  # Deliberately NOT over $r_util as well: those candidates differ in
  # area, and picking across them by score is the blended objective this
  # design exists to avoid. Area was settled above as a budget; the
  # density and aspect candidates all sit at that budget, so scoring
  # between them is a like-for-like period comparison.
  set all [concat [list $w] $r_dens $r_asp]
  set winner [af_select $all $delta_tie]

  # Hysteresis: replace the incumbent only when the winner actually buys
  # area. Without this a design whose folklore was already right would
  # drift every time the race runs, on noise.
  if { $winner ne "" && [dict get $winner core_um2] >= [dict get $inc_cand core_um2] } {
    af_log "no candidate beats the incumbent on area; keeping it"
    set winner $inc_cand
  }

  af_write_evidence [file join $::env(REPORTS_DIR) auto_floorplan.json] \
    [list [list utilization $r_util] [list density $r_dens] [list aspect $r_asp]] \
    $winner $delta_tie $tie_n $incumbent \
    [dict create target $af_target achieved $af_achieved gap $af_gap \
      gap_ties $af_gap_ties]

  if { $winner eq "" } {
    af_log "no candidate survived; leaving config.mk values in place"
    return 0
  }

  # --- apply -------------------------------------------------------------
  # Override every form the floorplan can be specified in, so whichever
  # branch floorplan.tcl takes below sees the raced values and the
  # mutual-exclusion check still sees exactly one method.
  set ::env(CORE_UTILIZATION) [dict get $winner util]
  set ::env(CORE_ASPECT_RATIO) [dict get $winner aspect]
  set ::env(CORE_MARGIN) [dict get $winner margin]
  foreach v { DIE_AREA CORE_AREA } {
    if { [info exists ::env($v)] } {
      af_log "overriding $v from config.mk"
      unset ::env($v)
    }
  }
  set ::env(PLACE_DENSITY) [dict get $winner density]
  if { [info exists ::env(PLACE_DENSITY_LB_ADDON)] } {
    unset ::env(PLACE_DENSITY_LB_ADDON)
  }

  af_log "winner [dict get $winner tag]: utilization\
[dict get $winner util], aspect [dict get $winner aspect], density\
[format %.4g [dict get $winner density]] (was utilization $u0, aspect $a0)"
  return 1
}

# The raced density is decided at the floorplan stage but consumed at the
# place stage, in a different process. Rather than add a stage-boundary
# artifact (which every build system wrapping ORFS would then have to
# declare), put it on the block: ODB properties survive write_db/read_db,
# so it travels with 2_floorplan.odb across every stage boundary at no
# cost, and it is visible to anyone inspecting the database.
proc af_stash_place_density { density } {
  set blk [ord::get_db_block]
  if { $blk eq "NULL" } {
    return
  }
  set existing [odb::dbStringProperty_find $blk AUTO_FLOORPLAN_PLACE_DENSITY]
  if { $existing ne "NULL" && $existing ne "" } {
    odb::dbProperty_destroy $existing
  }
  odb::dbStringProperty_create $blk AUTO_FLOORPLAN_PLACE_DENSITY $density
}

# Read it back. Returns "" when absent, so callers can fall back to the
# ordinary computation.
proc af_stashed_place_density { } {
  set blk [ord::get_db_block]
  if { $blk eq "NULL" } {
    return ""
  }
  set p [odb::dbStringProperty_find $blk AUTO_FLOORPLAN_PLACE_DENSITY]
  if { $p eq "NULL" || $p eq "" } {
    return ""
  }
  return [$p getValue]
}
