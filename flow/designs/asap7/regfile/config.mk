# AUTO_MEMORIES_REGFILES in its smallest form: one register file, listed
# by spec, in a parent of flops. Seconds to global route.
export DESIGN_NICKNAME = regfile
export DESIGN_NAME     = regfile_top
export PLATFORM        = asap7

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/regfile.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export AUTO_MEMORIES          = 1
export AUTO_MEMORIES_REGFILES = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/RegFile.regfile

# The file's macro is 28.5 x 10 um; a core sized by utilization alone
# would be square and narrower than the macro and its halo.
export DIE_AREA      = 0 0 60 45
export CORE_AREA     = 2 2 58 43
export PLACE_DENSITY = 0.5
