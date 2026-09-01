export DESIGN_NICKNAME = tinyRocket
export DESIGN_NAME = RocketTile
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1
export SYNTH_MINIMUM_KEEP_SIZE ?= 5000

# SYNTH_KEEP_MODULES is a captured list of the modules the
# keep-hierarchy discovery step selects at SYNTH_MINIMUM_KEEP_SIZE
# above.
#
# Under make it is redundant: discovery runs and finds the same list.
# Under bazel it is REQUIRED. Parallel synthesis declares one
# per-module re-canonicalization action per kept module, so bazel needs
# the module names at analysis time. When the list is only discovered
# inside a build action, bazel still emits the partition actions but no
# per-module checkpoints exist for them, and every partition fails with
#
#   ERROR: per-module checkpoint missing: \
#     partition_<Module>_canonical.rtlil
#
# Recapture after changing the RTL or SYNTH_MINIMUM_KEEP_SIZE, then sort:
#
#   make DESIGN_CONFIG=./designs/nangate45/tinyRocket/config.mk \
#        SYNTH_KEEP_MODULES= clean_synth synth
#   jq -r '.modules | sort | join(" ")' \
#     results/nangate45/RocketTile/base/kept_modules.json
export SYNTH_KEEP_MODULES ?= \
  ALU \
  AMOALU \
  BreakpointUnit \
  CSRFile \
  DCache \
  DCacheDataArray \
  DCacheModuleanon2 \
  DCacheModuleanon3 \
  Frontend \
  HellaCacheArbiter \
  IBuf \
  ICache \
  IntSyncCrossingSink \
  IntSyncCrossingSink_1 \
  IntSyncCrossingSink_2 \
  IntXbar_4 \
  MulDiv \
  PMPChecker \
  PTW \
  PlusArgTimeout \
  Queue_38 \
  Queue_39 \
  Queue_40 \
  Queue_41 \
  RVCExpander \
  Repeater_5 \
  Rocket \
  RocketTile \
  ScratchpadSlavePort \
  ShiftQueue \
  SynchronizerShiftReg_w1_d3 \
  TLB \
  TLB_1 \
  TLBuffer_10 \
  TLBuffer_11 \
  TLFragmenter_5 \
  TLMonitor_35 \
  TLMonitor_36 \
  TLXbar_8 \
  TLXbar_9 \
  data_arrays_0 \
  data_arrays_0_0 \
  data_arrays_0_0_ext \
  data_arrays_0_ext \
  tag_array \
  tag_array_ext

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/AsyncResetReg.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ClockDivider2.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ClockDivider3.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/plusarg_reader.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lib))

export CORE_UTILIZATION       = 60
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.75
