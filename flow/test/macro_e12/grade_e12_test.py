#!/usr/bin/env python3
"""Unit tests for the E12 gate.

These run in milliseconds on synthetic fixtures: the point is that the
gate's arithmetic and its pass/fail logic are testable without a flow
run, so a wrong verdict is caught here rather than after a 25-minute
campaign. The one test that touches real data checks that the committed
archive still reproduces the published rho of +0.72 [0.48, 0.84] -- if
that ever fails, the archive or the statistics moved and every E12
number is void.
"""

import json
import math
import os
import tempfile
import unittest

import grade_e12
from e12_stats import spearman, spearman_ci

ARCHIVE = os.path.join(os.path.dirname(__file__), "score_vs_flow_swerv.json")


def make_truth(n, macro_paths, proxy_macro_mean=None):
    """A minimal archive: n candidates with the given truth values."""
    candidates = {}
    for i in range(n):
        candidates["cand_s%d" % i] = {
            "grt": {
                "macro_paths_mean": macro_paths[i],
                "achieved": 1000.0 + i,
                "general_paths_mean": 900.0 + i,
                "stdcell_um2": 10000.0 + i,
            },
            "proxy": {
                "macro_mean": (
                    macro_paths[i] if proxy_macro_mean is None else proxy_macro_mean[i]
                ),
                "wq25": (
                    macro_paths[i] if proxy_macro_mean is None else proxy_macro_mean[i]
                ),
            },
        }
    return {"design": "synthetic", "candidates": candidates}


def make_leaves(n, flat_macro_mean, clustered_hpwl, diverged=()):
    flat = {}
    clustered = {}
    for i in range(n):
        tag = "cand_s%d" % i
        flat[tag] = {
            "tag": tag,
            "macro_mean": flat_macro_mean[i],
            "wq25": flat_macro_mean[i],
            "hpwl_dbu": 1000 + i,
            "gpl_s": 70.0,
        }
        clustered[tag] = {
            "tag": tag,
            "hpwl_dbu": clustered_hpwl[i],
            "cone_hpwl_dbu": clustered_hpwl[i] // 2,
            "diverged": 1 if tag in diverged else 0,
            "gpl_s": 20.0,
            "clusters_declared": 500,
        }
    return flat, clustered


class TestStats(unittest.TestCase):
    def test_perfect_and_inverted_ranking(self):
        xs = list(range(10))
        self.assertAlmostEqual(spearman(xs, xs), 1.0)
        self.assertAlmostEqual(spearman(xs, list(reversed(xs))), -1.0)

    def test_uniform_optimism_ranks_perfectly(self):
        """The premise the whole approach rests on."""
        truth = [10.0, 20.0, 30.0, 40.0]
        optimistic = [0.8 * v for v in truth]
        self.assertAlmostEqual(spearman(optimistic, truth), 1.0)

    def test_constant_score_is_nan_not_zero(self):
        """A scorer that returns one value for every candidate ranks nothing.

        rho is undefined there, and it must surface as NaN rather than as
        0.0 -- a silent 0.0 would read as "uncorrelated" and could be
        mistaken for a measurement.
        """
        rho = spearman([1, 1, 1, 1], [1, 2, 3, 4])
        self.assertTrue(math.isnan(rho))

    def test_ci_is_deterministic_and_brackets_rho(self):
        xs = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8]
        ys = [2, 7, 1, 8, 2, 8, 1, 8, 2, 8, 4, 5]
        first = spearman_ci(xs, ys, n_boot=200)
        second = spearman_ci(xs, ys, n_boot=200)
        self.assertEqual(first, second)
        low, high = first
        self.assertLessEqual(low, high)


class TestGateZero(unittest.TestCase):
    def test_exact_reproduction_passes(self):
        values = [100.0 + i for i in range(24)]
        truth = make_truth(24, values)
        flat, clustered = make_leaves(24, values, list(range(24)))
        verdict = grade_e12.build_verdict(truth, flat, clustered, 24, 100, 1e-6)
        self.assertTrue(verdict["gate_0_rig_check"]["pass"])
        self.assertEqual(verdict["gate_0_rig_check"]["candidates_compared"], 24)

    def test_drifted_candidate_fails_and_is_named(self):
        values = [100.0 + i for i in range(24)]
        drifted = list(values)
        drifted[7] = values[7] * 1.05
        truth = make_truth(24, values)
        flat, clustered = make_leaves(24, drifted, list(range(24)))
        verdict = grade_e12.build_verdict(truth, flat, clustered, 24, 100, 1e-6)
        gate0 = verdict["gate_0_rig_check"]
        self.assertFalse(gate0["pass"])
        self.assertEqual(sorted({m["tag"] for m in gate0["mismatches"]}), ["cand_s7"])

    def test_no_candidates_is_a_failure_not_a_pass(self):
        truth = make_truth(4, [1.0, 2.0, 3.0, 4.0])
        verdict = grade_e12.build_verdict(truth, {}, {}, 4, 100, 1e-6)
        self.assertFalse(verdict["gate_0_rig_check"]["pass"])


class TestGateOne(unittest.TestCase):
    def _verdict(self, clustered_hpwl, expected_n=24, diverged=()):
        values = [100.0 + i for i in range(24)]
        truth = make_truth(24, values)
        flat, clustered = make_leaves(24, values, clustered_hpwl, diverged)
        return grade_e12.build_verdict(truth, flat, clustered, expected_n, 200, 1e-6)

    def test_perfectly_ranking_clustered_score_is_above_the_interval(self):
        """rho = 1.0 is outside [0.48, 0.84], so it must not pass silently.

        The criterion is "indistinguishable from flat", not "at least as
        good as flat": a score that ranks the archive perfectly on n = 24
        is a signal to check for leakage, not to celebrate.
        """
        verdict = self._verdict(list(range(24)))
        gate1 = verdict["gate_1_e12"]
        self.assertAlmostEqual(gate1["rho"], 1.0)
        self.assertFalse(gate1["inside_flat_ci"])
        self.assertFalse(gate1["pass"])

    def test_score_inside_the_flat_interval_passes(self):
        """A rho inside the interval AND informative is a pass.

        This ordering was chosen to land where the real reference lands --
        rho 0.74, CI [0.49, 0.84] against the archive's 0.72 [0.48, 0.84]
        -- so the fixture exercises the gate at its actual operating
        point rather than at an artificial extreme.
        """
        order = [
            5,
            0,
            2,
            9,
            3,
            11,
            4,
            14,
            6,
            10,
            1,
            7,
            20,
            19,
            8,
            22,
            13,
            12,
            23,
            17,
            18,
            21,
            15,
            16,
        ]
        values = [100.0 + i for i in range(24)]
        truth = make_truth(24, values)
        flat, clustered = make_leaves(24, values, order)
        verdict = grade_e12.build_verdict(truth, flat, clustered, 24, 400, 1e-6)
        gate1 = verdict["gate_1_e12"]
        self.assertTrue(
            grade_e12.FLAT_CI[0] <= gate1["rho"] <= grade_e12.FLAT_CI[1],
            "fixture rho %.3f outside the interval it is meant to hit" % gate1["rho"],
        )
        self.assertTrue(gate1["ci_clear_of_zero"])
        self.assertEqual(gate1["verdict"], "pass")
        self.assertTrue(gate1["pass"])

    def test_uninformative_interval_is_inconclusive_not_pass(self):
        """The failure mode the four-candidate smoke run exposed.

        With a tiny population the bootstrap interval spans [-1, +1], so
        a rho can land inside the flat scorer's interval purely by
        accident. That is not a pass and it is not a failure -- nothing
        was measured -- so the gate must say so.
        """
        values = [100.0 + i for i in range(4)]
        truth = make_truth(4, values)
        flat, clustered = make_leaves(4, values, [0, 1, 3, 2])
        verdict = grade_e12.build_verdict(truth, flat, clustered, 4, 200, 1e-6)
        gate1 = verdict["gate_1_e12"]
        self.assertFalse(gate1["ci_clear_of_zero"])
        self.assertEqual(gate1["verdict"], "inconclusive")
        self.assertFalse(gate1["pass"])

    def test_informative_interval_can_still_pass(self):
        """A wide population with a real signal keeps passing."""
        verdict = self._verdict(list(range(24)))
        gate1 = verdict["gate_1_e12"]
        self.assertTrue(gate1["ci_clear_of_zero"])
        # rho = 1.0 is above the flat interval, so this is a fail rather
        # than inconclusive -- the point is that it is decided, not vague.
        self.assertEqual(gate1["verdict"], "fail")

    def test_inverted_score_fails(self):
        verdict = self._verdict(list(reversed(range(24))))
        self.assertLess(verdict["gate_1_e12"]["rho"], 0)
        self.assertFalse(verdict["gate_1_e12"]["pass"])

    def test_short_population_fails_even_with_good_rho(self):
        verdict = self._verdict(list(range(24)), expected_n=30)
        gate1 = verdict["gate_1_e12"]
        self.assertFalse(gate1["population_complete"])
        self.assertFalse(gate1["pass"])

    def test_missing_clustered_scores_fail_with_a_reason(self):
        values = [100.0 + i for i in range(24)]
        truth = make_truth(24, values)
        flat, _ = make_leaves(24, values, list(range(24)))
        verdict = grade_e12.build_verdict(truth, flat, {}, 24, 100, 1e-6)
        self.assertFalse(verdict["gate_1_e12"]["pass"])
        self.assertIn("reason", verdict["gate_1_e12"])

    def test_divergence_is_surfaced(self):
        verdict = self._verdict(list(range(24)), diverged=("cand_s3",))
        self.assertEqual(verdict["diverged"], ["cand_s3"])


class TestRemeasuredTruth(unittest.TestCase):
    """Truth measured here, rather than read from the archive."""

    def test_leaves_shape_like_the_archive(self):
        leaves = {
            "cand_s%d"
            % i: {
                "macro_paths_mean": 100.0 + i,
                "achieved": 1000.0 + i,
                "general_paths_mean": 900.0 + i,
                "stdcell_um2": 10000.0 + i,
            }
            for i in range(4)
        }
        truth = grade_e12.truth_from_leaves(leaves)
        self.assertEqual(sorted(truth["candidates"]), sorted(leaves))
        self.assertEqual(
            truth["candidates"]["cand_s0"]["grt"]["macro_paths_mean"], 100.0
        )

    def test_rig_check_is_vacuous_not_failing(self):
        """No archived score to reproduce, so gate 0 must not block."""
        leaves = {
            "cand_s%d"
            % i: {
                "macro_paths_mean": 100.0 + i,
                "achieved": 1000.0 + i,
                "general_paths_mean": 900.0 + i,
                "stdcell_um2": 10000.0 + i,
            }
            for i in range(4)
        }
        flat, clustered = make_leaves(4, [100.0 + i for i in range(4)], list(range(4)))
        verdict = grade_e12.build_verdict(
            grade_e12.truth_from_leaves(leaves), flat, clustered, 4, 100, 1e-6
        )
        gate0 = verdict["gate_0_rig_check"]
        self.assertTrue(gate0["pass"])
        self.assertIn("not_applicable", gate0)

    def test_empty_run_still_fails_the_rig_check(self):
        """The vacuous path must not swallow a run that produced nothing."""
        truth = make_truth(4, [1.0, 2.0, 3.0, 4.0])
        verdict = grade_e12.build_verdict(truth, {}, {}, 4, 100, 1e-6)
        self.assertFalse(verdict["gate_0_rig_check"]["pass"])


class TestLeafLoading(unittest.TestCase):
    def test_clustered_leaves_do_not_masquerade_as_flat(self):
        with tempfile.TemporaryDirectory() as tmp:
            for name, body in (
                ("cand_s0.json", {"tag": "cand_s0", "macro_mean": 1.0}),
                ("cand_s0.clustered.json", {"tag": "cand_s0", "hpwl_dbu": 2}),
            ):
                with open(os.path.join(tmp, name), "w", encoding="utf-8") as fp:
                    json.dump(body, fp)
            flat = grade_e12.load_leaves(
                tmp, ".json", exclude=(grade_e12.CLUSTERED_SUFFIX,)
            )
            clustered = grade_e12.load_leaves(tmp, grade_e12.CLUSTERED_SUFFIX)
            self.assertEqual(sorted(flat), ["cand_s0"])
            self.assertEqual(sorted(clustered), ["cand_s0"])


class TestCommittedArchive(unittest.TestCase):
    """The archive is the reference; guard the number it is referenced for."""

    def setUp(self):
        if not os.path.exists(ARCHIVE):
            self.skipTest("archive fixture not present")
        with open(ARCHIVE, encoding="utf-8") as handle:
            self.truth = json.load(handle)
        self.tags = sorted(self.truth["candidates"])

    def _rho(self, block, field, kpi):
        """rho and CI between a score column and a ground-truth KPI.

        `block` is the per-candidate sub-dict holding the score, or None
        when the score sits directly on the candidate record.
        """
        candidates = self.truth["candidates"]
        scores = [
            candidates[t][block][field] if block else candidates[t][field]
            for t in self.tags
        ]
        truth = [candidates[t]["grt"][kpi] for t in self.tags]
        low, high = spearman_ci(scores, truth)
        return spearman(scores, truth), low, high

    def test_population_is_the_published_24(self):
        self.assertEqual(len(self.truth["candidates"]), 24)

    def test_flat_scorer_reproduces_published_rho_and_interval(self):
        """rho(proxy wq25, grt macro_paths_mean) == +0.72 [0.48, 0.84].

        This exact pairing is the one the published figure reports, and
        grade_e12.FLAT_CI is its interval. Pinning it here is what stops
        the gate from being silently re-based on a different column --
        the archive holds several score columns, and a neighbouring one
        (proxy macro_mean) sits a full 0.09 higher.
        """
        rho, low, high = self._rho("proxy", "wq25", "macro_paths_mean")
        self.assertAlmostEqual(rho, 0.72, delta=0.005)
        self.assertAlmostEqual(low, grade_e12.FLAT_CI[0], delta=0.005)
        self.assertAlmostEqual(high, grade_e12.FLAT_CI[1], delta=0.005)

    def test_corroborating_published_numbers(self):
        """Three more published numbers off the same archive.

        If these reproduce alongside the reference, the archive and the
        statistics really are the ones the published figure was made
        with -- a far stronger check than any single correlation.
        """
        # The in-anneal objective, published at +0.57 [0.24, 0.79]: the
        # cost function ranks the truth materially worse than a measured
        # placement does, which is why selection is not left to it.
        rho, low, high = self._rho(None, "objective_fixed_norm", "macro_paths_mean")
        self.assertAlmostEqual(rho, 0.57, delta=0.01)
        self.assertAlmostEqual(low, 0.24, delta=0.01)
        self.assertAlmostEqual(high, 0.79, delta=0.01)

        # Score versus area, published at +0.65 (proxy) and +0.47
        # (objective): the fog flattens period by spending area.
        rho, _, _ = self._rho("proxy", "wq25", "stdcell_um2")
        self.assertAlmostEqual(rho, 0.65, delta=0.01)
        rho, _, _ = self._rho(None, "objective_fixed_norm", "stdcell_um2")
        self.assertAlmostEqual(rho, 0.47, delta=0.02)

    def test_period_column_is_interchangeable_with_the_reference(self):
        """The reference scalar is not a fragile choice of column.

        proxy `period` and proxy `wq25` differ by construction but rank
        the truth within 0.01 of each other on identical intervals, so
        the +0.72 reference is a property of the flat rung rather than of
        which of its two aggregates was tabulated.
        """
        ref_rho, ref_low, ref_high = self._rho("proxy", "wq25", "macro_paths_mean")
        alt_rho, alt_low, alt_high = self._rho("proxy", "period", "macro_paths_mean")
        self.assertAlmostEqual(alt_rho, ref_rho, delta=0.01)
        self.assertAlmostEqual(alt_low, ref_low, delta=0.01)
        self.assertAlmostEqual(alt_high, ref_high, delta=0.01)

    def test_macro_path_scalar_ranks_better_than_the_reference(self):
        """Load-bearing for reading the verdict, so pinned here.

        The reference is the conservative scalar. A clustered score
        landing at, say, +0.75 is inside the gate yet still below what
        the flat rung's best scalar achieves; the verdict table reports
        both columns so that distinction stays visible instead of being
        buried by a pass.
        """
        reference, _, _ = self._rho("proxy", "wq25", "macro_paths_mean")
        best, best_low, _ = self._rho("proxy", "macro_mean", "macro_paths_mean")
        self.assertGreater(best, reference)
        self.assertAlmostEqual(best, 0.82, delta=0.01)
        self.assertGreater(best_low, grade_e12.FLAT_CI[0])

    def test_period_at_this_utilization_is_placement_insensitive(self):
        """Why the gate rides on the macro-path KPI and not on period.

        At this utilization every candidate ties on achieved period --
        the whole population fits inside the design's own noise band --
        so a scorer graded on period would be graded on noise. The
        macro-path aggregate is the KPI that actually moves.
        """
        candidates = self.truth["candidates"]
        delta_tie = self.truth["delta_tie"]["achieved"]
        achieved = [candidates[t]["grt"]["achieved"] for t in self.tags]
        macro = [candidates[t]["grt"]["macro_paths_mean"] for t in self.tags]
        self.assertLess(max(achieved) - min(achieved), delta_tie)
        self.assertGreater(max(macro) - min(macro), delta_tie)


if __name__ == "__main__":
    unittest.main()
