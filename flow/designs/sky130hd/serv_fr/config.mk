export DESIGN_NICKNAME = serv_fr
export DESIGN_NAME = serv_rf_top
export PLATFORM    = sky130hd

export VERILOG_FILES = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/*.v)) 
          
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lib))


# These values must be multiples of placement site
# x=0.19 y=1.4

#This value of area works
#export DIE_AREA    = 0 0 11400 11200
#export CORE_AREA   = 57 42 11020 10920

#This value of area faces congestion
export DIE_AREA = 0 0 11020 9800
export CORE_AREA = 57 42 10450 9380 
