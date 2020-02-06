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


# Utility to print tool version information
#-------------------------------------------------------------------------------
versions.txt:
	@yosys -V > $(abspath $@)
	@echo openroad `openroad -version` >> $(abspath $@)
	@klayout -v >> $(abspath $@)
	@echo TritonRoute `which TritonRoute` >> $(abspath $@)


# Pre-process Lefs
# ==============================================================================
$(OBJECTS_DIR)/merged.lef: $(TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS)
	mkdir -p $(OBJECTS_DIR)
	$(UTILS_DIR)/mergeLef.py --inputLef $(TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS) --outputLef $@

$(OBJECTS_DIR)/merged_padded.lef: $(OBJECTS_DIR)/merged.lef
	$(UTILS_DIR)/padLefMacro.py -r $(CELL_PAD_IN_SITES) \
	                              -l 0 \
	                              -s $(PLACE_SITE) \
	                              -i $< \
	                              -o $@

# Modify lef files for TritonRoute
$(OBJECTS_DIR)/merged_padded_spacing.lef: $(OBJECTS_DIR)/merged_padded.lef
	$(UTILS_DIR)/modifyLefSpacing.py -i $< -o $@

# Create special generic lef for TritonRoute if required.
ifneq ($(GENERIC_TECH_LEF),)
$(OBJECTS_DIR)/generic_merged_padded_spacing.lef: $(GENERIC_TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS)
	mkdir -p $(OBJECTS_DIR)
	$(UTILS_DIR)/mergeLef.py --inputLef $(GENERIC_TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS) --outputLef $@
	$(UTILS_DIR)/padLefMacro.py -r $(CELL_PAD_IN_SITES) \
	                              -l 0 \
	                              -s $(PLACE_SITE) \
	                              -i $@ \
	                              -o $@
	$(UTILS_DIR)/modifyLefSpacing.py -i $@ -o $@
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
	sed 's,<lef-files>.*</lef-files>,<lef-files>$(abspath $(OBJECTS_DIR)/merged.lef)</lef-files>,g' $^ > $@

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
	yosys -l $(LOG_DIR)/1_1_yosys.log -c $(SYNTH_SCRIPT)

$(RESULTS_DIR)/1_synth.v: $(RESULTS_DIR)/1_1_yosys.v
	cp $< $@

$(RESULTS_DIR)/1_synth.sdc: $(SDC_FILE)
	cp $< $@

clean_synth:
	rm -rf $(RESULTS_DIR)/1_*.v $(RESULTS_DIR)/1_synth.sdc
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
$(RESULTS_DIR)/2_1_floorplan.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc
	openroad -no_init $(SCRIPTS_DIR)/floorplan.tcl \
	  2>&1 | tee $(LOG_DIR)/2_1_floorplan.log
	@! grep --color "Error:" $(LOG_DIR)/2_1_floorplan.log


# STEP 2: IO Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_2_floorplan_io.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/2_1_floorplan.def
	openroad -no_init $(SCRIPTS_DIR)/io_placement.tcl \
	  2>&1 | tee $(LOG_DIR)/2_2_floorplan_io.log
	@! grep --color "Error:" $(LOG_DIR)/2_2_floorplan_io.log

# STEP 3: Timing Driven Mixed Sized Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_3_floorplan_tdms.def: $(RESULTS_DIR)/2_2_floorplan_io.def $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(LIB_FILES) $(OBJECTS_DIR)/merged_padded.lef
	openroad -no_init $(SCRIPTS_DIR)/tdms_place.tcl \
	  2>&1 | tee $(LOG_DIR)/2_3_tdms_place.log
	@! grep --color "Error:" $(LOG_DIR)/2_3_tdms_place.log
	$(UTILS_DIR)/fixIoPins.py --inputDef $@ --outputDef $@ --margin $(IO_PIN_MARGIN)

# STEP 4: Macro Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_4_floorplan_macro.def: $(RESULTS_DIR)/2_3_floorplan_tdms.def $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(IP_GLOBAL_CFG)
	openroad -no_init $(SCRIPTS_DIR)/macro_place.tcl \
	  2>&1 | tee $(LOG_DIR)/2_4_mplace.log

# STEP 5: PDN generation
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_5_floorplan_pdn.def: $(RESULTS_DIR)/2_4_floorplan_macro.def
	openroad -no_init $(SCRIPTS_DIR)/pdn.tcl | tee $(LOG_DIR)/2_5_pdn.log
	@! grep --color "Error:" $(LOG_DIR)/2_5_pdn.log
	@! grep --color "ERROR:" $(LOG_DIR)/2_5_pdn.log

# STEP 6: Tapcell and Welltie insertion
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_6_floorplan_tapcell.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/2_5_floorplan_pdn.def
	openroad -no_init $(SCRIPTS_DIR)/tapcell.tcl \
	  2>&1 | tee $(LOG_DIR)/2_6_tapcell.log
	@! grep --color "Error:" $(LOG_DIR)/2_6_tapcell.log

$(RESULTS_DIR)/2_floorplan.def: $(RESULTS_DIR)/2_6_floorplan_tapcell.def
	cp $< $@

$(RESULTS_DIR)/2_floorplan.v: $(RESULTS_DIR)/2_1_floorplan.def

$(RESULTS_DIR)/2_floorplan.sdc: $(RESULTS_DIR)/2_1_floorplan.def


clean_floorplan:
	rm -rf $(RESULTS_DIR)/2_*floorplan*.def
	rm -rf $(RESULTS_DIR)/2_floorplan.v $(RESULTS_DIR)/2_floorplan.sdc

# ==============================================================================
#  ____  _        _    ____ _____
# |  _ \| |      / \  / ___| ____|
# | |_) | |     / _ \| |   |  _|
# |  __/| |___ / ___ \ |___| |___
# |_|   |_____/_/   \_\____|_____|
#
place: $(RESULTS_DIR)/3_place.def \
       $(RESULTS_DIR)/3_place.v \
       $(RESULTS_DIR)/3_place.sdc
# ==============================================================================

# STEP 1: Global placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_1_place_gp.def: $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/2_floorplan.def $(RESULTS_DIR)/2_floorplan.v $(RESULTS_DIR)/2_floorplan.sdc
	openroad -no_init $(SCRIPTS_DIR)/global_place.tcl \
	  2>&1 | tee $(LOG_DIR)/3_1_place_gp.log
	@! grep --color "Error:" $(LOG_DIR)/3_1_place_gp.log

# STEP 2: Resizing & Buffering
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_2_place_resized.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/3_1_place_gp.def $(RESULTS_DIR)/2_floorplan.sdc
	openroad -no_init $(SCRIPTS_DIR)/resize.tcl \
	         2>&1 | tee $(LOG_DIR)/3_2_resizer.log
	@! grep --color "Error:" $(LOG_DIR)/3_2_resizer.log

$(RESULTS_DIR)/3_place.v: $(RESULTS_DIR)/3_2_place_resized.def


# STEP 3: Detail placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_3_place_dp.def: $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/3_2_place_resized.def
	openroad -no_init $(SCRIPTS_DIR)/detail_place.tcl \
	         2>&1 | tee $(LOG_DIR)/3_3_opendp.log
	@! grep --color "Error:" $(LOG_DIR)/3_3_opendp.log

$(RESULTS_DIR)/3_place.def: $(RESULTS_DIR)/3_3_place_dp.def
	cp $< $@

$(RESULTS_DIR)/3_place.sdc: $(RESULTS_DIR)/2_floorplan.sdc
	cp $< $@

#OpeNPDN
export OPDN_OPENDBPY = $(OPENROAD)/build/src/OpeNPDN/modules/OpenDB/src/swig/python/opendbpy.py
OpeNPDN = $(OPENROAD)/src/OpeNPDN/
export OPDN_SRC = $(OpeNPDN)

analyze_power_grid:  $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/3_place.def $(RESULTS_DIR)/3_place.sdc $(OBJECTS_DIR)/merged.lib
	openroad -no_init -exit $(SCRIPTS_DIR)/analyze_pdn_ir.tcl  \
			2>&1 | tee $(LOG_DIR)/analyze_pdn_ir.log
	@! grep --color "Error:" $(LOG_DIR)/analyze_pdn_ir.log

# Clean Targets
#-------------------------------------------------------------------------------
clean_place:
	rm -rf $(RESULTS_DIR)/3_*place*.def
	rm -rf $(RESULTS_DIR)/3_place.v $(RESULTS_DIR)/3_place.sdc


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
$(RESULTS_DIR)/4_cts.v: $(RESULTS_DIR)/3_place.def $(RESULTS_DIR)/3_place.v $(RESULTS_DIR)/3_place.sdc
	openroad -no_init $(SCRIPTS_DIR)/cts.tcl \
		2>&1 | tee $(LOG_DIR)/4_cts.log
	@! grep --color "Error:" $(LOG_DIR)/4_cts.log

$(RESULTS_DIR)/4_cts.def: $(RESULTS_DIR)/4_cts.v


$(RESULTS_DIR)/4_cts.sdc: $(RESULTS_DIR)/4_cts.v

clean_cts:
	rm -rf $(RESULTS_DIR)/4_cts.def $(RESULTS_DIR)/4_cts.v $(RESULTS_DIR)/4_cts.sdc


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
$(RESULTS_DIR)/route.guide: $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/4_cts.def
	openroad -no_init $(SCRIPTS_DIR)/global_route.tcl 2>&1 | tee $(LOG_DIR)/5_1_fastroute.log
	@! grep --color "Error:" $(LOG_DIR)/5_1_fastroute.log


# STEP 2: Run detail route
#-------------------------------------------------------------------------------

# Generate param file for TritonRoute
#-------------------------------------------------------------------------------
ifneq ($(GENERIC_TECH_LEF),)
  export TRITON_ROUTE_LEF := $(OBJECTS_DIR)/generic_merged_padded_spacing.lef
else
  export TRITON_ROUTE_LEF := $(OBJECTS_DIR)/merged_padded_spacing.lef
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
	echo "threads:$(NPROC)" >> $@
	echo "cpxthreads:1" >> $@
	echo "verbose:1" >> $@
	echo "gap:0" >> $@
	echo "timeout:2400" >> $@

# Run TritonRoute
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/5_route.def: $(OBJECTS_DIR)/TritonRoute.param $(RESULTS_DIR)/4_cts.def $(RESULTS_DIR)/route.guide
	TritonRoute $(OBJECTS_DIR)/TritonRoute.param  2>&1 | tee $(LOG_DIR)/5_2_TritonRoute.log

$(RESULTS_DIR)/5_route.v: $(RESULTS_DIR)/4_cts.v
	cp $< $@

$(RESULTS_DIR)/5_route.sdc: $(RESULTS_DIR)/4_cts.sdc
	cp $< $@

clean_route:
	rm -rf output*/ results*.out.dmp layer_*.mps
	rm -rf *.gdid *.log *.met *.sav *.res.dmp
	rm -rf $(RESULTS_DIR)/route.guide $(OBJECTS_DIR)/TritonRoute.param
	rm -rf $(RESULTS_DIR)/5_route.def $(RESULTS_DIR)/5_route.v $(RESULTS_DIR)/5_route.sdc $(OBJECTS_DIR)/5_route_TA.def


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
$(REPORTS_DIR)/6_final_report.rpt: $(RESULTS_DIR)/5_route.def $(RESULTS_DIR)/5_route.sdc
	openroad -no_init $(SCRIPTS_DIR)/final_report.tcl \
	         2>&1 | tee $(LOG_DIR)/6_1_report.log
	@! grep --color "Error:" $(LOG_DIR)/6_1_report.log

# Run Klayout
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/6_1_merged.gds: $(OBJECTS_DIR)/klayout.lyt $(GDS_FILES) $(RESULTS_DIR)/5_route.def
	klayout -zz -rd design_name=$(DESIGN_NAME) \
	        -rd in_lef=$(abspath $(OBJECTS_DIR)/merged.lef) \
	        -rd in_def=$(RESULTS_DIR)/5_route.def \
	        -rd in_gds="$(GDS_FILES)" \
	        -rd out_gds=$@ \
	        -rd map_file=./platforms/$(PLATFORM)/layermap.txt \
	        -rm $(UTILS_DIR)/def2gds.py 2>&1 | tee $(LOG_DIR)/6_1_merge.log

# TODO(rovinski) Placeholder until fill script works for more platforms
ifneq ($(USE_FILL),)
$(RESULTS_DIR)/6_final.gds: $(RESULTS_DIR)/6_1_merged.gds
	klayout -zz -rd in_gds="$^" \
	        -rd out_gds="$@" \
	        -rd report_file="$(REPORTS_DIR)/6_2_density.rpt" \
	        -rm $(UTILS_DIR)/gdsFill.py 2>&1 | tee $(LOG_DIR)/6_2_fill.log
else
$(RESULTS_DIR)/6_final.gds: $(RESULTS_DIR)/6_1_merged.gds
	cp $^ $@
endif

clean_finish:
	rm -rf $(RESULTS_DIR)/6_1_merged.gds
	rm -rf $(RESULTS_DIR)/6_final.gds
	rm -rf $(REPORTS_DIR)/6_*.rpt



# ==============================================================================
#  __  __ ___ ____   ____
# |  \/  |_ _/ ___| / ___|
# | |\/| || |\___ \| |
# | |  | || | ___) | |___
# |_|  |_|___|____/ \____|
#
# ==============================================================================

all: $(SDC_FILE) $(OBJECTS_DIR)/merged.lib $(OBJECTS_DIR)/merged.lef $(OBJECTS_DIR)/TritonRoute.param
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	openroad -no_init $(SCRIPTS_DIR)/run_all.tcl

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
	rm -rf *.rpt *.rpt.old *.def.v innovus.* pin_dumper.log
	rm -rf versions.txt


# DEF/GDS viewer shortcuts
#-------------------------------------------------------------------------------
$(foreach def,$(notdir $(wildcard $(RESULTS_DIR)/*.def)),innovus_$(def)): innovus_%:
	innovus -execute "loadLefFile $(OBJECTS_DIR)/merged.lef ; \
	                  loadDefFile $(RESULTS_DIR)/$* ; \
	                  win" \
	                  -no_logv ; stty sane

RESULTS_DEF = $(notdir $(wildcard $(RESULTS_DIR)/*.def))
RESULTS_GDS = $(notdir $(wildcard $(RESULTS_DIR)/*.gds))
$(foreach file,$(RESULTS_DEF) $(RESULTS_GDS),klayout_$(file)): klayout_%: $(OBJECTS_DIR)/klayout.lyt
	klayout -nn $(OBJECTS_DIR)/klayout.lyt $(RESULTS_DIR)/$*


# Utilities
#-------------------------------------------------------------------------------
include $(UTILS_DIR)/utils.mk
