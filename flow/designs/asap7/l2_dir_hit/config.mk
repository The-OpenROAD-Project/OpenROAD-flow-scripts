# l2_dir_hit: an L2 directory's hit, decided in one cycle from SRAM-fed
# registers, steering the cache's pipeline. README.md says what it is for
# and where it comes from.
export PLATFORM               = asap7
export DESIGN_NAME            = l2_dir_hit
export DESIGN_NICKNAME        = l2_dir_hit

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.sv))
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# Readable, parameterised SystemVerilog, read by slang.
export SYNTH_HDL_FRONTEND     = slang

# The tag, meta and data arrays are behavioural modules in the firtool
# port convention; AUTO_MEMORIES turns each into a generated macro at
# XiangShan's own shapes.
export AUTO_MEMORIES          = 1

# All three threshold voltages, so the resizer can trade leakage for
# speed per path, as a 3 GHz-class core does.
export ASAP7_USE_VT           = RVT LVT SLVT

export CORE_UTILIZATION       = 35
export CORE_MARGIN            = 2
# Channels between macros: room for the power grid to reach every SRAM.
export RTLMP_MIN_CHANNEL_SIZE = 4 4

# The slice's units stay modules, as CoupledL2's own flow keeps them: the
# macro placer clusters by them. Flat, one data bank is ~96 % of the area
# of the cluster around it and the area-balanced bisection cannot split
# it (MPL-0045).
export SYNTH_HIERARCHICAL     = 1
export SYNTH_KEEP_MODULES     = l2_directory l2_sink_c l2_mshr_ctl l2_custom_l1_hint
