export DESIGN_NICKNAME = bsg_manycore_tile_compute_mesh_fakeram
export DESIGN_NAME = bsg_manycore_tile_compute_mesh
export PLATFORM    = sky130hd

export VERILOG_FILES = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/bsg_manycore_tile_compute_mesh.v \
        ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/hard_mem_1rw_byte_mask_d1024_w32_wrapper.v \
        ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/hard_mem_1rw_d1024_w46_wrapper.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/bsg_manycore_tile_compute_mesh.sdc
export RCX_RULES     = $(PLATFORM_DIR)/rcx_patterns.rules

export ADDITIONAL_LEFS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/fakeram130_1024x8.lef
export ADDITIONAL_LIBS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/fakeram130_1024x8.lib

export _VDD_NET_NAME = vccd1
export _GND_NET_NAME = vssd1

export MACRO_PLACE_CHANNEL = 200 200

export PDN_CFG = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.cfg
# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 3800 3080 
export CORE_AREA   = 57 28 3420 2800

export PLACE_DENSITY = 0.10
export PLACE_DENSITY_MAX_POST_HOLD = 0.10
