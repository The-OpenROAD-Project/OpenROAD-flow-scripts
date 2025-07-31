# The runs below test the implementation of the EQUIVALENCE_CHECK_USE_LIBS variable. By default, equivalence checking uses the verilog simulation models. The EQUIVALENCE_CHECK_USE_LIBS variable can be used to force the tool to instead do equivalence checking using .lib files. The valid values for EQUIVALENCE_CHECK_USE_LIBS are 0|1|"<list of .lib files>"
# When EQUIVALENCE_CHECK_USE_LIBS=1 then the files in LIB_FILES are used.  If instead a list of specific .lib files is given, the path to each file must be included.


make DESIGN_CONFIG="designs/nangate45/gcd/config.mk" clean_all
make DESIGN_CONFIG="designs/nangate45/gcd/config.mk" EQUIVALENCE_CHECK=1 cts
# Note the output from the above run includes:
# Using verilog simulation models for gold design: /OpenROAD-flow-scripts/flow/platforms/nangate45/work_around_yosys/cells.v
#Using verilog simulation models for modified design: /OpenROAD-flow-scripts/flow/platforms/nangate45/work_around_yosys/cells.v


make DESIGN_CONFIG="designs/nangate45/gcd/config.mk" clean_cts
make DESIGN_CONFIG="designs/nangate45/gcd/config.mk" EQUIVALENCE_CHECK=1 EQUIVALENCE_CHECK_USE_LIBS=0 cts
# Note the output from the above run includes:
# Using verilog simulation models to determine function definitions of cells in gold design: /OpenROAD-flow-scripts/flow/platforms/nangate45/work_around_yosys/cells.v
# Using verilog simulation models to determine function definitions of cells in modified design: /OpenROAD-flow-scripts/flow/platforms/nangate45/work_around_yosys/cells.v

make DESIGN_CONFIG="designs/nangate45/gcd/config.mk" clean_cts
make DESIGN_CONFIG="designs/nangate45/gcd/config.mk" EQUIVALENCE_CHECK=1 EQUIVALENCE_CHECK_USE_LIBS=1 cts
# Note the output from the above run includes:
# Using .lib files to determine function definitions of cells in gold design: /OpenROAD-flow-scripts/flow/platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib   
# Using .lib files to determine function definitions of cells in modified design: /OpenROAD-flow-scripts/flow/platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib   


make DESIGN_CONFIG="designs/nangate45/gcd/config.mk" clean_cts
make DESIGN_CONFIG="designs/nangate45/gcd/config.mk" EQUIVALENCE_CHECK=1 EQUIVALENCE_CHECK_USE_LIBS=platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib cts
# Note the output from the above run includes: 
# Using .lib files to determine function definitions of cells in gold design: platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib
# Using .lib files to determine function definitions of cells in modified design: platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib



