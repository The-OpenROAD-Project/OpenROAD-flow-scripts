# The pins of tpu's two macros, the tile (tpu_block) and the parent built
# around the tiles (tpu_rest): IO_CONSTRAINTS of both.
#
# Every pin is placed by rule, from constants here, before anything is
# built, so the tile and the parent agree without either reading the
# other: a tile's pin and its partner on the opposite edge sit at one
# offset, on asap7 tracks every macro placed on the 0.144 x 2.16 um
# lattice shares (M3 and M5 on the north and south edges, M4 on the west
# and east). The parent's pin for a tile pin is the tile's mirrored
# across the edge they share, so the two touch there.

namespace eval tpu_io {
# the tile, and the parent's notch that holds 4 x 4 of them
variable tile_w 24.336
variable tile_h 25.92
variable notch {6.336 10.8 103.68 114.48}
# each side's ports in order, bit 0 first, with their widths; west and
# east are partners slot by slot, and north and south
variable sides {
    west {a_in 16 clk 1 rst 1 w_valid 1}
    east {a_out 16 clk_out 1 rst_out 1 w_valid_out 1}
    north {w_in 16 psum_in 64}
    south {w_out 16 psum_out 64 clk_south 1}
  }
# asap7's make_tracks: offset, pitch and wire width, um
variable tracks {M3 {0.009 0.036 0.018} M4 {0.012 0.048 0.024} M5 {0.012 0.048 0.024}}
variable length 0.12
variable corner 1.0
}

proc tpu_io::bits { ports } {
  set out {}
  foreach {name width} $ports {
    if { $width == 1 } {
      lappend out $name
    } else {
      for { set i 0 } { $i < $width } { incr i } {
        lappend out "$name\[$i\]"
      }
    }
  }
  return $out
}

proc tpu_io::snap { layer v } {
  variable tracks
  lassign [dict get $tracks $layer] off pitch
  return [expr { round(($off + round(($v - $off) / $pitch) * $pitch) * 1000) / 1000.0 }]
}

# Every tile pin: name -> {side layer x0 y0 x1 y1}, in tile um.
proc tpu_io::plan { } {
  variable tile_w
  variable tile_h
  variable sides
  variable tracks
  variable length
  variable corner
  set plan [dict create]
  foreach {a b span vertical} [list west east $tile_h 0 north south $tile_w 1] {
    set pa [bits [dict get $sides $a]]
    set pb [bits [dict get $sides $b]]
    set n [expr { max([llength $pa], [llength $pb]) }]
    set step [expr { ($span - 2 * $corner) / $n }]
    for { set i 0 } { $i < $n } { incr i } {
      set layer [expr { $vertical ? [lindex {M3 M5} [expr { $i % 2 }]] : "M4" }]
      set at [snap $layer [expr { $corner + $step * ($i + 0.5) }]]
      set half [expr { [lindex [dict get $tracks $layer] 2] / 2.0 }]
      foreach side [list $a $b] pins [list $pa $pb] {
        if { $i >= [llength $pins] } { continue }
        if { $vertical } {
          set y0 [expr { $side eq "south" ? 0 : $tile_h - $length }]
          set rect [list [expr { $at - $half }] $y0 [expr { $at + $half }] [expr { $y0 + $length }]]
        } else {
          set x0 [expr { $side eq "west" ? 0 : $tile_w - $length }]
          set rect [list $x0 [expr { $at - $half }] [expr { $x0 + $length }] [expr { $at + $half }]]
        }
        dict set plan [lindex $pins $i] [list $side $layer {*}$rect]
      }
    }
  }
  return $plan
}

proc tpu_io::place { name layer x y w h } {
  place_pin -pin_name $name -layer $layer -location [list $x $y] -pin_size [list $w $h]
}

# The tile: every pin where the plan has it.
proc tpu_io::tile { } {
  dict for {pin p} [plan] {
    lassign $p side layer x0 y0 x1 y1
    place $pin $layer [expr { ($x0 + $x1) / 2.0 }] [expr { ($y0 + $y1) / 2.0 }] \
      [expr { $x1 - $x0 }] [expr { $y1 - $y0 }]
  }
  puts "tpu_io.tcl: [dict size [plan]] tile pins planned"
}

# The parent: the whole die, the notch kept for the tiles.
proc tpu_io::parent { } {
  variable tile_w
  variable tile_h
  variable notch
  set block [ord::get_db_block]
  set tech [ord::get_db_tech]
  set dbu [$tech getDbUnitsPerMicron]
  lassign [lmap v $notch { expr { int(round($v * $dbu)) } }] nx0 ny0 nx1 ny1
  # nothing placed or routed in the notch
  odb::dbBlockage_create $block $nx0 $ny0 $nx1 $ny1
  foreach layer [$tech getLayers] {
    if { [$layer getType] eq "ROUTING" } {
      odb::dbObstruction_create $block $layer $nx0 $ny0 $nx1 $ny1
    }
  }
  # no row in the notch or within 0.54 um of it, room for the wires to
  # the tiles' pins: rows that cross it are split at its edges
  set halo [expr { int(round(0.54 * $dbu)) }]
  foreach row [$block getRows] {
    set b [$row getBBox]
    if { [$b yMax] <= $ny0 - $halo || [$b yMin] >= $ny1 + $halo } { continue }
    if { [$b xMax] <= $nx0 - $halo || [$b xMin] >= $nx1 + $halo } { continue }
    set site [$row getSite]
    set sw [$site getWidth]
    lassign [$row getOrigin] ox oy
    set name [$row getName]
    set orient [$row getOrient]
    set end [$b xMax]
    odb::dbRow_destroy $row
    set n [expr { ($nx0 - $halo - $ox) / $sw }]
    if { $n > 0 } {
      odb::dbRow_create $block ${name}_w $site $ox $oy $orient HORIZONTAL $n $sw
    }
    set x1 [expr { $ox + (($nx1 + $halo - $ox + $sw - 1) / $sw) * $sw }]
    set n [expr { ($end - $x1) / $sw }]
    if { $n > 0 } {
      odb::dbRow_create $block ${name}_e $site $x1 $oy $orient HORIZONTAL $n $sw
    }
  }
  # each port for a tile pin, u_b<row>_<col>__<pin>, the tile's pin
  # mirrored across their shared edge: the two touch there, and the
  # parent's lies outside the notch, where its router reaches it
  set plan [plan]
  set own {}
  set placed 0
  foreach bt [$block getBTerms] {
    set name [$bt getName]
    if { ![regexp {^u_b(\d+)_(\d+)__(.+)$} $name -> r c pin] } {
      lappend own $name
      continue
    }
    if { ![dict exists $plan $pin] } { error "tpu_io.tcl: $name: the tile has no pin $pin" }
    lassign [dict get $plan $pin] side layer x0 y0 x1 y1
    set cx [expr { ($x0 + $x1) / 2.0 }]
    set cy [expr { ($y0 + $y1) / 2.0 }]
    switch $side {
      south { set cy [expr { -$cy }] }
      north { set cy [expr { 2 * $tile_h - $cy }] }
      west { set cx [expr { -$cx }] }
      east { set cx [expr { 2 * $tile_w - $cx }] }
    }
    place $name $layer [expr { [lindex $notch 0] + $c * $tile_w + $cx }] \
      [expr { [lindex $notch 3] - ($r + 1) * $tile_h + $cy }] \
      [expr { $x1 - $x0 }] [expr { $y1 - $y0 }]
    incr placed
  }
  # tpu's own ports on its bottom edge; the weights at its west end, so
  # the global router's box for each reaches round the notch, up the C's
  # west side to its top side
  set west [lsearch -all -inline -regexp $own {^w_data}]
  set own [lsearch -all -inline -not -regexp $own {^w_data}]
  set_io_pin_constraint -region bottom:0-[expr { 2 * [lindex $notch 0] }] -pin_names $west
  set_io_pin_constraint -region bottom:* -pin_names $own
  # a path from port to port is one wire through the parent: the buffer
  # synthesis put between the ports goes, and repair leaves the net
  # alone, rather than buffer it along a line through the notch
  set through 0
  foreach inst [$block getInsts] {
    if { ![string match "BUF*" [[$inst getMaster] getName]] } { continue }
    set in ""
    set out ""
    foreach it [$inst getITerms] {
      set net [$it getNet]
      if { $net eq "NULL" || [$net getSigType] ne "SIGNAL" } { continue }
      if { [$it isInputSignal] } { set in $net }
      if { [$it isOutputSignal] } { set out $net }
    }
    if { $in eq "" || $out eq "" } { continue }
    if { [llength [$in getITerms]] != 1 || [llength [$in getBTerms]] != 1 } { continue }
    if { [llength [$out getITerms]] != 1 || [llength [$out getBTerms]] != 1 } { continue }
    set bt [lindex [$out getBTerms] 0]
    odb::dbInst_destroy $inst
    $bt connect $in
    odb::dbNet_destroy $out
    $in setDoNotTouch 1
    incr through
  }
  puts "tpu_io.tcl: $placed tile pins in the notch, [llength $own] on the\
    bottom edge, [llength $west] at its west end, $through feed-throughs kept whole"
}

switch [[ord::get_db_block] getName] {
  tpu_block { tpu_io::tile }
  tpu_rest { tpu_io::parent }
  default { error "tpu_io.tcl: for tpu_block and tpu_rest, not [[ord::get_db_block] getName]" }
}
