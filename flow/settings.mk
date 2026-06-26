# Enable LEC only if kepler-formal is installed.
# kepler-formal is primarily an OpenROAD/ORFS developer tool, not an end-user
# tool. End-users would typically run these checks transactionally at project
# completion, not in every CI run where it wastes CI time.
export LEC_CHECK ?= $(if $(wildcard $(KEPLER_FORMAL_EXE)),1,0)
export SEC_CHECK ?= 0
