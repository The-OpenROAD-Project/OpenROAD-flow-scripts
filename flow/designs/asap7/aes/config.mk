$(info [INFO-FLOW] AES Design)

DESIGN_DIR                   := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

export DESIGN_NAME            = aes_cipher_top
export DESIGN_NICKNAME        = aes
export DESIGN                 = aes

export VERILOG_FILES          = $(sort $(wildcard $(DESIGN_DIR)/src/*.v))
export SDC_FILE               = $(DESIGN_DIR)/src/constraint.sdc

export CORNER                ?= BC

export LIB_FILES             += $($(CORNER)_LIB_FILES)
export LIB_DIRS              += $($(CORNER)_LIB_DIRS)
export DB_FILES              += $($(CORNER)_DB_FILES)
export DB_DIRS               += $($(CORNER)_DB_DIRS)
export WRAP_LIBS             += $(WRAP_$(CORNER)_LIBS)
export WRAP_LEFS             += $(WRAP_$(CORNER)_LEFS)
export TEMPERATURE            = $($(CORNER)_TEMPERATURE)

export ABC_CLOCK_PERIOD_IN_PS = 400

export DESIGN_POWER           = VDD
export DESIGN_GROUND          = VSS

export DESIGN_DIR

include $(DESIGN_DIR)/config_asap7.mk
