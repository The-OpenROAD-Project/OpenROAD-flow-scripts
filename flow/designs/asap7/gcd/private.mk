$(RESULTS_DIR)/$(FLOORPLAN_INPUT_STEM).sdc: $(RESULTS_DIR)/1_synth.sdc
	cp $< $@

$(RESULTS_DIR)/$(FLOORPLAN_INPUT_STEM).v: $(RESULTS_DIR)/1_synth.v
	cp $< $@
