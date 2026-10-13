# ==============================================================================
# 3D hybrid bonding yield flow
#
# Included by the top level Makefile only when a design config sets
# FLOW_TYPE=3d. Nothing here is visible to the RTL-to-GDS flow, and nothing
# from variables.mk is available here.
#
# The flow drives OpenROAD for 3D stack validation and YAP (tools/YAP) for
# wafer-to-wafer (W2W) or die-to-wafer (D2W) hybrid bonding yield simulation,
# selected per design with YAP_FLOW, then renders the resulting
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
# Prefer the venv that `build_openroad.sh --3d` installs YAP's requirements into.
YAP_VENV_PYTHON = $(abspath $(FLOW_HOME)/../tools/install/yap-venv/bin/python)
PYTHON_EXE ?= $(if $(wildcard $(YAP_VENV_PYTHON)),$(YAP_VENV_PYTHON),$(shell command -v python3))
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

# Which YAP simulator the design runs through: W2W (wafer-to-wafer, whole
# wafers bonded) or D2W (die-to-wafer, dies placed onto a base).
YAP_FLOW ?= W2W
ifeq ($(filter W2W D2W,$(YAP_FLOW)),)
  $(error YAP_FLOW must be W2W or D2W, got '$(YAP_FLOW)')
endif
YAP_FLOW_DIR          = $(YAP_HOME)/$(YAP_FLOW)
GENERATE_CRITICALITY  = $(YAP_FLOW_DIR)/utils/generate_criticality.py
# Only D2W ships the bump naming script, but it works on any .bmap.
ASSIGN_BUMP_NAMES     = $(YAP_HOME)/D2W/utils/assign_bump_names.py

# Checked here rather than per target: every step of this flow either runs YAP
# or consumes something YAP produced, and design configs are free to name their
# inputs relative to YAP_HOME, which would otherwise fail as a missing
# prerequisite with no explanation.
ifeq ($(wildcard $(GENERATE_CRITICALITY)),)
  $(error YAP not found under '$(YAP_HOME)'. Run 'git submodule update --init --recursive' from the repository root, or set YAP_HOME)
endif

#-------------------------------------------------------------------------------
# Design defaults
ifeq ($(YAP_FLOW),D2W)
  YAP_MODE       ?= d2w_simulation
  NUM_DIE_STACKS ?= 1000
  # The YAP config key that `prepare` patches with the Monte Carlo sample count
  YAP_SAMPLES_KEY = NUM_DIE_STACKS
  YAP_SAMPLES     = $(NUM_DIE_STACKS)
  # default: replicated nets tolerate R-1 ESD and mechanical failures.
  # esd_strict: replicated signal nets tolerate no ESD failures.
  YAP_CRITICALITY_PROFILE ?= default
else
  YAP_MODE       ?= w2w_simulation
  NUM_WAFERS     ?= 1
  YAP_SAMPLES_KEY = NUM_WAFER_STACKS
  YAP_SAMPLES     = $(NUM_WAFERS)
endif

# Optional arguments to D2W's assign_bump_names.py, for .bmap files that come
# without port/net names (all "-"), e.g.
#   --critical-ratio 0.30 --redundant-ratio 0 --pg-ratio 0.50 --dummy-ratio 0.20
# When set, it renames the staged copies in place; the design inputs are never
# modified. Left empty, the .bmap names are used as is.
YAP_ASSIGN_BUMP_NAMES_ARGS ?=

# Files staged into OBJECTS_DIR for YAP to consume. YAP writes alongside its
# inputs, so it gets a private copy instead of the design directory.
THREE_D_INPUTS = $(STACK_CONFIG) $(CHIPLET_DEFS) $(BMAP_FILES) $(THREEDBF_FILES) \
                 $(YAP_CONFIG)

DB_FILE = $(RESULTS_DIR)/$(DESIGN).odb

# The staged copy of the YAP config that `prepare` patches. The original under
# the design directory is never modified.
YAP_CONFIG_STAGED = $(OBJECTS_DIR)/$(notdir $(YAP_CONFIG))

# D2W tags its fail map and per-interface configs with the config name and
# criticality profile, reads the profile's criticality files, and only writes
# the fail map when asked to.
ifeq ($(YAP_FLOW),D2W)
  YAP_FILE_TAG         = __$(basename $(notdir $(YAP_CONFIG)))__$(YAP_CRITICALITY_PROFILE)
  CRITICALITY_SUFFIX   = $(if $(filter esd_strict,$(YAP_CRITICALITY_PROFILE)),_criticality_esd_strict.txt,_criticality.txt)
  CRITICALITY_ARGS     = --profiles $(YAP_CRITICALITY_PROFILE)
  YAP_SIMULATE_ARGS    = --criticality-profile $(YAP_CRITICALITY_PROFILE) --save-failure-maps
else
  YAP_FILE_TAG         =
  CRITICALITY_SUFFIX   = _criticality.txt
  CRITICALITY_ARGS     =
  YAP_SIMULATE_ARGS    =
endif

YAP_FAIL_MAP = $(RESULTS_DIR)/assembly_fail_map_per_interface_dict$(YAP_FILE_TAG).npz

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
# The staged YAP config is patched with the absolute output path and the Monte
# Carlo sample count from the design config (NUM_WAFERS for W2W,
# NUM_DIE_STACKS for D2W). If YAP_ASSIGN_BUMP_NAMES_ARGS is set, the staged
# .bmap files get port/net names assigned.
# ==============================================================================
.PHONY: prepare
prepare: $(YAP_CONFIG_STAGED)

$(YAP_CONFIG_STAGED): $(THREE_D_INPUTS)
	@mkdir -p $(OBJECTS_DIR) $(RESULTS_DIR) $(LOG_DIR)
	cp $(THREE_D_INPUTS) $(OBJECTS_DIR)/
ifneq ($(strip $(YAP_ASSIGN_BUMP_NAMES_ARGS)),)
	$(RUN_CMD) --log $(abspath $(LOG_DIR)/2_assign_bump_names.log) --tee -- \
		$(PYTHON_EXE) $(ASSIGN_BUMP_NAMES) \
		--files $(addprefix $(abspath $(OBJECTS_DIR))/,$(notdir $(BMAP_FILES))) \
		$(YAP_ASSIGN_BUMP_NAMES_ARGS)
endif
	sed -i.bak \
		-e 's|OUTPUT_DIR:.*|OUTPUT_DIR: "$(abspath $(RESULTS_ROOT))/"|' \
		-e 's|$(YAP_SAMPLES_KEY):.*|$(YAP_SAMPLES_KEY): $(YAP_SAMPLES)|' \
		$@
	rm -f $@.bak

# Step 3: generate a default criticality file for every .bmap missing one
# ==============================================================================
.PHONY: generate_criticality
generate_criticality: $(CRITICALITY_STAMP)

$(CRITICALITY_STAMP): $(YAP_CONFIG_STAGED)
	@mkdir -p $(LOG_DIR)
	$(RUN_CMD) --log $(abspath $(LOG_DIR)/3_generate_criticality.log) --tee -- \
		bash -c 'set -e; shopt -s nullglob; \
		bmaps=($(abspath $(OBJECTS_DIR))/*_From_*.bmap); \
		if [ $${#bmaps[@]} -eq 0 ]; then \
			echo "[ERROR] No *_From_*.bmap in $(abspath $(OBJECTS_DIR))." >&2; \
			exit 1; \
		fi; \
		for bmap in "$${bmaps[@]}"; do \
			crit="$${bmap%.bmap}$(CRITICALITY_SUFFIX)"; \
			if [ -f "$$crit" ]; then \
				echo "Exists: $$crit"; \
			else \
				echo "Generating $$crit"; \
				$(PYTHON_EXE) $(GENERATE_CRITICALITY) "$$bmap" --force $(CRITICALITY_ARGS); \
			fi; \
		done'
	touch $@

# Step 4: run the YAP Monte Carlo hybrid bonding simulation (W2W or D2W)
#
# YAP resolves its relative paths against W2W/ or D2W/, hence the cd.
# ==============================================================================
.PHONY: yap_simulate
yap_simulate: $(YAP_FAIL_MAP)

$(YAP_FAIL_MAP): $(CRITICALITY_STAMP)
	@mkdir -p $(RESULTS_DIR) $(LOG_DIR)
	cd $(YAP_FLOW_DIR) && \
	$(RUN_CMD) --log $(abspath $(LOG_DIR)/4_yap_simulate.log) --tee -- \
		$(PYTHON_EXE) simulator_main.py \
		--config $(abspath $(YAP_CONFIG_STAGED)) \
		--mode $(YAP_MODE) \
		--ds_name $(DESIGN) \
		--ds_dir $(abspath $(OBJECTS_DIR)) \
		--verbose $(YAP_SIMULATE_ARGS)
	@test -f $@ || { echo "Error: YAP did not write $@"; exit 1; }

# Step 5: turn the YAP fail maps into per-pad risk CSVs
# ==============================================================================
.PHONY: generate_risk_map
generate_risk_map: $(RISK_MAP_STAMP)

$(RISK_MAP_STAMP): $(YAP_FAIL_MAP)
	@mkdir -p $(LOG_DIR)
	$(RUN_CMD) --log $(abspath $(LOG_DIR)/5_generate_risk_map.log) --tee -- \
		$(PYTHON_EXE) $(THREE_D_SCRIPTS_DIR)/generate_risk_map.py \
		--results_dir $(abspath $(RESULTS_DIR)) \
		--objects_dir $(abspath $(OBJECTS_DIR)) \
		--file_tag "$(YAP_FILE_TAG)"
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
