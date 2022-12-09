# OpenRCX  - RC file for OpenROAD FS
# Platform - GF180 gf180mcu-pdk
#
# NOTE: LEF contains RC values per layer

regexp {(\d+)} $::env(METAL_OPTION) metal

if { $metal == "6" } {

  set_wire_rc -signal -layer Metal2
  set_wire_rc -clock  -layer Metal5

} elseif  { $metal == "5" } {
  # TC matches LEF.  These are the temperature adjusted values.
  # The other stacks are likely similar but I haven't checked yet.
  if {$::env(CORNER) == "WC"} {
    set_layer_rc -via Via1 -resistance 16.845
    set_layer_rc -via Via2 -resistance 16.845
    set_layer_rc -via Via3 -resistance 16.845
    set_layer_rc -via Via4 -resistance 16.845

    set tech [ord::get_db_tech]
    foreach via [$tech getVias] {
      if {[$via getResistance] == 4.5} {
        $via setResistance 16.845
      }
    }
  } elseif {$::env(CORNER) == "BC"} {
    set_layer_rc -via Via1 -resistance 4.23
    set_layer_rc -via Via2 -resistance 4.23
    set_layer_rc -via Via3 -resistance 4.23
    set_layer_rc -via Via4 -resistance 4.23

    set tech [ord::get_db_tech]
    foreach via [$tech getVias] {
      if {[$via getResistance] == 4.5} {
        $via setResistance 4.23
      }
    }
  }
  
  set_wire_rc -signal -layer Metal2
  set_wire_rc -clock  -layer Metal4

} elseif  { $metal == "4" } {

  set_wire_rc -signal -layer Metal2
  set_wire_rc -clock  -layer Metal3

} elseif  { $metal == "3" } {

  set_wire_rc -signal -layer Metal2
  set_wire_rc -clock  -layer Metal2

} elseif  { $metal == "2" } {

  set_wire_rc -signal -layer Metal2
  set_wire_rc -clock  -layer Metal2
}
