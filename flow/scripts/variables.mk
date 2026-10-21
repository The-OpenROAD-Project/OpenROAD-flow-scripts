# Sets up ORFS variables using make variable support, relying
# on makefile features such as defaults, forward references,
# lazy evaluation, conditional code, include statements,
# etc.

export DESIGN_NICKNAME?=$(DESIGN_NAME)

#-------------------------------------------------------------------------------
# Setup variables to point to other location for the following sub directory
# - designs - default is under current directory
# - platforms - default is under current directory
# - utils, scripts, test - default is under current directory
export DESIGN_HOME   ?= $(FLOW_HOME)/designs
export PLATFORM_HOME ?= $(FLOW_HOME)/platforms

export UTILS_DIR     ?= $(FLOW_HOME)/util
export SCRIPTS_DIR   ?= $(FLOW_HOME)/scripts
export TEST_DIR      ?= $(FLOW_HOME)/test

PUBLIC=nangate45 sky130hd sky130hs asap7 ihp-sg13g2 gf180 gt2n

ifeq ($(origin PLATFORM), undefined)
  $(error PLATFORM variable not set.)
endif
ifeq ($(origin DESIGN_NAME), undefined)
  $(error DESIGN_NAME variable not set.)
endif

ifneq ($(PLATFORM_DIR),)
else ifneq ($(wildcard $(PLATFORM_HOME)/$(PLATFORM)),)
  export PLATFORM_DIR = $(PLATFORM_HOME)/$(PLATFORM)
else ifneq ($(findstring $(PLATFORM),$(PUBLIC)),)
  export PLATFORM_DIR = ./platforms/$(PLATFORM)
else ifneq ($(wildcard ../../$(PLATFORM)),)
  export PLATFORM_DIR = ../../$(PLATFORM)
else
  $(error [ERROR][FLOW] Platform '$(PLATFORM)' not found.)
endif

include $(PLATFORM_DIR)/config.mk

# __SPACE__ is a workaround for whitespace hell in "foreach"; there
# is no way to escape space in defaults.py and get "foreach" to work.
$(foreach line,$(shell $(PYTHON_EXE) $(SCRIPTS_DIR)/defaults.py),$(eval export $(subst __SPACE__, ,$(line))))

export LOG_DIR     = $(WORK_HOME)/logs/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)
export OBJECTS_DIR = $(WORK_HOME)/objects/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)
export REPORTS_DIR = $(WORK_HOME)/reports/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)
export RESULTS_DIR = $(WORK_HOME)/results/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)

#-------------------------------------------------------------------------------
ifeq (,$(strip $(NUM_CORES)))
  # Linux (utility program)
  NUM_CORES := $(shell nproc 2>/dev/null)

  ifeq (,$(strip $(NUM_CORES)))
    # Linux (generic)
    NUM_CORES := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
  endif
  ifeq (,$(strip $(NUM_CORES)))
    # BSD (at least FreeBSD and Mac OSX)
    NUM_CORES := $(shell sysctl -n hw.ncpu 2>/dev/null)
  endif
  ifeq (,$(strip $(NUM_CORES)))
    # Fallback
    NUM_CORES := 1
  endif
endif
export NUM_CORES

#-------------------------------------------------------------------------------
# setup all commands used within this flow
#
# Nix and Bazel (or whatever else environment) should explicitly set the
# variables OPENROAD_EXE, OPENSTA_EXE, YOSYS_EXE and PYTHON_EXE to point to
# installed tools. If those are not defined, tools built by ORFS are used and
# referred to by absolute paths.
#
# Avoid exporting deferred shell commands, for example something like
#
#   export PYTHON_EXE ?= $(shell command -v python3)
#
# causes Make to start up a new shell whenever PYTHON_EXE is expanded. An
# annoying side-effect of this is that whenever a shell is launched, all
# exported variables are expanded, which causes PYTHON_EXE to launch a shell,
# which causes other exported variables to be expanded, and if those launch
# shells, PYTHON_EXE is re-expanded which launches a shell, and so on.
#
# This is not an infinite loop, as there are rules in place to stop expansion
# under certain circumstances, but the effect is nonetheless cumulative.
# Previous versions of this file caused ~28k shell instances to be spawned for
# `make DESIGN_CONFIG=... clean_all`, which could be reduced to 41.
#
# The 'obvious' solution here is to just run each shell command once by forcing
# an immediate expansion with `:=`, something like
#
#   PYTHON_EXE ?= $(shell command -v python3)
#   export PYTHON_EXE := $(PYTHON_EXE)
#
# but this changes 'where' PYTHON_EXE was defined, command line/environment
# versus in a file, which messes with `get_variables` and causes command
# line/environment variables to not be propagated to submakes.
#
# Python is not built by ORFS, and as such its absolute path has to be fetched
# from the environment. Use `ifeq ($(origin PYTHON_EXE), undefined)` to check if
# the variable hasn't been defined yet and run a single shell instance to fetch
# the absolute path if so. The other tools should've been built by ORFS, and can
# use a pre-specified path, which we can just use ?= for.
ifeq ($(origin PYTHON_EXE), undefined)
  PYTHON_EXE := $(shell command -v python3)
endif
export PYTHON_EXE

export RUN_CMD = $(PYTHON_EXE) $(FLOW_HOME)/scripts/run_command.py

export OPENROAD_EXE ?= $(abspath $(FLOW_HOME)/../tools/install/OpenROAD/bin/openroad)
export OPENSTA_EXE  ?= $(abspath $(FLOW_HOME)/../tools/install/OpenROAD/bin/sta)

OPENROAD_IS_VALID := $(if $(OPENROAD_EXE),$(shell test -x $(OPENROAD_EXE) && echo "true"),)

export OPENROAD_ARGS = -no_init -threads $(NUM_CORES) $(OR_ARGS)
export OPENROAD_CMD = $(OPENROAD_EXE) -exit $(OPENROAD_ARGS)
export OPENROAD_NO_EXIT_CMD = $(OPENROAD_EXE) $(OPENROAD_ARGS)
export OPENROAD_GUI_CMD = $(OPENROAD_EXE) -gui -threads $(NUM_CORES) $(OR_ARGS)
export OPENROAD_WEB_CMD = $(OPENROAD_EXE) -web -threads $(NUM_CORES) $(OR_ARGS)

export YOSYS_EXE ?= $(abspath $(FLOW_HOME)/../tools/install/yosys/bin/yosys)

YOSYS_IS_VALID := $(if $(YOSYS_EXE),$(shell test -x $(YOSYS_EXE) && echo "true"),)

# Use locally installed and built klayout if it exists, otherwise use klayout in path
KLAYOUT_DIR = $(abspath $(FLOW_HOME)/../tools/install/klayout/)
KLAYOUT_BIN_FROM_DIR = $(KLAYOUT_DIR)/klayout

KEPLER_FORMAL_EXE ?= $(abspath $(FLOW_HOME)/../tools/install/kepler-formal/bin/kepler-formal)
export KEPLER_FORMAL_EXE

ifeq ($(wildcard $(KLAYOUT_BIN_FROM_DIR)), $(KLAYOUT_BIN_FROM_DIR))
KLAYOUT_CMD ?= sh -c 'LD_LIBRARY_PATH=$(dir $(KLAYOUT_BIN_FROM_DIR)) $$0 "$$@"' $(KLAYOUT_BIN_FROM_DIR)
else
ifeq ($(KLAYOUT_CMD),)
KLAYOUT_CMD ?= $(shell command -v klayout)
endif
endif

export KLAYOUT_CMD := $(KLAYOUT_CMD)

#-------------------------------------------------------------------------------
WRAPPED_LEFS = $(foreach lef,$(notdir $(WRAP_LEFS)),$(OBJECTS_DIR)/lef/$(lef:.lef=_mod.lef))
WRAPPED_LIBS = $(foreach lib,$(notdir $(WRAP_LIBS)),$(OBJECTS_DIR)/$(lib:.lib=_mod.lib))
export ADDITIONAL_LEFS += $(WRAPPED_LEFS) $(WRAP_LEFS)
export LIB_FILES += $(WRAP_LIBS) $(WRAPPED_LIBS)

# Stream system used for final result (GDS is default): GDS, GSDII, GDS2, OASIS, or OAS
STREAM_SYSTEM ?= GDS
ifneq ($(findstring GDS,$(shell echo $(STREAM_SYSTEM) | tr '[:lower:]' '[:upper:]')),)
	export STREAM_SYSTEM_EXT := gds
	GDSOAS_FILES = $(GDS_FILES)
	ADDITIONAL_GDSOAS = $(ADDITIONAL_GDS)
	SEAL_GDSOAS = $(SEAL_GDS)
else
	export STREAM_SYSTEM_EXT := oas
	GDSOAS_FILES = $(OAS_FILES)
	ADDITIONAL_GDSOAS = $(ADDITIONAL_OAS)
	SEAL_GDSOAS = $(SEAL_OAS)
endif
export WRAPPED_GDSOAS = $(foreach lef,$(notdir $(WRAP_LEFS)),$(OBJECTS_DIR)/$(lef:.lef=_mod.$(STREAM_SYSTEM_EXT)))

# If we are running headless use offscreen rendering for save_image
ifeq ($(DISPLAY),)
export QT_QPA_PLATFORM ?= offscreen
endif

# Create Macro wrappers (if necessary)
export WRAP_CFG = $(PLATFORM_DIR)/wrapper.cfg

export TCLLIBPATH := util/cell-veneer $(TCLLIBPATH)

export SYNTH_SCRIPT ?= $(SCRIPTS_DIR)/synth.tcl

export YOSYS_DEPENDENCIES=$(LIB_FILES) $(WRAPPED_LIBS) $(DFF_LIB_FILE) $(VERILOG_FILES) $(SYNTH_NETLIST_FILES) $(LATCH_MAP_FILE) $(ADDER_MAP_FILE)

export GDS_FINAL_FILE = $(RESULTS_DIR)/6_final.$(STREAM_SYSTEM_EXT)
export RESULTS_ODB = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.odb)))
export RESULTS_DEF = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.def)))
export RESULTS_GDS = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.gds)))
export RESULTS_OAS = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.oas)))
export RESULTS_V = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.v)))
export GDS_MERGED_FILE = $(RESULTS_DIR)/6_1_merged.$(STREAM_SYSTEM_EXT)

define get_variables
$(foreach V, $(.VARIABLES),$(if $(filter-out $(1), $(origin $V)), $(if $(filter-out .% %QT_QPA_PLATFORM% KLAYOUT% OPENROAD_EXE OPENROAD_ARGS OPENROAD_CMD OPENROAD_NO_EXIT_CMD OPENROAD_GUI_CMD OPENROAD_WEB_CMD OPENROAD_IS_VALID OPENSTA% PYTHON% YOSYS% GENERATE_ABSTRACT_RULE% do-step% do-copy% OPEN_GUI% OPEN_GUI_SHORTCUT% SUB_MAKE% UNSET_VARS% export%, $(V)), $V$ )))
endef

export UNSET_VARIABLES_NAMES := $(call get_variables,command% line environment% default automatic)
export ISSUE_VARIABLES_NAMES := $(sort $(filter-out \n get_variables, $(call get_variables,environment% default automatic)))
# This is Makefile's way to define a macro that expands to a single newline.
define newline


endef
export ISSUE_VARIABLES := $(foreach V, $(ISSUE_VARIABLES_NAMES), $(if $($V),$V=$($V),$V='')$(newline))
export COMMAND_LINE_ARGS := $(foreach V,$(.VARIABLES),$(if $(filter command% line, $(origin $V)),$(V)))

.PHONY: vars
vars:
	mkdir -p $(OBJECTS_DIR)
	$(UTILS_DIR)/generate-vars.sh $(OBJECTS_DIR)/vars

.PHONY: print-%
print-%:
	$(info $*: $($*))
	@true
