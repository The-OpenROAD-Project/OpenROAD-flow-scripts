#!/usr/bin/env python3
"""Unit tests for command arguments: scripts/args.py and args_grammar.bzl."""

import os
import sys
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "scripts"))

import args  # noqa: E402

G = args.G
STAGES = G["STAGES"]


def parse(text, platform=False):
    return G["parse_args"]("X_ARGS", text, STAGES, platform)


def fmt(text, platform=False):
    return G["format_args"](parse(text, platform), platform)


def run(env, command="repair_timing", stage="grt", call="main", flow=(), dep=()):
    return args.resolve(env, command, stage, call, True, list(flow), list(dep))


class Parse(unittest.TestCase):
    def test_set_flag_delete(self):
        e = parse("-a 1 -b ~-c")
        self.assertEqual(
            [(x["op"], x["option"], x["value"]) for x in e],
            [("set", "-a", "1"), ("flag", "-b", None), ("delete", "-c", None)],
        )

    def test_negative_number_is_a_value(self):
        self.assertEqual(parse("-margin -0.5")[0]["value"], "-0.5")

    def test_quoted_values(self):
        self.assertEqual(parse("-a {20 20}")[0]["value"], "20 20")
        self.assertEqual(parse('-a "x y"')[0]["value"], "x y")
        self.assertEqual(parse("-a {}")[0]["value"], "")

    def test_on_off_and_scopes(self):
        e = parse("off cts:on grt.wns:-x 1 floorplan:~-y")
        self.assertEqual(
            [(x["op"], x["stage"], x["call"]) for x in e],
            [("off", "", ""), ("on", "cts", ""), ("set", "grt", "wns")]
            + [("delete", "floorplan", "")],
        )

    def test_colon_in_a_value_is_no_scope(self):
        self.assertEqual(parse("-file a:b")[0]["value"], "a:b")

    def test_platform_names_the_command(self):
        e = parse("rtl_macro_placer:-halo_width 5 repair_timing:grt:off", True)
        self.assertEqual(
            [(x["command"], x["stage"], x["op"]) for x in e],
            [("rtl_macro_placer", "", "set"), ("repair_timing", "grt", "off")],
        )

    def test_round_trip(self):
        for text in [
            "-a 1 -b ~-c on cts:off grt.wns:-x {1 2}",
            "-file {a:b} -name {-x} -v {on}",
        ]:
            self.assertEqual(fmt(fmt(text)), fmt(text))
            self.assertEqual(parse(fmt(text)), parse(text))
        text = "repair_timing:grt:-x 1 clock_tree_synthesis:~-y"
        self.assertEqual(parse(fmt(text, True), True), parse(text, True))


class SyntaxErrors(unittest.TestCase):
    def check(self, text, message, platform=False):
        with self.assertRaises(args.ArgsError) as cm:
            parse(text, platform)
        self.assertIn(message, str(cm.exception))

    def test_value_without_option(self):
        self.check("30", "value with no option")
        self.check("-a 1 2", "'2' is a value with no option")

    def test_quotes(self):
        self.check("-a {1", "never closed")
        self.check("-a 1}", "with no '{'")
        self.check("-a {{1}}", "quoted once")
        self.check("-a x{1}", "inside a word")
        self.check("-a {1}x", "right after a quoted value")

    def test_scopes(self):
        self.check("plce:-a 1", "'plce' is not a stage")
        self.check("grt.a.b:-x", "a stage or stage.call")
        self.check("cts:grt:-x", "too many scopes")
        self.check("~x", "'~' deletes an option")

    def test_platform(self):
        self.check("-x 1", "must start with the command", True)
        self.check("cts:-x 1", "must start with the command", True)


class StageArgs(unittest.TestCase):
    def test_only_this_stage(self):
        text = "-a 1 cts:-b 2 grt.wns:off"
        self.assertEqual(G["stage_args"]("X", text, "cts", STAGES), "-a 1 cts:-b 2")
        self.assertEqual(G["stage_args"]("X", text, "grt", STAGES), "-a 1 grt.wns:off")
        self.assertEqual(G["stage_args"]("X", text, "place", STAGES), "-a 1")


class Resolve(unittest.TestCase):
    def test_nothing_set_gives_the_flow_unchanged(self):
        flow = ["-setup_margin", "0.1", "-setup", "-sequence", "a,b", "-skip_last_gasp"]
        self.assertEqual(
            run({}, flow=flow, dep=["-setup_margin", "0.1"]), [True, flow, []]
        )

    def test_override_in_place_add_and_delete(self):
        env = {"REPAIR_TIMING_ARGS": "-sequence vt_swap -hold ~-skip_last_gasp"}
        r = run(env, flow=["-setup", "-sequence", "a", "-skip_last_gasp"])
        self.assertEqual(r[1], ["-setup", "-sequence", "vt_swap", "-hold"])

    def test_deleting_an_option_not_passed_is_no_error(self):
        self.assertEqual(
            run({"REPAIR_TIMING_ARGS": "~-hold"}, flow=["-setup"])[1], ["-setup"]
        )

    def test_layers_highest_wins(self):
        env = {
            "PLATFORM_ARGS": "repair_timing:-x 2 repair_timing:-y 2",
            "REPAIR_TIMING_ARGS": "-y 3",
        }
        r = run(env, flow=["-x", "0"])
        self.assertEqual(r[1], ["-x", "2", "-y", "3"])

    def test_deprecated_beats_platform(self):
        env = {"PLATFORM_ARGS": "repair_timing:-x 2"}
        self.assertEqual(run(env, flow=["-x", "1"], dep=["-x", "1"])[1], ["-x", "1"])
        self.assertEqual(run(env, flow=["-x", "0"])[1], ["-x", "2"])

    def test_flow_passing_an_option_again_beats_the_deprecated_one(self):
        flow = ["-sequence", "a", "-setup", "-sequence", "b"]
        self.assertEqual(
            run({}, flow=flow, dep=["-sequence", "a"])[1], ["-sequence", "b", "-setup"]
        )
        env = {"PLATFORM_ARGS": "repair_timing:-sequence c"}
        self.assertEqual(
            run(env, flow=flow, dep=["-sequence", "a"])[1], ["-sequence", "c", "-setup"]
        )

    def test_specificity_within_a_layer(self):
        env = {"REPAIR_TIMING_ARGS": "grt.main:-x 3 grt:-x 2 -x 1"}
        self.assertEqual(run(env)[1], ["-x", "3"])
        self.assertEqual(run(env, call="wns")[1], ["-x", "2"])
        self.assertEqual(run(env, stage="cts")[1], ["-x", "1"])

    def test_a_higher_layer_beats_a_more_specific_lower_one(self):
        env = {
            "PLATFORM_ARGS": "repair_timing:grt.main:-x 1",
            "REPAIR_TIMING_ARGS": "-x 2",
        }
        self.assertEqual(run(env)[1], ["-x", "2"])

    def test_on_off(self):
        env = {"REPAIR_TIMING_ARGS": "off cts:on"}
        self.assertFalse(run(env)[0])
        self.assertTrue(run(env, stage="cts")[0])
        self.assertFalse(
            args.resolve({}, "report_metrics", "cts", "x", False, [], [])[0]
        )

    def test_platform_edit_for_another_command_is_ignored(self):
        env = {"PLATFORM_ARGS": "clock_tree_synthesis:-x 1"}
        self.assertEqual(run(env)[1], [])

    def test_flag_and_value_conflict(self):
        with self.assertRaises(args.ArgsError) as cm:
            run({"REPAIR_TIMING_ARGS": "-x"}, flow=["-x", "1"])
        self.assertIn("takes no value here", str(cm.exception))

    def test_no_note_for_an_edit_that_changes_nothing(self):
        self.assertEqual(
            run({"REPAIR_TIMING_ARGS": "-x 1 on"}, flow=["-x", "1"])[2], []
        )

    def test_no_note_for_a_variable_at_its_default(self):
        env = {"GLOBAL_ROUTE_ARGS": "-verbose"}
        r = args.resolve(
            env,
            "global_route",
            "grt",
            "main",
            True,
            [],
            [],
            None,
            {"GLOBAL_ROUTE_ARGS": "-verbose"},
        )
        self.assertEqual(r[1:], [["-verbose"], []])

    def test_notes_name_the_call_and_layer(self):
        notes = run({"REPAIR_TIMING_ARGS": "-x 1"})[2]
        self.assertEqual(notes, ["[grt.main] repair_timing: -x 1 (REPAIR_TIMING_ARGS)"])


class Legacy(unittest.TestCase):
    FIXED = ["-output_drc", "drc.rpt"]
    FLOW = FIXED + ["-verbose", "1", "-drc_report_iter_step", "5"]

    def resolve(self, value):
        env = {"DETAILED_ROUTE_ARGS": value}
        return args.resolve(
            env,
            "detailed_route",
            "route",
            "main",
            True,
            self.FLOW,
            [],
            "DETAILED_ROUTE_ARGS:2",
        )

    def test_a_command_line_that_reads_the_same_either_way(self):
        r = self.resolve("-verbose 1 -drc_report_iter_step 5 -droute_end_iter 3")
        self.assertEqual(r[1], self.FLOW + ["-droute_end_iter", "3"])
        self.assertEqual(
            r[2],
            ["[route.main] detailed_route: -droute_end_iter 3 (DETAILED_ROUTE_ARGS)"],
        )

    def test_a_command_line_still_replaces(self):
        r = self.resolve("-droute_end_iter 3")
        self.assertEqual(r[1], self.FIXED + ["-droute_end_iter", "3"])
        self.assertIn("add ~-verbose ~-drc_report_iter_step", r[2][0])

    def test_edits_edit(self):
        r = self.resolve("~-verbose")
        self.assertEqual(r[1], self.FIXED + ["-drc_report_iter_step", "5"])

    def test_tcl_split(self):
        self.assertEqual(
            args.tcl_split(' -a {b c} "d e"  f '), ["-a", "b c", "d e", "f"]
        )
        self.assertEqual(args.tcl_split("-a {b {c}}"), ["-a", "b {c}"])


class Check(unittest.TestCase):
    VARS = {
        "CTS_CLUSTER_SIZE": {
            "deprecated": 1,
            "stages": ["cts"],
            "replacement": "CLOCK_TREE_SYNTHESIS_ARGS = -sink_clustering_size {value}",
        },
        "SKIP_CTS_REPAIR_TIMING": {
            "deprecated": 1,
            "default": 0,
            "stages": ["cts"],
            "replacement": {"1": "REPAIR_TIMING_ARGS = cts:off"},
        },
        "RTLMP_MIN_CHANNEL_SIZE": {
            "deprecated": 1,
            "stages": ["floorplan"],
            "replacement": "RTL_MACRO_PLACER_ARGS = -min_channel_size {value}",
        },
    }

    def test_a_value_with_spaces_is_braced(self):
        self.assertEqual(
            args.check({"RTLMP_MIN_CHANNEL_SIZE": "20 20"}, "floorplan", self.VARS),
            [
                "RTLMP_MIN_CHANNEL_SIZE=20 20 is deprecated: write "
                "RTL_MACRO_PLACER_ARGS = -min_channel_size {20 20}"
            ],
        )

    def test_warns_only_when_set_in_its_stage_and_not_default(self):
        env = {"CTS_CLUSTER_SIZE": "30", "SKIP_CTS_REPAIR_TIMING": "0"}
        self.assertEqual(
            args.check(env, "cts", self.VARS),
            [
                "CTS_CLUSTER_SIZE=30 is deprecated: write "
                "CLOCK_TREE_SYNTHESIS_ARGS = -sink_clustering_size 30"
            ],
        )
        self.assertEqual(args.check(env, "grt", self.VARS), [])
        env["SKIP_CTS_REPAIR_TIMING"] = "1"
        self.assertEqual(len(args.check(env, "cts", self.VARS)), 2)

    def test_syntax_error_in_any_command(self):
        with self.assertRaises(args.ArgsError):
            args.check({"CLOCK_TREE_SYNTHESIS_ARGS": "-a {"}, "synth", {})

    def test_platform_args_unknown_command(self):
        with self.assertRaises(args.ArgsError) as cm:
            args.check({"PLATFORM_ARGS": "nope:-x 1"}, "synth", {})
        self.assertIn("'nope' is not a command", str(cm.exception))


class VariablesYaml(unittest.TestCase):
    """variables.json, generated from variables.yaml, agrees with the code."""

    @classmethod
    def setUpClass(cls):
        import json

        with open(os.path.join(args.DIR, "variables.json")) as f:
            cls.variables = json.load(f)

    def test_every_command_has_its_variable_and_stages(self):
        for command, stages in G["COMMANDS"].items():
            meta = self.variables[G["args_variable"](command)]
            self.assertEqual(sorted(meta["stages"]), sorted(stages), command)

    def test_every_replacement_parses(self):
        names = {G["args_variable"](c) for c in G["COMMANDS"]}
        for name, meta in self.variables.items():
            if not meta.get("deprecated") or "replacement" not in meta:
                continue
            replacement = meta["replacement"]
            texts = (
                replacement.values() if isinstance(replacement, dict) else [replacement]
            )
            for text in texts:
                variable, _, value = text.partition(" = ")
                variable = variable.split(",")[0]
                self.assertIn(variable, names, name)
                if value:
                    # A bare {value} is a whole command line: the old variable's.
                    parse(value.format(value="-x 1" if value == "{value}" else "1"))


class StarlarkSubset(unittest.TestCase):
    """args_grammar.bzl stays in the subset of Python that is also Starlark.

    ORFS has no Bazel, so this is the check that a change to the grammar
    still loads in a Bazel build. It rejects the constructs Starlark lacks;
    a Bazel build that load()s the file is the final word.
    """

    BANNED = {
        "While": "while loops",
        "Try": "exceptions",
        "Raise": "exceptions",
        "ClassDef": "classes",
        "JoinedStr": "f-strings",
        "Set": "sets",
        "SetComp": "sets",
        "Yield": "generators",
        "YieldFrom": "generators",
        "GeneratorExp": "generators",
        "Global": "global",
        "Nonlocal": "nonlocal",
        "Import": "import",
        "ImportFrom": "import",
        "With": "with",
        "AsyncFunctionDef": "async",
        "Await": "async",
        "Starred": "star expressions outside calls",
        "Is": "is / is not",
        "IsNot": "is / is not",
    }

    def test_only_the_common_subset(self):
        import ast

        path = os.path.join(args.DIR, "args_grammar.bzl")
        tree = ast.parse(open(path).read())
        for node in tree.body:
            ok = isinstance(node, (ast.FunctionDef, ast.Assign)) or (
                isinstance(node, ast.Expr) and isinstance(node.value, ast.Constant)
            )
            self.assertTrue(
                ok,
                "line {}: only defs and assignments at the top level".format(
                    node.lineno
                ),
            )
        defs = {n.name for n in tree.body if isinstance(n, ast.FunctionDef)}
        for node in ast.walk(tree):
            name = type(node).__name__
            if name in self.BANNED:
                self.fail(
                    "line {}: {} is not Starlark".format(
                        getattr(node, "lineno", "?"), self.BANNED[name]
                    )
                )
            if isinstance(node, ast.FunctionDef):
                calls = {
                    c.func.id
                    for c in ast.walk(node)
                    if isinstance(c, ast.Call) and isinstance(c.func, ast.Name)
                }
                if node.name in calls:
                    self.fail("{} recurses; Starlark doesn't".format(node.name))
            if isinstance(node, (ast.For, ast.comprehension)) and isinstance(
                node.iter, ast.Name
            ):
                # Starlark can't iterate a string; the grammar indexes them instead.
                self.assertNotIn(
                    node.iter.id,
                    ("text", "s", "token", "value", "word"),
                    "line {}: iterating a string".format(node.iter.lineno),
                )
        self.assertTrue(defs)


class Main(unittest.TestCase):
    def capture(self, argv, env):
        import contextlib
        import io

        out, err = io.StringIO(), io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
            args.main(argv, env)
        return out.getvalue().splitlines(), err.getvalue().splitlines()

    def test_resolve_names_the_call(self):
        out, err = self.capture(
            ["resolve", "repair_timing", "grt.wns", "1", "0", "0"], {}
        )
        self.assertEqual((out, err), (["1"], ["[grt.wns] repair_timing"]))

    def test_runs(self):
        env = {"REPORT_METRICS_ARGS": "grt:off"}
        self.assertEqual(
            self.capture(["runs", "report_metrics", "grt.x", "1"], env)[0], ["0"]
        )
        self.assertEqual(
            self.capture(["runs", "report_metrics", "cts.x", "1"], env), (["1"], [])
        )

    def test_resolve_protocol(self):
        out = []
        old = sys.stdout
        try:
            import io

            sys.stdout = io.StringIO()
            args.main(
                ["resolve", "repair_timing", "cts.main", "1", "2", "-a", "b c", "0"],
                {"REPAIR_TIMING_ARGS": "cts:-d"},
            )
            out = sys.stdout.getvalue().splitlines()
        finally:
            sys.stdout = old
        self.assertEqual(out, ["1", "-a", "b c", "-d"])


if __name__ == "__main__":
    unittest.main()
