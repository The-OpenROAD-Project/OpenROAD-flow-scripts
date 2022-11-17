# OpenRCX  - RC file for OpenROAD FS
# Platform - GF180 gf180mcu-pdk
#
# NOTE: LEF contains RC values per layer

regexp {(\d+)} $::env(METAL_OPTION) metal

if { $metal == "6" } {

  set_wire_rc -signal -layer Metal2
  set_wire_rc -clock  -layer Metal5

} elseif  { $metal == "5" } {

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
