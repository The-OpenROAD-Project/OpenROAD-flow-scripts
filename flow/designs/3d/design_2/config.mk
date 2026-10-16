export FLOW_TYPE        = 3d

export DESIGN           = design_2

export YAP_FLOW         = D2W
export NUM_DIE_STACKS   = 1000

export YAP_ASSIGN_BUMP_NAMES_ARGS = --critical-ratio 0.30 --redundant-ratio 0 \
                                    --pg-ratio 0.50 --dummy-ratio 0.20

export YAP_CONFIG       = $(DESIGN_DIR)/design_2.yaml

export STACK_CONFIG     = $(DESIGN_DIR)/generated_stack_config.3dbx
export CHIPLET_DEFS     = $(DESIGN_DIR)/generated_chiplet_definitions.3dbv

export BMAP_FILES       = $(DESIGN_DIR)/Compute_Large_0_From_Substrate_Organic.bmap \
                          $(DESIGN_DIR)/Compute_Large_1_From_Substrate_Organic.bmap \
                          $(DESIGN_DIR)/Compute_Large_2_From_Substrate_Organic.bmap \
                          $(DESIGN_DIR)/Compute_Large_3_From_Substrate_Organic.bmap

export THREEDBF_FILES   = $(DESIGN_DIR)/Compute_Large_0.3dbf \
                          $(DESIGN_DIR)/Compute_Large_1.3dbf \
                          $(DESIGN_DIR)/Compute_Large_2.3dbf \
                          $(DESIGN_DIR)/Compute_Large_3.3dbf \
                          $(DESIGN_DIR)/Substrate_Organic.3dbf
