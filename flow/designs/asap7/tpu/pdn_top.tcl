# The grid of a top level that is macros only. A core grid takes its
# extent from the rows, and this top level has none: the M9 straps are
# each macro's instance grid instead, over the macro, landing on its M8
# straps; macros that abut have straps that abut.
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}
# The parent macro's (u_rest's) box holds its notch, where the tiles
# are; a grid takes the area it covers first, so the tiles' grid is
# defined before the parent's.
set tiles {}
set others {}
foreach inst [[ord::get_db_block] getInsts] {
  set m [$inst getMaster]
  if { ![$m isBlock] } { continue }
  if { [$inst getName] eq "u_rest" } {
    dict set others [$m getName] 1
  } else {
    dict set tiles [$m getName] 1
  }
}
# Finding: the tiles' grid draws nothing, defined first or not; the
# generator seems to take the parent's whole box as occupied. The design
# is read at global route, where M9 carries no signal: the parent's grid
# only, the tiles' power left unconnected at the top level.
foreach {name cells} [list ParentGrid [dict keys $others]] {
  define_pdn_grid -macro -cells $cells -halo {0 0 0 0} -voltage_domains {CORE} -name $name
  add_pdn_stripe -grid $name -layer {M9} -width {0.16} -spacing {0.16} -pitch {2.88} -offset {0.5}
  add_pdn_connect -grid $name -layers {M8 M9}
}
