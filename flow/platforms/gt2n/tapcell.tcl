# GT2N tap cells (`gt2_6t_tapbspdn_*`, `gt2_6t_tapfspdn_*`) bridge the
# cell's BPR pin to the backside power network -- they are the only
# legal M1<->BPR (FSPDN) or sole BPR riser (BSPDN) per row. Tap density
# directly sets BPR rail resistance and BSPDN IR drop, so a tighter
# spacing matters more than in a conventional well-tap-only flow. Two
# microns gives a few tap columns even on small blocks.
tapcell \
  -distance 2 \
  -tapcell_master "$::env(TAP_CELL_NAME)" \
  -endcap_master "$::env(TAP_CELL_NAME)"
