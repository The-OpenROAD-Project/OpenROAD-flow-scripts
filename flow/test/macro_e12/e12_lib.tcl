# Shared helpers for the E12 clustered-scorer experiment.
#
# E12 asks whether a global placement run on RTL-MP's own std-cell
# clusters -- rather than on every std cell -- still ranks macro
# placement candidates as well as the flat scorer does. Ranking accuracy
# is the only requirement: a scorer that is uniformly optimistic ranks
# perfectly, so absolute error is not the enemy, rank inversions are.
#
# Everything here is report-only. Scores are read out of odb after
# global placement; nothing is written back to the design database, and
# each candidate is scored in its own process (gpl's Replace::reset()
# does not clear the cluster list, and gpl does write GCell locations
# back to odb, so process isolation is what makes scoring side-effect
# free).

# --------------------------------------------------------------------
# Environment and bookkeeping.

proc e12_env { name default } {
  if { [info exists ::env($name)] && $::env($name) ne "" } {
    return $::env($name)
  }
  return $default
}

# Point the ORFS per-stage directories at a per-tag work area so
# candidates cannot overwrite each other's intermediate files.
proc e12_redirect { tag } {
  set base [file join $::e12_work $tag]
  foreach {var sub} {RESULTS_DIR results REPORTS_DIR reports
                     LOG_DIR logs OBJECTS_DIR objects} {
    set dir [file join $base $sub]
    file mkdir $dir
    set ::env($var) $dir
  }
  return $base
}

proc e12_step { script } {
  set t0 [clock clicks -milliseconds]
  uplevel #0 [list source [file join $::env(SCRIPTS_DIR) $script]]
  set s [expr { ([clock clicks -milliseconds] - $t0) / 1000.0 }]
  puts "e12: $script done in ${s}s"
  return $s
}

proc e12_vmhwm_kb { } {
  if {
    [catch {
      set fp [open /proc/self/status r]
      set status [read $fp]
      close $fp
      regexp {VmHWM:\s+(\d+) kB} $status -> kb
    }]
  } {
    return 0
  }
  return $kb
}

# Append extra arguments to the exact argument list ORFS's
# macro_place_util.tcl constructs. RTLMP_ARGS would REPLACE that list,
# dropping halos and target_util, which would silently change what is
# being measured; wrapping the command keeps every ORFS argument and adds
# only what the experiment needs.
#
# Both users go through here on purpose. The candidate generator adds
# -random_seed, and the cluster dump adds -keep_clustering_data: the
# partition has to be the one *production* RTL-MP builds, so it must be
# produced by the production argument list too.
proc e12_wrap_placer { extra } {
  if { [info commands e12_real_rtl_macro_placer] eq "" } {
    rename rtl_macro_placer e12_real_rtl_macro_placer
    proc rtl_macro_placer { args } {
      e12_real_rtl_macro_placer {*}$args {*}$::e12_placer_extra
    }
  }
  set ::e12_placer_extra $extra
}

# --------------------------------------------------------------------
# Netlist queries.
#
# All of these iterate in a deterministic order (sorted by odb id) and
# return sorted id lists, so every derived set is a pure function of the
# database and not of pointer or hash order.

proc e12_is_supply { sig_type } {
  return [expr { $sig_type eq "POWER" || $sig_type eq "GROUND" }]
}

# Nets a scoring pass should look at: real signal nets, skipping the
# oversized ones RTL-MP itself ignores when it builds its clustered
# model (ClusteringEngine::isValidNet / large_net_threshold).
proc e12_signal_nets { block { large_net_threshold 0 } } {
  set nets {}
  foreach net [$block getNets] {
    if { [$net isSpecial] } {
      continue
    }
    if { [e12_is_supply [$net getSigType]] } {
      continue
    }
    if {
      $large_net_threshold > 0
      && [$net getTermCount] > $large_net_threshold
    } {
      continue
    }
    lappend nets $net
  }
  return $nets
}

# Half-perimeter wirelength over a net list, in exact integer DBU.
#
# dbNet::getTermBBox is the bounding box of the net's physical terminal
# locations, which is what gpl minimizes and what odb's own
# WireLengthEvaluator sums. Tcl integers are arbitrary precision and
# integer addition is associative, so the result is independent of
# iteration order and of thread count -- the determinism requirement is
# satisfied by construction rather than by discipline.
proc e12_hpwl_dbu { nets } {
  set hpwl 0
  foreach net $nets {
    # A net whose terminals have no physical location yields an inverted
    # (empty) rectangle, whose dx/dy are negative. Summing those blindly
    # produced a NEGATIVE total on the first real run -- a number that is
    # obviously wrong, but only obviously so because it went below zero;
    # a partially placed design would have quietly produced a plausible
    # one. Require a real two-terminal net and a non-inverted box.
    if { [$net getTermCount] < 2 } {
      continue
    }
    set bbox [$net getTermBBox]
    set dx [$bbox dx]
    set dy [$bbox dy]
    if { $dx < 0 || $dy < 0 } {
      continue
    }
    set hpwl [expr { $hpwl + $dx + $dy }]
  }
  return $hpwl
}

# Breadth-first expansion outward from macro pins.
#
# Returns a dict with, per hop level 1..hops, the movable instances
# reached at that level, plus the accumulated net set at each level.
# Two consumers, one traversal:
#
#   halo-flat coarsening -- the instances within 1-2 hops of a macro pin
#   stay individual movables instead of being folded into a cluster,
#   because clustering smears exactly the pin geometry the live KPI
#   (the macro-path timing aggregate) reads.
#
#   macro-cone scoring -- HPWL summed over only the nets in the cone,
#   because a score dominated by wirelength the KPI never looks at is a
#   score spending its resolution in the wrong place.
proc e12_macro_bfs { block hops { large_net_threshold 0 } } {
  set macro_ids {}
  foreach inst [$block getInsts] {
    if { [[$inst getMaster] isBlock] } {
      lappend macro_ids [$inst getId]
    }
  }
  set macro_ids [lsort -integer -unique $macro_ids]

  # seen_inst: every instance already assigned to a level, so a later hop
  # cannot claim it again. seen_net: likewise for nets.
  set seen_inst {}
  foreach id $macro_ids {
    dict set seen_inst $id 1
  }
  set seen_net {}
  set frontier {}
  foreach id $macro_ids {
    lappend frontier [odb::dbInst_getInst $block $id]
  }

  set result [dict create macros $macro_ids]
  set cone_nets {}

  # Level 0 is the macros themselves: its nets are the ones incident to a
  # macro pin, which is the cone even when no instance is kept flat. The
  # loop therefore collects nets first and expands second, so hops = 0 is
  # a meaningful configuration (cluster everything, cone still defined)
  # rather than an empty result.
  for { set hop 0 } { $hop <= $hops } { incr hop } {
    set reached {}
    foreach inst $frontier {
      foreach iterm [$inst getITerms] {
        set net [$iterm getNet]
        if { $net eq "NULL" || $net eq "" } {
          continue
        }
        if { [$net isSpecial] || [e12_is_supply [$net getSigType]] } {
          continue
        }
        if {
          $large_net_threshold > 0
          && [$net getTermCount] > $large_net_threshold
        } {
          continue
        }
        set net_id [$net getId]
        if { ![dict exists $seen_net $net_id] } {
          dict set seen_net $net_id 1
          lappend cone_nets $net_id
        }
        lappend reached $net
      }
    }
    dict set result cone_nets$hop [lsort -integer -unique $cone_nets]
    if { $hop == $hops } {
      break
    }

    set next_ids {}
    foreach net $reached {
      foreach other [$net getITerms] {
        set other_inst [$other getInst]
        set other_id [$other_inst getId]
        if { [dict exists $seen_inst $other_id] } {
          continue
        }
        if { [[$other_inst getMaster] isBlock] || [$other_inst isFixed] } {
          continue
        }
        dict set seen_inst $other_id 1
        lappend next_ids $other_id
      }
    }
    set next_ids [lsort -integer -unique $next_ids]
    dict set result hop[expr { $hop + 1 }] $next_ids
    set frontier {}
    foreach id $next_ids {
      lappend frontier [odb::dbInst_getInst $block $id]
    }
  }
  return $result
}

# The halo-flat instance set: everything within $hops of a macro pin.
proc e12_halo_flat_ids { bfs hops } {
  set ids {}
  for { set hop 1 } { $hop <= $hops } { incr hop } {
    if { [dict exists $bfs hop$hop] } {
      lappend ids {*}[dict get $bfs hop$hop]
    }
  }
  return [lsort -integer -unique $ids]
}

# --------------------------------------------------------------------
# Score readout.

# Every score record carries the cost side of the measurement next to
# the ranking side, so the ranking-accuracy-vs-cost curve can be drawn
# from the evidence rather than estimated. num_gcells/num_fillers come
# from gpl's own log, which is the only place they are reported.
proc e12_write_leaf { path fields } {
  set fp [open $path w]
  puts $fp "{"
  set n [llength $fields]
  set i 0
  foreach {key value} $fields {
    incr i 2
    set comma [expr { $i < $n ? "," : "" }]
    if {
      [string is entier -strict $value]
      || [string is double -strict $value]
    } {
      puts $fp "  \"$key\": $value$comma"
    } else {
      puts $fp "  \"$key\": \"$value\"$comma"
    }
  }
  puts $fp "}"
  close $fp
}
