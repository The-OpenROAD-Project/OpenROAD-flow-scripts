load("//flow/designs:design.bzl", "design")

design(config = "config.mk")

# The E12 macro-placement experiment (//flow/test/macro_e12) drives this
# design's flow from its synthesis output. design() leaves the flow
# targets package-private, so expose just the synth stage to that one
# package rather than widening the whole family.
alias(
    name = "swerv_wrapper_synth_for_e12",
    actual = ":swerv_wrapper_synth",
    visibility = ["//flow/test/macro_e12:__pkg__"],
)
