load("//flow/designs:design.bzl", "design")

# SDC_FILE_EXTRA is a design-private path hook: set in this design's
# config.mk, source'd from this design's io.tcl, never read by ORFS.
# bazel-orfs's config_mk_parser SOURCE_VARS still stages the file into
# the sandbox; user_sources= tells the validator to leave the name
# alone (no variables.yaml entry required).
design(
    config = "config.mk",
    user_sources = ["SDC_FILE_EXTRA"],
)
