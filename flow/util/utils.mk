# Utilities
#===============================================================================
.PHONY: metadata
metadata: finish metadata-generate metadata-check

# Synthesis-only metadata: generate and check QoR after just the synth
# stage, without running the full flow. Only the synthesis-stage metrics
# are sent to the dashboard, which evaluates just those. Sequential
# sub-makes rather than prerequisites: each step consumes the previous
# one's outputs, which plain prerequisites would race under make -j.
.PHONY: metadata-synth
metadata-synth:
	$(MAKE) synth
	$(MAKE) metadata-generate
	$(MAKE) metadata-check-synth

.PHONY: metadata-generate
metadata-generate:
	mkdir -p $(REPORTS_DIR)
	echo $(DESIGN_DIR) > $(REPORTS_DIR)/design-dir.txt
	$(PYTHON_EXE) $(UTILS_DIR)/genMetrics.py -d $(DESIGN_NICKNAME) \
	    -p $(PLATFORM) \
	    -v $(FLOW_VARIANT) \
	    --logs $(LOG_DIR) \
	    --reports $(REPORTS_DIR) \
	    --results $(RESULTS_DIR) \
	    -o $(REPORTS_DIR)/metadata.json 2>&1 \
	    | tee $(abspath $(REPORTS_DIR)/metadata-generate.log)

# The QoR gate: metadata.json against the QoR dashboard's baseline for the
# commit it records (the master build at its merge base, from the first of
# the dashboard's default pipelines that has the design), using the
# dashboard's rule configs. If no local remote-tracking ref contains the local
# commit, compute its merge base against DASHBOARD_MERGE_BASE (default
# refs/remotes/upstream/master if it names a commit, else
# refs/remotes/origin/master).
# If the pinned build is missing, warn and send the run unpinned. When local
# pinning applies, warn for a default ref that gives no merge base and fail
# for an explicit ref that gives no merge base. Set DASHBOARD_BASE_COMMIT
# to pin the baseline, DASHBOARD_API_KEY for a private platform and
# DASHBOARD_JOB_NAME to check as a build of one pipeline instead. A failed
# rule fails the target; an unreachable dashboard or a design without a
# baseline only warns.
.PHONY: metadata-check
metadata-check:
	$(PYTHON_EXE) $(UTILS_DIR)/checkQorMetrics.py \
	    -m $(abspath $(REPORTS_DIR)/metadata.json) \
	    -p $(PLATFORM) -d $(DESIGN_NICKNAME) --variant $(FLOW_VARIANT) 2>&1 \
	    | tee $(abspath $(REPORTS_DIR)/metadata-check.log)

# Send only the synthesis-stage metrics, so a synthesis-only run is gated
# by the rules the dashboard holds for those metrics.
.PHONY: metadata-check-synth
metadata-check-synth:
	$(PYTHON_EXE) $(UTILS_DIR)/checkQorMetrics.py \
	    -m $(abspath $(REPORTS_DIR)/metadata.json) \
	    -p $(PLATFORM) -d $(DESIGN_NICKNAME) --variant $(FLOW_VARIANT) \
	    --only-prefix synth__ constraints__ 2>&1 \
	    | tee $(abspath $(REPORTS_DIR)/metadata-check.log)

.PHONY: clean_metadata
clean_metadata:
	rm -f $(REPORTS_DIR)/design-dir.txt
	rm -f $(REPORTS_DIR)/metadata*.*

# The golden designs/<platform>/<design>/metadata-<variant>-ok.json files
# were removed with the report table that compared runs against them.
.PHONY: update_metadata
update_metadata:
	@echo "[WARN] make update_metadata is deprecated and does nothing." \
	      "The golden metadata-<variant>-ok.json files and the report table" \
	      "that read them were removed. Baselines live in the QoR dashboard" \
	      "(see docs/contrib/Metrics.md)."

.PHONY: update_metadata_autotuner
update_metadata_autotuner:
	$(PYTHON_EXE) $(UTILS_DIR)/genMetrics.py -d $(DESIGN_NICKNAME) \
	    -p $(PLATFORM) \
	    -v $(FLOW_VARIANT) \
	    --logs $(LOG_DIR) \
	    --reports $(REPORTS_DIR) \
	    --results $(RESULTS_DIR) \
	    -o $(DESIGN_DIR)/metadata-$(FLOW_VARIANT)-at.json -x

#-------------------------------------------------------------------------------

.PHONY: write_rc
write_rc: $(RESULTS_DIR)/6_nets_rc.csv $(RESULTS_DIR)/6_segments_rc.csv

# A pattern rule to write both files with a single run, as the grouped target
# syntax requires GNU Make 4.3.
%_nets_rc.csv %_segments_rc.csv:
	$(UNSET_AND_MAKE) do-write_rc

# The do- sibling, following do-synth-report and the do-step/do-copy
# families: the file target above decides *whether* to run and delegates
# here, and this rule is the only place the invocation lives. A caller
# doing its own dependency checking asks for this one directly.
.PHONY: do-write_rc
do-write_rc:
	$(RUN_CMD) --log $(LOG_DIR)/6_write_rc.log --tee -- $(OPENROAD_CMD) $(UTILS_DIR)/write_rc.tcl

.PHONY: correlate_rc
correlate_rc: $(RESULTS_DIR)/6_segments_rc.csv
	$(PYTHON_EXE) $(UTILS_DIR)/correlateRC.py \
	    -segments_rc_file $(RESULTS_DIR)/6_segments_rc.csv

# TODO Make always wants to redo designs with this rule, regardless of which variations are tried.
#	$(MAKE) DESIGN_CONFIG=$$config write_rc; \
#$(foreach config,$(wildcard designs/$(PLATFORM)/*/config.mk),$(MAKE) DESIGN_CONFIG=$(config) write_rc; )
.PHONY: correlate_platform_rc
correlate_platform_rc:
	for config in designs/$(PLATFORM)/*/config.mk; do \
	  design=$$(basename $$(dirname $$config)); \
	  make DESIGN_CONFIG=./$$config \
	    results/$(PLATFORM)/$$design/base/6_nets_rc.csv \
	    results/$(PLATFORM)/$$design/base/6_segments_rc.csv; \
	done
	$(PYTHON_EXE) $(UTILS_DIR)/correlateRC.py \
	    -segments_rc_file $$(find results/$(PLATFORM)/*/base -name 6_segments_rc.csv)

# Utility to create issues
#-------------------------------------------------------------------------------
# Run "make {script}_issue" where script is wildcarded from the scripts folder
#   e.g "make cts_issue"
# Set the ISSUE_TAG variable to rename the generated tar file
#-------------------------------------------------------------------------------
ISSUE_SCRIPTS = $(patsubst %.tcl,%,$(notdir $(sort $(wildcard $(SCRIPTS_DIR)/*.tcl))))
define \n


endef

.PHONY: $(foreach script,$(ISSUE_SCRIPTS),$(script)_issue)

$(foreach script,$(ISSUE_SCRIPTS),$(script)_issue): %_issue :
	$(PYTHON_EXE) $(UTILS_DIR)/makeIssue.py $(WORK_HOME)/$*

.PHONY: clean_issues
clean_issues:
	rm -f $(foreach issue, $(ISSUE_SCRIPTS), $(issue)_*.tar.gz)
	rm -f vars*.sh vars*.tcl vars*.gdb run-me*.sh

$(RESULTS_DIR)/6_final_only_clk.def: $(RESULTS_DIR)/6_final.def
	$(RUN_CMD) --tee -- $(OPENROAD_CMD) $(SCRIPTS_DIR)/deleteNonClkNets.tcl

$(RESULTS_DIR)/6_final_no_power.def: $(RESULTS_DIR)/6_final.def
	$(RUN_CMD) --tee -- $(OPENROAD_CMD) $(SCRIPTS_DIR)/deletePowerNets.tcl


.PHONY: gallery
gallery: check-klayout $(RESULTS_DIR)/6_final_no_power.def $(RESULTS_DIR)/6_final_only_clk.def
	$(RUN_CMD) --log $(LOG_DIR)/6_1_merge.log --tee -- \
	        klayout -z -nc -rx -rd gallery_json=util/gallery.json \
	        -rd results_path=$(RESULTS_DIR) \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rm $(UTILS_DIR)/createGallery.py

.PHONY: view_cells view_cells_web
view_cells:
	$(OPENROAD_GUI_CMD) $(SCRIPTS_DIR)/view_cells.tcl

.PHONY: view_cells_web
view_cells_web:
	$(OPENROAD_WEB_CMD) $(SCRIPTS_DIR)/view_cells.tcl

## Quick access to command line
.PHONY: command
command:
	$(OPENROAD_NO_EXIT_CMD)

## Convert RVE DRC database to JSON
.PHONY: convert_rve
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
.PHONY: update_sdc_clocks
update_sdc_clocks: $(RESULTS_DIR)/route.guide
	cp $(RESULTS_DIR)/updated_clks.sdc $(SDC_FILE)
