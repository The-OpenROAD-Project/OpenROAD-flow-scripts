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
define_pdn_grid -name {grid} -voltage_domains {CORE}
add_pdn_stripe -grid {grid} -layer {Metal1} -width {0.44} -pitch {7.56} -offset {0} -followpins -extend_to_core_ring
add_pdn_ring -grid {grid} -layers {Metal3 Metal4} -widths {3.0} -spacings {2.0} -core_offsets {4.5} -connect_to_pads
add_pdn_stripe -grid {grid} -layer {Metal3} -width {1.840} -pitch {75.6} -offset {37.8} -extend_to_core_ring
add_pdn_stripe -grid {grid} -layer {Metal4} -width {1.840} -pitch {75.6} -offset {37.8} -extend_to_core_ring
add_pdn_connect -grid {grid} -layers {Metal1 Metal3}
add_pdn_connect -grid {grid} -layers {Metal3 Metal4}
