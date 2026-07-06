load("//flow/designs:design.bzl", "design")

design(
    config = "config.mk",
    # DESIGN_TYPE is exported for private-PDK (gf12) DRC scripts and is
    # not an ORFS flow variable; bypass variables.yaml validation.
    user_arguments = ["DESIGN_TYPE"],
)
