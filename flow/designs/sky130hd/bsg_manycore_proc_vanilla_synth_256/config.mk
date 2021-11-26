export DESIGN_NICKNAME = bsg_manycore_proc_vanilla_synth_256
export DESIGN_NAME = bsg_manycore_proc_vanilla
export PLATFORM    = sky130hd

export VERILOG_FILES = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/bsg_manycore_proc_vanilla.v \
        ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/hard_mem_1rw_byte_mask_d1024_w32_wrapper.v \
        ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/hard_mem_1rw_d1024_w46_wrapper.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/bsg_manycore_proc_vanilla.sdc
export RCX_RULES     = $(PLATFORM_DIR)/rcx_patterns.rules

export ADDITIONAL_GDS_FILES  = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/synthram_256x8.gds
export ADDITIONAL_LEFS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/synthram_256x8.lef
export ADDITIONAL_LIBS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/synthram_256x8.lib

export _VDD_NET_NAME = vccd1
export _GND_NET_NAME = vssd1

export PDN_CFG = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.cfg

export MACRO_PLACE_CHANNEL = 250 250

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 5700 4900 
export CORE_AREA   = 114 56 5510 4760

export PLACE_DENSITY = 0.10
export PLACE_DENSITY_MAX_POST_HOLD = 0.10
