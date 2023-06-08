
MegaBoom design for ORFS
Derived from Ravi's "megaboom" branch originated from https://boom-core.org.

The memory behavior modules are modified to include optional instantiation of FakeRam.
These FakeRams were generated from FakeRam2.0 and are part of ASAP7's ORFS platform.
The FakeRams instantiation is enabled via `define WITHFAKERAM. The definition is in
the file openROAD.h.

The MegaBoom RTL delivery includs testing harness module that instantiate Megaboom. 
In order to allow synthesis to synthesize the Megaboom rather than testing harness, 
'define TESTHARNESS is commented out. This switch is also defined in openROAD.h.

The TESTHARNESS is useful for testing the MegaBoom with simulation platform.
