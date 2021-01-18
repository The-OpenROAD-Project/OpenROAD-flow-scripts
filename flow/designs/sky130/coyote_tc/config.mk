export DESIGN_NICKNAME = coyote_tc
export DESIGN_NAME = coyote_tc

export PLATFORM    = sky130
# Clone Skywater library:
# git clone git@github.com:google/skywater-pdk.git --recursive
#

export SKY130_IO_VERSION ?= v0.2.0
export OPENRAMS_DIR = $(PLATFORM_DIR)/open_ram

export VERILOG_FILES = ./designs/src/coyote_tc/coyote_tc.v \
                       ./designs/src/coyote/coyote.sv2v.v \
                       ./designs/$(PLATFORM)/coyote_tc/ios.v \
                       ./designs/$(PLATFORM)/coyote_tc/macros.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_gpio_ovtv2/sky130_fd_io__top_gpio_ovtv2.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_gpio_ovtv2/sky130_fd_io__top_gpio_ovtv2.pp.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_gpiov2/sky130_fd_io__top_gpiov2.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_gpiov2/sky130_fd_io__top_gpiov2.pp.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_ground_hvc_wpad/sky130_fd_io__top_ground_hvc_wpad.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_ground_hvc_wpad/sky130_fd_io__top_ground_hvc_wpad.pp.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_ground_lvc_wpad/sky130_fd_io__top_ground_lvc_wpad.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_ground_lvc_wpad/sky130_fd_io__top_ground_lvc_wpad.pp.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_power_hvc_wpad/sky130_fd_io__top_power_hvc_wpad.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_power_hvc_wpad/sky130_fd_io__top_power_hvc_wpad.pp.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_power_hvc_wpadv2/sky130_fd_io__top_power_hvc_wpadv2.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_power_hvc_wpadv2/sky130_fd_io__top_power_hvc_wpadv2.pp.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_power_lvc_wpad/sky130_fd_io__top_power_lvc_wpad.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_power_lvc_wpad/sky130_fd_io__top_power_lvc_wpad.pp.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_refgen_new/sky130_fd_io__top_refgen_new.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_refgen_new/sky130_fd_io__top_refgen_new.pp.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_refgen/sky130_fd_io__top_refgen.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_refgen/sky130_fd_io__top_refgen.pp.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_sio_macro/sky130_fd_io__top_sio_macro.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_sio_macro/sky130_fd_io__top_sio_macro.pp.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_sio/sky130_fd_io__top_sio.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_sio/sky130_fd_io__top_sio.pp.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_xres4v2/sky130_fd_io__top_xres4v2.blackbox.v \
                       $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_xres4v2/sky130_fd_io__top_xres4v2.pp.blackbox.v 

export SDC_FILE      = ./designs/$(PLATFORM)/coyote_tc/constraint.sdc

export FOOTPRINT_LIBRARY = $(PLATFORM_DIR)/library.sky130_fd_io.tcl
export FOOTPRINT         = ./designs/$(PLATFORM)/coyote_tc/coyote_tc.package.strategy
export SIG_MAP_FILE      = ./designs/$(PLATFORM)/coyote_tc/coyote_tc.sigmap

export ADDITIONAL_LIBS = $(OPENRAMS_DIR)/sky130_sram_1rw1r_80x64_8/sky130_sram_1rw1r_80x64_8_TT_1p8V_25C.lib \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_128x256_8/sky130_sram_1rw1r_128x256_8_TT_1p8V_25C.lib \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_44x64_8/sky130_sram_1rw1r_44x64_8_TT_1p8V_25C.lib \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_64x256_8/sky130_sram_1rw1r_64x256_8_TT_1p8V_25C.lib \
                         $(PLATFORM_DIR)/lib/sky130_dummy_io.lib

export ADDITIONAL_GDS  = $(OPENRAMS_DIR)/sky130_sram_1rw1r_80x64_8/sky130_sram_1rw1r_80x64_8.gds \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_128x256_8/sky130_sram_1rw1r_128x256_8.gds \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_44x64_8/sky130_sram_1rw1r_44x64_8.gds \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_64x256_8/sky130_sram_1rw1r_64x256_8.gds

export ADDITIONAL_LEFS = \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_gpio_ovtv2/sky130_fd_io__top_gpio_ovtv2.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_gpiov2/sky130_fd_io__top_gpiov2.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_ground_hvc_wpad/sky130_fd_io__top_ground_hvc_wpad.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_ground_lvc_wpad/sky130_fd_io__top_ground_lvc_wpad.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_power_hvc_wpad/sky130_fd_io__top_power_hvc_wpad.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_power_lvc_wpad/sky130_fd_io__top_power_lvc_wpad.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/top_xres4v2/sky130_fd_io__top_xres4v2.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/corner_bus_overlay/sky130_fd_io__corner_bus_overlay.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_gpiov2/sky130_fd_io__overlay_gpiov2.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vccd_hvc/sky130_fd_io__overlay_vccd_hvc.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vccd_lvc/sky130_fd_io__overlay_vccd_lvc.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vdda_hvc/sky130_fd_io__overlay_vdda_hvc.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vdda_lvc/sky130_fd_io__overlay_vdda_lvc.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vddio_hvc/sky130_fd_io__overlay_vddio_hvc.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vddio_lvc/sky130_fd_io__overlay_vddio_lvc.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vssa_hvc/sky130_fd_io__overlay_vssa_hvc.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vssa_lvc/sky130_fd_io__overlay_vssa_lvc.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vssd_hvc/sky130_fd_io__overlay_vssd_hvc.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vssd_lvc/sky130_fd_io__overlay_vssd_lvc.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vssio_hvc/sky130_fd_io__overlay_vssio_hvc.lef \
                         $(SKY130_PDK)/libraries/sky130_fd_io/$(SKY130_IO_VERSION)/cells/overlay_vssio_lvc/sky130_fd_io__overlay_vssio_lvc.lef \
                         $(SKY130_EF_PDK)/custom/sky130_fd_io/lef/sky130_ef_io__com_bus_slice_10um.lef \
                         $(SKY130_EF_PDK)/custom/sky130_fd_io/lef/sky130_ef_io__com_bus_slice_1um.lef \
                         $(SKY130_EF_PDK)/custom/sky130_fd_io/lef/sky130_ef_io__com_bus_slice_20um.lef \
                         $(SKY130_EF_PDK)/custom/sky130_fd_io/lef/sky130_ef_io__com_bus_slice_5um.lef \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_80x64_8/sky130_sram_1rw1r_80x64_8.lef \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_128x256_8/sky130_sram_1rw1r_128x256_8.lef \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_44x64_8/sky130_sram_1rw1r_44x64_8.lef \
                         $(OPENRAMS_DIR)/sky130_sram_1rw1r_64x256_8/sky130_sram_1rw1r_64x256_8.lef \
                         $(PLATFORM_DIR)/lef/sky130io_fill.lef

# These values must be multiples of placement site
export DIE_AREA    = 0.0 0.0 5200 4609.14
export CORE_AREA   = 210 210 4990 4389.14

export ABC_CLOCK_PERIOD_IN_PS = 10000
export ABC_DRIVER_CELL = sky130_fd_sc_hs__buf_1
export ABC_LOAD_IN_FF = 3

export POST_SYNTHESYS_RENAMING = ./designs/sky130/coyote_tc/post_synthesis_rename.tcl

# Use custom power grid with core rings offset from the pads
export PDN_CFG = ./designs/sky130/coyote_tc/pdn.cfg

# Point to the RC file
export SETRC_FILE = $(PLATFORM_DIR)/setRC.tcl

