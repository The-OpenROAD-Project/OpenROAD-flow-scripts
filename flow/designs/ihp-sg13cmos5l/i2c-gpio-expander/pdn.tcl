# standard cells
add_global_connection -net {VDD} -pin_pattern {^VDD$} -power
add_global_connection -net {VDD} -pin_pattern {^VDDPE$}
add_global_connection -net {VDD} -pin_pattern {^VDDCE$}
add_global_connection -net {VSS} -pin_pattern {^VSS$} -ground
add_global_connection -net {VSS} -pin_pattern {^VSSE$}

global_connect

# core voltage domain
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

# stdcell grid
define_pdn_grid -name {grid} -voltage_domains {CORE} -pins {Metal4 TopMetal1}
add_pdn_stripe -grid {grid} -layer {Metal1} -width {0.44} -pitch {7.56} -offset {0} \
  -followpins -extend_to_core_ring
add_pdn_ring -grid {grid} -layers {Metal3 Metal4} -widths {8.0} -spacings {5.0} \
  -core_offsets {4.5} -connect_to_pads
add_pdn_stripe -grid {grid} -layer {Metal4} -width {4.0} -pitch {75.0} -offset {25.0} \
  -extend_to_core_ring
add_pdn_stripe -grid {grid} -layer {TopMetal1} -width {4.0} -pitch {75.0} -offset {25.0} \
  -extend_to_core_ring
add_pdn_connect -grid {grid} -layers {Metal1 Metal4}
add_pdn_connect -grid {grid} -layers {Metal3 Metal4}
add_pdn_connect -grid {grid} -layers {Metal4 TopMetal1}
