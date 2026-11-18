# Global connections, made at floorplan right after the netlist is
# loaded (GLOBAL_CONNECT_TCL); the PDN scripts define the grids.
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
