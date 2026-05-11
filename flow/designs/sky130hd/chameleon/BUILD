load("//flow/designs:design.bzl", "design")

# FP_PDN_RAIL_{OFFSET,WIDTH} are read by chameleon's own pdn.cfg, not
# by ORFS itself — route them through user_arguments so the validator
# doesn't reject them as unknown ORFS variables.
#
# VERILOG_FILES_BLACKBOX is a config.mk-local helper: only used via
# $(VERILOG_FILES_BLACKBOX) expansion inside VERILOG_FILES.
design(
    config = "config.mk",
    user_arguments = [
        "FP_PDN_RAIL_OFFSET",
        "FP_PDN_RAIL_WIDTH",
    ],
    local_arguments = ["VERILOG_FILES_BLACKBOX"],
)
