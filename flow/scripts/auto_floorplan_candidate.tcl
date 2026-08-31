# One AUTO_FLOORPLAN candidate, evaluated in its own OpenROAD process.
#
# Launched by auto_floorplan.tcl as
#   openroad -exit -no_init auto_floorplan_candidate.tcl
# with the parent's environment plus the AF_* overrides below. Writes a
# one-line JSON result to $AF_RESULT and exits 0; any failure exits
# non-zero and the driver eliminates the candidate.
#
# Why a subprocess rather than fork or an in-process loop:
#   - rtl_macro_placer is not re-entrant in a single process (the
#     physical hierarchy tree is destroyed at the end of run() and only
#     built in the constructor -- OpenROAD#11277), and every candidate
#     that changes the outline or the target utilization must re-place
#     the macros. A fresh process sidesteps that entirely.
#   - the parent's ODB stays untouched, so "only the winner commits"
#     holds by construction: the committed floorplan is produced by the
#     ordinary stage code at the winning coordinates, not carried over
#     from a scoring run.
#   - candidates are embarrassingly parallel and the driver can simply
#     bound how many run at once.
# The cost is re-reading 1_synth.odb per candidate, which is seconds.
#
# Inputs (environment):
#   AF_UTIL, AF_ASPECT, AF_MARGIN   the outline to try
#   AF_DENSITY                      resolved placement density, or empty
#                                   to let the candidate compute the
#                                   measured lower bound and add AF_ADDON
#   AF_ADDON                        headroom fraction above the lower bound
#   AF_WORK                         scratch dir for this candidate
#   AF_RESULT                       JSON output path
#   AF_SRC_RESULTS                  the real RESULTS_DIR, holding 1_synth.*

source $::env(SCRIPTS_DIR)/load.tcl
source $::env(SCRIPTS_DIR)/sample_paths.tcl

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

# Re-entrancy guard: floorplan.tcl sources the driver only when
# AUTO_FLOORPLAN is enabled. A candidate must run the *ordinary* stage,
# or it would race inside the race.
set ::env(AUTO_FLOORPLAN) 0

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

# Density: either handed down resolved, or computed here from the
# measured lower bound once core rows exist (gpl::get_global_placement_
# uniform_density needs them, so it cannot be evaluated before the
# floorplan). PLACE_DENSITY_LB_ADDON is unset either way -- the driver
# owns that decision now.
if { [info exists ::env(PLACE_DENSITY_LB_ADDON)] } {
  unset ::env(PLACE_DENSITY_LB_ADDON)
}

set af_t0 [clock milliseconds]

# --- floorplan -----------------------------------------------------------
# The real stage script, so the candidate sees production behaviour
# (tracks, routing layer adjustment, netlist repair, everything).
source $::env(SCRIPTS_DIR)/floorplan.tcl

set af_t_fp [clock milliseconds]

# Resolve the density now that core rows exist.
set af_density [af_env AF_DENSITY]
if { $af_density eq "" } {
  set af_lb [gpl::get_global_placement_uniform_density \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)]
  set af_addon [af_env AF_ADDON 0.0]
  set af_density [expr { $af_lb + ((1.0 - $af_lb) * $af_addon) + 0.01 }]
} else {
  set af_lb -1
}
set ::env(PLACE_DENSITY) $af_density

# A density at or above 1.0 is not a candidate, it is an error the
# ordinary flow would raise (FLW-24). Eliminate it here instead.
if { $af_density >= 1.0 } {
  set f [open $::env(AF_RESULT) w]
  puts $f [list ok 0 reason "density $af_density >= 1.0"]
  close $f
  exit 0
}

# --- macro placement -----------------------------------------------------
# Skipped by the stage script itself when the design has no macros.
source $::env(SCRIPTS_DIR)/macro_place.tcl

set af_t_mp [clock milliseconds]

# --- pins + report-only global placement ---------------------------------
# This is the scorer. Non-timing-driven and non-routability-driven on
# purpose: the estimation-ladder work found timing-driven mode adds noise
# without improving the ability to compare, and the point here is
# ranking, not absolute accuracy. Nothing is written back.
if { [env_var_exists_and_non_empty IO_CONSTRAINTS] } {
  source $::env(IO_CONSTRAINTS)
}

set af_gp0 [clock milliseconds]
# AF_SEED lets the driver re-run one candidate under different placer
# seeds to measure this design's own noise floor, which is what makes
# delta_tie a measurement rather than a guessed threshold.
#
# -place_ios rather than an explicit place_pins: IO_PLACER_H/V are
# place-stage variables and erase_non_stage_variables has already removed
# them by the time the floorplan stage runs, so a candidate cannot see
# them. It is also the better answer -- per-candidate pin adaptation
# mirrors production (io_placement runs after macro placement), and
# off-track pins do not matter to a ranking scalar. Whether -place_ios
# costs ranking accuracy versus pre-placed pins is an open question in
# the estimation-ladder work; it is recorded here so the choice is not
# mistaken for a settled one.
log_cmd global_placement -density $af_density \
  -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
  -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
  -random_seed [af_env AF_SEED 1] \
  -place_ios \
  -force_center_initial_place
set af_gp1 [clock milliseconds]

# --- repair rung ---------------------------------------------------------
# The scoring placement alone is blind to the half of the answer that
# matters most here. PLACE_DENSITY's headroom exists for growth the flow
# has not committed yet -- repair_design's buffer insertion and gate
# upsizing above all -- and a proxy that stops at global placement cannot
# see any of it. Measured on gcd without this rung, the score improved
# monotonically as the core shrank (330.4 -> 325.7 across the utilization
# ladder, against a delta_tie of 0.46) while the flow's TNS at finish got
# 2.2x worse: a rank inversion, and exactly the one auto-floorplan.md
# predicts if the scorer is blind to repair growth.
#
# So run the production repair. resize.tcl is the reference for what that
# means; it cannot be sourced directly (it re-reads 3_3_place_gp.odb and
# re-scopes the variables), so the same helper is called on the design
# already in memory. repair_timing is deliberately not run:
# ENABLE_PLACE_REPAIR_TIMING defaults to 0, so production does not run it
# here either, and matching production is the point of this rung.
#
# The growth this exposes is recorded next to the score. It is the
# quantity PLACE_DENSITY_LB_ADDON was always a guess at, so having it as
# a measurement is worth as much as the ranking it fixes.
set af_t_rep0 [clock milliseconds]
set af_inst_before [sta::network_leaf_instance_count]
set af_pin_before [sta::network_leaf_pin_count]
set af_area_before [dict get [af_design_area] stdcell_um2]

if { [af_env AF_REPAIR 1] ne "0" } {
  estimate_parasitics -placement
  if { [env_var_exists_and_non_empty DONT_USE_CELLS] } {
    set_dont_use $::env(DONT_USE_CELLS)
  }
  repair_design_helper
}

set af_inst_after [sta::network_leaf_instance_count]
set af_area_after [dict get [af_design_area] stdcell_um2]
set af_growth [expr {
  $af_area_before > 0
  ? ($af_area_after - $af_area_before) / $af_area_before
  : 0.0
}]
set af_t_rep1 [clock milliseconds]
set af_growth_pct [format %.1f [expr { 100.0 * $af_growth }]]
puts "AUTO_FLOORPLAN: repair grew std-cell area by ${af_growth_pct}%\
 ($af_inst_before -> $af_inst_after instances)"

# --- global route rung ---------------------------------------------------
# estimate_parasitics -placement prices wires by an ideal-length estimate,
# so a placement score built on it is blind to routing congestion -- and
# congestion is what a denser core actually buys you. Measured on gcd:
# the placement-only score improved monotonically as the core shrank
# (330.4 -> 325.7 across the utilization ladder, 10x the 0.46 noise
# floor), while at finish the flow's detailed-route wirelength was +59%
# and TNS 2.2x worse. The repair rung above did not explain it: gcd's
# instance count is unchanged by repair_design, 304 -> 304.
#
# So price the wires the way the flow does, with the flow's own element:
# global_route, then estimate_parasitics -global_routing, which is
# exactly the pair global_route.tcl runs.
#
# A candidate whose global route fails is eliminated rather than scored.
# That is not a workaround, it is the guard doing its job: a floorplan
# that cannot be routed is not a cheap floorplan.
#
# This is the expensive rung, and it is on by default because fidelity is
# what makes the ranking mean anything. AF_GRT=0 falls back to the
# placement-only estimate for a cheaper, less faithful race.
set af_t_grt0 [clock milliseconds]
set af_grt_ok 1
if { [af_env AF_GRT 1] ne "0" } {
  if { [catch { log_cmd global_route } af_grt_err] } {
    set af_grt_ok 0
    puts "AUTO_FLOORPLAN: global route failed: $af_grt_err"
  } else {
    log_cmd estimate_parasitics -global_routing
  }
}
set af_t_grt1 [clock milliseconds]

if { !$af_grt_ok } {
  set f [open $::env(AF_RESULT) w]
  puts $f [list ok 0 reason "global route failed"]
  close $f
  exit 0
}

# --- score ---------------------------------------------------------------
if { [af_env AF_GRT 1] eq "0" } {
  estimate_parasitics -placement
}
set_propagated_clock [all_clocks]
set af_sampled [af_sample_paths]
set af_score [af_score_from_paths $af_sampled]
set af_macro_score [af_macro_score_from_paths $af_sampled]
set af_area [af_design_area]

# Post-placement utilization is the feasibility guard the driver applies:
# a candidate whose cells do not fit is not a cheaper floorplan, it is a
# floorplan that will fail downstream.
set af_util_post [expr {
  ([dict get $af_area stdcell_um2] +
    [dict get $af_area macro_um2]) /
  [dict get $af_area core_um2]
}]

set af_t1 [clock milliseconds]

# The driver is also Tcl, so hand it a Tcl dict rather than JSON parsed
# back out with a regex. A dict literal round-trips exactly, needs no
# parser, and cannot be corrupted by quoting -- an earlier JSON+regexp
# version silently mangled long float fields once the record grew.
set af_rec [list \
  ok 1 \
  util $::env(AF_UTIL) \
  aspect $::env(AF_ASPECT) \
  margin $::env(AF_MARGIN) \
  density $af_density \
  density_lb $af_lb \
  addon [af_env AF_ADDON -1] \
  seed [af_env AF_SEED 1] \
  score $af_score \
  macro_score $af_macro_score \
  degraded [dict get $af_sampled degraded] \
  n_paths [dict get $af_sampled n_paths] \
  wns [dict get $af_sampled wns] \
  clock_period [dict get $af_sampled clock_period] \
  core_um2 [dict get $af_area core_um2] \
  stdcell_um2 [dict get $af_area stdcell_um2] \
  macro_um2 [dict get $af_area macro_um2] \
  util_post $af_util_post \
  repair_growth $af_growth \
  inst_before $af_inst_before \
  inst_after $af_inst_after \
  repair_ms [expr { $af_t_rep1 - $af_t_rep0 }] \
  grt_ms [expr { $af_t_grt1 - $af_t_grt0 }] \
  floorplan_ms [expr { $af_t_fp - $af_t0 }] \
  macro_place_ms [expr { $af_t_mp - $af_t_fp }] \
  gpl_ms [expr { $af_gp1 - $af_gp0 }] \
  total_ms [expr { $af_t1 - $af_t0 }]]

set f [open $::env(AF_RESULT) w]
puts $f $af_rec
close $f

exit 0
