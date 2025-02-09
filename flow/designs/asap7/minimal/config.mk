export DESIGN_NICKNAME = minimal
export SDC_FILE = designs/asap7/minimal/empty.sdc
export PLATFORM = asap7
# Faster build and more information in GUI with hierarchical synthesis
export SYNTH_HIERARCHICAL ?= 1
# Keep all modules so we can examine the full hierarchy
export MAX_UNGROUP_SIZE ?= 0

# Set the core utilization to 10% for the minimal design to
# maximize chances of getting an initial floorplan. This
# provides a generous area, yet not so big as to make making
# floorplan problematic
export CORE_UTILIZATION ?= 10
# Low placement density to maximize chances of getting a floorplan
export PLACE_DENSITY ?= 0.20

# This won't work with an empty .sdc file
export SKIP_REPORT_METRICS = 1

