"""The <COMMAND>_ARGS grammar: edits to the arguments ORFS passes to a command.

See docs/user/CommandArguments.md for the user's view. In short:

    -option value     set the value
    -flag             add the flag
    ~-option          delete the option, and its value if it has one
    on / off          run the command / do not run it
    stage:            in front of an edit: only in that stage
    stage.call:       in front of an edit: only at that call
    command:          in front of an edit: the command it is for; only in
                      PLATFORM_ARGS, where every edit names one
    {a b} or "a b"    a value with spaces in it, as in Tcl

Layers merge lowest first. For each option the highest layer that mentions
it decides; within a layer a call edit beats a stage edit, a stage edit
beats an unscoped one, and later beats earlier.

This file is Python and Starlark both: ORFS runs it as Python (args.py),
and a Bazel build load()s it to check the grammar at analysis and to give
each stage only its own edits. Keep it in the common subset: no while,
recursion, classes, exceptions, sets, f-strings or iteration over a string,
and nothing at the top level but assignments and defs. Errors go through
fail(), a Starlark builtin that args.py provides when it runs this file.
"""

# The commands a <COMMAND>_ARGS variable can edit, each read in the stages
# that run it. The variable's name is the command's in upper case.
COMMANDS = {
    "balance_row_usage": ["place"],
    "buffer_ports": ["place"],
    "clock_tree_synthesis": ["cts"],
    "cluster_flops": ["place"],
    "detailed_placement": ["place", "cts", "grt"],
    "detailed_route": ["route"],
    "global_placement": ["place"],
    "global_route": ["grt"],
    "improve_placement": ["place"],
    "place_pins": ["place"],
    "repair_antennas": ["grt", "route"],
    "repair_design": ["place", "grt"],
    "repair_tie_fanout": ["floorplan"],
    "repair_timing": ["floorplan", "place", "cts", "grt"],
    "report_metrics": ["synth", "floorplan", "place", "cts", "grt", "route", "final"],
    "rtl_macro_placer": ["floorplan"],
}

# The stages a scope can name, in flow order.
STAGES = ["synth", "floorplan", "place", "cts", "grt", "route", "final"]

def args_variable(command):
    return command.upper() + "_ARGS"

_IDENT_START ="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
_IDENT_REST = _IDENT_START + "0123456789"
_SPACE = " \t\n\r"

def _is_ident(s):
    if not s or s[0] not in _IDENT_START:
        return False
    for i in range(1, len(s)):
        if s[i] not in _IDENT_REST:
            return False
    return True

def _is_option(token):
    # -name, not -5 or -0.5: a negative number is a value.
    return len(token) > 1 and token[0] == "-" and _is_ident(token[1:])

_CLOSE = {"{": "}", "\"": "\""}

def _tokenize(name, text):
    """Splits on whitespace into (word, quoted) pairs.

    {...} or "..." around a value makes it one word, as in Tcl.
    """
    tokens = []
    current = ""
    braced = False
    close = ""
    for i in range(len(text)):
        c = text[i]
        if close:
            if c == close:
                close = ""
            elif c == "{" or (c == "\"" and close == "}"):
                fail("{}: '{}' inside a quoted value at character {}; a value is quoted once".format(name, c, i))
            else:
                current += c
        elif c in _CLOSE:
            if current:
                fail("{}: '{}' inside a word at character {}; quotes go around a whole value".format(name, c, i))
            close = _CLOSE[c]
            braced = True
        elif c == "}":
            fail("{}: '}}' with no '{{' before it, at character {}".format(name, i))
        elif c in _SPACE:
            if current or braced:
                tokens.append((current, braced))
            current = ""
            braced = False
        else:
            if braced:
                fail("{}: text right after a quoted value at character {}; put a space after it".format(name, i))
            current += c
    if close:
        fail("{}: '{}' is never closed".format(name, "{" if close == "}" else "\""))
    if current or braced:
        tokens.append((current, braced))
    return tokens

def _is_edit_word(word):
    return word in ("on", "off") or _is_option(word) or (word.startswith("~") and len(word) > 1)

def _split_scope(name, token, platform, stages):
    """Returns [command, stage, call, edit] for a scoped token, else None."""
    parts = token.split(":")
    if len(parts) == 1 or not _is_edit_word(parts[-1]):
        # No edit after the last colon, so no scope: a value such as a:b.
        return None
    edit = parts[-1]
    scopes = parts[:-1]
    command = ""
    if platform:
        if not _is_ident(scopes[0]) or scopes[0] in stages:
            fail("{}: '{}' must start with the command it is for, as in clock_tree_synthesis:{}".format(name, token, edit))
        command = scopes[0]
        scopes = scopes[1:]
    if len(scopes) > 1:
        fail("{}: '{}' has too many scopes; write {}stage:edit or {}stage.call:edit".format(
            name,
            token,
            "command:" if platform else "",
            "command:" if platform else "",
        ))
    stage = ""
    call = ""
    if scopes:
        where = scopes[0].split(".")
        if len(where) > 2:
            fail("{}: '{}': a scope is a stage or stage.call".format(name, token))
        stage = where[0]
        if stage not in stages:
            fail("{}: '{}': '{}' is not a stage ({}){}".format(
                name,
                token,
                stage,
                ", ".join(stages),
                "" if platform else "; only PLATFORM_ARGS names a command",
            ))
        if len(where) == 2:
            call = where[1]
            if not _is_ident(call):
                fail("{}: '{}': '{}' is not a call name".format(name, token, call))
    return [command, stage, call, edit]

def parse_args(name, text, stages, platform = False):
    """Parses a variable's value into a list of edits.

    Args:
      name: the variable's name, for error messages.
      text: the variable's value.
      stages: the stage names a scope may use.
      platform: True for PLATFORM_ARGS, where every edit names its command.

    Returns:
      A list of dicts with keys command, stage, call, op ("set", "flag",
      "delete", "on" or "off"), option and value. Fails on a syntax error.
    """
    edits = []
    pending = None
    for token, braced in _tokenize(name, text):
        scoped = None
        if not braced:
            scoped = _split_scope(name, token, platform, stages)
        if scoped != None:
            command, stage, call, word = scoped
        else:
            command, stage, call, word = "", "", "", token
        if braced or (scoped == None and not _is_edit_word(word)):
            if pending == None:
                fail("{}: '{}' is a value with no option before it; a value with spaces goes in braces".format(name, token))
            pending["op"] = "set"
            pending["value"] = token
            pending = None
            continue
        if platform and not command:
            fail("{}: '{}' must start with the command it is for, as in clock_tree_synthesis:{}".format(name, token, token))
        pending = None
        e = {"command": command, "stage": stage, "call": call, "op": "", "option": "", "value": None}
        if word in ("on", "off"):
            e["op"] = word
        elif word.startswith("~"):
            if not _is_option(word[1:]):
                fail("{}: '{}': '~' deletes an option, as in ~-repair_clock_nets".format(name, token))
            e["op"] = "delete"
            e["option"] = word[1:]
        else:
            e["op"] = "flag"
            e["option"] = word
            pending = e
        edits.append(e)
    return edits

def quote_value(value):
    """A value as the grammar writes it, in braces when it needs them."""
    if value == "" or value in ("on", "off") or value.startswith("~") or _is_option(value) or ":" in value:
        return "{" + value + "}"
    for i in range(len(value)):
        if value[i] in _SPACE or value[i] in "{}":
            return "{" + value + "}"
    return value

def format_args(edits, platform = False):
    """Writes edits back in the grammar: the inverse of parse_args()."""
    words = []
    for e in edits:
        prefix = ""
        if platform:
            prefix = e["command"] + ":"
        if e["stage"]:
            prefix += e["stage"]
            if e["call"]:
                prefix += "." + e["call"]
            prefix += ":"
        if e["op"] in ("on", "off"):
            words.append(prefix + e["op"])
        elif e["op"] == "delete":
            words.append(prefix + "~" + e["option"])
        else:
            words.append(prefix + e["option"])
            if e["op"] == "set":
                words.append(quote_value(e["value"]))
    return " ".join(words)

def stage_args(name, text, stage, stages, platform = False):
    """The part of a variable's value that can matter in one stage.

    An unscoped edit matters in every stage, a scoped one only in its own,
    so a build that keys each stage on its inputs can give each stage this
    and leave the other stages' keys alone.
    """
    if stage not in stages:
        fail("{}: '{}' is not a stage ({})".format(name, stage, ", ".join(stages)))
    edits = parse_args(name, text, stages, platform)
    return format_args([e for e in edits if e["stage"] in ("", stage)], platform)

def args_layer(words):
    """A list of words, as a command line takes them, as a layer of edits."""
    edits = []
    pending = None
    for w in words:
        if pending != None and not _is_option(w):
            pending["op"] = "set"
            pending["value"] = w
            pending = None
            continue
        if not _is_option(w):
            fail("'{}' is a value with no option before it in {}".format(w, " ".join(words)))
        e = {"command": "", "stage": "", "call": "", "op": "flag", "option": w, "value": None}
        edits.append(e)
        pending = e
    return edits

def _specificity(e):
    if e["call"]:
        return 2
    if e["stage"]:
        return 1
    return 0

def resolve(layers, command, stage, call, run = True):
    """Merges layers of edits into what one call of a command gets.

    Args:
      layers: a list of [name, edits] pairs, lowest priority first, with
        edits as parse_args() or args_layer() returns them. An edit that
        names a command applies only to that command.
      command: the command being called.
      stage: the stage it is called in.
      call: the call's name within the stage.
      run: whether the command runs when no layer says on or off.

    Returns:
      A dict: "run", a bool; "args", the words to pass, in the order the
      options were first set; "changes", a list of [layer, edit] for each
      edit that changed what the layers below it gave.
    """
    values = {}
    kinds = {}
    order = []
    changes = []
    for layer in layers:
        layer_name = layer[0]
        edits = layer[1]
        applicable = []
        for i in range(len(edits)):
            e = edits[i]
            if e["command"] and e["command"] != command:
                continue
            if e["stage"] and e["stage"] != stage:
                continue
            if e["call"] and e["call"] != call:
                continue
            applicable.append([_specificity(e), i, e])
        for _, _, e in sorted(applicable, key = lambda t: (t[0], t[1])):
            op = e["op"]
            if op in ("on", "off"):
                if run != (op == "on"):
                    changes.append([layer_name, e])
                run = op == "on"
                continue
            option = e["option"]
            if op == "delete":
                if option in values:
                    changes.append([layer_name, e])
                    values.pop(option)
                    order.remove(option)
                continue
            kind = "flag" if op == "flag" else "value"
            if option in kinds and kinds[option] != kind:
                fail("{}: {} {} {} here, and {} below".format(
                    layer_name,
                    command,
                    option,
                    "takes no value" if kind == "flag" else "takes a value",
                    "a value" if kind == "flag" else "no value",
                ))
            kinds[option] = kind
            if option not in values:
                order.append(option)
            elif values[option] == e["value"]:
                continue
            changes.append([layer_name, e])
            values[option] = e["value"]
    words = []
    for option in order:
        words.append(option)
        if values[option] != None:
            words.append(values[option])
    return {"run": run, "args": words, "changes": changes}
