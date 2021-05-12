export DESIGN_NICKNAME = chameleon_hier
export DESIGN_NAME = soc_core
export PLATFORM    = sky130hd

export SKY130_IO_VERSION ?= v0.2.0
export OPENRAMS_DIR = ./platforms/sky130ram
export IO_DIR       = ./platforms/sky130io



export VERILOG_FILES_BLACKBOX =  \
					./designs/src/$(DESIGN_NICKNAME)/rtl/ibex/*.v \
    					./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/DFFRAM_4K.v \
    					./designs/src/$(DESIGN_NICKNAME)/rtl/AHB_sys_0/APB_sys_0/*.v \
    					./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/DMC_32x16HC.v

export BLOCKS = \
                         DFFRAM_4K \
	                 DMC_32x16HC \
	                 apb_sys_0 \
	                 ibex_wrapper


export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/rtl/acc/AHB_SPM.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/AHBSRAM.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/DFFRAMBB.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/GPIO.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/APB_I2C.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/APB_SPI.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/APB_UART.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/i2c_master.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/PWM32.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/RAM_3Kx32.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/QSPI_XIP_CTRL.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/spi_master.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/TIMER32.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/IPs/WDT32.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/AHB_sys_0/*.v \
    				   ./designs/src/$(DESIGN_NICKNAME)/rtl/soc_core.v \
					   $(VERILOG_FILES_BLACKBOX)
					   
export MACRO_PLACE_CHANNEL  = 160 160
export MACRO_PLACE_HALO = 2 2
export DIE_AREA    = 0.0 0.0 6800 6800
export CORE_AREA   = 200 200 6600 6600
export SDC_FILE          = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export RCX_RULES     = $(PLATFORM_DIR)/rcx_patterns.rules


export MACRO_PLACEMENT = ./designs/sky130hd/$(DESIGN_NICKNAME)/macro_placment.cfg


#export ADDITIONAL_LIBS = $(IO_DIR)/lib/sky130_dummy_io.lib
#export ADDITIONAL_LEFS = 
#export ADDITIONAL_GDS = 
			
# These values must be multiples of placement site





#export ABC_CLOCK_PERIOD_IN_PS = 10000
#export ABC_DRIVER_CELL = sky130_fd_sc_hd__buf_1
#export ABC_LOAD_IN_FF = 3


# Use custom power grid with core rings offset from the pads
#export PDN_CFG = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.cfg

export FP_PDN_RAIL_WIDTH = 0.48
export FP_PDN_RAIL_OFFSET = 0


# Point to the RC file
export SETRC_FILE = $(PLATFORM_DIR)/setRC.tcl

export MIN_ROUTING_LAYER 2
export MAX_ROUTING_LAYER 6

export FASTROUTE_TCL $(PLATFORM_DIR)/fastroute.tcl

