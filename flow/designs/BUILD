exports_files(["BUILD"])

# Local TL;DR of https://dashboard.precisioninno.com/: a GitHub-markdown
# status table over the forced-engine OpenROAD-SYN QoR tests already
# built in this workspace (see flow/designs/design.bzl). Reads
# bazel-testlogs only — builds nothing, instant.
#
#   bazelisk run //flow/designs:syn-dashboard
alias(
    name = "syn-dashboard",
    actual = "//flow/util:synDashboard",
)
