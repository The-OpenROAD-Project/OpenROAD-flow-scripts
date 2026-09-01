# E12 truth measurement: carry one candidate through the entire
# production tail and report what the flow actually delivered.
#
# This is the ground truth every score is graded against, and the reason
# it must be the whole tail rather than a shortcut: a scorer that only
# has to beat a placement-time estimate can be right for the wrong
# reasons. repair_design, repair_timing, CTS and global routing all get
# to respond to a macro placement, so the difference between a score and
# this number is the price of predicting instead of running.
#
# The stage sequence mirrors flow.tcl, entered at the point a candidate
# archive begins: the candidate .odb is ORFS's 2_2_floorplan_macro
# output, so the tail is tapcell through global_route. Reusing ORFS's own
# stage scripts rather than reimplementing them is what makes this the
# production tail and not an approximation of one.
#
# Report-only, like the scorers: WRITE_ODB_AND_SDC_EACH_STAGE=0 makes the
# stage scripts' own write helpers no-ops and nothing is written back.

set e12_dir [file dirname [file normalize [info script]]]
source [file join $e12_dir e12_lib.tcl]
source [file join $e12_dir extract_lib.tcl]

set ::e12_out [e12_env E12_OUT_DIR [e12_env RUN_OUTPUT_DIR ""]]
if { $::e12_out eq "" } {
  error "evaluate: set E12_OUT_DIR or declare out_dir"
}
set tag [e12_env E12_TAG ""]
if { $tag eq "" } {
  error "evaluate: set E12_TAG to the candidate tag (eg cand_s0)"
}
set ::e12_work [e12_env E12_WORK [file join $::env(WORK_HOME) e12_work]]
set cand_odb [e12_env E12_CAND_ODB [file join $::e12_out $tag.odb]]
set base_sdc [e12_env E12_BASE_SDC [file join $::e12_out base_floorplan.sdc]]
foreach f [list $cand_odb $base_sdc] {
  if { ![file exists $f] } {
    error "evaluate: missing $f"
  }
}

set ::env(KEEP_VARS) 1
set ::env(SKIP_REPORT_METRICS) 1
set ::env(WRITE_ODB_AND_SDC_EACH_STAGE) 0

e12_redirect eval_$tag
source $::env(SCRIPTS_DIR)/load.tcl

set stem 2_2_floorplan_macro
file copy -force $cand_odb [file join $::env(RESULTS_DIR) $stem.odb]
file copy -force $base_sdc [file join $::env(RESULTS_DIR) $stem.sdc]
load_design $stem.odb $stem.sdc

# The production tail, in flow.tcl's order.
set tail {
  tapcell.tcl
  pdn.tcl
  global_place_skip_io.tcl
  io_placement.tcl
  global_place.tcl
  resize.tcl
  detail_place.tcl
  cts.tcl
  global_route.tcl
}

set t0 [clock clicks -milliseconds]
set stage_s [dict create]
foreach script $tail {
  set s [e12_step $script]
  dict set stage_s [file rootname $script] $s
}
set tail_s [expr { ([clock clicks -milliseconds] - $t0) / 1000.0 }]

# global_route.tcl leaves propagated clocks and global-routing parasitics
# in place, which is exactly the state the KPI instrument expects, so the
# measurement is of the routed design rather than a re-estimate.
set sample [extract_sample_paths]
set area [extract_design_area]

set general_sum 0.0
set general_n 0
set macro_sum 0.0
set macro_n 0
foreach pt [dict get $sample paths] {
  set period [lindex $pt 2]
  if { [lindex $pt 3] } {
    set macro_sum [expr { $macro_sum + $period }]
    incr macro_n
  } else {
    set general_sum [expr { $general_sum + $period }]
    incr general_n
  }
}

# Field names match the committed archive's `grt` block so a re-measured
# truth is a drop-in replacement for it rather than a second schema.
e12_write_leaf [file join $::e12_out $tag.grt.json] [list \
  tag $tag \
  time_unit "[sta::unit_scale_abbreviation time][sta::unit_suffix time]" \
  clock_period [dict get $sample clock_period] \
  wns [dict get $sample wns] \
  achieved [expr { [dict get $sample clock_period] - [dict get $sample wns] }] \
  general_paths_mean [expr { $general_n ? $general_sum / $general_n : 0.0 }] \
  macro_paths_mean [expr { $macro_n ? $macro_sum / $macro_n : 0.0 }] \
  general_paths $general_n \
  macro_paths $macro_n \
  stdcell_um2 [dict get $area stdcell_um2] \
  macro_um2 [dict get $area macro_um2] \
  num_stdcells [dict get $area num_stdcells] \
  num_macros [dict get $area num_macros] \
  tail_s $tail_s \
  vmhwm_kb [e12_vmhwm_kb]]

set achieved [expr { [dict get $sample clock_period] - [dict get $sample wns] }]
set macro_mean [expr { $macro_n ? $macro_sum / $macro_n : 0.0 }]
puts "e12: $tag truth achieved [format %.1f $achieved],\
  macro_paths_mean [format %.1f $macro_mean], tail ${tail_s}s"
foreach script $tail {
  set stem [file rootname $script]
  puts "e12:   [format %-24s $stem] [dict get $stage_s $stem]s"
}
exit 0
