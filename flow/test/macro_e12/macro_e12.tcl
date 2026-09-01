# E12 step 0: regenerate the candidate population and re-measure it with
# the flat scorer.
#
# Why this step exists at all. The E12 question is whether a *clustered*
# global placement ranks macro-placement candidates as well as a flat
# one. The reference it is graded against is a committed archive of 24
# swerv_wrapper candidates scored by the flat rung and then carried
# through the full production tail to global route
# (score_vs_flow_swerv.json). The candidate placements themselves were
# never committed, so they have to be regenerated here -- and nothing
# downstream is interpretable until the regenerated flat scores
# reproduce the archived ones. This script is therefore both the
# candidate generator and the rig check.
#
# The population comes from rtl_macro_placer -random_seed 0..k-1: the
# macro placer is used as a distribution generator, not as an optimizer.
# Its annealing cost picks the better of two of its own placements at
# roughly coin-flip probability, so the selection intelligence has to
# live in a score measured after the fact, not in the cost function.
#
# One production floorplan spine is shared; candidates diverge only at
# macro_place, so a copy-on-write snapshot would pay for the whole shared
# prefix. Two execution shapes, selected by E12_SERIAL_THREADS:
#
#   0            fork -jobs $E12_JOBS: candidates in parallel,
#                single-threaded each (a fork child must not raise its own
#                thread count). Requires bazel-orfs's fork facility.
#   N > 0        no fork: candidates run sequentially in the parent with
#                set_thread_count N.
#
# The fork facility is not in every bazel-orfs pin -- notably not in the
# one ORFS currently pins -- so when it is missing this falls back to the
# serial arm automatically. That is a throughput difference, not a
# measurement difference: the upstream campaign measured 65 candidates/h
# forked against 23.8 serial, because generation dominates and RTL-MP is
# thread-insensitive. Budget accordingly before asking for 24 of them.

# The fork facility is optional. It is what makes many candidates cheap
# -- they share the whole floorplan prefix through a copy-on-write
# snapshot -- but it lives in bazel-orfs and is not present in every pin,
# so its absence must degrade to the serial arm rather than crash. The
# serial arm is not a lesser measurement: it produces the same scores,
# one at a time (see e12_reset_placement for what it has to undo by hand
# that a fork child gets for free).
set ::e12_have_fork 0
if {
  [info exists ::env(ORFS_FORK_TCL)]
  && [file exists $::env(ORFS_FORK_TCL)]
} {
  source $::env(ORFS_FORK_TCL)
  set ::e12_have_fork 1
}

set e12_dir [file dirname [file normalize [info script]]]
source [file join $e12_dir e12_lib.tcl]
source [file join $e12_dir extract_lib.tcl]

set ::e12_out [e12_env E12_OUT_DIR [e12_env RUN_OUTPUT_DIR ""]]
if { $::e12_out eq "" } {
  error "macro_e12: set E12_OUT_DIR or declare out_dir"
}
set ::e12_work [e12_env E12_WORK [file join $::env(WORK_HOME) e12_work]]
set ::e12_k [e12_env E12_K 24]
set ::e12_jobs [e12_env E12_JOBS 12]
# 0 means "use fork if it is available". A positive value, or the absence
# of fork, selects the serial arm with that many threads.
set ::e12_serial_threads [e12_env E12_SERIAL_THREADS 0]
if { !$::e12_have_fork && $::e12_serial_threads == 0 } {
  set ::e12_serial_threads 1
}
set ::e12_fork_opts [list -timeout [e12_env E12_CHILD_TIMEOUT 14400]]
file mkdir $::e12_out

set ::env(KEEP_VARS) 1
set ::env(SKIP_REPORT_METRICS) 1

# --------------------------------------------------------------------
# The flat scoring rung, kept as the control.
#
# Non-timing-driven and non-routability-driven on purpose: the score is
# a measurement taken on the far side of the fog, and it prices density
# and congestion implicitly by actually doing the placement. The STA
# readout is retained here only because the archived reference numbers
# include it -- for ranking it is known to be droppable (raw HPWL alone
# ranks the ground truth nearly as well).
proc e12_score_flat { } {
  set t0 [clock clicks -milliseconds]
  if { ![info exists ::e12_pins_placed] } {
    if { [e12_env IO_CONSTRAINTS ""] ne "" } {
      uplevel #0 [list source $::env(IO_CONSTRAINTS)]
    }
    place_pins -hor_layers $::env(IO_PLACER_H) \
      -ver_layers $::env(IO_PLACER_V)
    set ::e12_pins_placed 1
  }
  set cell_pad [e12_env CELL_PAD_IN_SITES_GLOBAL_PLACEMENT 0]
  set gp_args [list -density [place_density_with_lb_addon] \
    -pad_left $cell_pad -pad_right $cell_pad \
    -force_center_initial_place]
  global_placement {*}$gp_args
  set gpl_s [expr { ([clock clicks -milliseconds] - $t0) / 1000.0 }]

  # The HPWL readout the clustered scorer will use, measured here too so
  # the two rungs are compared on the same scalar as well as on the STA
  # aggregates.
  set block [ord::get_db_block]
  set hpwl_dbu [e12_hpwl_dbu [e12_signal_nets $block]]

  set t0 [clock clicks -milliseconds]
  estimate_parasitics -placement
  set_propagated_clock [all_clocks]
  set sample [extract_sample_paths]
  set sta_s [expr { ([clock clicks -milliseconds] - $t0) / 1000.0 }]

  set wq25_sum 0.0
  set wq25_n 0
  set macro_sum 0.0
  set macro_n 0
  foreach pt [dict get $sample paths] {
    set period [lindex $pt 2]
    if { [lindex $pt 3] } {
      set macro_sum [expr { $macro_sum + $period }]
      incr macro_n
    } else {
      set wq25_sum [expr { $wq25_sum + $period }]
      incr wq25_n
    }
  }

  return [dict create \
    clock_period [dict get $sample clock_period] \
    wns [dict get $sample wns] \
    period [expr { [dict get $sample clock_period] - [dict get $sample wns] }] \
    wq25 [expr { $wq25_n ? $wq25_sum / $wq25_n : 0.0 }] \
    macro_mean [expr { $macro_n ? $macro_sum / $macro_n : 0.0 }] \
    hpwl_dbu $hpwl_dbu \
    gpl_s $gpl_s \
    sta_s $sta_s \
    sample $sample]
}

# One candidate: seeded production macro placement, then the flat rung.
# Runs inside a fork child (parallel shape) or inline in the parent
# (serial shape).
proc e12_candidate { seed } {
  set tag cand_s$seed
  e12_redirect $tag
  e12_wrap_placer [list -random_seed $seed]
  set t0 [clock clicks -milliseconds]
  e12_step macro_place.tcl
  set place_s [expr { ([clock clicks -milliseconds] - $t0) / 1000.0 }]

  # Archive the production macro-placement script and the post-macro
  # database. The clustered scorer reads the .odb back rather than
  # regenerating the candidate, so generation is paid exactly once.
  file copy -force \
    [file join $::env(RESULTS_DIR) 2_2_floorplan_macro.tcl] \
    [file join $::e12_out $tag.place.tcl]
  write_db [file join $::e12_out $tag.odb]

  set score [e12_score_flat]
  e12_write_leaf [file join $::e12_out $tag.json] [list \
    tag $tag \
    seed $seed \
    time_unit "[sta::unit_scale_abbreviation time][sta::unit_suffix time]" \
    clock_period [dict get $score clock_period] \
    wns [dict get $score wns] \
    period [dict get $score period] \
    wq25 [dict get $score wq25] \
    macro_mean [dict get $score macro_mean] \
    hpwl_dbu [dict get $score hpwl_dbu] \
    macro_place_s $place_s \
    gpl_s [dict get $score gpl_s] \
    sta_s [dict get $score sta_s] \
    vmhwm_kb [e12_vmhwm_kb]]
  puts "e12: leaf $tag done (macro_place ${place_s}s,\
    gpl [dict get $score gpl_s]s)"
}

# In-parent reset between serial candidates: macros back to unfixed and
# unplaced, standard cells and pins unplaced, macro soft blockages gone.
# Fork children never need this -- each inherits the pristine
# post-floorplan snapshot.
proc e12_reset_placement { } {
  set blk [ord::get_db_block]
  foreach inst [$blk getInsts] {
    if { [[$inst getMaster] isBlock] } {
      $inst setPlacementStatus NONE
      $inst setOrient R0
      $inst setLocation 0 0
    } elseif { [$inst isPlaced] } {
      $inst setPlacementStatus NONE
    }
  }
  foreach blockage [$blk getBlockages] {
    odb::dbBlockage_destroy $blockage
  }
  foreach bterm [$blk getBTerms] {
    foreach bpin [$bterm getBPins] {
      odb::dbBPin_destroy $bpin
    }
  }
  unset -nocomplain ::e12_pins_placed
  unset_propagated_clock [all_clocks]
}

# --------------------------------------------------------------------
# The walk.

set seeds {}
for { set i 0 } { $i < $::e12_k } { incr i } {
  lappend seeds $i
}
if { $::e12_serial_threads > 0 } {
  set shape "serial with $::e12_serial_threads threads"
  if { !$::e12_have_fork } {
    append shape " (fork unavailable in this bazel-orfs pin)"
  }
} else {
  set shape "fork -jobs $::e12_jobs"
}
puts "e12: [llength $seeds] candidates, $shape"

e12_redirect spine
file copy -force $::env(ODB_FILE) \
  [file join $::env(RESULTS_DIR) 1_synth.odb]
file copy -force [file rootname $::env(ODB_FILE)].sdc \
  [file join $::env(RESULTS_DIR) 1_synth.sdc]
set t0 [clock clicks -milliseconds]
e12_step floorplan.tcl
set ::e12_prefix_s [expr { ([clock clicks -milliseconds] - $t0) / 1000.0 }]

# The base floorplan, before any candidate's macro placement: the
# clustered scorer's cluster partition is derived from this, once, and
# shared by every candidate. That sharing is what makes the reduction
# common-mode across candidates, which is what protects the ranking.
#
# Archived as the .odb/.sdc pair ORFS's own load_design expects, because
# the later steps re-enter through the ORFS stage machinery rather than
# calling read_db themselves -- a bare read_db would skip liberty and SDC
# setup and leave the ORFS helper procs undefined.
foreach ext {odb sdc} {
  file copy -force \
    [file join $::env(RESULTS_DIR) 2_1_floorplan.$ext] \
    [file join $::e12_out base_floorplan.$ext]
}

set failed {}
if { $::e12_serial_threads > 0 } {
  set_thread_count $::e12_serial_threads
  foreach seed $seeds {
    if { [catch { e12_candidate $seed } err] } {
      puts stderr "e12: candidate s$seed failed: $err"
      lappend failed s$seed
    }
    e12_reset_placement
  }
} else {
  set statuses [fork -jobs $::e12_jobs {*}$::e12_fork_opts seed $seeds {
    e12_candidate $seed
  }]
  dict for {seed code} $statuses {
    if { $code != 0 } {
      puts stderr "e12: candidate s$seed failed with status $code;\
        its outputs are missing"
      lappend failed s$seed
    }
  }
}

set scored 0
foreach seed $seeds {
  if { [file exists [file join $::e12_out cand_s$seed.json]] } {
    incr scored
  }
}
puts "e12: $scored/[llength $seeds] candidates scored,\
  prefix ${::e12_prefix_s}s"
if { $scored == 0 } {
  error "macro_e12: no candidate produced a score"
}
exit 0
