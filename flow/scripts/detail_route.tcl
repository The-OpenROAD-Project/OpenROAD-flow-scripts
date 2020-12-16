# Currently there is no need to populate opendb but that is
# expected to change in the future.

detailed_route -param $::env(OBJECTS_DIR)/TritonRoute.param

if {![info exists standalone] || $standalone} {
  exit
}
