export PLATFORM               = asap7

export DESIGN_NAME            = cva6

export SRC_HOME = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)
export VERILOG_FILES          = $(sort $(wildcard $(SRC_HOME)/common/local/util/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/pmp/src/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cache_subsystem/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/common/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/common/macros/blackbox/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/utils/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cache_subsystem/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cva6_mmu/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cvfpu/src/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/*.sv)) \
	$(SRC_HOME)/core/cvxif_example/include/cvxif_instr_pkg.sv \
	$(sort $(wildcard $(SRC_HOME)/core/cvxif_example/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/frontend/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/include/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/vendor/pulp-platform/axi/src/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/vendor/pulp-platform/common_cells/src/*.sv)) \
	$(SRC_HOME)/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv \
	$(PLATFORM_DIR)/verilog/fakeram7_256x32.sv

export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/include \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/common_cells/include \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/include

export VERILOG_DEFINES += -D HPDCACHE_ASSERT_OFF

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram7_256x32.lef

export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/NLDM/fakeram7_256x32.lib

export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export DIE_AREA               = 0 0 250 250
export CORE_AREA              = 1.08 1.08 240 240

export PLACE_DENSITY          = 0.50

# a smoketest for this option, there are a
# few last gasp iterations
export SKIP_LAST_GASP ?= 1


export SYNTH_HDL_FRONTEND = slang
