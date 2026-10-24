# tpu's top level, macros only: the parent macro u_rest at the die's
# origin, the tiles u_b<row>_<col> in a grid in its notch, row 0 at the
# notch's top, its west and top edges at 6.336 and 114.48 um
# (tpu_io.tcl). place_macro refuses macros whose bounding boxes overlap
# (MPL-0041), and the parent's box holds its notch: the macros are placed
# through the database directly, fixed, and the router sees their real
# shapes.
set block [ord::get_db_block]
set dbu [[ord::get_db_tech] getDbUnitsPerMicron]
proc at { inst x y } {
  $inst setOrigin $x $y
  $inst setOrient R0
  $inst setPlacementStatus FIRM
}
at [$block findInst u_rest] 0 0
set x0 [expr { int(round(6.336 * $dbu)) }]
set y1 [expr { int(round(114.48 * $dbu)) }]
set n 0
foreach i [$block getInsts] {
  if { ![regexp {^u_b(\d+)_(\d+)$} [$i getName] -> r c] } { continue }
  set m [$i getMaster]
  at $i [expr { $x0 + $c * [$m getWidth] }] [expr { $y1 - ($r + 1) * [$m getHeight] }]
  incr n
}
puts "place_notch.tcl: $n tiles in the notch"
