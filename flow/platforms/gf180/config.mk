#-----------------------------------------------------
# Tech/Libs
#   TRACK_OPTION - 9t 7t
#   METAL_OPTION - 5LM_1TM
#----------------------------------------------------
export TRACK_OPTION                          ?= 9t
export METAL_OPTION                          ?= 5LM_1TM
export KVALUE                                ?= 9
export POWER_OPTION                          ?= 5v0
export CORNER                                ?= BC
export PROCESS                                = 180

#----------------------------------------------------
# OpenROAD
#----------------------------------------------------
export TECH_LEF                               = $(PLATFORM_DIR)/lef/gf180mcu_$(METAL_OPTION)_$(KVALUE)K_$(TRACK_OPTION)_tech.lef

export SC_LEF                                ?= $(PLATFORM_DIR)/lef/gf180mcu_$(METAL_OPTION)_$(KVALUE)K_$(TRACK_OPTION)_sc.lef

export GDS_FILES                              = $(wildcard $(PLATFORM_DIR)/gds/$(TRACK_OPTION)/*.gds) \
                                                $(ADDITIONAL_GDS)

# Dont use cells 
export DONT_USE_CELLS                         = *_1

# Fill cells used in fill cell insertion
export FILL_CELLS                             ?= gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__fill_64 \
                                                 gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__fill_32 \
                                                 gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__fill_16 \
                                                 gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__fill_8 \
                                                 gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__fill_4 \
                                                 gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__fill_2 \
                                                 gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__fill_1

export TIE_CELL                               = gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__filltie
export ENDCAP_CELL                            = gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__endcap
export RC_FILE                                = $(PLATFORM_DIR)/setRC.tcl

#-----------------------------------------------------
# Yosys
#-----------------------------------------------------

# set the TIEHI/TIELO cells
export TIEHI_CELL_AND_PORT                    = gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__tieh Z
export TIELO_CELL_AND_PORT                    = gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__tiel ZN

export ABC_DRIVER_CELL                        = gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__buf_4
export ABC_LOAD_IN_FF                         = 0.01343

# hold buffer cell
export MIN_BUF_CELL_AND_PORTS                 = gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__dlya_4 I Z

# Used in synthesis
export MAX_FANOUT                             = 20

# Yosys mapping files
export LATCH_MAP_FILE ?= $(PLATFORM_DIR)/cells_latch.v
export ADDER_MAP_FILE ?= $(PLATFORM_DIR)/cells_adders.v

#--------------------------------------------------------
# Floorplan
#-------------------------------------------------------
# Placement site for core cells
ifeq ($(TRACK_OPTION),9t) 
export PLACE_SITE                             ?= GF018hv5v_green_sc9
else
export PLACE_SITE                             ?= GF018hv5v_mcu_sc7
endif

# IO Placer pin layers
export IO_PLACER_H                           ?= Metal3
export IO_PLACER_V                           ?= Metal4

# Define default PDN config
export PDN_TCL                               ?= $(PLATFORM_DIR)/openROAD/pdn/pdn_grid_strategy_$(TRACK_OPTION)_6M.cfg

# Endcap and Welltie cells
export TAPCELL_TCL                           ?= $(PLATFORM_DIR)/openROAD/tapcell.tcl

# macro planning
export MACRO_PLACE_HALO                      ?= 10 10
export MACRO_PLACE_CHANNEL                   ?= 20.16 20.16

#---------------------------------------------------------
# Place
#--------------------------------------------------------
export PLACE_DENSITY                         ?= 0.40

#---------------------------------------------------------
# Route
#---------------------------------------------------------
# FastRoute options
export MIN_ROUTING_LAYER                     ?= Metal2
export MAX_ROUTING_LAYER                     ?= Metal5
export DISABLE_VIA_GEN                       ?= 1

# Define fastRoute tcl
export FASTROUTE_TCL ?= $(PLATFORM_DIR)/fastroute.tcl

# KLayout layer properties
export KLAYOUT_TECH_FILE                      = $(PLATFORM_DIR)/KLayout/gf180mcu_$(METAL_OPTION)_$(KVALUE)K_$(TRACK_OPTION).lyt
export KLAYOUT_LEF_FILE                       = $(PLATFORM_DIR)/KLayout/tech_$(TRACK_OPTION)_$(METAL_OPTION).lef
export GDS_LAYER_MAP                          = $(abspath $(PLATFORM_DIR)/gds/$(TRACK_OPTION)/gf180mcu_$(METAL_OPTION)_$(KVALUE)K_$(TRACK_OPTION)_edi2gds.layermap)

# For RCX
export BC_RCX_RULES                           = $(PLATFORM_DIR)/openROAD/rcx/gf180mcu_1p5m_1tm_9k_sp_smim_OPTB_bst.rules
export WC_RCX_RULES                           = $(PLATFORM_DIR)/openROAD/rcx/gf180mcu_1p5m_1tm_9k_sp_smim_OPTB_wst.rules
export TC_RCX_RULES                           = $(PLATFORM_DIR)/openROAD/rcx/gf180mcu_1p5m_1tm_9k_sp_smim_OPTB_typ.rules

export BC_RCX_RC_CORNER                       = FuncRCmin
export WC_RCX_RC_CORNER                       = FuncRCmax
export TC_RCX_RC_CORNER                       = FuncRCtyp

export RCX_RULES                              = $($(CORNER)_RCX_RULES)
export RCX_RC_CORNER                          = $($(CORNER)_RCX_RC_CORNER)

#----------------------------------------------------------------------------------------------------
# define libraries - corner dependant setting
#----------------------------------------------------------------------------------------------------
# standard cell section
#----------------------------------------------------------------------------------------------------
export BC_LIB_FILES                           = $(abspath $(PLATFORM_DIR)/lib/gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__ff_n40C_5v50.lib.gz)
export BC_TEMPERATURE                         = -40c

export WC_LIB_FILES                           = $(abspath $(PLATFORM_DIR)/lib/gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__ss_125C_4v50.lib.gz)
export WC_TEMPERATURE                         = 125c

export TC_LIB_FILES                           = $(abspath $(PLATFORM_DIR)/lib/gf180mcu_fd_sc_mcu$(TRACK_OPTION)$(POWER_OPTION)__tt_025C_5v00.lib.gz)
export TC_TEMPERATURE                         = 25c

# ----------------------------------------------------------------------------------------------------
# now, set files from user setting CORNER
# ----------------------------------------------------------------------------------------------------
export TEMPERATURE                           = $($(CORNER)_TEMPERATURE)
export LIB_FILES                             = $($(CORNER)_LIB_FILES) \
                                               $(ADDITIONAL_LIBS)

# For proprietary tool enablements that are not public
export GF180_PRIVATE_DIR ?= ../../gf180-private
-include $(GF180_PRIVATE_DIR)/private.mk
