# ==============================================================================
#  _____ ___ _   _ ___ ____  _   _ ___ _   _  ____
# |  ___|_ _| \ | |_ _/ ___|| | | |_ _| \ | |/ ___|
# | |_   | ||  \| || |\___ \| |_| || ||  \| | |  _
# |  _|  | || |\  || | ___) |  _  || || |\  | |_| |
# |_|   |___|_| \_|___|____/|_| |_|___|_| \_|\____|
#
GDS_FINAL_FILE = $(RESULTS_DIR)/6_final.$(STREAM_SYSTEM_EXT)
finish: $(LOG_DIR)/6_report.log \
        $(RESULTS_DIR)/6_final.v \
        $(RESULTS_DIR)/6_final.sdc \
        $(GDS_FINAL_FILE)
	@printf "%-25s %10s\n" Log "Elapsed seconds"
	-@$(UTILS_DIR)/genElapsedTime.py -d "$(LOG_DIR)"

# ==============================================================================

ifneq ($(USE_FILL),)
$(RESULTS_DIR)/6_1_fill.odb: $(RESULTS_DIR)/5_route.odb $(FILL_CONFIG)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/density_fill.tcl -metrics $(LOG_DIR)/6_density_fill.json) 2>&1 | tee $(LOG_DIR)/6_density_fill.log
else
$(RESULTS_DIR)/6_1_fill.odb: $(RESULTS_DIR)/5_route.odb
	cp $< $@
endif

$(RESULTS_DIR)/6_1_fill.sdc: $(RESULTS_DIR)/5_route.sdc
	cp $< $@

$(RESULTS_DIR)/6_final.sdc: $(RESULTS_DIR)/5_route.sdc
	cp $< $@

$(LOG_DIR)/6_report.log: $(RESULTS_DIR)/6_1_fill.odb $(RESULTS_DIR)/6_1_fill.sdc
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/final_report.tcl -metrics $(LOG_DIR)/6_report.json) 2>&1 | tee $(LOG_DIR)/6_report.log

$(RESULTS_DIR)/6_final.def: $(LOG_DIR)/6_report.log

generate_abstract: $(RESULTS_DIR)/6_final.gds $(RESULTS_DIR)/6_final.def  $(RESULTS_DIR)/6_final.v
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/generate_abstract.tcl -metrics $(LOG_DIR)/generate_abstract.json) 2>&1 | tee $(LOG_DIR)/generate_abstract.log

# Merge wrapped macros using Klayout
#-------------------------------------------------------------------------------
$(WRAPPED_GDSOAS): $(OBJECTS_DIR)/klayout_wrap.lyt $(WRAPPED_LEFS)
	$(call KLAYOUT_FOUND)
	($(TIME_CMD) $(KLAYOUT_CMD) -zz -rd design_name=$(basename $(notdir $@)) \
	        -rd in_def=$(OBJECTS_DIR)/def/$(notdir $(@:$(STREAM_SYSTEM_EXT)=def)) \
	        -rd in_files="$(ADDITIONAL_GDSOAS)" \
	        -rd config_file=$(FILL_CONFIG) \
	        -rd seal_file="" \
	        -rd out_file=$@ \
	        -rd tech_file=$(OBJECTS_DIR)/klayout_wrap.lyt \
	        -rd layer_map=$(GDS_LAYER_MAP) \
	        -r $(UTILS_DIR)/def2stream.py) 2>&1 | tee $(LOG_DIR)/6_merge_$(basename $(notdir $@)).log

# Merge GDS using Klayout
#-------------------------------------------------------------------------------
GDS_MERGED_FILE = $(RESULTS_DIR)/6_1_merged.$(STREAM_SYSTEM_EXT)
$(GDS_MERGED_FILE): $(RESULTS_DIR)/6_final.def $(OBJECTS_DIR)/klayout.lyt $(GDSOAS_FILES) $(WRAPPED_GDSOAS) $(SEAL_GDSOAS)
	$(call KLAYOUT_FOUND)
	($(TIME_CMD) $(STDBUF_CMD) $(KLAYOUT_CMD) -zz -rd design_name=$(DESIGN_NAME) \
	        -rd in_def=$< \
	        -rd in_files="$(GDSOAS_FILES) $(WRAPPED_GDSOAS)" \
	        -rd config_file=$(FILL_CONFIG) \
	        -rd seal_file="$(SEAL_GDSOAS)" \
	        -rd out_file=$@ \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rd layer_map=$(GDS_LAYER_MAP) \
	        -r $(UTILS_DIR)/def2stream.py) 2>&1 | tee $(LOG_DIR)/6_1_merge.log

$(RESULTS_DIR)/6_final.v: $(LOG_DIR)/6_report.log

$(GDS_FINAL_FILE): $(GDS_MERGED_FILE)
	cp $^ $@

drc: $(REPORTS_DIR)/6_drc.lyrdb

$(REPORTS_DIR)/6_drc.lyrdb: $(GDS_FINAL_FILE) $(KLAYOUT_DRC_FILE)
ifneq ($(KLAYOUT_DRC_FILE),)
	$(call KLAYOUT_FOUND)
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

$(RESULTS_DIR)/6_lvs.lvsdb: $(GDS_FINAL_FILE) $(KLAYOUT_LVS_FILE) $(OBJECTS_DIR)/6_final_concat.cdl
ifneq ($(KLAYOUT_LVS_FILE),)
	$(call KLAYOUT_FOUND)
	($(TIME_CMD) $(KLAYOUT_CMD) -b -rd in_gds="$<" \
	        -rd cdl_file=$(abspath $(OBJECTS_DIR)/6_final_concat.cdl) \
	        -rd report_file=$(abspath $@) \
	        -r $(KLAYOUT_LVS_FILE)) 2>&1 | tee $(LOG_DIR)/6_lvs.log
else
	echo "LVS not supported on this platform" > $@
endif

clean_finish:
	rm -rf $(RESULTS_DIR)/6_*.gds $(RESULTS_DIR)/6_*.oas $(RESULTS_DIR)/6_*.odb $(RESULTS_DIR)/6_*.v $(RESULTS_DIR)/6_*.def $(RESULTS_DIR)/6_*.sdc $(RESULTS_DIR)/6_*.spef
	rm -rf $(REPORTS_DIR)/6_*.rpt
	rm -f  $(LOG_DIR)/6_*


