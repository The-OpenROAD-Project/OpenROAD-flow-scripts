# Global connections, made at floorplan right after the netlist is
# loaded (GLOBAL_CONNECT_TCL); the PDN scripts define the grids.
add_global_connection -net {vdd} -inst_pattern {.*} -pin_pattern {^vdd$} -power
add_global_connection -net {vss} -inst_pattern {.*} -pin_pattern {^vss$} -ground
