load("//flow/designs:design.bzl", "design")

design(
    config = "config.mk",
    # BC/TC/WC_ADDITIONAL_LIB_FILES are pure make helpers expanded via
    # $($(CORNER)_ADDITIONAL_LIB_FILES) within this config.mk only.
    local_arguments = [
        "BC_ADDITIONAL_LIB_FILES",
        "TC_ADDITIONAL_LIB_FILES",
        "WC_ADDITIONAL_LIB_FILES",
    ],
    # DESIGN_TYPE is exported for private-PDK (gf12) DRC scripts and is
    # not an ORFS flow variable; bypass variables.yaml validation.
    user_arguments = ["DESIGN_TYPE"],
)
