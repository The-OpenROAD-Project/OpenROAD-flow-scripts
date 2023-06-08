MegaBoom design for ORFS
Derived from Ravi's megaboom branch originated from https://boom-core.org.

rocketchip.MegaBoomConfig.behav_srams.v - memory behavior file
The memory behavior modules are modified to include optional instantiation of FakeRam.
These FakeRams were generated from FakeRam2.0 and are part of ASAP7's ORFS platform.
The instantiation of FakeRams are triggered by `define WITHFAKERAM. The `define declaration
is contained within openROAD.h file.

openROAD.h - auxillary file for switches
The RTL delivery includs testing harness module that instantiate Megaboom. In order to allow
synthesis to synthesize the Megaboom hierachy rather than the testing harness, 'define TESTHARNESS
has been commented out.

The testing harness is useful when used within simulation platform for testing the MegaBoom design.
    

