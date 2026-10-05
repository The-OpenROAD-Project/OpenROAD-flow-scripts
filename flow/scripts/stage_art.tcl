# Stage art snapshots: small JSON dumps of what a stage did, rendered by
# util/stage_art.py into a picture at the end of the stage log.
#
# Each probe reads the in-memory design through plain odb/sta/grt calls,
# so it works in a GUI-less build, and caps its output to a fixed grid so
# the snapshot stays a few KB regardless of design size.

# Grid the die is binned into for maps; the renderer scales it to fit.
set ::stage_art_cols 64
set ::stage_art_rows 24

# What each stage snapshots, by log stem; a failed stage snapshots the
# same, as the design was when the error hit. Every stage flow.sh runs is
# listed: a stage missing here is an error, not a silently empty summary.
set ::stage_art_probes [dict create \
  1_synth {timing} \
  1_3_floorplan_to_place {} \
  2_1_floorplan {timing} \
  2_2_floorplan_macro {die macros} \
  2_3_floorplan_tapcell {} \
  2_4_floorplan_pdn {} \
  3_1_place_gp_skip_io {} \
  3_2_place_iop {} \
  3_3_place_gp {die macros density rudy timing} \
  3_4_place_resized {timing} \
  3_5_place_dp {die macros density timing} \
  4_1_cts {timing} \
  5_1_grt {die macros congestion timing} \
  5_2_route {die drc} \
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

proc stage_art_um { dbu } {
  return [expr { double($dbu) / [[ord::get_db_block] getDbUnitsPerMicron] }]
}

proc stage_art_rect { rect } {
  return [format {[%.3f, %.3f, %.3f, %.3f]} \
    [stage_art_um [$rect xMin]] [stage_art_um [$rect yMin]] \
    [stage_art_um [$rect xMax]] [stage_art_um [$rect yMax]]]
}

# Bins for the density and RUDY maps: at most the stage_art grid, and no
# smaller than four placement rows, so a bin averages over several cells
# instead of reporting single cells as 0% or 100%.
proc stage_art_bins { } {
  set block [ord::get_db_block]
  set die [$block getDieArea]
  set min_bin [expr { [$block getDbUnitsPerMicron] }]
  set rows [$block getRows]
  if { [llength $rows] > 0 } {
    set min_bin [expr { 4 * [[[lindex $rows 0] getSite] getHeight] }]
  }
  set cols [expr { max(1, min($::stage_art_cols, [$die dx] / $min_bin)) }]
  set rows [expr { max(1, min($::stage_art_rows, [$die dy] / $min_bin)) }]
  return [list $cols $rows]
}

proc stage_art_grid_json { grid_name cols rows fmt } {
  upvar 1 $grid_name grid
  set out {}
  for { set j [expr { $rows - 1 }] } { $j >= 0 } { incr j -1 } {
    set row {}
    for { set i 0 } { $i < $cols } { incr i } {
      lappend row [format $fmt $grid($i,$j)]
    }
    lappend out "\[[join $row ,]\]"
  }
  return "\[[join $out ,]\]"
}

proc stage_art_die { } {
  set block [ord::get_db_block]
  return [format {{"die": %s, "core": %s}} \
    [stage_art_rect [$block getDieArea]] [stage_art_rect [$block getCoreArea]]]
}

proc stage_art_macros { } {
  set block [ord::get_db_block]
  set macros {}
  foreach inst [$block getInsts] {
    set master [$inst getMaster]
    if { ![$master isBlock] } {
      continue
    }
    set halo [$inst getHalo]
    if { $halo != "NULL" } {
      set halo_json [stage_art_rect [$halo getBox]]
    } else {
      set halo_json null
    }
    lappend macros [format \
      {{"name": %s, "master": %s, "w": %.3f, "h": %.3f, "box": %s, "placed": %s, "halo": %s}} \
      [stage_art_json_str [$inst getName]] [stage_art_json_str [$master getName]] \
      [stage_art_um [$master getWidth]] [stage_art_um [$master getHeight]] \
      [stage_art_rect [$inst getBBox]] \
      [expr { [$inst isPlaced] ? "true" : "false" }] $halo_json]
  }
  return "\[[join $macros {, }]\]"
}

# Fraction of each die bin covered by placed standard cells, splitting
# each cell over the bins it overlaps; macros are reported separately by
# the macros probe.
proc stage_art_density { } {
  set block [ord::get_db_block]
  set die [$block getDieArea]
  lassign [stage_art_bins] cols rows
  set x0 [$die xMin]
  set y0 [$die yMin]
  set bin_w [expr { double([$die dx]) / $cols }]
  set bin_h [expr { double([$die dy]) / $rows }]
  for { set i 0 } { $i < $cols } { incr i } {
    for { set j 0 } { $j < $rows } { incr j } {
      set area($i,$j) 0.0
    }
  }
  foreach inst [$block getInsts] {
    if { ![$inst isPlaced] || [[$inst getMaster] isBlock] } {
      continue
    }
    set box [$inst getBBox]
    set bx0 [$box xMin]
    set by0 [$box yMin]
    set bx1 [$box xMax]
    set by1 [$box yMax]
    set i0 [expr { max(0, int(($bx0 - $x0) / $bin_w)) }]
    set i1 [expr { min($cols - 1, int(($bx1 - $x0) / $bin_w)) }]
    set j0 [expr { max(0, int(($by0 - $y0) / $bin_h)) }]
    set j1 [expr { min($rows - 1, int(($by1 - $y0) / $bin_h)) }]
    for { set i $i0 } { $i <= $i1 } { incr i } {
      set w [expr { min($bx1, $x0 + ($i + 1) * $bin_w) - max($bx0, $x0 + $i * $bin_w) }]
      for { set j $j0 } { $j <= $j1 } { incr j } {
        set h [expr { min($by1, $y0 + ($j + 1) * $bin_h) - max($by0, $y0 + $j * $bin_h) }]
        set area($i,$j) [expr { $area($i,$j) + max(0.0, $w) * max(0.0, $h) }]
      }
    }
  }
  set bin_area [expr { $bin_w * $bin_h }]
  foreach key [array names area] {
    set area($key) [expr { $area($key) / $bin_area }]
  }
  return [stage_art_grid_json area $cols $rows %.3f]
}

# RUDY (rectangular uniform wire density): each net's bounding-box
# half-perimeter spread uniformly over the box, the routing demand
# estimate gpl and grt use. Reported in um of wire per um^2.
proc stage_art_rudy { } {
  set block [ord::get_db_block]
  set die [$block getDieArea]
  lassign [stage_art_bins] cols rows
  set x0 [$die xMin]
  set y0 [$die yMin]
  set bin_w [expr { double([$die dx]) / $cols }]
  set bin_h [expr { double([$die dy]) / $rows }]
  for { set i 0 } { $i < $cols } { incr i } {
    for { set j 0 } { $j < $rows } { incr j } {
      set rudy($i,$j) 0.0
    }
  }
  set dbu [$block getDbUnitsPerMicron]
  foreach net [$block getNets] {
    if { [$net isSpecial] || [$net getSigType] in {POWER GROUND} } {
      continue
    }
    set box [$net getTermBBox]
    set w [expr { max([$box dx], 1) }]
    set h [expr { max([$box dy], 1) }]
    # Demand per dbu^2 of box, times the box/bin overlap below.
    set density [expr { double($w + $h) / ($w * $h) }]
    set i0 [expr { max(0, int(([$box xMin] - $x0) / $bin_w)) }]
    set i1 [expr { min($cols - 1, int(([$box xMax] - $x0) / $bin_w)) }]
    set j0 [expr { max(0, int(([$box yMin] - $y0) / $bin_h)) }]
    set j1 [expr { min($rows - 1, int(([$box yMax] - $y0) / $bin_h)) }]
    for { set i $i0 } { $i <= $i1 } { incr i } {
      set bx0 [expr { max([$box xMin], $x0 + $i * $bin_w) }]
      set bx1 [expr { min([$box xMin] + $w, $x0 + ($i + 1) * $bin_w) }]
      for { set j $j0 } { $j <= $j1 } { incr j } {
        set by0 [expr { max([$box yMin], $y0 + $j * $bin_h) }]
        set by1 [expr { min([$box yMin] + $h, $y0 + ($j + 1) * $bin_h) }]
        set rudy($i,$j) [expr {
          $rudy($i,$j)
          + $density * max(0.0, $bx1 - $bx0) * max(0.0, $by1 - $by0)
        }]
      }
    }
  }
  # dbu of wire per dbu^2 of bin -> um per um^2.
  set bin_area [expr { $bin_w * $bin_h }]
  foreach key [array names rudy] {
    set rudy($key) [expr { $rudy($key) / $bin_area * $dbu }]
  }
  return [stage_art_grid_json rudy $cols $rows %.3f]
}

# Routing usage/capacity from the gcell grid grt saves in odb: totals per
# layer, the worst gcells, and a die map of all-layer usage/capacity with
# the count of overflowing gcell-layers per bin.
proc stage_art_congestion { } {
  set block [ord::get_db_block]
  set grid [$block getGCellGrid]
  if { $grid == "NULL" } {
    return null
  }
  set xs [$grid getGridX]
  set ys [$grid getGridY]
  set nx [llength $xs]
  set ny [llength $ys]
  set cols [expr { min($::stage_art_cols, $nx) }]
  set rows [expr { min($::stage_art_rows, $ny) }]
  for { set i 0 } { $i < $cols } { incr i } {
    for { set j 0 } { $j < $rows } { incr j } {
      set bin_cap($i,$j) 0.0
      set bin_use($i,$j) 0.0
      set bin_over($i,$j) 0
    }
  }
  # Visit at most ~2M gcell-layer pairs: on huge grids sample every
  # stride-th gcell, which still finds wide hotspots.
  set routing_layers {}
  foreach layer [[ord::get_db_tech] getLayers] {
    if { [$layer getType] == "ROUTING" } {
      lappend routing_layers $layer
    }
  }
  set stride [expr { max(1, int(ceil(sqrt(double($nx) * $ny * [llength $routing_layers] / 2e6)))) }]
  set layers {}
  set hotspots {}
  foreach layer $routing_layers {
    set cap 0.0
    set use 0.0
    set over 0
    set hot 0
    set sampled 0
    set worst 0.0
    for { set x 0 } { $x < $nx } { incr x $stride } {
      set i [expr { $x * $cols / $nx }]
      for { set y 0 } { $y < $ny } { incr y $stride } {
        set c [$grid getCapacity $layer $x $y]
        set u [$grid getUsage $layer $x $y]
        set cap [expr { $cap + $c }]
        set use [expr { $use + $u }]
        set j [expr { $y * $rows / $ny }]
        set bin_cap($i,$j) [expr { $bin_cap($i,$j) + $c }]
        set bin_use($i,$j) [expr { $bin_use($i,$j) + $u }]
        if { $u > $c } {
          incr over
          incr bin_over($i,$j)
        }
        if { $c > 0 } {
          incr sampled
          set ratio [expr { $u / $c }]
          if { $ratio >= 0.8 } {
            incr hot
          }
          if { $ratio > $worst } {
            set worst $ratio
          }
          if { $ratio >= 0.8 } {
            lappend hotspots [list $ratio [$layer getName] \
              [stage_art_um [lindex $xs $x]] [stage_art_um [lindex $ys $y]]]
          }
        }
      }
    }
    if { $cap == 0 && $use == 0 } {
      continue
    }
    set fmt "{\"name\": %s, \"dir\": %s, \"capacity\": %.0f, \"usage\": %.0f, "
    append fmt "\"gcells\": %d, \"overflow_gcells\": %d, \"hot_gcells\": %d, \"worst\": %.3f}"
    lappend layers [format $fmt \
      [stage_art_json_str [$layer getName]] [stage_art_json_str [$layer getDirection]] \
      $cap $use $sampled $over $hot $worst]
  }
  set top {}
  # The worst 50; the renderer picks distinct spots among them.
  foreach h [lrange [lsort -real -decreasing -index 0 $hotspots] 0 49] {
    lassign $h ratio layer x y
    lappend top [format {{"ratio": %.3f, "layer": %s, "x": %.1f, "y": %.1f}} \
      $ratio [stage_art_json_str $layer] $x $y]
  }
  # Map: demand over capacity summed over all layers in each bin, and
  # the number of overflowing gcell-layers in it.
  foreach key [array names bin_cap] {
    set map($key) [expr { $bin_cap($key) > 0 ? $bin_use($key) / $bin_cap($key) : 0.0 }]
  }
  return [format {{"gcells": [%d, %d], "stride": %d, "layers": [%s], "hotspots": [%s], %s}} \
    $nx $ny $stride [join $layers {, }] [join $top {, }] \
    "\"map\": [stage_art_grid_json map $cols $rows %.3f],\
     \"overflow_map\": [stage_art_grid_json bin_over $cols $rows %d]"]
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

proc stage_art_drc { } {
  set block [ord::get_db_block]
  set categories {}
  foreach category [$block getMarkerCategories] {
    foreach sub [$category getMarkerCategories] {
      set boxes {}
      foreach marker [lrange [$sub getMarkers] 0 199] {
        set box [$marker getBBox]
        lappend boxes [format {[%.2f, %.2f]} \
          [stage_art_um [$box xCenter]] [stage_art_um [$box yCenter]]]
      }
      lappend categories [format {{"name": %s, "count": %d, "at": [%s]}} \
        [stage_art_json_str [$sub getName]] [$sub getMarkerCount] [join $boxes {, }]]
    }
  }
  return "\[[join $categories {, }]\]"
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
