# One floorplan candidate: the production flow, floorplan to finish, run
# against one set of floorplan coordinates in its own OpenROAD process.
#
# Launched by auto_floorplan.tcl with the derivation's environment plus
# the AF_* overrides below. Writes a Tcl dict to $AF_RESULT and exits 0;
# a failure of the flow is recorded as an eliminated candidate rather
# than a crash, because a floorplan that cannot be built is a legitimate
# answer about that floorplan.
#
# THE ORACLE IS THE FLOW
#
# An earlier version scored candidates with a fast pre-route proxy --
# global placement plus a sampled-path timing readout. Measured against
# the finished flow over a utilization ladder, that proxy did not rank:
# rho = -1.000 on gcd (perfectly inverted) and +0.100 on gcd-ccs, the two
# designs whose noise floor is small enough for the question to have an
# answer. So the derivation asks the flow itself and pays for it, which
# is what ideas/auto-floorplan.md meant by "the race is the oracle inside
# a utilization shmoo".
#
# Why a subprocess per candidate rather than fork or an in-process loop:
#   - rtl_macro_placer is not re-entrant in a single process
#     (OpenROAD#11277), and every candidate re-places the macros.
#   - the parent's database stays untouched.
#   - candidates are embarrassingly parallel, and the driver bounds how
#     many run at once. Bazel would provision one core per action, so the
#     fan-out is ours to control rather than the build system's.
#
# Synthesis is shared: every candidate starts from the same 1_synth.odb,
# staged below. Re-running it per candidate would be the most expensive
# part of the walk and would measure nothing.
#
# Inputs (environment):
#   AF_UTIL, AF_ASPECT, AF_MARGIN   the outline to try
#   AF_ADDON                        headroom fraction above the measured
#                                   density lower bound
#   AF_SEED                         placer seed, for the noise floor walk
#   AF_WORK                         scratch dir for this candidate
#   AF_RESULT                       result dict output path
#   AF_SRC_RESULTS                  the shared RESULTS_DIR, holding 1_synth.*

source $::env(SCRIPTS_DIR)/load.tcl

proc af_env { name { default "" } } {
  if { [info exists ::env($name)] && $::env($name) ne "" } {
    return $::env($name)
  }
  return $default
}

set af_work $::env(AF_WORK)
file mkdir $af_work

# Redirect every output the stage scripts write into this candidate's own
# scratch dir, so nothing lands in the real results/reports/logs tree.
# Seed it with the synthesis outputs the floorplan stage reads.
foreach { var sub } { RESULTS_DIR results REPORTS_DIR reports LOG_DIR logs OBJECTS_DIR objects } {
  set d [file join $af_work $sub]
  file mkdir $d
  set ::env($var) $d
}
foreach f { 1_synth.odb 1_synth.sdc } {
  file copy -force [file join $::env(AF_SRC_RESULTS) $f] \
    [file join $::env(RESULTS_DIR) $f]
}

# Feed the candidate coordinates in through the same variables a
# config.mk would set, so the production stage code is what runs.
# Anything that would select a different init method has to go.
set ::env(CORE_UTILIZATION) $::env(AF_UTIL)
set ::env(CORE_ASPECT_RATIO) $::env(AF_ASPECT)
set ::env(CORE_MARGIN) $::env(AF_MARGIN)
foreach v { DIE_AREA CORE_AREA FLOORPLAN_DEF FOOTPRINT } {
  if { [info exists ::env($v)] } {
    unset ::env($v)
  }
}

set af_t0 [clock milliseconds]

# --- density -------------------------------------------------------------
# Hand the candidate its headroom fraction and let production resolve it.
# place_density_with_lb_addon() computes the measured lower bound once core
# rows exist and adds the addon; doing that here instead would be a second
# implementation of the same rule, and would resolve it against a different
# placement state than the one global placement actually sees.
#
# The resolved value is captured by wrapping the proc rather than recomputed
# afterwards, so what is recorded is exactly the density production used.
set ::env(PLACE_DENSITY_LB_ADDON) [af_env AF_ADDON 0.0]
if { [info exists ::env(PLACE_DENSITY)] } {
  unset ::env(PLACE_DENSITY)
}
set ::af_used_density -1
proc af_after_global_place { } {
  set ::af_used_density [place_density_with_lb_addon]
}

# Bound this candidate's own threading. Total concurrency is bazel's
# --jobs times AF_JOBS times this, and OpenROAD otherwise takes every
# core it can see, so a pool of candidates would each try to use the
# whole machine. Two is a reasonable default: most of the flow is
# single-threaded anyway, and the parallelism that matters here is
# across candidates.
set_thread_count [af_env AF_THREADS 2]

# Vary the placer seed so the noise floor measures something. Without
# this every seed runs an identical flow and 2 sigma comes out at 1e-13,
# which would make the hysteresis inert and every difference look real.
set ::env(GPL_RANDOM_SEED) [af_env AF_SEED 1]

# --- the production flow, floorplan to finish ----------------------------
# The oracle. A pre-route proxy was measured not to rank the utilization
# axis at all -- rho -1.00 on gcd against the finished flow -- so the
# derivation asks the flow itself. Every stage below is the production
# script; see auto_floorplan_flow.tcl.
if { [catch { source $::env(SCRIPTS_DIR)/auto_floorplan_flow.tcl } af_err] } {
  set f [open $::env(AF_RESULT) w]
  puts $f [list ok 0 reason "flow failed: [string map {"\n" " "} $af_err]"]
  close $f
  exit 0
}
set af_t1 [clock milliseconds]

# --- what the flow achieved ----------------------------------------------
set af_blk [ord::get_db_block]
set af_dbu [$af_blk getDbUnitsPerMicron]

proc af_rect_um { rect dbu } {
  return [list \
    [expr { [$rect xMin] / double($dbu) }] \
    [expr { [$rect yMin] / double($dbu) }] \
    [expr { [$rect xMax] / double($dbu) }] \
    [expr { [$rect yMax] / double($dbu) }]]
}
set af_die_rect [af_rect_um [$af_blk getDieArea] $af_dbu]
set af_core_rect [af_rect_um [$af_blk getCoreArea] $af_dbu]

set af_core [$af_blk getCoreArea]
set af_scale [expr { double($af_dbu) * double($af_dbu) }]
set af_core_um2 [expr { [$af_core dx] * double([$af_core dy]) / $af_scale }]

set af_stdcell_um2 0.0
set af_macro_um2 0.0
foreach inst [$af_blk getInsts] {
  set m [$inst getMaster]
  set a [expr { [$m getWidth] * double([$m getHeight]) / $af_scale }]
  if { [$m isBlock] } {
    set af_macro_um2 [expr { $af_macro_um2 + $a }]
  } elseif { [$m isCore] } {
    set af_stdcell_um2 [expr { $af_stdcell_um2 + $a }]
  }
}

# The achieved period, post-route: clock - WNS. Never WNS on its own --
# it lives near zero, so a fractional change in it means nothing.
set af_clk 0
set af_wns 0
set af_clks [get_clocks]
if { [llength $af_clks] > 0 } {
  set af_clk [get_property [lindex $af_clks 0] period]
}
if { ![catch { sta::worst_slack_cmd "max" } af_ws] && abs($af_ws) < 1.0e20 } {
  set af_wns [sta::time_sta_ui $af_ws]
}

# DRC: detail_route.tcl writes its violations to a report; an empty or
# absent file is zero. A candidate with DRCs is not a cheaper floorplan.
set af_drc 0
set af_drc_rpt [file join $::env(REPORTS_DIR) 5_route_drc.rpt]
if { [file exists $af_drc_rpt] } {
  set fh [open $af_drc_rpt r]
  set af_drc [regexp -all {violation type:} [read $fh]]
  close $fh
}

set af_rec [list \
  ok 1 \
  util [af_env AF_UTIL -1] \
  aspect [af_env AF_ASPECT -1] \
  margin [af_env AF_MARGIN -1] \
  addon [af_env AF_ADDON -1] \
  density $::af_used_density \
  seed [af_env AF_SEED 1] \
  clock_period $af_clk \
  wns $af_wns \
  achieved [expr { $af_clk - $af_wns }] \
  core_um2 $af_core_um2 \
  stdcell_um2 $af_stdcell_um2 \
  macro_um2 $af_macro_um2 \
  die_rect $af_die_rect \
  core_rect $af_core_rect \
  drc $af_drc \
  total_ms [expr { $af_t1 - $af_t0 }]]

set f [open $::env(AF_RESULT) w]
puts $f $af_rec
close $f

exit 0
