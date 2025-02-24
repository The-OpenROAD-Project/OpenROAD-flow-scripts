export DESIGN_NICKNAME = chameleon
export DESIGN_NAME     = soc_core
export PLATFORM        = sky130hd

export VERILOG_FILES_BLACKBOX = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex/*.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/DFFRAM_4K.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/AHB_sys_0/APB_sys_0/*.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/DMC_32x16HC.v

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/acc/AHB_SPM.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/AHBSRAM.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/DFFRAMBB.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/GPIO.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/APB_I2C.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/APB_SPI.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/APB_UART.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/i2c_master.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/PWM32.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/RAM_3Kx32.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/QSPI_XIP_CTRL.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/spi_master.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/TIMER32.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/WDT32.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/AHB_sys_0/*.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/soc_core.v \
                       $(VERILOG_FILES_BLACKBOX)

export ABC_AREA = 1

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export DIE_AREA   = 0 0 2920 3520
export CORE_AREA  = 20 20 2900 3500

export chameleon_DIR = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)

export ADDITIONAL_GDS  = $(chameleon_DIR)/gds/apb_sys_0.gds.gz \
                               $(chameleon_DIR)/gds/DMC_32x16HC.gds.gz \
                               $(chameleon_DIR)/gds/DFFRAM_4K.gds.gz \
                               $(chameleon_DIR)/gds/ibex_wrapper.gds.gz

export ADDITIONAL_LEFS  = $(chameleon_DIR)/lef/apb_sys_0.lef \
                          $(chameleon_DIR)/lef/DFFRAM_4K.lef \
                          $(chameleon_DIR)/lef/DMC_32x16HC.lef \
                          $(chameleon_DIR)/lef/ibex_wrapper.lef

export MACRO_PLACEMENT = $(chameleon_DIR)/chameleon.macro_placment.cfg

export FP_PDN_RAIL_WIDTH  = 0.48
export FP_PDN_RAIL_OFFSET = 0
export TNS_END_PERCENT    = 100


