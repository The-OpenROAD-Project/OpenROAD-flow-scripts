# Utilities
#===============================================================================
metadata: $(REPORTS_DIR)/metadata-$(FLOW_VARIANT)-check.log

clean_metadata:
	rm -f $(REPORTS_DIR)/metadata-$(FLOW_VARIANT)-check.log
	rm -f $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json

.PHONY: update_metadata update_rules update_ok
update_ok: update_metadata update_rules

update_metadata: $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json
	cp -f $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json \
	      $(DESIGN_DIR)/metadata-$(FLOW_VARIANT)-ok.json

update_rules:
	$(UTILS_DIR)/genRuleFile.py $(DESIGN_DIR) --variant $(FLOW_VARIANT) --failing --tighten

update_rules_force:
	$(UTILS_DIR)/genRuleFile.py $(DESIGN_DIR) --variant $(FLOW_VARIANT) --update

$(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json:
	echo $(DESIGN_DIR) > $(REPORTS_DIR)/design-dir.txt
	$(UTILS_DIR)/genMetrics.py -d $(DESIGN_NICKNAME) \
		-p $(PLATFORM) \
		-v $(FLOW_VARIANT) \
		-o $@ 2>&1 | tee $(REPORTS_DIR)/gen-metrics-$(FLOW_VARIANT)-check.log

RULES_DESIGN = $(dir $(DESIGN_CONFIG))rules-$(FLOW_VARIANT).json

$(REPORTS_DIR)/metadata-$(FLOW_VARIANT)-check.log: $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json
	$(UTILS_DIR)/checkMetadata.py -m $< -r $(RULES_DESIGN) 2>&1 | tee $@

#-------------------------------------------------------------------------------

write_net_rc: $(RESULTS_DIR)/6_net_rc.csv

#$(RESULTS_DIR)/6_net_rc.csv: $(RESULTS_DIR)/4_cts.odb $(RESULTS_DIR)/6_final.spef
$(RESULTS_DIR)/6_net_rc.csv:
	($(TIME_CMD) $(OPENROAD_CMD) $(UTILS_DIR)/write_net_rc_script.tcl) 2>&1 | tee $(LOG_DIR)/6_write_net_rc.log

correlate_rc: $(RESULTS_DIR)/6_net_rc.csv
	$(UTILS_DIR)/correlateRC.py $(RESULTS_DIR)/6_net_rc.csv

# TODO Make always wants to redo designs with this rule, regardless of which variations are tried.
#	$(MAKE) DESIGN_CONFIG=$$config write_net_rc; \
#$(foreach config,$(wildcard designs/$(PLATFORM)/*/config.mk),$(MAKE) DESIGN_CONFIG=$(config) write_net_rc; )
correlate_platform_rc:
	for config in designs/$(PLATFORM)/*/config.mk; do \
	  design=$$(basename $$(dirname $$config)); \
	  make DESIGN_CONFIG=./$$config results/$(PLATFORM)/$$design/base/6_net_rc.csv; \
	done
	$(UTILS_DIR)/correlateRC.py $$(find results/$(PLATFORM)/*/base -name 6_net_rc.csv)

# Run test using gnu parallel
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

# Utility to create issues
#-------------------------------------------------------------------------------
# Run "make {script}_issue" where script is wildcarded from the scripts folder
#   e.g "make cts_issue"
# Set the ISSUE_TAG variable to rename the generated tar file
#-------------------------------------------------------------------------------
ISSUE_SCRIPTS = $(patsubst %.tcl,%,$(notdir $(sort $(wildcard $(SCRIPTS_DIR)/*.tcl))))
define \n


endef

export ISSUE_VARIABLES := $(foreach V, $(.VARIABLES),$(if $(filter-out environment% default automatic, $(origin $V)), $(if $(filter-out .% %QT_QPA_PLATFORM% %TIME_CMD% KLAYOUT% GENERATE_ABSTRACT_RULE%, $(V)),$V=$($V))${\n}))

$(foreach script,$(ISSUE_SCRIPTS),$(script)_issue): %_issue : versions.txt
	$(UTILS_DIR)/makeIssue.sh $*

clean_issues:
	rm -rf $(foreach issue, $(ISSUE_SCRIPTS), $(issue)_*.tar.gz)
	rm -rf $(VARS_BASENAME).sh $(RUN_ME_SCRIPT)
 
$(RESULTS_DIR)/6_final_only_clk.def: $(RESULTS_DIR)/6_final.def
	$(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/deleteNonClkNets.tcl

$(RESULTS_DIR)/6_final_no_power.def: $(RESULTS_DIR)/6_final.def
	$(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/deletePowerNets.tcl


gallery: $(RESULTS_DIR)/6_final_no_power.def $(RESULTS_DIR)/6_final_only_clk.def
	($(TIME_CMD) klayout -z -nc -rx -rd gallery_json=util/gallery.json \
	        -rd results_path=$(RESULTS_DIR) \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rm $(UTILS_DIR)/createGallery.py) 2>&1 | tee $(LOG_DIR)/6_1_merge.log

view_cells:
	$(OPENROAD_GUI_CMD) $(SCRIPTS_DIR)/view_cells.tcl

## Quick access to command line
command:
	$(OPENROAD_NO_EXIT_CMD)

## Provide easy access to debugging
ifdef GDB
OPENROAD_EXE := gdb --args $(OPENROAD_EXE)
endif

## Provide easy way to run valgrind
ifdef VALGRIND
OPENROAD_EXE := valgrind $(VALGRIND_ARGS) $(OPENROAD_EXE)
endif

## Convert RVE DRC database to JSON
convert_rve: $(REPORTS_DIR)/drc.json

$(REPORTS_DIR)/drc.json: $(DRC_FILE)
ifneq ($(DRC_FILE),)
	$(KLAYOUT_CMD) -z -rd in_drc="$<" \
	        -rd out_file="$@" \
	        -rm $(UTILS_DIR)/convertDrc.py
else
	@echo "No DRC_FILE defined."
endif

# Update the clock period sdc based on the worst slack reported by the final
# (post global route) timing.
update_sdc_clocks: $(RESULTS_DIR)/route.guide
	cp $(RESULTS_DIR)/updated_clks.sdc $(SDC_FILE)
