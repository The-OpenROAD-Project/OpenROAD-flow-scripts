export PLATFORM                = asap7

export DESIGN_NICKNAME        ?= coralnpu
export DESIGN_NAME             = CoreMiniAxi

export VERILOG_FILES           = $(DESIGN_HOME)/src/coralnpu/$(DESIGN_NAME).sv

# The snapshot is firtool's output with its verification layers
# concatenated in: 61 binds of *_Verification_Assert into the core. A
# layer is opt-in, so a synthesis build leaves them out; surgery.py
# removes them, as firtool's output without layers enabled would be.
export SYNTH_VERILOG_SURGERY   = $(DESIGN_HOME)/$(PLATFORM)/coralnpu/surgery.py

# The two TCM SRAMs, Sram_512x128 and Sram_2048x128, keep their arrays
# inside wrappers; surgery.py moves each into a memory module of
# firtool's convention (one read port, one write port with a 16-lane
# byte mask), and AUTO_MEMORIES gives each a generated macro, mask and
# all. The USE_ASAP7 fakerams have no write mask.
export AUTO_MEMORIES           = 1

export SDC_FILE                = $(DESIGN_HOME)/$(PLATFORM)/coralnpu/constraint.sdc

export SYNTH_HDL_FRONTEND     ?= slang

export CORE_UTILIZATION        = 65

# coralnpu's units, kept by name: the core, its fetch, dispatch,
# register files, load/store unit, CSRs and FPU, and the two AXI
# bridges. The ALUs, branch units, multiplier and divider are small and
# belong with the dispatch and writeback around them. The size
# threshold is out of reach so that the list alone decides.
export SYNTH_HIERARCHICAL      = 1
export SYNTH_KEEP_MODULES      = SCore UncachedFetch DispatchV1 Regfile FRegfile LsuV1 Csr FloatCore AxiSlave DBus2AxiV1
export SYNTH_MINIMUM_KEEP_SIZE = 1000000000
export OPENROAD_HIERARCHICAL   = 1

export RTLMP_MIN_CHANNEL_SIZE = 4 4
