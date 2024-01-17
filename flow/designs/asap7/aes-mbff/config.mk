export PLATFORM               = asap7

export DESIGN_NAME            = aes_cipher_top
export DESIGN_NICKNAME        = aes-mbff

export VERILOG_FILES = $(sort $(wildcard ./designs/src/aes/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/aes/constraint.sdc

export ABC_AREA               = 1

export CORE_UTILIZATION         = 40
export CORE_ASPECT_RATIO        = 1
export CORE_MARGIN              = 2
export PLACE_DENSITY            = 0.65
export TNS_END_PERCENT          = 100

export CLUSTER_FLOPS            = 1
export ENABLE_DPO               = 0
