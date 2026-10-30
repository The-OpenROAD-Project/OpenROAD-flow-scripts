#!/usr/bin/env python3
"""Command arguments for the stage scripts: docs/user/CommandArguments.md.

The stage scripts call this with $PYTHON_EXE, so that the handling of
arguments is in Python with unit tests (flow/test/test_args.py) instead of
in Tcl. The grammar itself is in args_grammar.bzl, which a Bazel build
load()s too.

    args.py check STAGE
        Checks every <COMMAND>_ARGS and PLATFORM_ARGS, and warns about each
        deprecated variable STAGE reads that is set. Run before a stage
        erases its non-stage variables.

    args.py runs COMMAND CALL RUN
        Prints 1 or 0: whether the call runs. RUN is the flow's choice.

    args.py resolve COMMAND CALL RUN N FLOW... M DEPRECATED... [LEGACY]
        Prints 1 or 0, whether the call runs, then the arguments it gets,
        one per line, and names the call in the log. CALL is stage.name. FLOW is the command line the flow
        passes when no <COMMAND>_ARGS is set, deprecated variables included,
        DEPRECATED the part of it that deprecated variables add: they rank
        above PLATFORM_ARGS. LEGACY names a variable that replaces the
        flow's arguments when it holds a plain command line; LEGACY:N keeps
        the first N words of FLOW.
"""

import json
import os
import sys

DIR = os.path.dirname(os.path.realpath(__file__))


class ArgsError(Exception):
    pass


def _fail(msg):
    raise ArgsError(msg)


def load_grammar():
    """args_grammar.bzl as a Python module, with Starlark's fail()."""
    scope = {"fail": _fail}
    with open(os.path.join(DIR, "args_grammar.bzl")) as f:
        exec(compile(f.read(), "args_grammar.bzl", "exec"), scope)
    return scope


G = load_grammar()


def tcl_split(text):
    """Splits a value the way Tcl's {*} splits a list."""
    words = []
    i = 0
    n = len(text)
    while i < n:
        while i < n and text[i].isspace():
            i += 1
        if i >= n:
            break
        if text[i] == "{":
            depth = 1
            j = i + 1
            while j < n and depth:
                if text[j] == "{":
                    depth += 1
                elif text[j] == "}":
                    depth -= 1
                j += 1
            if depth:
                raise ArgsError("unbalanced '{' in: " + text)
            words.append(text[i + 1 : j - 1])
            i = j
        elif text[i] == '"':
            j = text.find('"', i + 1)
            if j < 0:
                raise ArgsError("unbalanced '\"' in: " + text)
            words.append(text[i + 1 : j])
            i = j + 1
        else:
            j = i
            while j < n and not text[j].isspace():
                j += 1
            words.append(text[i:j])
            i = j
    return words


def edits_of(env, name, platform=False):
    return G["parse_args"](name, env.get(name, ""), G["STAGES"], platform)


def is_command_line(edits):
    """True when a value uses nothing a plain command line can't say."""
    return all(e["op"] in ("set", "flag") and not e["stage"] for e in edits)


def check(env, stage, variables):
    """Returns warnings; raises ArgsError on the first syntax error."""
    for command in sorted(G["COMMANDS"]):
        edits_of(env, G["args_variable"](command))
    for e in edits_of(env, "PLATFORM_ARGS", platform=True):
        if e["command"] not in G["COMMANDS"]:
            raise ArgsError(
                "PLATFORM_ARGS: '{}' is not a command with arguments here ({})".format(
                    e["command"], ", ".join(sorted(G["COMMANDS"]))
                )
            )
    warnings = []
    for name in sorted(variables):
        meta = variables[name]
        if not meta.get("deprecated") or name not in env or env[name] == "":
            continue
        if str(meta.get("default", "")) == env[name]:
            continue
        stages = meta.get("stages", [])
        if stages and "All stages" not in stages and stage not in stages:
            continue
        replacement = meta["replacement"]
        if isinstance(replacement, dict):
            if env[name] not in replacement:
                continue
            replacement = replacement[env[name]]
        else:
            replacement = replacement.format(value=G["quote_value"](env[name]))
        warnings.append(
            "{}={} is deprecated: write {}".format(name, env[name], replacement)
        )
    return warnings


def resolve(env, command, stage, call, run, flow, deprecated, legacy=None, defaults={}):
    """What one call of a command gets: [run, args, notes].

    defaults are the variables.yaml defaults: a <COMMAND>_ARGS at its
    default is the flow's own choice, and its edits get no note.
    """
    variable = G["args_variable"](command)
    flow_edits = G["args_layer"](flow)
    # A deprecated variable's option ranks above PLATFORM_ARGS where it
    # survives in the flow's command line, as it does today; where the flow
    # passes the option again after it, the flow's value wins, as today.
    passed = G["resolve"]([["", flow_edits]], command, stage, call, True)["args"]
    survives = dict(zip(passed, passed[1:] + [None]))
    deprecated = [
        e
        for e in G["args_layer"](deprecated)
        if e["option"] in survives
        and (e["value"] is None or survives[e["option"]] == e["value"])
    ]
    layers = [
        ["the flow", flow_edits],
        ["PLATFORM_ARGS", edits_of(env, "PLATFORM_ARGS", platform=True)],
        ["deprecated variables", deprecated],
        [variable, edits_of(env, variable)],
    ]
    r = G["resolve"](layers, command, stage, call, run)
    notes = [
        "[{}.{}] {}: {} ({})".format(stage, call, command, G["format_args"]([e]), layer)
        for layer, e in r["changes"]
        if layer == "PLATFORM_ARGS"
        or (layer == variable and env.get(variable) != defaults.get(variable))
    ]
    legacy, _, fixed = (legacy or "").partition(":")
    if legacy and env.get(legacy) and is_command_line(layers[3][1]):
        old = flow[: int(fixed or 0)] + tcl_split(env[legacy])
        if old != r["args"]:
            gone = [w for w in r["args"] if w.startswith("-") and w not in old]
            notes = [
                "{} replaces the flow's arguments to {}; it will edit them"
                " instead, so to keep this command line add {}".format(
                    legacy, command, " ".join("~" + w for w in gone)
                )
            ]
            return [r["run"], old, notes]
    return [r["run"], r["args"], notes]


def _counted(argv):
    n = int(argv[0])
    return argv[1 : 1 + n], argv[1 + n :]


def main(argv, env):
    with open(os.path.join(DIR, "variables.json")) as f:
        variables = json.load(f)
    if argv[:1] == ["check"] and len(argv) == 2:
        for w in check(env, argv[1], variables):
            print("[WARNING] " + w, file=sys.stderr)
        return 0
    if argv[:1] == ["resolve"] and len(argv) >= 6:
        command, where, run = argv[1:4]
        stage, _, call = where.partition(".")
        flow, rest = _counted(argv[4:])
        deprecated, rest = _counted(rest)
        legacy = rest[0] if rest else None
        defaults = {
            k: str(v["default"]) for k, v in variables.items() if "default" in v
        }
        run, args, notes = resolve(
            env, command, stage, call, run == "1", flow, deprecated, legacy, defaults
        )
        # The call's name goes in the log in front of the command, so a user
        # can copy it into a scope.
        for note in notes or ["[{}] {}".format(where, command)]:
            print(note, file=sys.stderr)
        print("1" if run else "0")
        for w in args:
            print(w)
        return 0
    if argv[:1] == ["runs"] and len(argv) == 4:
        command, where, run = argv[1:4]
        stage, _, call = where.partition(".")
        run, _, notes = resolve(env, command, stage, call, run == "1", [], [])
        for note in notes:
            print(note, file=sys.stderr)
        print("1" if run else "0")
        return 0
    print(__doc__, file=sys.stderr)
    return 2


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:], os.environ))
    except ArgsError as e:
        print("[ERROR] " + str(e), file=sys.stderr)
        sys.exit(1)
