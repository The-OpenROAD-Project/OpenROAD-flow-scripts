# check the lower boundary of the PLACE_DENSITY and add PLACE_DENSITY_LB_ADDON if it exists
if {[info exist ::env(PLACE_DENSITY_LB_ADDON)]} {
  set place_density_lb [gpl::get_global_placement_uniform_density \
  -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
  -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)]
  set place_density [expr $place_density_lb + ((1.0 - $place_density_lb) * $::env(PLACE_DENSITY_LB_ADDON)) + 0.01]
  if {$place_density > 1.0} {
    utl::error FLW 24 "Place density exceeds 1.0 (current PLACE_DENSITY_LB_ADDON = $::env(PLACE_DENSITY_LB_ADDON)). Please check if the value of PLACE_DENSITY_LB_ADDON is between 0 and 0.99."
  }
} else {
  set place_density $::env(PLACE_DENSITY)
}
