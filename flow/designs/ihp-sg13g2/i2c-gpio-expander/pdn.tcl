# standard cells
add_global_connection -net {VDD} -pin_pattern {^VDD$} -power
add_global_connection -net {VDD} -pin_pattern {^VDDPE$}
add_global_connection -net {VDD} -pin_pattern {^VDDCE$}
add_global_connection -net {VSS} -pin_pattern {^VSS$} -ground
add_global_connection -net {VSS} -pin_pattern {^VSSE$}

# macros
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VDD!} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VSS!} -ground
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground

# padframe core power pins
add_global_connection -net {VDD} -pin_pattern {^vdd$} -power
add_global_connection -net {VSS} -pin_pattern {^vss$} -ground

# padframe io power pins
add_global_connection -net {IOVDD} -pin_pattern {^iovdd$} -power
add_global_connection -net {IOVSS} -pin_pattern {^iovss$} -ground

global_connect

# core voltage domain
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

# stdcell grid
define_pdn_grid -name {grid} -voltage_domains {CORE} -pins {TopMetal1 TopMetal2}
add_pdn_stripe -grid {grid} -layer {Metal1} -width {0.44} -pitch {7.56} -offset {0} \
  -followpins -extend_to_core_ring
add_pdn_ring -grid {grid} -layers {TopMetal1 TopMetal2} -widths {8.0} -spacings {5.0} \
  -core_offsets {4.5} -connect_to_pads
add_pdn_stripe -grid {grid} -layer {TopMetal1} -width {2.200} -pitch {75.6} -offset {13.6} \
  -extend_to_core_ring
add_pdn_stripe -grid {grid} -layer {TopMetal2} -width {2.200} -pitch {75.6} -offset {13.6} \
  -extend_to_core_ring
add_pdn_connect -grid {grid} -layers {Metal1 TopMetal1}
add_pdn_connect -grid {grid} -layers {TopMetal1 TopMetal2}

define_pdn_grid \
  -name {CORE_macro_grid_1} -voltage_domains {CORE} \
  -macro -cells {I2cDeviceCtrl} -grid_over_boundary
add_pdn_connect -grid {CORE_macro_grid_1} -layers {Metal4 TopMetal1}
add_pdn_connect -grid {CORE_macro_grid_1} -layers {Metal5 TopMetal1}
