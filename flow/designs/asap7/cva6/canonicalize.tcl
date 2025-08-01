# Remove rvfi_probes_o interface since contributes 4k ports and connections
# (many of which are buffers tied to tie cells)

delete cva6/o:rvfi_probes_o*
