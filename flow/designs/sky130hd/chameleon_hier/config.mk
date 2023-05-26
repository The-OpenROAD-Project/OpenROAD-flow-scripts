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


export VERILOG_FILES = \
  ./designs/src/$(DESIGN_NICKNAME)/rtl/acc/AHB_SPM.v \
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

export HAS_IO_CONSTRAINTS = 1
export ENABLE_DPO = 0
export MACRO_PLACE_CHANNEL  = 160 160
export MACRO_PLACE_HALO = 160 160
export DIE_AREA    = 0.0 0.0 6800 6800
export CORE_AREA   = 200 200 6600 6600
export SDC_FILE          = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export MIN_ROUTING_LAYER = met1
export MAX_ROUTING_LAYER = met5
