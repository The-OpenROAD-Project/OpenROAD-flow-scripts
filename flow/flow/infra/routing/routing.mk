# ==============================================================================
#  ____   ___  _   _ _____ ___ _   _  ____
# |  _ \ / _ \| | | |_   _|_ _| \ | |/ ___|
# | |_) | | | | | | | | |  | ||  \| | |  _
# |  _ <| |_| | |_| | | |  | || |\  | |_| |
# |_| \_\\___/ \___/  |_| |___|_| \_|\____|
#
route: $(RESULTS_DIR)/5_route.odb \
       $(RESULTS_DIR)/5_route.sdc
# ==============================================================================


# STEP 1: Run global route
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/5_1_grt.odb: $(RESULTS_DIR)/4_cts.odb $(FASTROUTE_TCL) $(PRE_GLOBAL_ROUTE)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/global_route.tcl -metrics $(LOG_DIR)/5_1_fastroute.json) 2>&1 | tee $(LOG_DIR)/5_1_fastroute.log


# STEP 2: Run detailed route
#-------------------------------------------------------------------------------
ifeq ($(USE_WXL),)
$(RESULTS_DIR)/5_2_route.odb: $(RESULTS_DIR)/5_1_grt.odb
else
$(RESULTS_DIR)/5_2_route.odb: $(RESULTS_DIR)/4_cts.odb
endif
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/detail_route.tcl -metrics $(LOG_DIR)/5_2_TritonRoute.json) 2>&1 | tee $(LOG_DIR)/5_2_TritonRoute.log

$(RESULTS_DIR)/5_route.odb: $(RESULTS_DIR)/5_2_route.odb
	cp $< $@

$(RESULTS_DIR)/5_route.sdc: $(RESULTS_DIR)/4_cts.sdc
	cp $< $@

$(RESULTS_DIR)/5_route.v:
	@export OR_DB=5_route ;\
	$(OPENROAD_CMD) ./scripts/write_verilog.tcl

clean_route:
	rm -rf output*/ results*.out.dmp layer_*.mps
	rm -rf *.gdid *.log *.met *.sav *.res.dmp
	rm -rf $(RESULTS_DIR)/route.guide $(RESULTS_DIR)/output_guide.mod $(RESULTS_DIR)/updated_clks.sdc
	rm -rf $(RESULTS_DIR)/5_*.odb $(RESULTS_DIR)/5_route.sdc $(RESULTS_DIR)/5_*.def $(RESULTS_DIR)/5_*.v
	rm -f  $(REPORTS_DIR)/5_*
	rm -f  $(LOG_DIR)/5_*

klayout_tr_rpt: $(RESULTS_DIR)/5_route.def $(OBJECTS_DIR)/klayout.lyt
	$(call KLAYOUT_FOUND)
	$(KLAYOUT_CMD) -rd in_drc="$(REPORTS_DIR)/5_route_drc.rpt" \
	        -rd in_def="$<" \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rm $(UTILS_DIR)/viewDrc.py

klayout_guides: $(RESULTS_DIR)/5_route.def $(OBJECTS_DIR)/klayout.lyt
	$(call KLAYOUT_FOUND)
	$(KLAYOUT_CMD) -rd in_guide="$(RESULTS_DIR)/route.guide" \
	        -rd in_def="$<" \
	        -rd net_name=$(GUIDE_NET) \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rm $(UTILS_DIR)/viewGuide.py

