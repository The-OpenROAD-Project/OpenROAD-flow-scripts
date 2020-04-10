# ==============================================================================
# Uncomment or add the design to run
# ==============================================================================

# DESIGN_CONFIG=./designs/nangate45/aes.mk
# DESIGN_CONFIG=./designs/nangate45/black_parrot.mk
# DESIGN_CONFIG=./designs/nangate45/bp_be_top.mk
# DESIGN_CONFIG=./designs/nangate45/bp_fe_top.mk
# DESIGN_CONFIG=./designs/nangate45/bp_multi_top.mk
# DESIGN_CONFIG=./designs/nangate45/dynamic_node.mk
# DESIGN_CONFIG=./designs/nangate45/gcd.mk
# DESIGN_CONFIG=./designs/nangate45/ibex.mk
# DESIGN_CONFIG=./designs/nangate45/jpeg.mk
# DESIGN_CONFIG=./designs/nangate45/swerv.mk
# DESIGN_CONFIG=./designs/nangate45/swerv_wrapper.mk
# DESIGN_CONFIG=./designs/nangate45/tinyRocket.mk

# DESIGN_CONFIG=./designs/tsmc65lp/aes.mk
# DESIGN_CONFIG=./designs/tsmc65lp/ariane.mk
# DESIGN_CONFIG=./designs/tsmc65lp/black_parrot.mk
# DESIGN_CONFIG=./designs/tsmc65lp/bp_be_top.mk
# DESIGN_CONFIG=./designs/tsmc65lp/bp_fe_top.mk
# DESIGN_CONFIG=./designs/tsmc65lp/bp_multi_top.mk
# DESIGN_CONFIG=./designs/tsmc65lp/coyote.mk
# DESIGN_CONFIG=./designs/tsmc65lp/dynamic_node.mk
# DESIGN_CONFIG=./designs/tsmc65lp/gcd.mk
# DESIGN_CONFIG=./designs/tsmc65lp/ibex.mk
# DESIGN_CONFIG=./designs/tsmc65lp/jpeg.mk
# DESIGN_CONFIG=./designs/tsmc65lp/swerv.mk
# DESIGN_CONFIG=./designs/tsmc65lp/swerv_wrapper.mk
# DESIGN_CONFIG=./designs/tsmc65lp/tinyRocket.mk
# DESIGN_CONFIG=./designs/tsmc65lp/vb.mk

# DESIGN_CONFIG=./designs/gf14/aes.mk
# DESIGN_CONFIG=./designs/gf14/dynamic_node.mk
# DESIGN_CONFIG=./designs/gf14/gcd.mk
# DESIGN_CONFIG=./designs/gf14/ibex.mk
# DESIGN_CONFIG=./designs/gf14/jpeg.mk
# DESIGN_CONFIG=./designs/gf14/swerv.mk

# DESIGN_CONFIG=./designs/gf14/bsg_padring.mk
# DESIGN_CONFIG=./designs/gf14/bsg_loopback.mk
# DESIGN_CONFIG=./designs/gf14/bp_single.mk
# DESIGN_CONFIG=./designs/gf14/bp_quad.mk

# DESIGN_CONFIG=./designs/invecas12/gcd.mk

# DESIGN_CONFIG=./designs/sw130/gcd.mk


# Default design
DESIGN_CONFIG ?= ./designs/nangate45/gcd.mk

# # Global override Floorplan
# export CORE_UTILIZATION := 30
# export CORE_ASPECT_RATIO := 1
# export CORE_MARGIN := 4

default: finish

# ==============================================================================
#  ____  _____ _____ _   _ ____
# / ___|| ____|_   _| | | |  _ \
# \___ \|  _|   | | | | | | |_) |
#  ___) | |___  | | | |_| |  __/
# |____/|_____| |_|  \___/|_|
#
# ==============================================================================

# Include design and platform configuration
include $(DESIGN_CONFIG)
include ./platforms/$(PLATFORM)/config.mk

# Setup working directories
export DESIGN_NICKNAME ?= $(DESIGN_NAME)

export LOG_DIR     = ./logs/$(PLATFORM)/$(DESIGN_NICKNAME)
export OBJECTS_DIR = ./objects/$(PLATFORM)/$(DESIGN_NICKNAME)
export REPORTS_DIR = ./reports/$(PLATFORM)/$(DESIGN_NICKNAME)
export RESULTS_DIR = ./results/$(PLATFORM)/$(DESIGN_NICKNAME)

export SCRIPTS_DIR = ./scripts
export UTILS_DIR   = ./util
export TEST_DIR    = ./test

# Tool Options
SHELL = /bin/bash -o pipefail
TIME_CMD = /usr/bin/time -f "%Eelapsed %PCPU %MmemKB"
NUM_CORES = $(shell grep -c ^processor /proc/cpuinfo)
OPENROAD_CMD = openroad -no_init -exit


# Utility to print tool version information
#-------------------------------------------------------------------------------
versions.txt:
	@yosys -V > $(abspath $@)
	@echo openroad `openroad -version` >> $(abspath $@)
	@klayout -v >> $(abspath $@)
	@echo TritonRoute `which TritonRoute` >> $(abspath $@)

# Pre-process Lefs
# ==============================================================================

# Modify lef files for TritonRoute
$(OBJECTS_DIR)/merged_spacing.lef: $(TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS)
	mkdir -p $(OBJECTS_DIR)
	$(UTILS_DIR)/mergeLef.py --inputLef $(TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS) --outputLef $@
	$(UTILS_DIR)/modifyLefSpacing.py -i $@ -o $@

# Create special generic lef for TritonRoute if required.
ifneq ($(GENERIC_TECH_LEF),)
$(OBJECTS_DIR)/generic_merged_spacing.lef: $(GENERIC_TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS)
	mkdir -p $(OBJECTS_DIR)
	$(UTILS_DIR)/mergeLef.py --inputLef $(GENERIC_TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS) --outputLef $@
# 	$(UTILS_DIR)/modifyLefSpacing.py -i $@ -o $@
endif

# Pre-process libraries
# ==============================================================================
$(OBJECTS_DIR)/merged.lib: $(DESIGN_LIB_FILES)
	mkdir -p $(OBJECTS_DIR)
	$(UTILS_DIR)/mergeLib.pl $(PLATFORM)_merged \
	                           $(LIB_FILES) \
	                           > $@.tmp
	$(UTILS_DIR)/markDontUse.py -p "$(DONT_USE_CELLS)" -i $@.tmp -o $@

# Pre-process KLayout tech
# ==============================================================================
 $(OBJECTS_DIR)/klayout.lyt: $(KLAYOUT_TECH_FILE)
	mkdir -p $(OBJECTS_DIR)
	sed 's,<lef-files>.*</lef-files>,$(foreach file, $(TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS),<lef-files>$(abspath $(file))</lef-files>),g' $^ > $@

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
SYNTH_SCRIPT ?= scripts/synth.tcl

$(RESULTS_DIR)/1_1_yosys.v:  $(OBJECTS_DIR)/merged.lib
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	($(TIME_CMD) yosys -c $(SYNTH_SCRIPT)) 2>&1 | tee $(LOG_DIR)/1_1_yosys.log

$(RESULTS_DIR)/1_synth.v: $(RESULTS_DIR)/1_1_yosys.v
	cp $< $@

$(RESULTS_DIR)/1_synth.sdc: $(SDC_FILE)
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
           $(RESULTS_DIR)/2_floorplan.v \
           $(RESULTS_DIR)/2_floorplan.sdc
# ==============================================================================


# STEP 1: Translate verilog to def
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_1_floorplan.def: $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/floorplan.tcl) 2>&1 | tee $(LOG_DIR)/2_1_floorplan.log
	@! grep --color -i "^Error:" $(LOG_DIR)/2_1_floorplan.log


# STEP 2: IO Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_2_floorplan_io.def: $(RESULTS_DIR)/2_1_floorplan.def
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/io_placement.tcl) 2>&1 | tee $(LOG_DIR)/2_2_floorplan_io.log
	@! grep --color -i "^Error:" $(LOG_DIR)/2_2_floorplan_io.log

# STEP 3: Timing Driven Mixed Sized Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_3_floorplan_tdms.def: $(RESULTS_DIR)/2_2_floorplan_io.def $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(LIB_FILES)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/tdms_place.tcl) 2>&1 | tee $(LOG_DIR)/2_3_tdms_place.log
	@! grep --color -i "^Error:" $(LOG_DIR)/2_3_tdms_place.log
	$(UTILS_DIR)/fixIoPins.py --inputDef $@ --outputDef $@ --margin $(IO_PIN_MARGIN)

# STEP 4: Macro Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_4_floorplan_macro.def: $(RESULTS_DIR)/2_3_floorplan_tdms.def $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(IP_GLOBAL_CFG)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/macro_place.tcl) 2>&1 | tee $(LOG_DIR)/2_4_mplace.log
	@! grep --color -i "^Error:" $(LOG_DIR)/2_4_mplace.log

# STEP 5: Tapcell and Welltie insertion
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_5_floorplan_tapcell.def: $(RESULTS_DIR)/2_4_floorplan_macro.def
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/tapcell.tcl) 2>&1 | tee $(LOG_DIR)/2_5_tapcell.log
	@! grep --color -i "^Error:" $(LOG_DIR)/2_5_tapcell.log

# STEP 6: PDN generation
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_6_floorplan_pdn.def: $(RESULTS_DIR)/2_5_floorplan_tapcell.def
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/pdn.tcl) 2>&1 | tee $(LOG_DIR)/2_6_pdn.log
	@! grep --color -i "^Error:" $(LOG_DIR)/2_6_pdn.log

$(RESULTS_DIR)/2_floorplan.def: $(RESULTS_DIR)/2_6_floorplan_pdn.def
	cp $< $@

$(RESULTS_DIR)/2_floorplan.v: $(RESULTS_DIR)/2_1_floorplan.def

$(RESULTS_DIR)/2_floorplan.sdc: $(RESULTS_DIR)/2_1_floorplan.def


clean_floorplan:
	rm -rf $(RESULTS_DIR)/2_*floorplan*.def
	rm -rf $(RESULTS_DIR)/2_floorplan.v $(RESULTS_DIR)/2_floorplan.sdc
	rm -f  $(REPORTS_DIR)/2_*
	rm -f  $(LOG_DIR)/2_*

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

# STEP 1: Global placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_1_place_gp.def: $(RESULTS_DIR)/2_floorplan.def $(RESULTS_DIR)/2_floorplan.v $(RESULTS_DIR)/2_floorplan.sdc
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/global_place.tcl) 2>&1 | tee $(LOG_DIR)/3_1_place_gp.log
	@! grep --color -i "^Error:" $(LOG_DIR)/3_1_place_gp.log

# STEP 2: Resizing & Buffering
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_2_place_resized.def: $(RESULTS_DIR)/3_1_place_gp.def $(RESULTS_DIR)/2_floorplan.sdc
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/resize.tcl) 2>&1 | tee $(LOG_DIR)/3_2_resizer.log
	@! grep --color -i "^Error:" $(LOG_DIR)/3_2_resizer.log

# STEP 3: Detail placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_3_place_dp.def: $(RESULTS_DIR)/3_2_place_resized.def
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/detail_place.tcl) 2>&1 | tee $(LOG_DIR)/3_3_opendp.log
	@! grep --color -i "^Error:" $(LOG_DIR)/3_3_opendp.log

$(RESULTS_DIR)/3_place.def: $(RESULTS_DIR)/3_3_place_dp.def
	cp $< $@

$(RESULTS_DIR)/3_place.sdc: $(RESULTS_DIR)/2_floorplan.sdc
	cp $< $@

#OpeNPDN
export OPDN_OPENDBPY = $(OPENROAD)/build/src/OpeNPDN/modules/OpenDB/src/swig/python/opendbpy.py
OpeNPDN = $(OPENROAD)/src/OpeNPDN/
export OPDN_SRC = $(OpeNPDN)

analyze_power_grid: $(RESULTS_DIR)/3_place.def $(RESULTS_DIR)/3_place.sdc $(OBJECTS_DIR)/merged.lib
	($(TIME_CMD) $(OPENROAD_CMD) -exit $(SCRIPTS_DIR)/analyze_pdn_ir.tcl) 2>&1 | tee $(LOG_DIR)/analyze_pdn_ir.log
	@! grep --color -i "^Error:" $(LOG_DIR)/analyze_pdn_ir.log

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
     $(RESULTS_DIR)/4_cts.v \
     $(RESULTS_DIR)/4_cts.sdc
# ==============================================================================

# Run TritonCTS
# ------------------------------------------------------------------------------
$(RESULTS_DIR)/4_1_cts_prefillcell.def: $(RESULTS_DIR)/3_place.def $(RESULTS_DIR)/3_place.sdc
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/cts.tcl) 2>&1 | tee $(LOG_DIR)/4_1_cts_prefillcell.log
	@! grep --color -i "^Error:" $(LOG_DIR)/4_1_cts_prefillcell.log

# Filler insertion
# TODO(rovinski) This is more logically part of finishing, but OpenDB can't read
# the post-TritonRoute DEF at the moment
# ------------------------------------------------------------------------------
$(RESULTS_DIR)/4_cts.def: $(RESULTS_DIR)/4_1_cts_prefillcell.def
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/fillcell.tcl) 2>&1 | tee $(LOG_DIR)/4_cts.log
	@! grep --color -i "^Error:" $(LOG_DIR)/4_cts.log

$(RESULTS_DIR)/4_cts.v: $(RESULTS_DIR)/4_cts.def

$(RESULTS_DIR)/4_cts.sdc: $(RESULTS_DIR)/4_cts.def

clean_cts:
	rm -rf $(RESULTS_DIR)/4_cts.def $(RESULTS_DIR)/4_cts.v $(RESULTS_DIR)/4_cts.sdc
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
       $(RESULTS_DIR)/5_route.v \
       $(RESULTS_DIR)/5_route.sdc
# ==============================================================================


# STEP 1: Run global route
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/route.guide: $(RESULTS_DIR)/4_cts.def
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/global_route.tcl) 2>&1 | tee $(LOG_DIR)/5_1_fastroute.log
	@! grep --color -i "^Error:" $(LOG_DIR)/5_1_fastroute.log


# STEP 2: Run detail route
#-------------------------------------------------------------------------------

# Generate param file for TritonRoute
#-------------------------------------------------------------------------------
ifneq ($(GENERIC_TECH_LEF),)
  export TRITON_ROUTE_LEF := $(OBJECTS_DIR)/generic_merged_spacing.lef
else
  export TRITON_ROUTE_LEF := $(OBJECTS_DIR)/merged_spacing.lef
endif

$(OBJECTS_DIR)/TritonRoute.param: $(TRITON_ROUTE_LEF)
	echo "lef:$(TRITON_ROUTE_LEF)" > $@
	echo "def:$(RESULTS_DIR)/4_cts.def" >> $@
	echo "guide:$(RESULTS_DIR)/route.guide" >> $@
	echo "output:$(RESULTS_DIR)/5_route.def" >> $@
	echo "outputTA:$(OBJECTS_DIR)/5_route_TA.def" >> $@
	echo "outputguide:$(RESULTS_DIR)/output_guide.mod" >> $@
	echo "outputDRC:$(REPORTS_DIR)/5_route_drc.rpt" >> $@
	echo "outputMaze:$(RESULTS_DIR)/maze.log" >> $@
	echo "threads:$(NUM_CORES)" >> $@
	echo "cpxthreads:1" >> $@
	echo "verbose:1" >> $@
	echo "gap:0" >> $@
	echo "timeout:2400" >> $@
ifneq ($(dbProcessNode),)
	echo "dbProcessNode:$(dbProcessNode)" >> $@
endif

# Run TritonRoute
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/5_route.def: $(OBJECTS_DIR)/TritonRoute.param $(RESULTS_DIR)/4_cts.def $(RESULTS_DIR)/route.guide
ifeq ($(PLATFORM),gf14)
	($(TIME_CMD) TritonRoute14 $(OBJECTS_DIR)/TritonRoute.param) 2>&1 | tee $(LOG_DIR)/5_2_TritonRoute.log
else
	($(TIME_CMD) TritonRoute $(OBJECTS_DIR)/TritonRoute.param) 2>&1 | tee $(LOG_DIR)/5_2_TritonRoute.log
endif

$(RESULTS_DIR)/5_route.v: $(RESULTS_DIR)/4_cts.v
	cp $< $@

$(RESULTS_DIR)/5_route.sdc: $(RESULTS_DIR)/4_cts.sdc
	cp $< $@

clean_route:
	rm -rf output*/ results*.out.dmp layer_*.mps
	rm -rf *.gdid *.log *.met *.sav *.res.dmp
	rm -rf $(RESULTS_DIR)/route.guide $(OBJECTS_DIR)/TritonRoute.param
	rm -rf $(RESULTS_DIR)/5_route.def $(RESULTS_DIR)/5_route.v $(RESULTS_DIR)/5_route.sdc $(OBJECTS_DIR)/5_route_TA.def
	rm -f  $(REPORTS_DIR)/5_*
	rm -f  $(LOG_DIR)/5_*


# ==============================================================================
#  _____ ___ _   _ ___ ____  _   _ ___ _   _  ____
# |  ___|_ _| \ | |_ _/ ___|| | | |_ _| \ | |/ ___|
# | |_   | ||  \| || |\___ \| |_| || ||  \| | |  _
# |  _|  | || |\  || | ___) |  _  || || |\  | |_| |
# |_|   |___|_| \_|___|____/|_| |_|___|_| \_|\____|
#
finish: $(REPORTS_DIR)/6_final_report.rpt \
        $(RESULTS_DIR)/6_final.gds
# ==============================================================================
$(REPORTS_DIR)/6_final_report.rpt: $(RESULTS_DIR)/5_route.def $(RESULTS_DIR)/5_route.v $(RESULTS_DIR)/5_route.sdc
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/final_report.tcl) 2>&1 | tee $(LOG_DIR)/6_report.log
	@! grep --color -i "^Error:" $(LOG_DIR)/6_report.log

# Merge GDS using Klayout
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/6_1_merged.gds: $(OBJECTS_DIR)/klayout.lyt $(GDS_FILES) $(RESULTS_DIR)/5_route.def
	($(TIME_CMD) klayout -zz -rd design_name=$(DESIGN_NAME) \
	        -rd in_def=$(RESULTS_DIR)/5_route.def \
	        -rd in_gds="$(GDS_FILES)" \
	        -rd out_gds=$@ \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rm $(UTILS_DIR)/def2gds.py) 2>&1 | tee $(LOG_DIR)/6_1_merge.log

# TODO(rovinski) Placeholder until fill script works for more platforms
ifneq ($(USE_FILL),)
$(RESULTS_DIR)/6_final.gds: $(RESULTS_DIR)/6_1_merged.gds
	($(TIME_CMD) klayout -zz -rd in_gds="$<" \
	        -rd out_gds="$@" \
	        -rd config_file=$(FILL_CONFIG) \
	        -rd report_file="$(REPORTS_DIR)/6_2_density.rpt" \
	        -rm $(UTILS_DIR)/gdsFill.py) 2>&1 | tee $(LOG_DIR)/6_2_fill.log
else
$(RESULTS_DIR)/6_final.gds: $(RESULTS_DIR)/6_1_merged.gds
	cp $^ $@
endif

drc: $(REPORTS_DIR)/6_drc.lyrdb

$(REPORTS_DIR)/6_drc.lyrdb: $(RESULTS_DIR)/6_final.gds $(KLAYOUT_DRC_FILE)
ifneq ($(KLAYOUT_DRC_FILE),)
	($(TIME_CMD) klayout -zz -rd in_gds="$<" \
	        -rd report_file=$(abspath $@) \
	        -r $(KLAYOUT_DRC_FILE)) 2>&1 | tee $(LOG_DIR)/6_drc.log
	# Hacky way of getting DRV count (don't error on no matches)
	grep -c "<value>" $@ > $(REPORTS_DIR)/6_drc_count.rpt || [[ $$? == 1 ]]
else
	echo "DRC not supported on this platform" > $@
endif

clean_finish:
	rm -rf $(RESULTS_DIR)/6_1_merged.gds
	rm -rf $(RESULTS_DIR)/6_final.gds
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

all: $(SDC_FILE) $(OBJECTS_DIR)/merged.lib $(OBJECTS_DIR)/TritonRoute.param $(OBJECTS_DIR)/klayout.lyt
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/run_all.tcl) 2>&1 | tee $(LOG_DIR)/run_all.log

clean:
	@echo
	@echo "Make clean disabled."
	@echo "Use make clean_all or clean individual steps:"
	@echo "  clean_synth clean_floorplan clean_place clean_cts clean_route clean_finish"
	@echo

clean_all: clean_synth clean_floorplan clean_place clean_cts clean_route clean_finish
	rm -rf $(OBJECTS_DIR)

nuke: clean_test clean_issues
	rm -rf ./results ./logs ./reports ./objects
	rm -rf layer_*.mps macrocell.list *best.plt *_pdn.def dummy.guide run.param
	rm -rf *.rpt *.rpt.old *.def.v pin_dumper.log
	rm -rf versions.txt


# DEF/GDS viewer shortcuts
#-------------------------------------------------------------------------------
RESULTS_DEF = $(notdir $(wildcard $(RESULTS_DIR)/*.def))
RESULTS_GDS = $(notdir $(wildcard $(RESULTS_DIR)/*.gds))
$(foreach file,$(RESULTS_DEF) $(RESULTS_GDS),klayout_$(file)): klayout_%: $(OBJECTS_DIR)/klayout.lyt
	klayout -nn $(OBJECTS_DIR)/klayout.lyt $(RESULTS_DIR)/$*


# Utilities
#-------------------------------------------------------------------------------
include $(UTILS_DIR)/utils.mk
-include ./private/util/utils.mk
