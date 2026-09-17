# ==============================================================================
# 3D hybrid bonding yield flow
#
# Included by the top level Makefile only when a design config sets
# FLOW_TYPE=3d. Nothing here is visible to the RTL-to-GDS flow, and nothing
# from variables.mk is available here.
#
# The flow drives OpenROAD for 3D stack validation and YAP (tools/YAP) for
# wafer-to-wafer hybrid bonding yield simulation, then renders the resulting
# per-pad risk maps as heatmaps in the OpenROAD GUI.
#
# See docs/user/ThreeDFlow.md.
# ==============================================================================

ifeq ($(origin DESIGN),undefined)
  $(error DESIGN variable not set.)
endif
ifeq ($(origin YAP_CONFIG),undefined)
  $(error YAP_CONFIG variable not set.)
endif

export DESIGN_NICKNAME ?= $(DESIGN)

export UTILS_DIR       ?= $(FLOW_HOME)/util
export SCRIPTS_DIR     ?= $(FLOW_HOME)/scripts
THREE_D_SCRIPTS_DIR     = $(SCRIPTS_DIR)/3d

# "3d" occupies the slot the platform name takes in the RTL-to-GDS flow, so a
# 3D run never collides with a hardened design of the same name. FLOW_VARIANT
# has no meaning here - there is no per-variant tuning to explore.
RESULTS_ROOT            = $(WORK_HOME)/results/3d
export RESULTS_DIR      = $(RESULTS_ROOT)/$(DESIGN)
export LOG_DIR          = $(WORK_HOME)/logs/3d/$(DESIGN)
export OBJECTS_DIR      = $(WORK_HOME)/objects/3d/$(DESIGN)

#-------------------------------------------------------------------------------
# Tools
#
# HERE BE DRAGONS: bare `export VAR`, never `export VAR := $(VAR)`. See the
# matching comment in variables.mk for why.
PYTHON_EXE ?= $(shell command -v python3)
export PYTHON_EXE

RUN_CMD = $(PYTHON_EXE) $(FLOW_HOME)/scripts/run_command.py

ifneq (${IN_NIX_SHELL},)
  OPENROAD_EXE ?= $(shell command -v openroad)
else
  OPENROAD_EXE ?= $(abspath $(FLOW_HOME)/../tools/install/OpenROAD/bin/openroad)
endif
export OPENROAD_EXE

OPENROAD_IS_VALID := $(if $(OPENROAD_EXE),$(shell test -x $(OPENROAD_EXE) && echo "true"),)

OPENROAD_ARGS    = -no_init $(OR_ARGS)
OPENROAD_CMD     = $(OPENROAD_EXE) -exit $(OPENROAD_ARGS)
# No -exit: the web server has to stay up to serve the viewer.
OPENROAD_WEB_CMD = $(OPENROAD_EXE) -web $(OPENROAD_ARGS)

YAP_HOME             ?= $(abspath $(FLOW_HOME)/../tools/YAP)
YAP_W2W_DIR           = $(YAP_HOME)/W2W
GENERATE_CRITICALITY  = $(YAP_W2W_DIR)/utils/generate_criticality.py

# Checked here rather than per target: every step of this flow either runs YAP
# or consumes something YAP produced, and design configs are free to name their
# inputs relative to YAP_HOME, which would otherwise fail as a missing
# prerequisite with no explanation.
ifeq ($(wildcard $(GENERATE_CRITICALITY)),)
  $(error YAP not found under '$(YAP_HOME)'. Run 'git submodule update --init --recursive' from the repository root, or set YAP_HOME)
endif

#-------------------------------------------------------------------------------
# Design defaults
YAP_MODE   ?= w2w_simulation
NUM_WAFERS ?= 1

# Files staged into OBJECTS_DIR for YAP to consume. YAP writes alongside its
# inputs, so it gets a private copy instead of the design directory.
THREE_D_INPUTS = $(STACK_CONFIG) $(CHIPLET_DEFS) $(BMAP_FILES) $(THREEDBF_FILES) \
                 $(YAP_CONFIG)

DB_FILE = $(RESULTS_DIR)/$(DESIGN).odb

# The staged copy of the YAP config that `prepare` patches. The original under
# the design directory is never modified.
YAP_CONFIG_STAGED = $(OBJECTS_DIR)/$(notdir $(YAP_CONFIG))

YAP_FAIL_MAP = $(RESULTS_DIR)/assembly_fail_map_per_interface_dict.npz

# Both of these steps write a set of files whose names are only known after the
# preceding step has run, so a stamp stands in for them as the make target.
CRITICALITY_STAMP = $(OBJECTS_DIR)/criticality.stamp
RISK_MAP_STAMP    = $(RESULTS_DIR)/risk_maps.stamp

#-------------------------------------------------------------------------------
.PHONY: check-openroad
check-openroad:
	@if [ "$(strip $(OPENROAD_IS_VALID))" != "true" ]; then \
		echo "OPENROAD_EXE is set to '$(OPENROAD_EXE)', but it is either not found or not executable."; \
		exit 1; \
	fi

.PHONY: all
all: check_3dblox generate_risk_map

# Step 1: read the 3D stack into OpenROAD, validate it, write an ODB
# ==============================================================================
.PHONY: check_3dblox
check_3dblox: $(DB_FILE)

$(DB_FILE): $(STACK_CONFIG) $(CHIPLET_DEFS) $(THREEDBF_FILES) | check-openroad
	@mkdir -p $(RESULTS_DIR) $(LOG_DIR)
	STACK_CONFIG_PATH=$(abspath $(STACK_CONFIG)) \
	DB_PATH=$(abspath $@) \
		$(RUN_CMD) --log $(abspath $(LOG_DIR)/1_check_3dblox.log) --tee -- \
		$(OPENROAD_CMD) $(THREE_D_SCRIPTS_DIR)/check_3dblox.tcl

# Step 2: stage the design inputs into OBJECTS_DIR
#
# The staged YAP config is patched with the absolute output path and the wafer
# stack count from the design config.
# ==============================================================================
.PHONY: prepare
prepare: $(YAP_CONFIG_STAGED)

$(YAP_CONFIG_STAGED): $(THREE_D_INPUTS)
	@mkdir -p $(OBJECTS_DIR) $(RESULTS_DIR) $(LOG_DIR)
	cp $(THREE_D_INPUTS) $(OBJECTS_DIR)/
	sed -i.bak \
		-e 's|OUTPUT_DIR:.*|OUTPUT_DIR: "$(abspath $(RESULTS_ROOT))/"|' \
		-e 's|NUM_WAFER_STACKS:.*|NUM_WAFER_STACKS: $(NUM_WAFERS)|' \
		$@
	rm -f $@.bak

# Step 3: generate a default criticality file for every .bmap missing one
# ==============================================================================
.PHONY: generate_criticality
generate_criticality: $(CRITICALITY_STAMP)

$(CRITICALITY_STAMP): $(YAP_CONFIG_STAGED)
	@mkdir -p $(LOG_DIR)
	$(RUN_CMD) --log $(abspath $(LOG_DIR)/3_generate_criticality.log) --tee -- \
		bash -c 'set -e; for bmap in $(abspath $(OBJECTS_DIR))/*_From_*.bmap; do \
			crit="$${bmap%.bmap}_criticality.txt"; \
			if [ -f "$$crit" ]; then \
				echo "Exists: $$crit"; \
			else \
				echo "Generating $$crit"; \
				$(PYTHON_EXE) $(GENERATE_CRITICALITY) "$$bmap" --force; \
			fi; \
		done'
	touch $@

# Step 4: run the YAP Monte Carlo W2W hybrid bonding simulation
#
# YAP resolves its relative paths against W2W/, hence the cd.
# ==============================================================================
.PHONY: yap_simulate
yap_simulate: $(YAP_FAIL_MAP)

$(YAP_FAIL_MAP): $(CRITICALITY_STAMP)
	@mkdir -p $(RESULTS_DIR) $(LOG_DIR)
	cd $(YAP_W2W_DIR) && \
	$(RUN_CMD) --log $(abspath $(LOG_DIR)/4_yap_simulate.log) --tee -- \
		$(PYTHON_EXE) simulator_main.py \
		--config $(abspath $(YAP_CONFIG_STAGED)) \
		--mode $(YAP_MODE) \
		--ds_name $(DESIGN) \
		--ds_dir $(abspath $(OBJECTS_DIR)) \
		--verbose

# Step 5: turn the YAP fail maps into per-pad risk CSVs
# ==============================================================================
.PHONY: generate_risk_map
generate_risk_map: $(RISK_MAP_STAMP)

$(RISK_MAP_STAMP): $(YAP_FAIL_MAP)
	@mkdir -p $(LOG_DIR)
	$(RUN_CMD) --log $(abspath $(LOG_DIR)/5_generate_risk_map.log) --tee -- \
		$(PYTHON_EXE) $(THREE_D_SCRIPTS_DIR)/generate_risk_map.py \
		--results_dir $(abspath $(RESULTS_DIR)) \
		--objects_dir $(abspath $(OBJECTS_DIR))
	touch $@

# Step 6: overlay the risk maps in the OpenROAD web viewer
#
# The heatmaps attach to individual chiplets, which only the web viewer renders
# as a stack, so this step is web only. Requires an OpenROAD build providing
# web_load_chiplet_heatmap. Pass a fixed port with e.g. OR_ARGS="-web_port 8080".
# ==============================================================================
.PHONY: view_heatmaps
view_heatmaps: $(DB_FILE)
	DB_PATH=$(abspath $(DB_FILE)) \
	HEATMAP_DIR=$(abspath $(RESULTS_DIR)) \
		$(OPENROAD_WEB_CMD) $(THREE_D_SCRIPTS_DIR)/view_heatmaps.tcl

#-------------------------------------------------------------------------------
.PHONY: clean
clean:
	rm -rf $(OBJECTS_DIR) $(RESULTS_DIR) $(LOG_DIR)

.PHONY: clean_all
clean_all: clean

.PHONY: print-%
print-%:
	$(info $*: $($*))
	@true
