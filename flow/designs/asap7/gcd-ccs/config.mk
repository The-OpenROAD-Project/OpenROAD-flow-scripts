export DESIGN_NICKNAME = gcd-ccs
export LIB_MODEL = CCS
include designs/asap7/gcd/config.mk

# Lower the core utilization from 65 (base asap7/gcd) to 60
# due to a DPL failure at the global route stage due to extra
# buffers inserted by repair_timing
export CORE_UTILIZATION = 60