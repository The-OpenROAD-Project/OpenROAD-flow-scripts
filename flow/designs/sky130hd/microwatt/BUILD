load("//flow/designs:design.bzl", "design")

# VERILOG_FILES_BLACKBOX is a config.mk-local helper: only used via
# $(VERILOG_FILES_BLACKBOX) expansion inside VERILOG_FILES. Not read by
# ORFS or by any user .tcl/.mk — drop it so it never reaches orfs_flow.
design(config = "config.mk", local_arguments = ["VERILOG_FILES_BLACKBOX"])
