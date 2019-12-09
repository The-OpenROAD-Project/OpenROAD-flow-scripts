shell:
	openroad
# ==============================================================================
# Uncomment or add the design to run
# ==============================================================================

# DESIGN_CONFIG=./designs/aes_nangate45.mk
# DESIGN_CONFIG=./designs/dynamic_node_nangate45.mk
# DESIGN_CONFIG=./designs/gcd_nangate45.mk
# DESIGN_CONFIG=./designs/ibex_nangate45.mk
# DESIGN_CONFIG=./designs/swerv_nangate45.mk
# DESIGN_CONFIG=./designs/tinyRocket_nangate45.mk

# DESIGN_CONFIG=./designs/aes_tsmc65lp.mk
# DESIGN_CONFIG=./designs/ariane_tsmc65lp.mk
# DESIGN_CONFIG=./designs/bp_fe_top_tsmc65lp.mk
# DESIGN_CONFIG=./designs/coyote_tsmc65lp.mk
# DESIGN_CONFIG=./designs/dynamic_node_tsmc65lp.mk
# DESIGN_CONFIG=./designs/gcd_tsmc65lp.mk
# DESIGN_CONFIG=./designs/ibex_tsmc65lp.mk
# DESIGN_CONFIG=./designs/jpeg_tsmc65lp.mk
# DESIGN_CONFIG=./designs/swerv_tsmc65lp.mk
# DESIGN_CONFIG=./designs/swerv_wrapper_tsmc65lp.mk
# DESIGN_CONFIG=./designs/tinyRocket_tsmc65lp.mk
# DESIGN_CONFIG=./designs/vb_tsmc65lp.mk


# Default design
DESIGN_CONFIG ?= ./designs/gcd_nangate45.mk

# # Global override Floorplan
# CORE_UTILIZATION := 30
# CORE_ASPECT_RATIO := 1
# CORE_MARGIN := 4

all: route

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
export TEST_DIR    = ./test

# Tool Options
SHELL = /bin/bash -o pipefail
BANNER = printf "\e[31m" ; \
         date ; \
         figlet -c -p -d $(OPENROAD)/figlet/fonts/ $(1) ; \
         printf "\e[0m" ; \
         sleep 1 ;


# Quick check to make sure OpenROAD tools are installed
ifeq ("$(OPENROAD)","")
  $(error ERROR: These tests require the OpenROAD tools to be setup.)
endif


# Pre-process Lefs
# ==============================================================================
$(OBJECTS_DIR)/merged.lef: $(MERGED_LEF)
	mkdir -p $(OBJECTS_DIR)
	cp $< $@

$(OBJECTS_DIR)/merged_padded.lef: $(OBJECTS_DIR)/merged.lef
	$(SCRIPTS_DIR)/padLefMacro.py -p $(CELL_PAD_IN_MICRON) -i $< -o $@

# Modify lef files for TritonRoute
$(OBJECTS_DIR)/merged_padded_spacing.lef: $(OBJECTS_DIR)/merged_padded.lef
	$(SCRIPTS_DIR)/modifyLefSpacing.py -i $< -o $@

# Pre-process libraries
# ==============================================================================
$(OBJECTS_DIR)/merged.lib: $(DESIGN_LIB_FILES)
	mkdir -p $(OBJECTS_DIR)
	$(SCRIPTS_DIR)/mergeLib.pl $(PLATFORM)_merged \
	                           $(LIB_FILES) \
	                           > $@.tmp
	$(SCRIPTS_DIR)/markDontUse.pl -p "$(DONT_USE_CELLS)" -i $@.tmp -o $@

# Link flute data files
# ==============================================================================
./PORT9.dat:
	ln -sf $(OPENROAD)/src/yosys/$@ $@
./POST9.dat:
	ln -sf $(OPENROAD)/etc/$@ $@
./POWV9.dat:
	ln -sf $(OPENROAD)/etc/$@ $@
../etc/PORT9.dat:
	mkdir -p ../etc
	ln -sf $(OPENROAD)/src/yosys/PORT9.dat $@
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
	@$(call BANNER, 1. SYNTHESIS)
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	yosys -l $(LOG_DIR)/1_yosys.log -c $(SYNTH_SCRIPT)

$(RESULTS_DIR)/1_2_buffer.v: $(RESULTS_DIR)/1_1_yosys.v $(SDC_FILE) | ../etc/PORT9.dat ../etc/POST9.dat ../etc/POWV9.dat
	openroad $(SCRIPTS_DIR)/buffer.tcl \
	        2>&1 | tee $(LOG_DIR)/1_2_buffer.log
	@! grep --color "Error:" $(LOG_DIR)/1_2_buffer.log


$(RESULTS_DIR)/1_synth.v: $(RESULTS_DIR)/1_2_buffer.v
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
ifneq ($(CORE_UTILIZATION),)
  FLOORPLAN_ARGS = -utilization $(CORE_UTILIZATION) \
                   -aspect_ratio $(CORE_ASPECT_RATIO) \
                   -core_space $(CORE_MARGIN)
else
  FLOORPLAN_ARGS = -die_area "$(DIE_AREA)" -core_area "$(CORE_AREA)"
endif

$(RESULTS_DIR)/2_1_floorplan.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/1_synth.v
	@$(call BANNER, 2. FLOORPLAN)
	openroad $(SCRIPTS_DIR)/verilog2def.tcl \
		2>&1 | tee $(LOG_DIR)/2_1_verilog2def.log
	sed -i 's/VERSION 5.5/VERSION 5.6/' $@


# STEP 2: IO Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_2_floorplan_io.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/2_1_floorplan.def
	openroad $(SCRIPTS_DIR)/io_placement.tcl
#	ioPlacer --input-lef $(OBJECTS_DIR)/merged.lef \
#	         --input-def $(RESULTS_DIR)/2_1_floorplan.def \
#	         --output $@ \
#	         --hmetal 5 \
#	         --vmetal 6 \
#	         --random 2 \
#	         --wirelen 1 \
#	         2>&1 | tee $(LOG_DIR)/2_2_ioPlacer.log

# STEP 3: Timing Driven Mixed Sized Placement
# Only run if required
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_3_floorplan_tdms.def: $(RESULTS_DIR)/2_2_floorplan_io.def $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(LIB_FILES) $(OBJECTS_DIR)/merged_padded.lef | ./PORT9.dat ./POST9.dat ./POWV9.dat
ifeq ($(RUN_MACRO_PLACEMENT),1)
	RePlAce \
	  -bmflag etc \
	  -lef $(OBJECTS_DIR)/merged_padded.lef \
	  -def $(RESULTS_DIR)/2_2_floorplan_io.def  \
	  -verilog $(RESULTS_DIR)/1_synth.v \
	  $(foreach file,$(LIB_FILES),-lib $(file)) \
	  -sdc $(RESULTS_DIR)/1_synth.sdc \
	  -output $(RESULTS_DIR)/td-ms-replace \
	  -t 1 \
	  -timing \
	  -resPerMicron $(RES_PER_MICRON) \
	  -capPerMicron $(CAP_PER_MICRON) \
	  -skipIP \
	  -plot \
	  -experi output \
	  -den 0.7 \
	  -onlyGP \
	  2>&1 | tee $(LOG_DIR)/2_3_TD-MS-RePlAce.log
	cp $(RESULTS_DIR)/td-ms-replace/etc/2_2_floorplan_io/output/2_2_floorplan_io_final.def $@
else
	cp $< $@
endif

# STEP 4: Macro Placement
# Only run if required
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_4_floorplan_macro.def: $(RESULTS_DIR)/2_3_floorplan_tdms.def $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(IP_GLOBAL_CFG)
ifeq ($(RUN_MACRO_PLACEMENT),1)
	fplan $(foreach file,$(LIB_FILES),-lib $(file)) \
	    -verilog $(RESULTS_DIR)/1_synth.v \
	    -lef $(OBJECTS_DIR)/merged_padded.lef \
	    -def $(RESULTS_DIR)/2_3_floorplan_tdms.def \
	    -design $(DESIGN_NAME) \
	    -sdc $(RESULTS_DIR)/1_synth.sdc \
	    -output $(DESIGN_NAME) \
	    -globalConfig $(IP_GLOBAL_CFG) \
	    -depth 3 \
	    -plot \
	    -westFix \
	    | tee $(LOG_DIR)/2_4_fplan.log
	    mv $(DESIGN_NAME)_best.def $@
else
	cp $< $@
endif

# STEP 5: PDN generation
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_5_floorplan_pdn.def: $(RESULTS_DIR)/2_4_floorplan_macro.def
ifneq ($(PDN_CFG),)
	apply_pdn $(PDN_CFG) | tee $(LOG_DIR)/2_5_apply_pdn.log
	mv $(DESIGN_NAME)_post_T8.def $@
else
	cp $< $@
endif


# STEP 6: Tapcell and Welltie insertion
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_6_floorplan_tapcell.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/2_5_floorplan_pdn.def
	cp $(RESULTS_DIR)/2_5_floorplan_pdn.def $@
	tapcell -lef $(OBJECTS_DIR)/merged.lef \
	        -def $(RESULTS_DIR)/2_5_floorplan_pdn.def \
	        -rule $(WELLTTAP_RULE) \
	        -welltap $(WELLTIE_CELL) \
	        -endcap $(ENDCAP_CELL) \
	        -rows \
	        -outdef $@ | tee $(LOG_DIR)/2_6_tapcell.log

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
$(RESULTS_DIR)/3_1_place_gp.def: $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/2_floorplan.def $(RESULTS_DIR)/2_floorplan.v $(RESULTS_DIR)/2_floorplan.sdc | ./PORT9.dat ./POST9.dat ./POWV9.dat
	@$(call BANNER, 3. PLACE)
	rm -rf $(RESULTS_DIR)/etc/
	openroad $(SCRIPTS_DIR)/global_place.tcl

$(RESULTS_DIR)/replace.gif: $(RESULTS_DIR)/3_1_place_gp.def
	convert -delay 20  $(RESULTS_DIR)/replace/etc/floorplan/output/cell/cGP2D*.jpg \
	        -delay 100 $(RESULTS_DIR)/replace/etc/floorplan/output/globalPlaceResult.jpg \
	        $@

# STEP 2: Resizing & Buffering
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_2_place_resized.def: $(OBJECTS_DIR)/merged.lef $(RESULTS_DIR)/3_1_place_gp.def $(RESULTS_DIR)/2_floorplan.sdc | ../etc/PORT9.dat ../etc/POST9.dat ../etc/POWV9.dat
	openroad $(SCRIPTS_DIR)/resize.tcl \
	         2>&1 | tee $(LOG_DIR)/3_2_resizer.log
	# @! grep --color "Error:" $(LOG_DIR)/3_2_resizer.log

$(RESULTS_DIR)/3_place.v: $(RESULTS_DIR)/3_2_place_resized.def


# STEP 3: Detail placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_3_place_dp.def: $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/3_2_place_resized.def
	openroad $(SCRIPTS_DIR)/detail_place.tcl \
	         2>&1 | tee $(LOG_DIR)/3_3_opendp.log

$(RESULTS_DIR)/3_place.def: $(RESULTS_DIR)/3_3_place_dp.def
	cp $< $@

$(RESULTS_DIR)/3_place.sdc: $(RESULTS_DIR)/2_floorplan.sdc
	cp $< $@

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

# Prepare tritonCTS config
# ------------------------------------------------------------------------------
SKEW  = 50
TOLER = 1000
PERCENTILE = 0.075
$(OBJECTS_DIR)/tritonCts.config: $(OBJECTS_DIR)/merged_padded.lef $(RESULTS_DIR)/3_place.def
	@$(call BANNER, 4. CTS)
	mkdir -p $(OBJECTS_DIR)
	echo "lef $(OBJECTS_DIR)/merged_padded.lef" > $@
	echo "path $(RESULTS_DIR)/3_place.def" >> $@
	echo "verilog $(RESULTS_DIR)/3_place.v" >> $@
	echo "design $(DESIGN_NAME)" >> $@
	echo "target_skew $(SKEW)" >> $@
	echo "width $(CORE_WIDTH)" >> $@
	echo "height $(CORE_HEIGHT)" >> $@
	echo "tech $(PROCESS)" >> $@
	echo "ck_port $(CLOCK_PORT)" >> $@
	echo "db_units 2000" >> $@
	echo "root_buff $(CTS_BUF_CELL)" >> $@
	echo "toler $(TOLER)" >> $@
	echo "percentile $(PERCENTILE)" >> $@


# Run TritonCTS
# ------------------------------------------------------------------------------
TRITONCTS = $(OPENROAD)/build/src/TritonCTS
$(RESULTS_DIR)/4_cts.v: $(OBJECTS_DIR)/tritonCts.config | ./PORT9.dat ./POST9.dat ./POWV9.dat
	$(TRITONCTS)/runTritonCTS.tcl \
	  -configFilePath=$< \
	  -scriptsPath=$(TRITONCTS)/scripts \
	  -techFilesPath=$(CTS_TECH_DIR) \
	  -lefDefParserPath=$(TRITONCTS)/lefdef2cts \
	  -executablePath=$(TRITONCTS)/genHtree \
	  -legalizerPath=$(TRITONCTS)/../OpenDP/opendp \
	  -outputPath=$(RESULTS_DIR)/run 2>&1 | tee $(LOG_DIR)/4_tritonCTS.log
	openroad $(SCRIPTS_DIR)/cts_legalize.tcl
	cp $(RESULTS_DIR)/run/final.v $@

$(RESULTS_DIR)/4_cts.def: $(RESULTS_DIR)/4_cts.v
	cp $(RESULTS_DIR)/run/cts_final.def $@

$(RESULTS_DIR)/4_cts.sdc: $(RESULTS_DIR)/3_place.sdc
	cp $< $@

clean_cts:
	rm -rf $(OBJECTS_DIR)/tritonCts.config
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
	@$(call BANNER, 5. ROUTING)
	envsubst < $(SCRIPTS_DIR)/fastroute.rsyn > $(OBJECTS_DIR)/fastroute.rsyn
	openroad $(SCRIPTS_DIR)/global_route.tcl | tee $(LOG_DIR)/5_1_FRlefdef.log


# STEP 2: Run detail route
#-------------------------------------------------------------------------------

# Generate param file for TritonRoute
#-------------------------------------------------------------------------------
$(OBJECTS_DIR)/TritonRoute.param: $(OBJECTS_DIR)/merged_padded_spacing.lef $(RESULTS_DIR)/4_cts.def $(RESULTS_DIR)/route.guide
	echo "lef:$(OBJECTS_DIR)/merged_padded_spacing.lef" > $@
	echo "def:$(RESULTS_DIR)/4_cts.def" >> $@
	echo "guide:$(RESULTS_DIR)/route.guide" >> $@
	echo "output:$(RESULTS_DIR)/5_route.def" >> $@
	echo "outputTA:$(RESULTS_DIR)/5_route_TA.def" >> $@
	echo "outputguide:$(RESULTS_DIR)/output_guide.mod" >> $@
	echo "outputMaze:$(RESULTS_DIR)/maze.log" >> $@
	echo "threads:$(NPROC)" >> $@
	echo "cpxthreads:1" >> $@
	echo "verbose:1" >> $@
	echo "gap:0" >> $@
	echo "timeout:2400" >> $@

# Run TritonRoute
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/5_route.def: $(OBJECTS_DIR)/TritonRoute.param
	TritonRoute $< 2>&1 | tee $(LOG_DIR)/5_2_TritonRoute.log

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
finish: $(RESULTS_DIR)/6_final.gds \
        $(REPORTS_DIR)/6_final_report.rpt
# ==============================================================================
$(REPORTS_DIR)/6_final_report.rpt: $(RESULTS_DIR)/5_route.def $(RESULTS_DIR)/5_route.sdc
	openroad $(SCRIPTS_DIR)/final_report.tcl \
	         2>&1 | tee $(LOG_DIR)/6_1_report.log


# Run magic
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/6_final.gds: $(MAGIC_TECH_FILE) $(GDS_FILES) $(RESULTS_DIR)/5_route.def
	@$(call BANNER, 6. FINISHING)
	magic -dnull -noconsole -T $(MAGIC_TECH_FILE) \
	      $(SCRIPTS_DIR)/magic.tcl | tee $(LOG_DIR)/6_magic.log

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


clean:
	@echo
	@echo "Make clean disabled."
	@echo "Use make clean_all or clean individual steps:"
	@echo "  clean_synth clean_floorplan clean_place clean_cts clean_route clean_finish"
	@echo

clean_all: clean_synth clean_floorplan clean_place clean_cts clean_route clean_finish

nuke:
	rm -rf ./results ./logs ./reports ./objects
	rm -rf ./POST9.dat ./PORT9.dat ./POWV9.dat
	rm -rf ../etc/POST9.dat ../etc/PORT9.dat ../etc/POWV9.dat
	rm -rf layer_*.mps macrocell.list *best.plt *_pdn.def dummy.guide run.param
	rm -rf *.rpt *.def.v innovus.* pin_dumper.log


# DEF/GDS viewer shortcuts
#-------------------------------------------------------------------------------
$(foreach def,$(notdir $(wildcard $(RESULTS_DIR)/*.def)),innovus_$(def)): innovus_%:
	innovus -execute "loadLefFile $(MERGED_LEF) ; \
	                  loadDefFile $(RESULTS_DIR)/$* ; \
	                  win" \
	                  -no_logv ; stty sane

$(foreach def,$(notdir $(wildcard $(RESULTS_DIR)/*.def)),klayout_$(def)): klayout_%:
	klayout -nn $(KLAYOUT_TECH_FILE) $(RESULTS_DIR)/$*

# run test using gnu parallel
#-------------------------------------------------------------------------------
TEST_SCRIPT ?= $(TEST_DIR)/core_tests.sh
run_test:
	parallel --sshloginfile $(TEST_DIR)/nodes.txt \
	         --timeout 21600 \
	         --workdir `pwd` < $(TEST_SCRIPT) \
	         --joblog $(TEST_DIR)/parallel.log

