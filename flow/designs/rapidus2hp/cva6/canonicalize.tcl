# Remove rvfi_probes_o interface since it's not in the baseline and contributes
# 4k ports and connections (many of which are buffers tied to tie cells)

delete cva6/o:rvfi_probes_o*
