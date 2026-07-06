load("//flow/designs:design.bzl", "design")

# FP_PDN_RAIL_{OFFSET,WIDTH} are read by chameleon's own pdn.cfg, not
# by ORFS itself — route them through user_arguments so the validator
# doesn't reject them as unknown ORFS variables.
#
# VERILOG_FILES_BLACKBOX is a config.mk-local, source-typed helper:
# only used via $(VERILOG_FILES_BLACKBOX) expansion inside
# VERILOG_FILES. The new bazel-orfs validates sources too, so route it
# through user_sources.
design(
    config = "config.mk",
    user_arguments = [
        "FP_PDN_RAIL_OFFSET",
        "FP_PDN_RAIL_WIDTH",
    ],
    user_sources = ["VERILOG_FILES_BLACKBOX"],
)
