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

# DESIGN_CONFIG=./designs/gf14/gcd.mk

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
export LOG_DIR     = ./logs/$(PLATFORM)/$(DESIGN_NAME)
export OBJECTS_DIR = ./objects/$(PLATFORM)/$(DESIGN_NAME)
export REPORTS_DIR = ./reports/$(PLATFORM)/$(DESIGN_NAME)
export RESULTS_DIR = ./results/$(PLATFORM)/$(DESIGN_NAME)

export SCRIPTS_DIR = ./scripts
export UTILS_DIR   = ./util
export TEST_DIR    = ./test

# Tool Options
SHELL = /bin/bash -o pipefail

# Quick check to make sure OpenROAD tools are installed
ifeq ("$(OPENROAD)","")
  $(error ERROR: These tests require the OpenROAD tools to be setup.)
endif


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

# Link flute data files
# ==============================================================================
./POST9.dat:
	ln -sf $(OPENROAD)/etc/$@ $@
./POWV9.dat:
	ln -sf $(OPENROAD)/etc/$@ $@
../etc/POST9.dat:
	mkdir -p ../etc
	ln -sf $(OPENROAD)/etc/POST9.dat $@
../etc/POWV9.dat:
	mkdir -p ../etc
	ln -sf $(OPENROAD)/etc/POWV9.dat $@



# ==============================================================================
#  ______   ___   _ _____ _   _ _____ ____ ___ ____
# / ___\ \ / / \ | |_   _| | | | ____/ ___|_ _/ ___|
# \___ \\ V /|  \| | | | | |_| |  _| \___ \| |\___ \
#  ___) || | | |\  | | | |  _  | |___ ___) | | ___) |
# |____/ |_| |_| \_| |_| |_| |_|_____|____/___|____/
#
synth: $(RESULTS_DIR)/1_synth.v \
       $(RESULTS_DIR)/1_synth.sdc
# ==============================================================================


# Run Synthesis using yosys
#-------------------------------------------------------------------------------
SYNTH_SCRIPT ?= scripts/synth.tcl

$(RESULTS_DIR)/1_1_yosys.v:  $(OBJECTS_DIR)/merged.lib
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	yosys -l $(LOG_DIR)/1_1_yosys.log -c $(SYNTH_SCRIPT)

$(RESULTS_DIR)/1_2_buffer.v: $(RESULTS_DIR)/1_1_yosys.v $(SDC_FILE) $(OBJECTS_DIR)/merged.lef | ../etc/POST9.dat ../etc/POWV9.dat
	openroad $(SCRIPTS_DIR)/buffer.tcl \
	        2>&1 | tee $(LOG_DIR)/1_2_buffer.log
	@! grep --color "Error:" $(LOG_DIR)/1_2_buffer.log


$(RESULTS_DIR)/1_synth.v: $(RESULTS_DIR)/1_2_buffer.v
	cp $< $@

$(RESULTS_DIR)/1_synth.sdc: $(RESULTS_DIR)/1_1_yosys.v
	@

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

$(RESULTS_DIR)/2_1_floorplan.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/1_synth.v
	openroad $(SCRIPTS_DIR)/verilog2def.tcl \
	  2>&1 | tee $(LOG_DIR)/2_1_verilog2def.log
	@! grep --color "Error:" $(LOG_DIR)/2_1_verilog2def.log


# STEP 2: IO Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_2_floorplan_io.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/2_1_floorplan.def
	openroad $(SCRIPTS_DIR)/io_placement.tcl \
	  2>&1 | tee $(LOG_DIR)/2_2_floorplan_io.log
	@! grep --color "Error:" $(LOG_DIR)/2_2_floorplan_io.log

# STEP 3: Timing Driven Mixed Sized Placement
# Only run if required
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_3_floorplan_tdms.def: $(RESULTS_DIR)/2_2_floorplan_io.def $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(LIB_FILES) $(OBJECTS_DIR)/merged_padded.lef | ./POST9.dat ./POWV9.dat
	openroad $(SCRIPTS_DIR)/tdms_place.tcl \
	  2>&1 | tee $(LOG_DIR)/2_3_tdms_place.log
	@! grep --color "Error:" $(LOG_DIR)/2_3_tdms_place.log
	$(UTILS_DIR)/fixIoPins.py --inputDef $@ --outputDef $@ --margin $(IO_PIN_MARGIN)

# STEP 4: Macro Placement
# Only run if required
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_4_floorplan_macro.def: $(RESULTS_DIR)/2_3_floorplan_tdms.def $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(IP_GLOBAL_CFG)
	openroad $(SCRIPTS_DIR)/macro_place.tcl \
	  2>&1 | tee $(LOG_DIR)/2_4_mplace.log

# STEP 5: PDN generation
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_5_floorplan_pdn.def: $(RESULTS_DIR)/2_4_floorplan_macro.def
	openroad $(SCRIPTS_DIR)/pdn.tcl | tee $(LOG_DIR)/2_5_pdn.log
	@! grep --color "Error:" $(LOG_DIR)/2_5_pdn.log
	@! grep --color "ERROR:" $(LOG_DIR)/2_5_pdn.log

# STEP 6: Tapcell and Welltie insertion
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_6_floorplan_tapcell.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/2_5_floorplan_pdn.def | ./POST9.dat ./POWV9.dat
	openroad $(SCRIPTS_DIR)/tapcell.tcl \
	  2>&1 | tee $(LOG_DIR)/2_6_tapcell.log
	@! grep --color "Error:" $(LOG_DIR)/2_6_tapcell.log

$(RESULTS_DIR)/2_floorplan.def: $(RESULTS_DIR)/2_6_floorplan_tapcell.def
	cp $< $@

$(RESULTS_DIR)/2_floorplan.v: $(RESULTS_DIR)/1_synth.v
	cp $< $@

$(RESULTS_DIR)/2_floorplan.sdc: $(RESULTS_DIR)/1_synth.sdc
	cp $< $@


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
$(RESULTS_DIR)/3_1_place_gp.def: $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/2_floorplan.def $(RESULTS_DIR)/2_floorplan.v $(RESULTS_DIR)/2_floorplan.sdc | ./POST9.dat ./POWV9.dat
	openroad $(SCRIPTS_DIR)/global_place.tcl \
	  2>&1 | tee $(LOG_DIR)/3_1_place_gp.log
	@! grep --color "Error:" $(LOG_DIR)/3_1_place_gp.log

$(RESULTS_DIR)/replace.gif: $(RESULTS_DIR)/3_1_place_gp.def
	convert -delay 20  $(RESULTS_DIR)/replace/etc/floorplan/output/cell/cGP2D*.jpg \
	        -delay 100 $(RESULTS_DIR)/replace/etc/floorplan/output/globalPlaceResult.jpg \
	        $@

# STEP 2: Resizing & Buffering
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_2_place_resized.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/3_1_place_gp.def $(RESULTS_DIR)/2_floorplan.sdc | ../etc/POST9.dat ../etc/POWV9.dat
	openroad $(SCRIPTS_DIR)/resize.tcl \
	         2>&1 | tee $(LOG_DIR)/3_2_resizer.log
	@! grep --color "Error:" $(LOG_DIR)/3_2_resizer.log

$(RESULTS_DIR)/3_place.v: $(RESULTS_DIR)/3_2_place_resized.def


# STEP 3: Detail placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_3_place_dp.def: $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/3_2_place_resized.def
	openroad $(SCRIPTS_DIR)/detail_place.tcl \
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
	openroad -exit $(SCRIPTS_DIR)/analyze_pdn_ir.tcl  \
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
$(RESULTS_DIR)/4_cts.v: $(RESULTS_DIR)/3_place.def $(RESULTS_DIR)/3_place.v $(RESULTS_DIR)/3_place.sdc | ./POST9.dat ./POWV9.dat
	openroad $(SCRIPTS_DIR)/cts.tcl \
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
	openroad $(SCRIPTS_DIR)/global_route.tcl 2>&1 | tee $(LOG_DIR)/5_1_fastroute.log
	@! grep --color "Error:" $(LOG_DIR)/5_1_fastroute.log


# STEP 2: Run detail route
#-------------------------------------------------------------------------------

# Generate param file for TritonRoute
#-------------------------------------------------------------------------------
ifneq ($(GENERIC_TECH_LEF),)
  TRITON_ROUTE_LEF := $(OBJECTS_DIR)/generic_merged_padded_spacing.lef
else
  TRITON_ROUTE_LEF := $(OBJECTS_DIR)/merged_padded_spacing.lef
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
	rm -rf $(RESULTS_DIR)/5_route.def $(RESULTS_DIR)/5_route.v $(RESULTS_DIR)/5_route.sdc $(RESULTS_DIR)/5_route_TA.def


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
	openroad $(SCRIPTS_DIR)/final_report.tcl \
	         2>&1 | tee $(LOG_DIR)/6_1_report.log
	@! grep --color "Error:" $(LOG_DIR)/6_1_report.log

# Run Klayout
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/6_final.gds: $(OBJECTS_DIR)/klayout.lyt $(GDS_FILES) $(RESULTS_DIR)/5_route.def
	klayout -zz -rd design_name=$(DESIGN_NAME) \
	        -rd in_lef=$(abspath $(OBJECTS_DIR)/merged.lef) \
	        -rd in_def=$(RESULTS_DIR)/5_route.def \
	        -rd in_gds="$(GDS_FILES)" \
	        -rd out_gds=$@ \
	        -rd map_file=./platforms/$(PLATFORM)/layermap.txt \
	        -rm $(UTILS_DIR)/def2gds.py

clean_finish:
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

all: $(SDC_FILE) $(OBJECTS_DIR)/merged.lib $(OBJECTS_DIR)/merged.lef $(OBJECTS_DIR)/TritonRoute.param \
		| ../etc/POST9.dat ../etc/POWV9.dat POST9.dat POWV9.dat
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	openroad $(SCRIPTS_DIR)/run_all.tcl

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
	rm -rf ./POST9.dat ./POWV9.dat
	rm -rf ../etc/PORT9.dat ../etc/POWV9.dat
	rm -rf layer_*.mps macrocell.list *best.plt *_pdn.def dummy.guide run.param
	rm -rf *.rpt *.def.v innovus.* pin_dumper.log
	rm -rf versions.txt


# DEF/GDS viewer shortcuts
#-------------------------------------------------------------------------------
$(foreach def,$(notdir $(wildcard $(RESULTS_DIR)/*.def)),innovus_$(def)): innovus_%:
	innovus -execute "loadLefFile $(OBJECTS_DIR)/merged.lef ; \
	                  loadDefFile $(RESULTS_DIR)/$* ; \
	                  win" \
	                  -no_logv ; stty sane

$(foreach def,$(notdir $(wildcard $(RESULTS_DIR)/*.def)),klayout_$(def)): klayout_%: $(OBJECTS_DIR)/klayout.lyt
	klayout -nn $(OBJECTS_DIR)/klayout.lyt $(RESULTS_DIR)/$*


# Utilities
#-------------------------------------------------------------------------------
drc: $(REPORTS_DIR)/drc.rpt

$(REPORTS_DIR)/drc.rpt: $(RESULTS_DIR)/5_route.def
	innovus -execute "loadLefFile $(OBJECTS_DIR)/merged.lef ; \
	                  loadDefFile $<; \
	                  verify_drc -limit 10000 -report $(REPORTS_DIR)/drc.rpt; \
	                  exit" \
	                  -no_gui -no_logv
#; stty sane here breaks gnu parallel


print_cells:
	find ./logs/ -iname 1_1_yosys.log -exec sh -c "grep -iH 'Number of cells' {} | tail -1" \;

print_drc:
	find ./reports/ -iname drc.rpt -exec sh -c "grep -iH 'viol' {} | tail -1" \;

# run test using gnu parallel
#-------------------------------------------------------------------------------
TEST_SCRIPT ?= $(TEST_DIR)/core_tests.sh
run_test:
	parallel --sshloginfile $(TEST_DIR)/nodes.txt \
	         --timeout 21600 \
	         --workdir `pwd` < $(TEST_SCRIPT) \
	         --joblog $(TEST_DIR)/parallel.log

clean_test:
	rm -rf $(TEST_DIR)/logs
	rm -rf $(TEST_DIR)/parallel.log

# Utility to print information tool version information
#-------------------------------------------------------------------------------
YOSYS_PATH := $(dir $(shell which yosys))
OPENROAD_PATH := $(dir $(shell which openroad))
TRITONROUTE_PATH := $(dir $(shell which TritonRoute))
.PHONY: versions.txt
versions.txt:
	-@echo "======================================================" > $(abspath $@)
	@openroad -version >> $(abspath $@)
	-@cd $(OPENROAD_PATH); echo OpenROAD `git diff --quiet || echo '*dirty*'` `git config --get remote.origin.url` >> $(abspath $@)
	-@cd $(OPENROAD_PATH); echo branch:`git rev-parse --abbrev-ref HEAD` `git rev-parse HEAD` >> $(abspath $@)
	-@cd $(OPENROAD_PATH); git submodule foreach --recursive 'echo $$path `git diff --quiet || echo -n '*dirty*'` branch:`git rev-parse --abbrev-ref HEAD` `git rev-parse HEAD`' >> $(abspath $@)
	-@echo "======================================================" >> $(abspath $@)
	@yosys -V >> $(abspath $@)
	-@cd $(YOSYS_PATH); echo Yosys `git diff --quiet || echo '*dirty*'` `git config --get remote.origin.url` >> $(abspath $@)
	-@cd $(YOSYS_PATH); echo branch:`git rev-parse --abbrev-ref HEAD` `git rev-parse HEAD` >> $(abspath $@)
	-@echo "======================================================" >> $(abspath $@)
	-@cd $(TRITONROUTE_PATH); echo TritonRoute `git diff --quiet || echo '*dirty*'` `git config --get remote.origin.url` >> $(abspath $@)
	-@cd $(TRITONROUTE_PATH); echo branch:`git rev-parse --abbrev-ref HEAD` `git rev-parse HEAD` >> $(abspath $@)
	-@echo "======================================================" >> $(abspath $@)
	@klayout -v >> $(abspath $@)
	-@echo "======================================================" >> $(abspath $@)
	-@sed -i '/Entering /d' $@


# Utility to print information tool version information
#-------------------------------------------------------------------------------
# Run "make {script}_issue" where script is wildcarded from the scripts folder
#   e.g "make cts_issue"
# Set the ISSUE_TAG variable to rename the generated tar file
#-------------------------------------------------------------------------------
ISSUE_TAG ?= $(DESIGN_NAME)_$(PLATFORM)_$(shell date +"%Y-%m-%d_%H-%M")
ISSUE_SCRIPTS = $(patsubst %.tcl,%,$(notdir $(wildcard $(SCRIPTS_DIR)/*.tcl)))
ISSUE_CP_FILE_VARS = BLACKBOX_MAP_TCL BLACKBOX_V_FILE CTS_TECH_DIR GENERIC_TECH_LEF \
                     IP_GLOBAL_CFG LATCH_MAP_FILE LIB_FILES SC_LEF TECH_LEF \
                     TRACKS_INFO_FILE SDC_FILE VERILOG_FILES TAPCELL_TCL

$(foreach script,$(ISSUE_SCRIPTS),$(script)_issue): %_issue : versions.txt ./POST9.dat ./POWV9.dat
	# Creating runme.sh script
	@echo "#!/bin/bash"                    > runme.sh
	@echo "source vars.sh"                 >> runme.sh
	@echo "openroad $(SCRIPTS_DIR)/$*.tcl" >> runme.sh
	@chmod +x runme.sh

	# Creating vars.sh script
	-@rm -f vars.sh
	@$(foreach V, $(.VARIABLES), \
	  $(if $(filter-out environment% default automatic, $(origin $V)), \
	  echo export $V=\""$($V)\""  >> vars.sh ;) \
	)
	@sed -i '/export \./d' vars.sh

	# Archiving issue to $*_$(ISSUE_TAG).tar.gz
	@tar -czhf $*_$(ISSUE_TAG).tar.gz \
	    --xform='s|^|$*_$(ISSUE_TAG)/|S' $(LOG_DIR) \
	                                     $(OBJECTS_DIR) \
	                                     $(REPORTS_DIR) \
	                                     $(RESULTS_DIR) \
	                                     $(SCRIPTS_DIR) \
	                                     $(foreach var,$(ISSUE_CP_FILE_VARS),$($(var))) \
	                                     runme.sh vars.sh \
	                                     $^

clean_issues:
	rm -rf $(foreach issue, $(ISSUE_SCRIPTS), $(issue)_*.tar.gz)
	rm -rf vars.sh runme.sh
