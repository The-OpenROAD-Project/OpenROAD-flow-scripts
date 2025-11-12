export DESIGN_NICKNAME = minimal
export SDC_FILE ?= $(FLOW_HOME)/designs/asap7/minimal/empty.sdc
export PLATFORM = asap7
# Faster build and more information in GUI with hierarchical synthesis
export SYNTH_HIERARCHICAL ?= 1
# Keep all modules so we can examine the full hierarchy
export SYNTH_MINIMUM_KEEP_SIZE ?= 0

# Set the core utilization to 10% for the minimal design to
# maximize chances of getting an initial floorplan. This
# provides a generous area, yet not so big as to make making
# floorplan problematic
export CORE_UTILIZATION ?= 10
# Low placement density to maximize chances of getting a floorplan
export PLACE_DENSITY ?= 0.20

# This won't work with an empty .sdc file
export SKIP_REPORT_METRICS ?= 1

# Faster build, remove these in your own config.mk
export SKIP_CTS_REPAIR_TIMING ?= 1
export REMOVE_ABC_BUFFERS ?= 1
export SKIP_INCREMENTAL_REPAIR ?= 1
export GPL_TIMING_DRIVEN ?= 0
export GPL_ROUTING_DRIVEN ?= 0
