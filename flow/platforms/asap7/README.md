# Summary

Version 1.7

This package contain minimal file set require for designs, packaged under OpenROAD.
This package also contain memory macro created from FakeRam2.0. The purpose of the
memory macros is to complete OpenROAD design flow.

FakeRam2.0 https://github.com/maliberty/FakeRAM2.0.git

# Content

The package contain

	* lib     - timing libraries for both standard cells and memory macros
	* lef     - LEF file format for physical design implementation for both
                    standard cells and memory macros
	* verilog - verilog model for memory macros
	* gds     - GDS for standard cells

Along with data files, the package contain 

	* PDN configuration for OpenROAD PG implementation
	* tapcell.tcl - script for OpenROAD tap cell insertion
	* KLayout technology files
