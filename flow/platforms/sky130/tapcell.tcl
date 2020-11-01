if {$::env(LIBRARY) == "hd"} {
  tapcell \
    -endcap_cpp "2" \
    -distance 14 \
    -tapcell_master "sky130_fd_sc_hd__tap_1" \
    -endcap_master "sky130_fd_sc_hd__decap_4"
} elseif {$::env(LIBRARY) == "hs"} {
  tapcell \
    -endcap_cpp "2" \
    -distance 14 \
    -tapcell_master "sky130_fd_sc_hs__tap_1" \
    -endcap_master "sky130_fd_sc_hs__decap_4"
}
