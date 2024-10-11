export DESIGN_NICKNAME = aes-hybrid
export DESIGN_NAME     = aes_cipher_top
export PLATFORM        = gf180

# See the README
export SC_LEF = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/adjusted-gf180mcu_5LM_1TM_9K_9t_sc.lef

export BC_ADDITIONAL_LIB_FILES = gf180mcu_fd_sc_mcu7t$(POWER_OPTION)__ff_n40C_5v50.lib.gz

export WC_ADDITIONAL_LIB_FILES = gf180mcu_fd_sc_mcu7t$(POWER_OPTION)__ss_125C_4v50.lib.gz

export TC_ADDITIONAL_LIB_FILES = gf180mcu_fd_sc_mcu7t$(POWER_OPTION)__tt_025C_5v00.lib.gz

export ADDITIONAL_LEFS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/hybrid_sites.lef \
                         $(PLATFORM_DIR)/lef/gf180mcu_5LM_1TM_9K_7t_sc.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/$($(CORNER)_ADDITIONAL_LIB_FILES)
#export ADDITIONAL_GDS  = $(wildcard $(PLATFORM_DIR)/gds/7t/*.gds)

export GDS_ALLOW_EMPTY = gf180mcu_fd_sc_mcu7t5v0__.*

export PLACE_SITE      = sc9sc7

export VERILOG_FILES   = $(sort $(wildcard ./designs/src/aes/*.v))
export SDC_FILE        = ./designs/$(PLATFORM)/aes/constraint.sdc
export ABC_AREA        = 1

export CORE_UTILIZATION  = 30
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN       = 2

export PLACE_DENSITY = 0.40

export ENABLE_DPO = 0
export BALANCE_ROWS = 1

export PDN_TCL = $(PLATFORM_DIR)/openROAD/pdn/pdn_grid_strategy_7t_6M.cfg

export FILL_CELLS=

ifeq ($(USE_FILL),1)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif
