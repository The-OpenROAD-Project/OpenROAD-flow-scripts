# Floorplan derivation: measure the floorplan shape instead of guessing it.
#
# Run by <name>_auto_floorplan_data, off a design's synthesised netlist.
# Races candidate outlines and densities, each evaluated by running the
# production flow to finish, and writes the winner and every candidate to
# $AF_EVIDENCE. <name>_auto_floorplan_pin turns that into config.mk
# values. Nothing here runs during an ordinary build.
#
# WHAT IS BEING RETIRED
#
# CORE_UTILIZATION (or DIE_AREA/CORE_AREA), CORE_ASPECT_RATIO and
# PLACE_DENSITY (or PLACE_DENSITY_LB_ADDON) are the last hand-carried
# numbers in a config.mk. Each is a human prediction of downstream
# behaviour standing where a measurement should be: the right utilization
# is "the smallest core in which this netlist still closes", which is a
# question about repair_design, CTS and routing -- none of which have
# happened when the number is read.
#
# THE ORACLE IS THE FLOW
#
# An earlier version scored candidates with a fast pre-route proxy. It
# does not rank the utilization axis: measured against the finished flow
# over a utilization ladder, rho = -1.000 on gcd (perfectly inverted) and
# +0.100 on gcd-ccs -- the two designs whose noise floor is small enough
# for the question to have an answer. So each candidate runs the real
# flow and reports what it achieved. That is expensive, and it is why
# this is a job you run rather than something the flow does.
#
# Every ladder is a dimensionless fraction. There is no per-design
# constant anywhere in this file.

proc af_env { name { default "" } } {
  if { [info exists ::env($name)] && $::env($name) ne "" } {
    return $::env($name)
  }
  return $default
}

proc af_log { msg } {
  puts "AUTO_FLOORPLAN: $msg"
}

# Fractions of the incumbent utilization. Above 1.0 is a smaller core;
# one point below is kept so the walk can report that loosening was
# better rather than only ever being able to tighten.
set ::af_util_ladder [af_env AF_UTIL_LADDER {0.9 1.0 1.1 1.2 1.3 1.4}]

# Fractions of the headroom above the measured density lower bound. This
# is exactly what PLACE_DENSITY_LB_ADDON means; the ladder makes it
# measured instead of guessed.
set ::af_addon_ladder [af_env AF_ADDON_LADDER {0.00 0.05 0.10 0.15 0.20}]

# Aspect ratios to try at the winning area point. Often a tie, which is a
# result: the folklore value gets graded rather than assumed.
set ::af_aspect_ladder [af_env AF_ASPECT_LADDER {0.8 1.0 1.25}]

# Placer seeds for the noise floor. Eight rather than three: the range of
# a small sample is a poor estimator of spread, biased low and with an
# expectation that grows with n, so a range-based floor would move every
# threshold purely by changing the seed count. These run concurrently.
set ::af_tie_seeds [af_env AF_TIE_SEEDS {1 2 3 4 5 6 7 8}]

# The exchange rate between area and period: one percent of achieved
# period is worth this many percent of core area. A product decision --
# how much silicon a percent of speed is worth -- not a tuning constant,
# which is why it is a rate and not a threshold.
#
# Validated once against an asap7 sweep rather than searched per design:
# lambda = 3 rejects the trades that gave up a lot of period for little
# area (ethmac +13.4% period for -16.7% area, aes +5.6% for -8.7%) and
# accepts every win and every cheap trade (gcd-ccs +0.78% for -24.2%,
# mock-alu +0.92% for -28.8%, aes_lvt +1.37% for -28.5%). Every verdict
# is unchanged for lambda in [2, 5], so this is the shape of a policy
# rather than a fitted number.
set ::af_lambda [af_env AF_LAMBDA 3.0]

# Width of the handover around the target period, as a fraction of the
# clock. Verdicts unchanged for tau in [0.01, 0.10].
set ::af_tau_frac [af_env AF_TAU_FRAC 0.02]

# ---------------------------------------------------------------------
# The objective
# ---------------------------------------------------------------------

# ln(1 + e^x), computed so neither tail overflows.
proc af_softplus { x } {
  if { $x > 0 } {
    return [expr { $x + log(1.0 + exp(-$x)) }]
  }
  return [expr { log(1.0 + exp($x)) }]
}

# What the derivation minimises:
#
#   P_eff = T + tau * ln(1 + e^((p - T)/tau))
#   J     = ln(area) + lambda * ln(P_eff)
#
# P_eff is a smooth one-sided penalty: it tracks the achieved period p
# when the design is slower than its target T and flattens to T when it
# is faster. Speed beyond what the SDC asked for has no value, so area
# spent buying it is never repaid; a design short of target pays the full
# exchange rate for every percent it gives up.
#
# There is no regime switch to get wrong. The same expression minimises
# area down to the target on a design that closes -- the period term goes
# flat, leaving ln(area) -- and trades period against area on one that
# does not. The derivative says it plainly:
#
#   dA/A = -lambda * sigma((p - T)/tau) * dp/P_eff
#
# The effective rate is lambda*sigma, scaling itself down as the design
# gets comfortably faster than target. A hard max(p, T) gives identical
# verdicts on every design measured, but its kink treats two candidates
# either side of the target very differently on a noisy measurement; the
# softplus removes that cliff for free.
proc af_objective { area period target } {
  if { $area <= 0 || $target <= 0 } {
    return 1e30
  }
  set tau [expr { $::af_tau_frac * $target }]
  set p_eff [expr { $target + $tau * [af_softplus [expr { ($period - $target) / $tau }]] }]
  return [expr { log($area) + $::af_lambda * log($p_eff) }]
}

proc af_period { r } {
  return [dict get $r achieved]
}

# How much J a period difference of delta_tie could account for on its
# own, at a given operating point. Used as hysteresis: a winner must beat
# the incumbent by more than the noise could have produced.
#
# Area is exact -- the same coordinates give the same core every time --
# so only the period term carries noise, and this converts the measured
# period floor into the J units the comparison is made in.
proc af_objective_tie { r target delta_tie } {
  set p [af_period $r]
  set a [dict get $r core_um2]
  return [expr {
    abs([af_objective $a [expr { $p + $delta_tie }] $target] -
      [af_objective $a $p $target])
  }]
}

proc af_select_objective { results target } {
  set best ""
  set best_j 0
  foreach r $results {
    set j [af_objective [dict get $r core_um2] [af_period $r] $target]
    if { $best eq "" || $j < $best_j } {
      set best $r
      set best_j $j
    }
  }
  return $best
}

# ---------------------------------------------------------------------
# Running candidates
# ---------------------------------------------------------------------

proc af_shell_quote { s } {
  return "'[string map {' '\\''} $s]'"
}

# A candidate expresses its density in exactly one of the two forms the
# flow supports: a raced headroom fraction (addon), or a fixed
# PLACE_DENSITY. The second form exists so the incumbent can be run as
# the design actually is -- see af_incumbent_density.
proc af_cand { tag util aspect margin addon seed { density "" } } {
  return [dict create tag $tag util [format %.4g $util] aspect $aspect \
    margin $margin addon $addon seed $seed density_fixed $density]
}

# The candidate writes a Tcl dict, so reading it is a validity check.
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

# Echo the tail of a failed candidate's log. Its own log lives in a
# scratch dir a sandboxed build discards, so without this a bare "it
# failed" would be undebuggable.
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

# Run candidates as parallel subprocesses, bounded by AF_JOBS.
#
# The fan-out is deliberately ours and not the build system's: bazel
# provisions roughly one core per action, so expressing each candidate as
# its own target would overprovision by the thread count of every
# concurrent flow. One action, explicit pool. Note that building several
# designs' data targets at once multiplies AF_JOBS by bazel's --jobs.
proc af_run_batch { cands work } {
  set jobs [af_env AF_JOBS 2]
  af_log "running [llength $cands] candidates, $jobs at a time"

  set pending $cands
  set running {}
  set results {}

  while { [llength $pending] > 0 || [llength $running] > 0 } {
    while { [llength $pending] > 0 && [llength $running] < $jobs } {
      set c [lindex $pending 0]
      set pending [lrange $pending 1 end]
      set tag [dict get $c tag]
      set result [file join $work "$tag.rec"]
      set done [file join $work "$tag.done"]
      file delete -force $result $done

      set assigns {}
      foreach { k v } [list \
        AF_UTIL [dict get $c util] \
        AF_ASPECT [dict get $c aspect] \
        AF_MARGIN [dict get $c margin] \
        AF_ADDON [dict get $c addon] \
        AF_DENSITY [dict get $c density_fixed] \
        AF_SEED [dict get $c seed] \
        AF_WORK [file join $work $tag] \
        AF_RESULT $result \
        AF_SRC_RESULTS $::env(RESULTS_DIR)] {
        lappend assigns "$k=[af_shell_quote $v]"
      }
      # A wrapper shell so a crashed candidate still records a status:
      # the driver must tell "eliminated" from "still running" without a
      # timeout heuristic.
      set cmd "[join $assigns { }] \
[af_shell_quote $::env(OPENROAD_EXE)] -no_init -exit \
[af_shell_quote $::env(SCRIPTS_DIR)/auto_floorplan_candidate.tcl] \
> [af_shell_quote $work/$tag.log] 2>&1; echo \$? > [af_shell_quote $done]"
      exec sh -c $cmd &
      lappend running [list $tag $result $done]
    }

    # Candidates are minutes long, so a coarse poll costs nothing.
    after 1000
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
        af_log "candidate $tag eliminated (exit $rc); last lines of its log:"
        af_log_tail [file join $work "$tag.log"] 15
        continue
      }
      set fh [open $result r]
      set d [af_parse_result [read $fh]]
      close $fh
      if { $d eq "" } {
        af_log "candidate $tag eliminated (unparseable record)"
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

# A floorplan that routes with violations is not a cheaper floorplan.
# This is a hard filter and not a term in the objective: no amount of
# area buys past it.
proc af_survivors { results } {
  set out {}
  foreach r $results {
    if { [dict get $r drc] > 0 } {
      af_log "candidate [dict get $r tag] eliminated:\
 [dict get $r drc] DRC violations"
      continue
    }
    lappend out $r
  }
  return $out
}

# The design's own noise floor, from re-running one candidate under
# different placer seeds. Measured, never chosen: a threshold from
# anywhere else would let the derivation be rewarded for predicting
# noise. Two standard deviations rather than the range, so it does not
# grow with the seed count.
proc af_measure_delta_tie { winner work } {
  set cands {}
  foreach seed [lrange $::af_tie_seeds 1 end] {
    lappend cands [af_cand "tie_s$seed" [dict get $winner util] \
      [dict get $winner aspect] [dict get $winner margin] \
      [dict get $winner addon] $seed]
  }
  set periods [list [af_period $winner]]
  foreach r [af_run_batch $cands $work] {
    lappend periods [af_period $r]
  }
  set n [llength $periods]
  if { $n < 2 } {
    af_log "noise floor could not be measured (n=$n); treating every\
 difference as real"
    return [list 0.0 $n]
  }
  set sum 0.0
  foreach p $periods {
    set sum [expr { $sum + $p }]
  }
  set mean [expr { $sum / $n }]
  set ss 0.0
  foreach p $periods {
    set ss [expr { $ss + ($p - $mean) * ($p - $mean) }]
  }
  set spread [expr { 2.0 * sqrt($ss / ($n - 1)) }]
  set clk [dict get $winner clock_period]
  af_log "noise floor over $n seeds: 2 sigma = [format %.4g $spread]\
 ([format %.2f [expr { $clk > 0 ? 100.0 * $spread / $clk : -1 }]]% of the\
 clock period)"
  return [list $spread $n]
}

# ---------------------------------------------------------------------
# The incumbent
# ---------------------------------------------------------------------

# The utilization the design uses today. A design that states an explicit
# rectangle gets an equivalent derived from it, so every design enters
# the walk with its own configuration as a candidate regardless of form.
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
          $cell_um2 + [$m getWidth] * double([$m getHeight]) / $scale
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
  return [af_env CORE_ASPECT_RATIO 1.0]
}

proc af_incumbent_margin { } {
  return [af_env CORE_MARGIN 1.0]
}

proc af_incumbent_addon { } {
  return [af_env PLACE_DENSITY_LB_ADDON ""]
}

# The density the design actually runs at when it states one directly.
# Only meaningful when there is no incumbent addon: PLACE_DENSITY_LB_ADDON
# overrides PLACE_DENSITY rather than adding to it, so a design that sets
# both is already expressing the addon form.
proc af_incumbent_density { } {
  if { [af_incumbent_addon] ne "" } {
    return ""
  }
  return [af_env PLACE_DENSITY ""]
}

# ---------------------------------------------------------------------
# Evidence
# ---------------------------------------------------------------------

proc af_dict_get_or { d key default } {
  if { [dict exists $d $key] } {
    return [dict get $d $key]
  }
  return $default
}

# Write one JSON object to a channel, field by field.
#
# Deliberately not built as one Tcl string and printed: a long line
# assembled with lappend + join came back with fragments of itself
# spliced in under OpenROAD's Tcl once the record grew past a few hundred
# characters. Short writes are unaffected.
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

# Every candidate, what it achieved, why it was eliminated if it was, the
# measured noise floor, and the winner. A verdict without its evidence is
# an assertion.
proc af_write_evidence { path phases winner delta_tie tie_n incumbent } {
  set fields {
    util aspect margin density addon seed clock_period wns achieved
    core_um2 stdcell_um2 macro_um2 drc total_ms
  }
  set fh [open $path w]
  puts $fh "{"
  puts $fh "  \"design\": \"$::env(DESIGN_NAME)\","
  puts $fh "  \"platform\": \"$::env(PLATFORM)\","
  puts $fh "  \"oracle\": \"production flow, floorplan to finish, per candidate\","
  puts $fh "  \"search\": \"coordinate descent: utilization, then density, then aspect\","
  puts $fh "  \"lambda\": $::af_lambda,"
  puts $fh "  \"tau_frac\": $::af_tau_frac,"
  puts $fh "  \"delta_tie\": [format %.10g $delta_tie],"
  puts $fh "  \"delta_tie_n\": $tie_n,"
  puts -nonewline $fh "  \"incumbent\": "
  af_json_obj_to $fh [list \
    util [dict get $incumbent util] \
    aspect [dict get $incumbent aspect] \
    addon [dict get $incumbent addon]]
  puts $fh ","
  puts -nonewline $fh "  \"winner\": "
  if { $winner eq "" } {
    puts -nonewline $fh "null"
  } else {
    set wp [list tag "\"[dict get $winner tag]\""]
    foreach f { util aspect margin density addon achieved clock_period core_um2 drc } {
      lappend wp $f [af_dict_get_or $winner $f -1]
    }
    foreach f { die_rect core_rect } {
      if { [dict exists $winner $f] } {
        lappend wp $f "\"[dict get $winner $f]\""
      }
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
}

# ---------------------------------------------------------------------
# The walk
# ---------------------------------------------------------------------

proc af_run { } {
  # A die that is a constraint is not a choice: a DEF-initialised
  # floorplan or an ICeWall footprint describes a package and pad ring,
  # and deriving the outline underneath it would be meaningless.
  if {
    [env_var_exists_and_non_empty FLOORPLAN_DEF] ||
    [env_var_exists_and_non_empty FOOTPRINT]
  } {
    af_log "FLOORPLAN_DEF/FOOTPRINT set: the die is a constraint, not derived"
    return 0
  }

  set work [af_env AF_WORK_DIR [file join $::env(OBJECTS_DIR) auto_floorplan]]
  file mkdir $work
  set evidence $::env(AF_EVIDENCE)

  set u0 [af_incumbent_util]
  set a0 [af_incumbent_aspect]
  set m0 [af_incumbent_margin]
  set addon0 [af_incumbent_addon]
  set incumbent [dict create util $u0 aspect $a0 \
    addon [expr { $addon0 eq "" ? -1 : $addon0 }]]
  af_log "incumbent: utilization $u0, aspect $a0, margin $m0, addon\
 [expr { $addon0 eq "" ? "(fixed PLACE_DENSITY)" : $addon0 }]"

  # What the utilization phase holds constant while it moves the core.
  #
  # A design stating a fixed PLACE_DENSITY has no incumbent headroom
  # fraction. Substituting a ladder rung for it -- which this used to do --
  # means the phase's 1.0 rung is not the incumbent at all but the design
  # at a density it has never run, so the hysteresis guard compares the
  # winner against a floorplan that does not exist. On aes_lvt that
  # strawman read 9.3 ps pessimistic and accounted for most of an
  # apparent win that the production flow scored as a lost closure.
  #
  # So hold the design's own density, in the design's own form. The
  # density phase then races the addon from the winning area point.
  set hold_density [af_incumbent_density]
  set hold_addon [expr { $addon0 eq "" ? 0.0 : $addon0 }]

  # --- utilization ------------------------------------------------------
  set cands {}
  foreach f $::af_util_ladder {
    set u [expr { $u0 * $f }]
    if { $u >= 100.0 } {
      continue
    }
    lappend cands [af_cand "u[string map {. p} $f]" $u $a0 $m0 $hold_addon \
      1 $hold_density]
  }
  set r_util [af_survivors [af_run_batch $cands $work]]
  if { [llength $r_util] == 0 } {
    af_log "no utilization candidate survived; nothing to derive"
    af_write_evidence $evidence [list [list utilization {}]] "" 0.0 0 $incumbent
    return 0
  }

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
  set target [dict get $inc_cand clock_period]

  lassign [af_measure_delta_tie $inc_cand $work] delta_tie tie_n
  set w [af_select_objective $r_util $target]
  af_log "utilization phase: [dict get $w util] minimises the objective\
 ([format %.4g [dict get $w core_um2]] um2, achieved\
 [format %.4g [af_period $w]]; incumbent\
 [format %.4g [dict get $inc_cand core_um2]] um2, achieved\
 [format %.4g [af_period $inc_cand]])"

  # --- density ----------------------------------------------------------
  set cands {}
  foreach f $::af_addon_ladder {
    lappend cands [af_cand "d[string map {. p} $f]" [dict get $w util] \
      $a0 $m0 $f 1]
  }
  set r_dens [af_survivors [af_run_batch $cands $work]]

  # --- aspect, at the winning area and density --------------------------
  set best_addon [dict get [af_select_objective \
    [concat [list $w] $r_dens] $target] addon]
  set cands {}
  foreach ar $::af_aspect_ladder {
    if { $ar == $a0 } {
      continue
    }
    lappend cands [af_cand "a[string map {. p} $ar]" [dict get $w util] \
      $ar $m0 $best_addon 1]
  }
  set r_asp [af_survivors [af_run_batch $cands $work]]

  # --- select -----------------------------------------------------------
  set all [concat $r_util $r_dens $r_asp]
  set winner [af_select_objective $all $target]

  # Hysteresis, in the units the decision is made in. A winner must beat
  # the incumbent by more J than the measured period noise could have
  # produced on its own; otherwise the design keeps what it has and the
  # derivation reports a tie rather than churning a config.mk on noise.
  set j_win [af_objective [dict get $winner core_um2] [af_period $winner] $target]
  set j_inc [af_objective [dict get $inc_cand core_um2] \
    [af_period $inc_cand] $target]
  set j_tie [af_objective_tie $inc_cand $target $delta_tie]
  af_log "objective: winner J [format %.5f $j_win], incumbent J\
 [format %.5f $j_inc], noise could account for [format %.5f $j_tie]"
  if { $j_win > $j_inc - $j_tie } {
    af_log "the winner does not beat the incumbent by more than the noise\
 floor could account for; keeping the incumbent"
    set winner $inc_cand
  }

  af_write_evidence $evidence \
    [list [list utilization $r_util] [list density $r_dens] \
      [list aspect $r_asp]] \
    $winner $delta_tie $tie_n $incumbent

  af_log "winner [dict get $winner tag]: utilization [dict get $winner util],\
 aspect [dict get $winner aspect], density\
 [format %.4g [dict get $winner density]], core\
 [format %.4g [dict get $winner core_um2]] um2, achieved\
 [format %.4g [af_period $winner]] against a target of [format %.4g $target]"
  af_log "evidence written to $evidence"
  return 1
}

# Entry point when run as an orfs_run script.
source $::env(SCRIPTS_DIR)/load.tcl
load_design 1_synth.odb 1_synth.sdc
af_run
