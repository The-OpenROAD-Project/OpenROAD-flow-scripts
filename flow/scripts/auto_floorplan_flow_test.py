#!/usr/bin/env python3

"""auto_floorplan_flow.tcl must stay flow.tcl's tail.

The floorplan derivation runs the production flow from floorplan to
finish in one process, starting from a shared 1_synth.odb. That sequence
is duplicated from flow.tcl because flow.tcl runs on source and offers no
seam to enter after synthesis.

Duplication of a sequence that has to stay in step rots silently: a stage
added to flow.tcl would simply not be measured by the derivation, and the
derived floorplan would be chosen against a flow that no longer exists.
This test makes that failure loud.
"""

import os
import re
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
FLOW = os.path.join(HERE, "flow.tcl")
DERIVE = os.path.join(HERE, "auto_floorplan_flow.tcl")

# The stages flow.tcl runs before the derivation's entry point. Everything
# after these must appear in both files, in the same order.
SYNTH_STAGES = ["synth_odb.tcl"]


def stages(path):
    with open(path) as f:
        return re.findall(r"(?m)^\s*flow_source\s+(\S+)", f.read())


def writes(path):
    with open(path) as f:
        return re.findall(r"(?m)^\s*flow_write_(?:db|sdc)\s+(\S+)", f.read())


class TestDeriveFlowMatchesFlow(unittest.TestCase):
    def test_stage_sequence_is_flow_tcl_tail(self):
        flow, derive = stages(FLOW), stages(DERIVE)
        self.assertEqual(
            flow[: len(SYNTH_STAGES)],
            SYNTH_STAGES,
            "flow.tcl no longer starts with the synthesis stage; the "
            "derivation's entry point assumption needs revisiting",
        )
        self.assertEqual(
            derive,
            flow[len(SYNTH_STAGES) :],
            "auto_floorplan_flow.tcl has drifted from flow.tcl. A stage "
            "added to one and not the other means the derivation picks a "
            "floorplan against a flow that is not the production one.",
        )

    def test_written_artifacts_match(self):
        flow, derive = writes(FLOW), writes(DERIVE)
        synth = [w for w in flow if w.startswith("1_synth")]
        self.assertEqual(
            derive,
            [w for w in flow if w not in synth],
            "the two flows no longer write the same artifacts",
        )

    def test_derive_does_not_run_synthesis(self):
        self.assertNotIn(
            "synth_odb.tcl",
            stages(DERIVE),
            "the derivation must start from the shared 1_synth.odb; "
            "re-running synthesis per candidate measures nothing and is "
            "the most expensive part of the walk",
        )


if __name__ == "__main__":
    unittest.main()
