# Suppress [WARNING STA-1212] "timing group from output port." for ASAP7.
# (This warning was numbered STA-0164 before OpenSTA renumbered its messages.)
#
# The asap7sc7p5t_SIMPLE_* libraries (all VT and corner variants) contain
# intentional output-to-output timing arcs from CON to SN in FAx1 and HAxp5.
# These cells use a mirror-adder topology: the inverted carry node (CON) is
# also an internal input to the sum stage, e.g. for HAxp5
# SN = !((A + B) * CON). The CON->SN arcs model how CON's load delays SN.
# They are correct and must not be removed from the Liberty files.
# Removing them makes SN timing optimistic, because SN delay would no longer
# depend on CON's load.
#
# OpenSTA builds and uses these arcs whether or not the warning is
# suppressed, so this suppression only affects log output.
#
# Note that this applies to every Liberty file read in an ASAP7 flow,
# including user-added ones (e.g. ADDITIONAL_LIBS). Elsewhere, STA-1212
# usually means a real library bug, such as a related_pin typo or wrong pin
# direction.
#
# See https://github.com/The-OpenROAD-Project/OpenROAD/discussions/3291 and
# https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/pull/1056
suppress_message STA 1212
