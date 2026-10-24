# tpu's top level, macros only: each of its ports sits where the parent
# macro's (u_rest's) pin for it is, on that macro's bottom edge.
set block [ord::get_db_block]
set dbu [[ord::get_db_tech] getDbUnitsPerMicron]
set l [$block findInst u_rest]
foreach bt [$block getBTerms] {
  set net [$bt getNet]
  if { $net eq "NULL" } { continue }
  foreach it [$net getITerms] {
    if { [$it getInst] ne $l } { continue }
    foreach mpin [[$it getMTerm] getMPins] {
      foreach box [$mpin getGeometry] {
        set x [expr { ([$box xMin] + [$box xMax]) / 2.0 / $dbu }]
        set layer [[$box getTechLayer] getName]
        place_pin -pin_name [$bt getName] -layer $layer -location [list $x 0] -force_to_die_boundary
        break
      }
      break
    }
  }
}
