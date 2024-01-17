export DESIGN_NICKNAME = coyote_tc
export DESIGN_NAME = coyote_tc

export PLATFORM    = sky130hd
# Clone Skywater library:
# git clone git@github.com:google/skywater-pdk.git --recursive
#

export SYNTH_HIERARCHICAL = 1
export RTLMP_FLOW = True

export SKY130_IO_VERSION ?= v0.2.0
export OPENRAMS_DIR = ./platforms/sky130ram
export IO_DIR       = ./platforms/sky130io

export VERILOG_FILES = ./designs/$(PLATFORM)/coyote_tc/ios.v \
                       ./designs/$(PLATFORM)/coyote_tc/macros.v \
                       ./designs/src/coyote_tc/coyote_tc.v \
                       ./designs/src/coyote/coyote.sv2v.v \
                       $(IO_DIR)/verilog/sky130_io.blackbox.v

export SDC_FILE      = ./designs/$(PLATFORM)/coyote_tc/constraint.sdc

export FOOTPRINT_TCL = ./designs/$(PLATFORM)/coyote_tc/pad.tcl

export ADDITIONAL_LIBS = $(OPENRAMS_DIR)/sky130_sram_1rw1r_80x64_8/sky130_sram_1rw1r_80x64_8_TT_1p8V_25C.lib \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_128x256_8/sky130_sram_1rw1r_128x256_8_TT_1p8V_25C.lib \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_44x64_8/sky130_sram_1rw1r_44x64_8_TT_1p8V_25C.lib \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_64x256_8/sky130_sram_1rw1r_64x256_8_TT_1p8V_25C.lib \
                         $(IO_DIR)/lib/sky130_dummy_io.lib

export ADDITIONAL_GDS  = $(OPENRAMS_DIR)/sky130_sram_1rw1r_80x64_8/sky130_sram_1rw1r_80x64_8.gds \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_128x256_8/sky130_sram_1rw1r_128x256_8.gds \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_44x64_8/sky130_sram_1rw1r_44x64_8.gds \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_64x256_8/sky130_sram_1rw1r_64x256_8.gds

export ADDITIONAL_LEFS = $(IO_DIR)/lef/sky130_ef_io__gpiov2_pad_wrapped.lef \
                         $(IO_DIR)/lef/sky130_ef_io__com_bus_slice_10um.lef \
                         $(IO_DIR)/lef/sky130_ef_io__com_bus_slice_1um.lef \
                         $(IO_DIR)/lef/sky130_ef_io__com_bus_slice_20um.lef \
                         $(IO_DIR)/lef/sky130_ef_io__com_bus_slice_5um.lef \
                         $(IO_DIR)/lef/sky130_ef_io__corner_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vccd_hvc_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vccd_lvc_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vdda_hvc_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vdda_lvc_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vddio_hvc_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vddio_lvc_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vssa_hvc_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vssa_lvc_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vssd_hvc_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vssd_lvc_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vssio_hvc_pad.lef \
                         $(IO_DIR)/lef/sky130_ef_io__vssio_lvc_pad.lef \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_80x64_8/sky130_sram_1rw1r_80x64_8.lef \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_128x256_8/sky130_sram_1rw1r_128x256_8.lef \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_44x64_8/sky130_sram_1rw1r_44x64_8.lef \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_64x256_8/sky130_sram_1rw1r_64x256_8.lef \

# These values must be multiples of placement site
export DIE_AREA    = 0.0 0.0 5200 4609.14
export CORE_AREA   = 250 250 4950 4349.14

# Use custom power grid with core rings offset from the pads
export PDN_TCL = ./designs/$(PLATFORM)/coyote_tc/pdn.tcl

# Point to the RC file
export SETRC_FILE = $(PLATFORM_DIR)/setRC.tcl
