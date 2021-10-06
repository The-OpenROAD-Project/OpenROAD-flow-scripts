export DESIGN_NICKNAME = bsg_manycore_tile_compute_mesh_real
export DESIGN_NAME = bsg_manycore_tile_compute_mesh
export PLATFORM    = sky130hd

export VERILOG_FILES_BLACKBOX = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/sky130_sram_1kbyte_1rw1r_8x1024_8.bb.v

export VERILOG_FILES = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/bsg_manycore_tile_compute_mesh.v \
	./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/hard_mem_1rw_byte_mask_d1024_w32_wrapper.v \
	./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/hard_mem_1rw_d1024_w46_wrapper.v \
	$(VERILOG_FILES_BLACKBOX)

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/bsg_manycore_tile_compute_mesh.sdc
export RCX_RULES     = $(PLATFORM_DIR)/rcx_patterns.rules

#export ADDITIONAL_GDS_FILES  =
export ADDITIONAL_LEFS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/sky130_sram_1kbyte_1rw1r_8x1024_8.lef

export _VDD_NET_NAME = vccd1
export _GND_NET_NAME = vssd1
# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 11400 8400
export CORE_AREA   = 152 112 11020 8120

#eixport PLACE_DENSITY = 0.39
#export PLACE_DENSITY_MAX_POST_HOLD = 0.39
