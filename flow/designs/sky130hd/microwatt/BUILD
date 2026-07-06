load("//flow/designs:design.bzl", "design")

# VERILOG_FILES_BLACKBOX is a config.mk-local, source-typed helper:
# only used via $(VERILOG_FILES_BLACKBOX) expansion inside
# VERILOG_FILES. The new bazel-orfs validates sources too, so route it
# through user_sources.
design(
    config = "config.mk",
    user_sources = ["VERILOG_FILES_BLACKBOX"],
)
