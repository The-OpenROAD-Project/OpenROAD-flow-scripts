# ==============================================================================
# Uncomment or add the design to run
# ==============================================================================

# DESIGN_CONFIG=./designs/nangate45/aes/config.mk
# DESIGN_CONFIG=./designs/nangate45/black_parrot/config.mk
# DESIGN_CONFIG=./designs/nangate45/bp_be_top/config.mk
# DESIGN_CONFIG=./designs/nangate45/bp_fe_top/config.mk
# DESIGN_CONFIG=./designs/nangate45/bp_multi_top/config.mk
# DESIGN_CONFIG=./designs/nangate45/dynamic_node/config.mk
# DESIGN_CONFIG=./designs/nangate45/gcd/config.mk
# DESIGN_CONFIG=./designs/nangate45/ibex/config.mk
# DESIGN_CONFIG=./designs/nangate45/jpeg/config.mk
# DESIGN_CONFIG=./designs/nangate45/swerv/config.mk
# DESIGN_CONFIG=./designs/nangate45/swerv_wrapper/config.mk
# DESIGN_CONFIG=./designs/nangate45/tiny-tests/config.mk
# DESIGN_CONFIG=./designs/nangate45/tinyRocket/config.mk

# DESIGN_CONFIG=./designs/tsmc65lp/aes/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/ariane/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/black_parrot/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/bp_be_top/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/bp_fe_top/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/bp_multi_top/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/coyote/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/dynamic_node/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/gcd/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/ibex/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/jpeg/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/swerv/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/swerv_wrapper/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/tinyRocket/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/vanilla5/config.mk

# DESIGN_CONFIG=./designs/gf12/aes/config.mk
# DESIGN_CONFIG=./designs/gf12/coyote/config.mk
# DESIGN_CONFIG=./designs/gf12/dynamic_node/config.mk
# DESIGN_CONFIG=./designs/gf12/gcd/config.mk
# DESIGN_CONFIG=./designs/gf12/ibex/config.mk
# DESIGN_CONFIG=./designs/gf12/jpeg/config.mk
# DESIGN_CONFIG=./designs/gf12/swerv/config.mk
# DESIGN_CONFIG=./designs/gf12/swerv_wrapper/config.mk
# DESIGN_CONFIG=./designs/gf12/tinyRocket/config.mk

# DESIGN_CONFIG=./designs/gf12/bsg_padring/config.mk
# DESIGN_CONFIG=./designs/gf12/bsg_loopback/config.mk
# DESIGN_CONFIG=./designs/gf12/bp_single/config.mk
# DESIGN_CONFIG=./designs/gf12/bp_dual/config.mk
# DESIGN_CONFIG=./designs/gf12/bp_quad/config.mk

# DESIGN_CONFIG=./designs/sky130hd/gcd/config.mk
# DESIGN_CONFIG=./designs/sky130hd/ibex/config.mk
# DESIGN_CONFIG=./designs/sky130hd/aes/config.mk
# DESIGN_CONFIG=./designs/sky130hd/jpeg/config.mk
# DESIGN_CONFIG=./designs/sky130hd/coyote_tc/config.mk
# DESIGN_CONFIG=./designs/sky130hd/chameleon/config.mk
# DESIGN_CONFIG=./designs/sky130hd/riscv32i/config.mk
# DESIGN_CONFIG=./designs/sky130hd/chameleon_hier/config.mk

# sky130hd PPA
# DESIGN_CONFIG=./designs/sky130hd/gcd/config_ppa.mk
# DESIGN_CONFIG=./designs/sky130hd/aes/config_ppa.mk
# DESIGN_CONFIG=./designs/sky130hd/ibex/config_ppa.mk
# DESIGN_CONFIG=./designs/sky130hd/jpeg/config_ppa.mk


# DESIGN_CONFIG=./designs/sky130hs/gcd/config.mk
# DESIGN_CONFIG=./designs/sky130hs/ibex/config.mk
# DESIGN_CONFIG=./designs/sky130hs/aes/config.mk
# DESIGN_CONFIG=./designs/sky130hs/jpeg/config.mk
# DESIGN_CONFIG=./designs/sky130hs/riscv32i/config.mk

# sky130hs PPA
# DESIGN_CONFIG=./designs/sky130hs/gcd/config_ppa.mk
# DESIGN_CONFIG=./designs/sky130hs/aes/config_ppa.mk
# DESIGN_CONFIG=./designs/sky130hs/ibex/config_ppa.mk
# DESIGN_CONFIG=./designs/sky130hs/jpeg/config_ppa.mk

# DESIGN_CONFIG=./designs/asap7/gcd/config.mk
# DESIGN_CONFIG=./designs/asap7/ibex/config.mk
# DESIGN_CONFIG=./designs/asap7/aes/config.mk
# DESIGN_CONFIG=./designs/asap7/jpeg/config.mk

# DESIGN_CONFIG=./designs/intel22/gcd/config.mk
# DESIGN_CONFIG=./designs/intel22/aes/config.mk
#
# Default design
DESIGN_CONFIG ?= ./designs/nangate45/gcd/config.mk
# Global override Floorplan
# export CORE_UTILIZATION := 30
# export CORE_ASPECT_RATIO := 1
# export CORE_MARGIN := 4

# ==============================================================================
#  ____  _____ _____ _   _ ____
# / ___|| ____|_   _| | | |  _ \
# \___ \|  _|   | | | | | | |_) |
#  ___) | |___  | | | |_| |  __/
# |____/|_____| |_|  \___/|_|
#
# ==============================================================================

#-------------------------------------------------------------------------------
# Default target when invoking without specific target.
.DEFAULT_GOAL := finish

#-------------------------------------------------------------------------------
# Proper way to initiate SHELL for make
SHELL          = /bin/bash
.SHELLFLAGS    = -o pipefail -c

#-------------------------------------------------------------------------------
# Setup varialbles to point to root / head of the OpenROAD directory
# - the following settings allowed user to point OpenRoad binaries to different
#   location
# - default is current install / clone directory
export FLOW_HOME ?= .

#-------------------------------------------------------------------------------
# Setup variables to point to other location for the following sub directory
# - designs - default is under current directory
# - platforms - default is under current directory
# - work home - default is current directory
# - utils, scripts, test - default is under current directory
export DESIGN_HOME   ?= $(FLOW_HOME)/designs
export PLATFORM_HOME ?= $(FLOW_HOME)/platforms
export WORK_HOME     ?= .

export UTILS_DIR     ?= $(FLOW_HOME)/util
export SCRIPTS_DIR   ?= $(FLOW_HOME)/scripts
export TEST_DIR      ?= $(FLOW_HOME)/test

#-------------------------------------------------------------------------------
# Include design and platform configuration
include $(DESIGN_CONFIG)

PUBLIC=nangate45 sky130hd sky130hs asap7

ifneq ($(wildcard $(PLATFORM_HOME)/$(PLATFORM)),)
  export PLATFORM_DIR = $(PLATFORM_HOME)/$(PLATFORM)
else ifneq ($(findstring $(PLATFORM),$(PUBLIC)),)
  export PLATFORM_DIR = ./platforms/$(PLATFORM)
else ifneq ($(wildcard ../../$(PLATFORM)),)
  export PLATFORM_DIR = ../../$(PLATFORM)
else
  $(error [ERROR][FLOW] Platform '$(PLATFORM)' not found)
endif

$(info [INFO][FLOW] Using platform directory $(PLATFORM_DIR))
include $(PLATFORM_DIR)/config.mk

export FLOW_VARIANT ?= base

# Setup working directories
export DESIGN_NICKNAME ?= $(DESIGN_NAME)

export DESIGN_DIR  = $(dir $(DESIGN_CONFIG))
export LOG_DIR     = $(WORK_HOME)/logs/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)
export OBJECTS_DIR = $(WORK_HOME)/objects/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)
export REPORTS_DIR = $(WORK_HOME)/reports/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)
export RESULTS_DIR = $(WORK_HOME)/results/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)

ifdef BLOCKS
$(info [INFO][FLOW] Hierarichal flow is invoked)
$(foreach block,$(BLOCKS),$(info following block is to be hardened :  ${block}))
$(foreach block,$(BLOCKS),$(eval BLOCK_CONFIGS += ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/$(block)/config.mk))
$(foreach block,$(BLOCKS),$(eval BLOCK_LEFS += ./results/$(PLATFORM)/$(DESIGN_NICKNAME)_$(block)/$(FLOW_VARIANT)/${block}.lef))
$(foreach block,$(BLOCKS),$(eval BLOCK_GDS += ./results/$(PLATFORM)/$(DESIGN_NICKNAME)_$(block)/$(FLOW_VARIANT)/6_final.gds))
export ADDITIONAL_LEFS += $(BLOCK_LEFS)
export ADDITIONAL_GDS += $(BLOCK_GDS)
endif

#-------------------------------------------------------------------------------
ifeq (, $(strip $(NPROC)))
  # Linux (utility program)
  NPROC := $(shell nproc 2>/dev/null)

  ifeq (, $(strip $(NPROC)))
    # Linux (generic)
    NPROC := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
  endif
  ifeq (, $(strip $(NPROC)))
    # BSD (at least FreeBSD and Mac OSX)
    NPROC := $(shell sysctl -n hw.ncpu 2>/dev/null)
  endif
  ifeq (, $(strip $(NPROC)))
    # Fallback
    NPROC := 1
  endif
endif
export NUM_CORES := $(NPROC)

#-------------------------------------------------------------------------------
# setup all commands used within this flow
TIME_CMD = /usr/bin/time -f "%Eelapsed %PCPU %MmemKB"
TIME_TEST = $(shell $(TIME_CMD) echo foo 2>/dev/null)
ifeq (, $(strip $(TIME_TEST)))
  TIME_CMD = /usr/bin/time
endif

# The following determine the executable location for each tool used by this flow.
# Priority is given to
#       1 user include path to the executable prior to running make
#       2 user explicity set with variable in Makefile or command line
OPENROAD_CMD            ?= $(shell command -v openroad)
ifeq ($(OPENROAD_CMD),)
  OPENROAD_CMD           = $(abspath $(FLOW_HOME)/../tools/build/OpenROAD/src/openroad) -no_init -exit
else
  OPENROAD_CMD           = $(shell command -v openroad) -no_init -exit
endif
OPENROAD_NO_EXIT_CMD     = $(firstword $(OPENROAD_CMD))

YOSYS_CMD               ?= $(shell command -v yosys)
ifeq ($(YOSYS_CMD),)
  YOSYS_CMD              = $(abspath $(FLOW_HOME)/../tools/build/yosys/bin/yosys)
endif

KLAYOUT_CMD             ?= $(shell command -v klayout)

#-------------------------------------------------------------------------------
WRAPPED_LEFS = $(foreach lef,$(notdir $(WRAP_LEFS)),$(OBJECTS_DIR)/lef/$(lef:.lef=_mod.lef))
WRAPPED_LIBS = $(foreach lib,$(notdir $(WRAP_LIBS)),$(OBJECTS_DIR)/$(lib:.lib=_mod.lib))
export ADDITIONAL_LEFS += $(WRAPPED_LEFS) $(WRAP_LEFS)
export LIB_FILES += $(WRAP_LIBS) $(WRAPPED_LIBS)

export DONT_USE_LIBS   = $(addprefix $(OBJECTS_DIR)/lib/, $(notdir $(LIB_FILES)))
export DONT_USE_SC_LIB ?= $(OBJECTS_DIR)/lib/$(notdir $(firstword $(LIB_FILES)))

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
 
 
# Targets to harden Blocks in case of hierarchical flow is triggered  
build_macros: $(BLOCK_LEFS) 

$(foreach block,$(BLOCKS),$(eval ./results/$(PLATFORM)/$(DESIGN_NICKNAME)_$(block)/$(FLOW_VARIANT)/${block}.lef: ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/${block}/config.mk))

$(BLOCK_LEFS):   
	make DESIGN_CONFIG=$< generate_abstract
       
# Utility to print tool version information
#-------------------------------------------------------------------------------
.PHONY: versions.txt
versions.txt:
	@$(YOSYS_CMD) -V > $@
	@echo openroad `$(firstword $(OPENROAD_CMD)) -version` >> $@
	@$(KLAYOUT_CMD) -zz -v >> $@

# Pre-process libraries
# ==============================================================================

# Create temporary Liberty files which have the proper dont_use properties set
# For use with Yosys and ABC
.SECONDEXPANSION:
$(DONT_USE_LIBS): $$(filter %$$(@F),$(LIB_FILES))
	@mkdir -p $(OBJECTS_DIR)/lib
	$(UTILS_DIR)/markDontUse.py -p "$(DONT_USE_CELLS)" -i $^ -o $@

$(OBJECTS_DIR)/lib/merged.lib:
	$(UTILS_DIR)/mergeLib.pl $(PLATFORM)_merged $(DONT_USE_LIBS) > $@

# Pre-process KLayout tech
# ==============================================================================
$(OBJECTS_DIR)/klayout_tech.lef: $(TECH_LEF)
	@mkdir -p $(OBJECTS_DIR)
	sed '/OR_DEFAULT/d' $< > $@

 $(OBJECTS_DIR)/klayout.lyt: $(KLAYOUT_TECH_FILE) $(OBJECTS_DIR)/klayout_tech.lef
	sed 's,<lef-files>.*</lef-files>,$(foreach file, $(OBJECTS_DIR)/klayout_tech.lef $(SC_LEF) $(ADDITIONAL_LEFS),<lef-files>$(abspath $(file))</lef-files>),g' $< > $@

$(OBJECTS_DIR)/klayout_wrap.lyt: $(KLAYOUT_TECH_FILE) $(OBJECTS_DIR)/klayout_tech.lef
	sed 's,<lef-files>.*</lef-files>,$(foreach file, $(OBJECTS_DIR)/klayout_tech.lef $(WRAP_LEFS),<lef-files>$(abspath $(file))</lef-files>),g' $< > $@
# Create Macro wrappers (if necessary)
# ==============================================================================
WRAP_CFG = $(PLATFORM_DIR)/wrapper.cfg


export TCLLIBPATH := util/cell-veneer $(TCLLIBPATH)
$(WRAPPED_LEFS):
	mkdir -p $(OBJECTS_DIR)/lef $(OBJECTS_DIR)/def
	util/cell-veneer/wrap.tcl -cfg $(WRAP_CFG) -macro $(filter %$(notdir $(@:_mod.lef=.lef)),$(WRAP_LEFS))
	mv $(notdir $@) $@
	mv $(notdir $(@:lef=def)) $(dir $@)../def/$(notdir $(@:lef=def))

$(WRAPPED_LIBS):
	mkdir -p $(OBJECTS_DIR)/lib
	sed 's/library(\(.*\))/library(\1_mod)/g' $(filter %$(notdir $(@:_mod.lib=.lib)),$(WRAP_LIBS)) | sed 's/cell(\(.*\))/cell(\1_mod)/g' > $@

# ==============================================================================
#  ______   ___   _ _____ _   _ _____ ____ ___ ____
# / ___\ \ / / \ | |_   _| | | | ____/ ___|_ _/ ___|
# \___ \\ V /|  \| | | | | |_| |  _| \___ \| |\___ \
#  ___) || | | |\  | | | |  _  | |___ ___) | | ___) |
# |____/ |_| |_| \_| |_| |_| |_|_____|____/___|____/
#
synth: versions.txt \
       $(RESULTS_DIR)/1_synth.v \
       $(RESULTS_DIR)/1_synth.sdc
# ==============================================================================


# Run Synthesis using yosys
#-------------------------------------------------------------------------------
SYNTH_SCRIPT ?= $(SCRIPTS_DIR)/synth.tcl

$(RESULTS_DIR)/1_1_yosys.v: $(DONT_USE_LIBS) $(WRAPPED_LIBS) $(DONT_USE_SC_LIB) $(VERILOG_FILES)
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	($(TIME_CMD) $(YOSYS_CMD) -c $(SYNTH_SCRIPT)) 2>&1 | tee $(LOG_DIR)/1_1_yosys.log

$(RESULTS_DIR)/1_synth.v: $(RESULTS_DIR)/1_1_yosys.v
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	cp $< $@

$(RESULTS_DIR)/1_synth.sdc: $(SDC_FILE)
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	cp $< $@

clean_synth:
	rm -f  $(RESULTS_DIR)/1_*.v $(RESULTS_DIR)/1_synth.sdc
	rm -f  $(REPORTS_DIR)/synth_*
	rm -f  $(LOG_DIR)/1_*
	rm -rf _tmp_yosys-abc-*


# ==============================================================================
#  _____ _     ___   ___  ____  ____  _        _    _   _
# |  ___| |   / _ \ / _ \|  _ \|  _ \| |      / \  | \ | |
# | |_  | |  | | | | | | | |_) | |_) | |     / _ \ |  \| |
# |  _| | |__| |_| | |_| |  _ <|  __/| |___ / ___ \| |\  |
# |_|   |_____\___/ \___/|_| \_\_|   |_____/_/   \_\_| \_|
#
floorplan: $(RESULTS_DIR)/2_floorplan.def \
           $(RESULTS_DIR)/2_floorplan.sdc
# ==============================================================================


# STEP 1: Translate verilog to def
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_1_floorplan.def: $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS) $(FOOTPRINT) $(SIG_MAP_FILE)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/floorplan.tcl -metrics $(LOG_DIR)/2_1_floorplan.json) 2>&1 | tee $(LOG_DIR)/2_1_floorplan.log


# STEP 2: IO Placement (random)
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_2_floorplan_io.def: $(RESULTS_DIR)/2_1_floorplan.def $(IO_CONSTRAINTS)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/io_placement_random.tcl -metrics $(LOG_DIR)/2_2_floorplan_io.json) 2>&1 | tee $(LOG_DIR)/2_2_floorplan_io.log

# STEP 3: Timing Driven Mixed Sized Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_3_floorplan_tdms.def: $(RESULTS_DIR)/2_2_floorplan_io.def $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(LIB_FILES)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/tdms_place.tcl -metrics $(LOG_DIR)/2_3_tdms.json) 2>&1 | tee $(LOG_DIR)/2_3_tdms_place.log

# STEP 4: Macro Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_4_floorplan_macro.def: $(RESULTS_DIR)/2_3_floorplan_tdms.def $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(MACRO_PLACEMENT)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/macro_place.tcl -metrics $(LOG_DIR)/2_4_mplace.json) 2>&1 | tee $(LOG_DIR)/2_4_mplace.log

# STEP 5: Tapcell and Welltie insertion
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_5_floorplan_tapcell.def: $(RESULTS_DIR)/2_4_floorplan_macro.def $(TAPCELL_TCL)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/tapcell.tcl -metrics $(LOG_DIR)/2_5_tapcell.json) 2>&1 | tee $(LOG_DIR)/2_5_tapcell.log


# STEP 6: PDN generation
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_6_floorplan_pdn.def: $(RESULTS_DIR)/2_5_floorplan_tapcell.def $(PDN_CFG)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/pdn.tcl -metrics $(LOG_DIR)/2_6_pdn.json) 2>&1 | tee $(LOG_DIR)/2_6_pdn.log

$(RESULTS_DIR)/2_floorplan.def: $(RESULTS_DIR)/2_6_floorplan_pdn.def
	cp $< $@

$(RESULTS_DIR)/2_floorplan.sdc: $(RESULTS_DIR)/2_1_floorplan.def


clean_floorplan:
	rm -f $(RESULTS_DIR)/2_*floorplan*.def $(RESULTS_DIR)/2_floorplan.sdc $(RESULTS_DIR)/2_floorplan.v
	rm -f $(REPORTS_DIR)/2_*
	rm -f $(LOG_DIR)/2_*

# ==============================================================================
#  ____  _        _    ____ _____
# |  _ \| |      / \  / ___| ____|
# | |_) | |     / _ \| |   |  _|
# |  __/| |___ / ___ \ |___| |___
# |_|   |_____/_/   \_\____|_____|
#
place: $(RESULTS_DIR)/3_place.def \
       $(RESULTS_DIR)/3_place.sdc
# ==============================================================================

# STEP 1: Global placement + IO placement (not random)
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_1_place_gp.def: $(RESULTS_DIR)/2_floorplan.def $(RESULTS_DIR)/2_floorplan.sdc $(LIB_FILES)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/global_place.tcl -metrics $(LOG_DIR)/3_1_place_gp.json) 2>&1 | tee $(LOG_DIR)/3_1_place_gp.log

# STEP 2: IO placement (non-random)
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_2_place_iop.def: $(RESULTS_DIR)/3_1_place_gp.def $(IO_CONSTRAINTS)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/io_placement.tcl -metrics $(LOG_DIR)/3_2_place_iop.json) 2>&1 | tee $(LOG_DIR)/3_2_place_iop.log

# STEP 3: Resizing & Buffering
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_3_place_resized.def: $(RESULTS_DIR)/3_2_place_iop.def $(RESULTS_DIR)/2_floorplan.sdc
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/resize.tcl -metrics $(LOG_DIR)/3_3_resizer.json) 2>&1 | tee $(LOG_DIR)/3_3_resizer.log

clean_resize:
	rm -f $(RESULTS_DIR)/3_3_place_resized.def

# STEP 4: Detail placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_4_place_dp.def: $(RESULTS_DIR)/3_3_place_resized.def
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/detail_place.tcl -metrics $(LOG_DIR)/3_4_opendp.json) 2>&1 | tee $(LOG_DIR)/3_4_opendp.log

$(RESULTS_DIR)/3_place.def: $(RESULTS_DIR)/3_4_place_dp.def
	cp $< $@

$(RESULTS_DIR)/3_place.sdc: $(RESULTS_DIR)/2_floorplan.sdc
	cp $< $@

# Clean Targets
#-------------------------------------------------------------------------------
clean_place:
	rm -f $(RESULTS_DIR)/3_*place*.def
	rm -f $(RESULTS_DIR)/3_place.sdc
	rm -f $(REPORTS_DIR)/3_*
	rm -f $(LOG_DIR)/3_*


# ==============================================================================
#   ____ _____ ____
#  / ___|_   _/ ___|
# | |     | | \___ \
# | |___  | |  ___) |
#  \____| |_| |____/
#
cts: $(RESULTS_DIR)/4_cts.def \
     $(RESULTS_DIR)/4_cts.sdc
# ==============================================================================

# Run TritonCTS
# ------------------------------------------------------------------------------
$(RESULTS_DIR)/4_1_cts.def: $(RESULTS_DIR)/3_place.def $(RESULTS_DIR)/3_place.sdc
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/cts.tcl -metrics $(LOG_DIR)/4_1_cts.json) 2>&1 | tee $(LOG_DIR)/4_1_cts.log

# Filler cell insertion
# ------------------------------------------------------------------------------
$(RESULTS_DIR)/4_2_cts_fillcell.def: $(RESULTS_DIR)/4_1_cts.def
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/fillcell.tcl -metrics $(LOG_DIR)/4_2_cts_fillcell.json) 2>&1 | tee $(LOG_DIR)/4_2_cts_fillcell.log

$(RESULTS_DIR)/4_cts.sdc: $(RESULTS_DIR)/4_cts.def

$(RESULTS_DIR)/4_cts.def: $(RESULTS_DIR)/4_2_cts_fillcell.def
	cp $< $@

clean_cts:
	rm -rf $(RESULTS_DIR)/4_*cts*.def $(RESULTS_DIR)/4_cts.sdc $(RESULTS_DIR)/4_cts.v
	rm -f  $(REPORTS_DIR)/4_*
	rm -f  $(LOG_DIR)/4_*


# ==============================================================================
#  ____   ___  _   _ _____ ___ _   _  ____
# |  _ \ / _ \| | | |_   _|_ _| \ | |/ ___|
# | |_) | | | | | | | | |  | ||  \| | |  _
# |  _ <| |_| | |_| | | |  | || |\  | |_| |
# |_| \_\\___/ \___/  |_| |___|_| \_|\____|
#
route: $(RESULTS_DIR)/5_route.def \
       $(RESULTS_DIR)/5_route.sdc
# ==============================================================================


# STEP 1: Run global route
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/route.guide: $(RESULTS_DIR)/4_cts.def $(FASTROUTE_TCL) $(PRE_GLOBAL_ROUTE)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/global_route.tcl -metrics $(LOG_DIR)/5_1_fastroute.json) 2>&1 | tee $(LOG_DIR)/5_1_fastroute.log


# STEP 2: Run detailed route
#-------------------------------------------------------------------------------
ifeq ($(USE_WXL),)
$(RESULTS_DIR)/5_route.def: $(RESULTS_DIR)/route.guide
endif
$(RESULTS_DIR)/5_route.def: $(RESULTS_DIR)/4_cts.def
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/detail_route.tcl -metrics $(LOG_DIR)/5_2_TritonRoute.json) 2>&1 | tee $(LOG_DIR)/5_2_TritonRoute.log

$(RESULTS_DIR)/5_route.sdc: $(RESULTS_DIR)/4_cts.sdc
	cp $< $@

clean_route:
	rm -rf output*/ results*.out.dmp layer_*.mps
	rm -rf *.gdid *.log *.met *.sav *.res.dmp
	rm -rf $(RESULTS_DIR)/route.guide $(RESULTS_DIR)/output_guide.mod
	rm -rf $(RESULTS_DIR)/5_route.def $(RESULTS_DIR)/5_route.sdc
	rm -f  $(REPORTS_DIR)/5_*
	rm -f  $(LOG_DIR)/5_*

klayout_tr_rpt: $(RESULTS_DIR)/5_route.def $(OBJECTS_DIR)/klayout.lyt
	$(KLAYOUT_CMD) -rd in_drc="$(REPORTS_DIR)/5_route_drc.rpt" \
	        -rd in_def="$<" \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rm $(UTILS_DIR)/viewDrc.py

klayout_guides: $(RESULTS_DIR)/5_route.def $(OBJECTS_DIR)/klayout.lyt
	$(KLAYOUT_CMD) -rd in_guide="$(RESULTS_DIR)/route.guide" \
	        -rd in_def="$<" \
	        -rd net_name=$(GUIDE_NET) \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rm $(UTILS_DIR)/viewGuide.py

# ==============================================================================
#  _____ ___ _   _ ___ ____  _   _ ___ _   _  ____
# |  ___|_ _| \ | |_ _/ ___|| | | |_ _| \ | |/ ___|
# | |_   | ||  \| || |\___ \| |_| || ||  \| | |  _
# |  _|  | || |\  || | ___) |  _  || || |\  | |_| |
# |_|   |___|_| \_|___|____/|_| |_|___|_| \_|\____|
#
6_FINAL_FILE = $(RESULTS_DIR)/6_final.$(STREAM_SYSTEM_EXT)
finish: $(LOG_DIR)/6_report.log \
        $(RESULTS_DIR)/6_final.v \
        $(RESULTS_DIR)/6_final.sdc \
        $(6_FINAL_FILE)
# ==============================================================================

ifneq ($(USE_FILL),)
$(RESULTS_DIR)/6_1_fill.def: $(RESULTS_DIR)/5_route.def
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/density_fill.tcl -metrics $(LOG_DIR)/6_density_fill.json) 2>&1 | tee $(LOG_DIR)/6_density_fill.log
else
$(RESULTS_DIR)/6_1_fill.def: $(RESULTS_DIR)/5_route.def
	cp $< $@
endif

$(RESULTS_DIR)/6_1_fill.sdc: $(RESULTS_DIR)/5_route.sdc
	cp $< $@

$(RESULTS_DIR)/6_final.sdc: $(RESULTS_DIR)/5_route.sdc
	cp $< $@

$(LOG_DIR)/6_report.log: $(RESULTS_DIR)/6_1_fill.def $(RESULTS_DIR)/6_1_fill.sdc
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/final_report.tcl -metrics $(LOG_DIR)/6_report.json) 2>&1 | tee $(LOG_DIR)/6_report.log

$(RESULTS_DIR)/6_final.def: $(LOG_DIR)/6_report.log

generate_abstract: $(RESULTS_DIR)/6_final.gds $(RESULTS_DIR)/6_final.def  $(RESULTS_DIR)/6_final.v
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/generate_abstract.tcl -metrics $(LOG_DIR)/generate_abstract.json) 2>&1 | tee $(LOG_DIR)/generate_abstract.log


# Merge wrapped macros using Klayout
#-------------------------------------------------------------------------------
$(WRAPPED_GDSOAS): $(OBJECTS_DIR)/klayout_wrap.lyt $(WRAPPED_LEFS)
	($(TIME_CMD) $(KLAYOUT_CMD) -zz -rd design_name=$(basename $(notdir $@)) \
	        -rd in_def=$(OBJECTS_DIR)/def/$(notdir $(@:$(STREAM_SYSTEM_EXT)=def)) \
	        -rd in_files="$(ADDITIONAL_GDSOAS)" \
	        -rd config_file=$(FILL_CONFIG) \
	        -rd seal_file="" \
	        -rd out_file=$@ \
	        -rd tech_file=$(OBJECTS_DIR)/klayout_wrap.lyt \
	        -rm $(UTILS_DIR)/def2stream.py) 2>&1 | tee $(LOG_DIR)/6_merge_$(basename $(notdir $@)).log

# Merge GDS using Klayout
#-------------------------------------------------------------------------------
6_1_MERGED_FILE = $(RESULTS_DIR)/6_1_merged.$(STREAM_SYSTEM_EXT)
$(6_1_MERGED_FILE): $(RESULTS_DIR)/6_final.def $(OBJECTS_DIR)/klayout.lyt $(GDSOAS_FILES) $(WRAPPED_GDSOAS)
	($(TIME_CMD) stdbuf -o L $(KLAYOUT_CMD) -zz -rd design_name=$(DESIGN_NAME) \
	        -rd in_def=$< \
	        -rd in_files="$(GDSOAS_FILES) $(WRAPPED_GDSOAS)" \
	        -rd config_file=$(FILL_CONFIG) \
	        -rd seal_file="$(SEAL_GDSOAS)" \
	        -rd out_file=$@ \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rm $(UTILS_DIR)/def2stream.py) 2>&1 | tee $(LOG_DIR)/6_1_merge.log

$(RESULTS_DIR)/6_final.v: $(LOG_DIR)/6_report.log

$(6_FINAL_FILE): $(6_1_MERGED_FILE)
	cp $^ $@

drc: $(REPORTS_DIR)/6_drc.lyrdb

$(REPORTS_DIR)/6_drc.lyrdb: $(6_FINAL_FILE) $(KLAYOUT_DRC_FILE)
ifneq ($(KLAYOUT_DRC_FILE),)
	($(TIME_CMD) $(KLAYOUT_CMD) -zz -rd in_gds="$<" \
	        -rd report_file=$(abspath $@) \
	        -r $(KLAYOUT_DRC_FILE)) 2>&1 | tee $(LOG_DIR)/6_drc.log
	# Hacky way of getting DRV count (don't error on no matches)
	grep -c "<value>" $@ > $(REPORTS_DIR)/6_drc_count.rpt || [[ $$? == 1 ]]
else
	echo "DRC not supported on this platform" > $@
endif

$(RESULTS_DIR)/6_final.cdl: $(RESULTS_DIR)/6_final.v
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/cdl.tcl) 2>&1 | tee $(LOG_DIR)/6_cdl.log

$(OBJECTS_DIR)/6_final_concat.cdl: $(RESULTS_DIR)/6_final.cdl $(CDL_FILE)
	cat $^ > $@

lvs: $(RESULTS_DIR)/6_lvs.lvsdb

$(RESULTS_DIR)/6_lvs.lvsdb: $(6_FINAL_FILE) $(KLAYOUT_LVS_FILE) $(OBJECTS_DIR)/6_final_concat.cdl
ifneq ($(KLAYOUT_LVS_FILE),)
	($(TIME_CMD) $(KLAYOUT_CMD) -b -rd in_gds="$<" \
	        -rd cdl_file=$(abspath $(OBJECTS_DIR)/6_final_concat.cdl) \
	        -rd report_file=$(abspath $@) \
	        -r $(KLAYOUT_LVS_FILE)) 2>&1 | tee $(LOG_DIR)/6_lvs.log
else
	echo "LVS not supported on this platform" > $@
endif

clean_finish:
	rm -rf $(RESULTS_DIR)/6_*.gds $(RESULTS_DIR)/6_*.oas $(RESULTS_DIR)/6_*.def $(RESULTS_DIR)/6_*.v $(RESULTS_DIR)/6_*.sdc
	rm -rf $(REPORTS_DIR)/6_*.rpt
	rm -f  $(LOG_DIR)/6_*



# ==============================================================================
#  __  __ ___ ____   ____
# |  \/  |_ _/ ___| / ___|
# | |\/| || |\___ \| |
# | |  | || | ___) | |___
# |_|  |_|___|____/ \____|
#
# ==============================================================================

all: $(SDC_FILE) $(WRAPPED_LIBS) $(DONT_USE_LIBS) $(OBJECTS_DIR)/klayout.lyt $(WRAPPED_GDSOAS)
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/run_all.tcl -metrics $(LOG_DIR)/run_all.json) 2>&1 | tee $(LOG_DIR)/run_all.log

clean:
	@echo
	@echo "Make clean disabled."
	@echo "Use make clean_all or clean individual steps:"
	@echo "  clean_synth clean_floorplan clean_place clean_cts clean_route clean_finish"
	@echo

clean_all: clean_synth clean_floorplan clean_place clean_cts clean_route clean_finish clean_metadata
	rm -rf $(OBJECTS_DIR)

nuke: clean_test clean_issues
	rm -rf ./results ./logs ./reports ./objects
	rm -rf layer_*.mps macrocell.list *best.plt *_pdn.def dummy.guide
	rm -rf *.rpt *.rpt.old *.def.v pin_dumper.log
	rm -rf versions.txt


# DEF/GDS/OAS viewer shortcuts
#-------------------------------------------------------------------------------
RESULTS_DEF = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.def)))
RESULTS_GDS = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.gds)))
RESULTS_OAS = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.oas)))
$(foreach file,$(RESULTS_DEF) $(RESULTS_GDS) $(RESULTS_OAS),klayout_$(file)): klayout_%: $(OBJECTS_DIR)/klayout.lyt
	$(KLAYOUT_CMD) -nn $(OBJECTS_DIR)/klayout.lyt $(RESULTS_DIR)/$*

gui_final: gui_6_final.def

$(foreach file,$(RESULTS_DEF),gui_$(file)): gui_%:
	DEF_FILE=$(RESULTS_DIR)/$* $(OPENROAD_NO_EXIT_CMD) -gui $(SCRIPTS_DIR)/gui.tcl

# Utilities
#-------------------------------------------------------------------------------
include $(UTILS_DIR)/utils.mk
export PRIVATE_DIR = ../../private_tool_scripts
-include $(PRIVATE_DIR)/util/utils.mk
