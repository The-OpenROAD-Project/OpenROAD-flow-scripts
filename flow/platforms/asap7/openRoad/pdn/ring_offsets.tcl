# Core offsets {left bottom right top} for an add_pdn_ring on hlayer (horizontal,
# width hwidth) and vlayer (vertical, width vwidth) that centre every ring wire
# on its layer's routing tracks, so its edges also fall on the ASAP7 routing grid.
# Each offset is at least min_offset.  The ring's width plus spacing on each
# layer must be a whole number of track pitches for the outer rings to stay on
# the tracks too.  Tracks must exist (make_tracks) before this is called.
proc asap7_ring_core_offsets { hlayer hwidth vlayer vwidth min_offset } {
  set block [ord::get_db_block]
  set tech [ord::get_db_tech]
  set core [$block getCoreArea]
  set min [ord::microns_to_dbu $min_offset]

  set offsets {}
  foreach { layer width axis lo hi } [list \
      $vlayer $vwidth X [$core xMin] [$core xMax] \
      $hlayer $hwidth Y [$core yMin] [$core yMax]] {
    set grid [$block findTrackGrid [$tech findLayer $layer]]
    lassign [$grid getGridPattern$axis 0] origin count step
    set w [ord::microns_to_dbu $width]
    # The low edge of a wire centred on a track, modulo the track pitch.
    set residue [expr { ($origin - $w / 2) % $step }]

    # Low side: the wire's low edge is lo - offset - w.
    set edge [expr { $lo - $min - $w }]
    set edge [expr { $edge - (($edge - $residue) % $step) }]
    set low_offset [expr { $lo - $w - $edge }]

    # High side: the wire's low edge is hi + offset.
    set edge [expr { $hi + $min }]
    set edge [expr { $edge + (($residue - $edge) % $step) }]
    set high_offset [expr { $edge - $hi }]

    lappend offsets $low_offset $high_offset
  }
  lassign $offsets left right bottom top
  return [lmap v [list $left $bottom $right $top] { ord::dbu_to_microns $v }]
}
