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

export CORE_UTILIZATION       = 60
export CORE_ASPECT_RATIO      = 1.3
export CORE_MARGIN            = 2

export LEC_AUX_VERILOG_FILES = $(DESIGN_DIR)/lec_blackbox_stubs.v

export ADDITIONAL_GDS  = $(DESIGN_DIR)/gds/apb_sys_0.gds.gz \
                               $(DESIGN_DIR)/gds/DMC_32x16HC.gds.gz \
                               $(DESIGN_DIR)/gds/DFFRAM_4K.gds.gz \
                               $(DESIGN_DIR)/gds/ibex_wrapper.gds.gz

export ADDITIONAL_LEFS  = $(DESIGN_DIR)/lef/apb_sys_0.lef \
                          $(DESIGN_DIR)/lef/DFFRAM_4K.lef \
                          $(DESIGN_DIR)/lef/DMC_32x16HC.lef \
                          $(DESIGN_DIR)/lef/ibex_wrapper.lef

export FP_PDN_RAIL_WIDTH  = 0.48
export FP_PDN_RAIL_OFFSET = 0
export TNS_END_PERCENT    = 100
