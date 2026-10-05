# Stage art snapshots: small JSON dumps of what a stage did, rendered by
# util/stage_art.py into a picture at the end of the stage log.
#
# Each probe reads the in-memory design through plain odb/sta/grt calls,
# so it works in a GUI-less build, and caps its output to a fixed grid so
# the snapshot stays a few KB regardless of design size.

# What each stage snapshots, by log stem; a failed stage snapshots the
# same, as the design was when the error hit. Every stage flow.sh runs is
# listed: a stage missing here is an error, not a silently empty summary.
set ::stage_art_probes [dict create \
  1_synth {timing} \
  1_3_floorplan_to_place {} \
  2_1_floorplan {timing} \
  2_2_floorplan_macro {} \
  2_3_floorplan_tapcell {} \
  2_4_floorplan_pdn {} \
  3_1_place_gp_skip_io {} \
  3_2_place_iop {} \
  3_3_place_gp {timing} \
  3_4_place_resized {timing} \
  3_5_place_dp {timing} \
  4_1_cts {timing} \
  5_1_grt {timing} \
  5_2_route {} \
  5_3_fillcell {} \
  6_1_fill {} \
  6_report {timing}]

proc stage_art_json_str { s } {
  return "\"[string map {\\ \\\\ \" \\\" \n \\n \r {} \t { }} $s]\""
}

# Tcl doubles print as e.g. "Inf" or "1e+30"; JSON wants null for those.
proc stage_art_json_num { v } {
  if { ![string is double -strict $v] || abs($v) >= 1e29 } {
    return null
  }
  return $v
}

proc stage_art_timing { } {
  if { [llength [all_clocks]] == 0 } {
    return null
  }
  set fields {}
  foreach {name min_max} {setup max hold min} {
    lappend fields [format \
      {%s: {"ws": %s, "tns": %s, "violators": %d}} \
      [stage_art_json_str $name] \
      [stage_art_json_num [sta::time_sta_ui [sta::worst_slack_cmd $min_max]]] \
      [stage_art_json_num [sta::time_sta_ui [sta::total_negative_slack_cmd $min_max]]] \
      [sta::endpoint_violation_count $min_max]]
  }
  set periods [lmap clk [all_clocks] { get_property $clk period }]
  lappend fields "\"period\": [stage_art_json_num [tcl::mathfunc::min {*}$periods]]"
  lappend fields "\"time_unit\": [stage_art_json_str [sta::unit_scale_abbrev_suffix time]]"
  return "{[join $fields {, }]}"
}

proc stage_art_version { } {
  set version [ord::openroad_git_describe]
  if { $version == "" } {
    set version [ord::openroad_version]
  }
  return $version
}

# Writes $REPORTS_DIR/<stage>.art.json. `error` is the Tcl error message
# when the stage failed, else empty. A probe that itself fails is
# recorded as an error string rather than hiding the stage's own result.
proc stage_art_snapshot { stage { error "" } } {
  set block [ord::get_db_block]
  set probes [dict get $::stage_art_probes $stage]
  # Design and platform too, so the snapshot renders on its own later,
  # e.g. from build outputs without the flow's environment.
  set fields [list \
    "\"stage\": [stage_art_json_str $stage]" \
    "\"design\": [stage_art_json_str $::env(DESIGN_NICKNAME)]" \
    "\"platform\": [stage_art_json_str $::env(PLATFORM)]" \
    "\"variant\": [stage_art_json_str $::env(FLOW_VARIANT)]" \
    "\"error\": [stage_art_json_str $error]" \
    "\"openroad\": [stage_art_json_str [stage_art_version]]" \
    "\"threads\": [ord::thread_count]"]
  if { $block != "NULL" } {
    foreach probe $probes {
      if { [catch { stage_art_$probe } value] } {
        set value "{\"probe_error\": [stage_art_json_str $value]}"
      }
      lappend fields "[stage_art_json_str $probe]: $value"
    }
  }
  set f [open $::env(REPORTS_DIR)/$stage.art.json w]
  puts $f "{[join $fields ",\n "]}"
  close $f
}
