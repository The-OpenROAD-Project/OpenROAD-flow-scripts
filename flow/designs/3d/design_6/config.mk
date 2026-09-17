# 3D hybrid bonding yield analysis: a TSV interconnect die with a four high
# DRAM stack bonded on top.
#
# FLOW_TYPE=3d selects the 3D flow in scripts/3d.mk instead of the RTL-to-GDS
# flow. See docs/user/ThreeDFlow.md.
export FLOW_TYPE        = 3d

export DESIGN           = design_6
export YAP_MODE         = w2w_simulation
export NUM_WAFERS       = 1

# This design's inputs ship with YAP. A design with its own inputs would point
# these at $(DESIGN_DIR) instead.
YAP_DESIGN_DIR          = $(YAP_HOME)/W2W/input/$(DESIGN)

export YAP_CONFIG       = $(YAP_HOME)/W2W/configs/$(DESIGN)/$(DESIGN).yaml

export STACK_CONFIG     = $(YAP_DESIGN_DIR)/generated_stack_config.3dbx
export CHIPLET_DEFS     = $(YAP_DESIGN_DIR)/generated_chiplet_definitions.3dbv

export BMAP_FILES       = $(YAP_DESIGN_DIR)/Memory_DRAM_0_From_TSV_Interconnect_Die.bmap \
                          $(YAP_DESIGN_DIR)/Memory_DRAM_0_To_Memory_DRAM_1.bmap \
                          $(YAP_DESIGN_DIR)/Memory_DRAM_1_From_Memory_DRAM_0.bmap \
                          $(YAP_DESIGN_DIR)/Memory_DRAM_1_To_Memory_DRAM_2.bmap \
                          $(YAP_DESIGN_DIR)/Memory_DRAM_2_From_Memory_DRAM_1.bmap \
                          $(YAP_DESIGN_DIR)/Memory_DRAM_2_To_Memory_DRAM_3.bmap \
                          $(YAP_DESIGN_DIR)/Memory_DRAM_3_From_Memory_DRAM_2.bmap \
                          $(YAP_DESIGN_DIR)/TSV_Interconnect_Die_To_Memory_DRAM_0.bmap

export THREEDBF_FILES   = $(YAP_DESIGN_DIR)/Memory_DRAM_0.3dbf \
                          $(YAP_DESIGN_DIR)/Memory_DRAM_1.3dbf \
                          $(YAP_DESIGN_DIR)/Memory_DRAM_2.3dbf \
                          $(YAP_DESIGN_DIR)/Memory_DRAM_3.3dbf \
                          $(YAP_DESIGN_DIR)/TSV_Interconnect_Die.3dbf
