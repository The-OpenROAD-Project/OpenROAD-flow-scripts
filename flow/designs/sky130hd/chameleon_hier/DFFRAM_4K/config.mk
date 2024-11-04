export TOP_NICKNAME = chameleon_hier
export TOP_DIR = $(DESIGN_HOME)/$(PLATFORM)/${TOP_NICKNAME}

export DESIGN_NAME = DFFRAM_4K
export DESIGN_NICKNAME = ${TOP_NICKNAME}_${DESIGN_NAME}
export PLATFORM    = sky130hd
export RTL_DIR  = $(DESIGN_HOME)/src/${TOP_NICKNAME}/rtl

export VERILOG_FILES = \
                         ${RTL_DIR}/IPs/DFFRAM_4K.v \
                         ${RTL_DIR}/IPs/DFFRAMBB.v


export SDC_FILE          = ${TOP_DIR}/${DESIGN_NAME}/constraint.sdc

export PDN_TCL = ${TOP_DIR}/BLOCKS_pdn.tcl

export ABC_DRIVER_CELL = sky130_fd_sc_hd__buf_1
export ABC_LOAD_IN_FF = 3

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1925 2450
export CORE_AREA    = 0.46 2.720 1924.54 2447.28
export MIN_ROUTING_LAYER = met1
export MAX_ROUTING_LAYER = met4
