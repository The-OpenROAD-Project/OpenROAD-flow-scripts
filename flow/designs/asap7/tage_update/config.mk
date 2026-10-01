# tage_update: gather, decide, scatter across a branch predictor's tables
# in one cycle. README.md says what it is for and where it comes from.
export PLATFORM               = asap7
export DESIGN_NAME            = tage_update
export DESIGN_NICKNAME        = tage_update

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.sv))
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# Readable, parameterised SystemVerilog, read by slang.
export SYNTH_HDL_FRONTEND     = slang

# The tables' SRAMs are behavioural modules in the firtool port
# convention; AUTO_MEMORIES turns each into a generated macro.
export AUTO_MEMORIES          = 1

# All three threshold voltages, so the resizer can trade leakage for
# speed per path, as a 3 GHz-class core does.
export ASAP7_USE_VT           = RVT LVT SLVT

export CORE_UTILIZATION       = 35
export CORE_MARGIN            = 2
# Channels between macros, as tinyRocket keeps them: room for the power
# grid to reach every SRAM.
export RTLMP_MIN_CHANNEL_SIZE = 8 8

# A ladder, FLOW_VARIANT=small|medium|large: small to iterate on, large
# at the size of XiangShan's TAGE. base, ORFS's default variant, is
# large: the smallest size that shows the effect (README.md, Variants).
ifeq ($(FLOW_VARIANT),small)
export VERILOG_TOP_PARAMS     = TABLES 2 BANKS 1 WAYS 1
else ifeq ($(FLOW_VARIANT),medium)
export VERILOG_TOP_PARAMS     = TABLES 4 BANKS 2 WAYS 2
else ifeq ($(FLOW_VARIANT),large)
export VERILOG_TOP_PARAMS     = TABLES 8 BANKS 4 WAYS 2
else
export VERILOG_TOP_PARAMS     = TABLES 8 BANKS 4 WAYS 2
endif
