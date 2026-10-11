# Move each placed macro to the nearest origin that keeps the transistors in it
# on ASAP7's fin and gate grids - fins every 27 nm, gates every 54 nm, as every
# standard-cell row has them - and its pins on the routing tracks.  The macro
# placer snaps a macro's pins to the tracks only, so the cells of a hardened
# block land off the grids of the cells around it.
#
# A macro built in this flow holds its cells and tracks on the same grids,
# measured from its origin, as the top level does from the die's.  Along an
# axis the macro is not mirrored on, the origin is then a whole number of each
# pitch; along a mirrored one, the origin plus the macro's size is twice the
# grid's offset, modulo the pitch.
#
# Use as POST_MACRO_PLACE_TCL.

proc asap7_snap_macros_to_fin_grid { } {
  set block [ord::get_db_block]
  set tech [ord::get_db_tech]
  set core [$block getCoreArea]
  # Fin and gate centres sit half a pitch past a multiple of the pitch, so
  # twice their offset is a whole pitch.
  set gate [ord::microns_to_dbu 0.054]
  set fin [ord::microns_to_dbu 0.027]

  set macros {}
  foreach inst [$block getInsts] {
    if { [[$inst getMaster] isBlock] && [$inst isPlaced] } {
      lappend macros $inst
    }
  }

  foreach inst $macros {
    set master [$inst getMaster]
    set orient [$inst getOrient]
    switch $orient {
      R0 { set flip_x 0; set flip_y 0 }
      MX { set flip_x 0; set flip_y 1 }
      MY { set flip_x 1; set flip_y 0 }
      R180 { set flip_x 1; set flip_y 1 }
      default {
        utl::warn FLW 25 "[$inst getName]: orientation $orient not snapped to the fin grid."
        continue
      }
    }
    set w [$master getWidth]
    set h [$master getHeight]

    # Constraints {pitch twice-offset} per axis: the gate and fin grids, then
    # the tracks of every routing layer the macro has pins on.
    set cons_x [list [list $gate 0]]
    set cons_y [list [list $fin 0]]
    set layers {}
    foreach mterm [$master getMTerms] {
      foreach mpin [$mterm getMPins] {
        foreach box [$mpin getGeometry] {
          set layer [$box getTechLayer]
          if { $layer != "NULL" && [$layer getType] == "ROUTING" } {
            dict set layers [$layer getName] $layer
          }
        }
      }
    }
    dict for {name layer} $layers {
      set grid [$block findTrackGrid $layer]
      if { $grid == "NULL" } {
        continue
      }
      if { [$layer getDirection] == "VERTICAL" } {
        for { set i 0 } { $i < [$grid getNumGridPatternsX] } { incr i } {
          lassign [$grid getGridPatternX $i] origin count step
          lappend cons_x [list $step [expr { 2 * $origin }]]
        }
      } else {
        for { set i 0 } { $i < [$grid getNumGridPatternsY] } { incr i } {
          lassign [$grid getGridPatternY $i] origin count step
          lappend cons_y [list $step [expr { 2 * $origin }]]
        }
      }
    }

    set loc [$inst getLocation]
    set x [asap7_snap_axis [lindex $loc 0] $w $flip_x $cons_x]
    set y [asap7_snap_axis [lindex $loc 1] $h $flip_y $cons_y]
    if { $x == "" || $y == "" } {
      # The tracks disagree with each other or with the fin grid: keep the
      # fin and gate grids, which the cells need, and say so.
      utl::warn FLW 26 "[$inst getName]: no origin puts both its pins on the\
        tracks and its cells on the fin grid; snapping to the fin grid only."
      set x [asap7_snap_axis [lindex $loc 0] $w $flip_x [lrange $cons_x 0 0]]
      set y [asap7_snap_axis [lindex $loc 1] $h $flip_y [lrange $cons_y 0 0]]
    }
    set dx [expr { $x - [lindex $loc 0] }]
    set dy [expr { $y - [lindex $loc 1] }]
    # The macro placer leaves its macros LOCKED, which setLocation refuses.
    set status [$inst getPlacementStatus]
    $inst setPlacementStatus PLACED
    $inst setLocation $x $y
    $inst setPlacementStatus $status
    set bbox [$inst getBBox]
    if {
      [$bbox xMin] < [$core xMin] || [$bbox yMin] < [$core yMin]
      || [$bbox xMax] > [$core xMax] || [$bbox yMax] > [$core yMax]
    } {
      utl::warn FLW 27 "[$inst getName] lies outside the core after snapping."
    }
    puts "Snapped [$inst getName] ($orient) to the fin grid by\
      ([ord::dbu_to_microns $dx], [ord::dbu_to_microns $dy]) um"
  }

  # Snapping moves each macro by under a pitch's worth; make sure that did not
  # push one onto another.
  foreach a $macros {
    foreach b $macros {
      if { [$a getName] >= [$b getName] } {
        continue
      }
      set ra [$a getBBox]
      set rb [$b getBBox]
      if {
        [$ra xMin] < [$rb xMax] && [$rb xMin] < [$ra xMax]
        && [$ra yMin] < [$rb yMax] && [$rb yMin] < [$ra yMax]
      } {
        utl::warn FLW 28 "[$a getName] and [$b getName] overlap after snapping."
      }
    }
  }
}

# The origin nearest `origin` (DBU) along one axis that meets every constraint
# {pitch twice-offset}: origin = 0 (mod pitch) unmirrored, origin + size =
# twice-offset (mod pitch) mirrored.  Empty if none does within the lcm.
proc asap7_snap_axis { origin size mirrored cons } {
  set period 1
  foreach c $cons {
    set period [asap7_lcm $period [lindex $c 0]]
  }
  for { set d 0 } { $d <= $period } { incr d } {
    foreach cand [list [expr { $origin - $d }] [expr { $origin + $d }]] {
      set ok 1
      foreach c $cons {
        lassign $c pitch twice
        set want [expr { $mirrored ? ($twice - $size) % $pitch : 0 }]
        if { ($cand - $want) % $pitch != 0 } {
          set ok 0
          break
        }
      }
      if { $ok } {
        return $cand
      }
    }
  }
  return ""
}

proc asap7_lcm { a b } {
  set x $a
  set y $b
  while { $y != 0 } {
    set t [expr { $x % $y }]
    set x $y
    set y $t
  }
  return [expr { $a / $x * $b }]
}

asap7_snap_macros_to_fin_grid
