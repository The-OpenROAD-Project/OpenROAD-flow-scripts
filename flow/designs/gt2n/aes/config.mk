export DESIGN_NICKNAME = aes
export DESIGN_NAME     = aes_cipher_top
export PLATFORM        = gt2n

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# AES is bigger than gcd; give the floorplan more room.
export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY_LB_ADDON = 0.20

export TNS_END_PERCENT = 100
# workaround for high congestion in post-grt repair (matches nangate45/aes)
export SKIP_INCREMENTAL_REPAIR = 1

export SWAP_ARITH_OPERATORS = 1
export OPENROAD_HIERARCHICAL = 1
