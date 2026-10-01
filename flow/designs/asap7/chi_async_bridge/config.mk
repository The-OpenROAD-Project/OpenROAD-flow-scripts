# chi_async_bridge: XiangShan's asynchronous CHI bridge between its tile
# and its network-on-chip. README.md says what it is for and where it
# comes from.
export PLATFORM               = asap7
export DESIGN_NAME            = chi_async_bridge
export DESIGN_NICKNAME        = chi_async_bridge

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.sv))
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# Readable, parameterised SystemVerilog, read by slang.
export SYNTH_HDL_FRONTEND     = slang

# All three threshold voltages, as for the core this bridge serves.
export ASAP7_USE_VT           = RVT LVT SLVT

export CORE_UTILIZATION       = 40
export CORE_MARGIN            = 2

# A ladder, FLOW_VARIANT=small|medium. base, ORFS's default variant, is
# XiangShan's bridge as it is: its flit widths and its queue depth of 16
# (system/SoC.scala:127), the only rung that reproduces XiangShan's
# period. medium keeps the flit widths at a depth of 4, small also
# narrows the flits; both are for iterating, in minutes.
export VERILOG_TOP_PARAMS     = DEPTH 16
ifeq ($(FLOW_VARIANT),small)
export VERILOG_TOP_PARAMS     = REQ_W 32 RSP_W 16 DAT_W 64 SNP_W 24 DEPTH 4
else ifeq ($(FLOW_VARIANT),medium)
export VERILOG_TOP_PARAMS     = DEPTH 4
endif
