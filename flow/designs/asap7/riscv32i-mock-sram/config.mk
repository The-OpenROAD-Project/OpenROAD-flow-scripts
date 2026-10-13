export DESIGN_NICKNAME = riscv32i-mock-sram
export BLOCKS=fakeram7_256x32

# ~1000 register file endpoints share near-identical paths, and detailed
# route parasitics add 10-40 ps over the global route estimate. Repairing
# with margin keeps them from failing together.
export SETUP_SLACK_MARGIN ?= 30

include designs/asap7/riscv32i/config.mk
