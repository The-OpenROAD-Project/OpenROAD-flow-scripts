# Tcl Contract

The stage scripts in `flow/scripts/*.tcl` are short, and they are read more
than they are written: a user who wants to know what a stage does, or which
knob to turn, reads its script. ORFS keeps them consistent with each other so
that knowing one script is most of the way to knowing the next. Over time a
set of idioms has grown up for doing that, and most of them were never
written down.

This page writes them down as rules a change to `flow/scripts/*.tcl` is
written and reviewed against. It is written for AI authoring and automated
review: an agent that changes a stage script, or reviews such a change,
checks it against every rule here, and against the rules for steps and
variables in the [Makefile Contract](./MakefileContract.md), which apply to
the stage scripts too and are not repeated here. A contributor whose agent
follows both pages writes code that reads like the code around it, and gets
through review without a maintainer having to restate them.

The rules are hard stops: a change that breaks one is wrong, whatever else it
fixes. Each rule says what breaks when it is broken. Any place where the
existing code disagrees with a rule is technical debt, whether an expedient
solution or older code written before the rule: debt to fix, not a precedent
to follow.

## Idiom

- **A script never writes its own version of an idiom `util.tcl` already
  has.** An optional flag is added with `append_env_var`, a command that does
  real work runs through `log_cmd`, a result is written with `orfs_write_db`
  and `orfs_write_sdc`. An idiom a change needs in two places becomes a proc
  in `util.tcl`.
  *Breaks:* each copy grows its own small bug, and nobody can grep for the
  places that do the same thing.
- **A command's arguments are never hidden from the log.** They are built in
  a list and run through `log_cmd`, so the log shows the full command line.
  A `<STEP>_ARGS` variable replaces the arguments the flow would pass, so a
  user can copy the line from the log into `config.mk` and edit it.
  *Breaks:* a user cannot see what a step ran with, or reproduce it.
- **A proc never takes its input from a global or the caller's scope.** It
  takes it as an argument and returns its result. State that must last
  across steps is in the `.odb`.
  *Breaks:* a reader cannot tell what a proc depends on, and the result
  changes with the order scripts are `source`d in.
- **A script never repeats an OpenROAD default.** It passes an option only
  when ORFS wants a value other than the tool's.
  *Breaks:* a change to the default in OpenROAD has no effect in ORFS, and
  the two drift apart.
- **A script never trades an explicit variable for a clever one.** A flag
  that means one thing (`has_clock`) stays a flag; an empty string or a
  sentinel value never stands in for it.
  *Breaks:* the reader has to work out what the special value means.
- **Tcl is never written with tabs, quotes or braces it does not need, or
  `[...]` around an `expr` condition.** `lappend` takes several values at
  once. `tclint` and `tclfmt` (`tclint.toml`) check the rest in CI.
  *Breaks:* the CI lint, and a reader who stops to work out why the extra
  syntax is there.

## Failure

- **A script never guards a read the flow guarantees.** A variable with a
  default in `flow/scripts/variables.yaml` is always set, and an input file
  the step declares is always there: no `file exists` before reading it, no
  `env_var_exists_and_non_empty` or `env_var_or_empty` fallback for it. The
  read fails, loudly, at the line that does it.
  *Breaks:* the guard is a code path no CI run exercises, and a missing
  variable or file shows up later, somewhere else, as a wrong result.
- **A failing step never writes the file a successful step writes.** It
  writes `<step>-failed.odb` and calls `error`, as
  `flow/scripts/global_place.tcl` does.
  *Breaks:* make, and any flow built on it, takes the file as proof that the
  step succeeded.
- **A script never adds error numbers or checks that belong in OpenROAD.**
  OpenROAD allocates error numbers; ORFS reports with `error`. A check on
  what a tool did belongs in the tool.
  *Breaks:* numbers that collide with OpenROAD's, and a check that only one
  flow runs.

## Interface

- **A result file's name and format never change as a side effect.** The
  names under `RESULTS_DIR` and the format of what is written there are part
  of ORFS's interface to users and other flows; a change to one is its own
  pull request, called out as breaking.
  *Breaks:* every flow and script that reads the old name.
- **`open.tcl` never writes a file.** Opening a stage, in the GUI or on the
  console, only reads. A variable such as `GUI_TIMING` means the same thing
  in both.
  *Breaks:* looking at a result changes the tree it is in.
- **A refactor or cleanup never changes behavior.** A change in what a step
  does is its own pull request, with its own QoR check.
  *Breaks:* a regression hides inside a change described as a no-op, and the
  review looks for it in the wrong place.

## Review suggestions to decline

Automated reviewers make some suggestions on these scripts again and again
that break the rules above. An agent writing a change does not take them, and
an agent reviewing one does not make them.

- **"Crashes if the variable is undefined; use `env_var_exists_and_non_empty`,
  `env_var_or_empty` or `env_var_equals`."** Not when the variable has a
  default in `variables.yaml`: it is always set, and a crash is what the
  flow wants when it is not.
- **"Check that the file exists before reading it."** The read already fails,
  with the tool's own message.
- **"Keep the stack trace with `error $msg $::errorInfo`."** OpenSTA's command
  layer loses the Tcl stack trace anyway.
- **"Write the file under `RESULTS_DIR`."** Read the callee first:
  `write_lec_verilog` in `flow/scripts/formal_check.tcl` adds `RESULTS_DIR`
  itself, and the suggestion doubles it.
- **"Make this robust for a case the flow does not have,"** such as a second
  `read_timing` in one GUI session, or a variable for one design's special
  case. Each adds code no CI run exercises, or changes behavior.
- **"Rewrite this yosys `select` expression."** Run it before taking it;
  reviewers and tests have disagreed with such suggestions.

Suggestions worth taking are real defects: a loop that is quadratic on large
nets, parsing that breaks on input the flow produces, a command that does
real work outside `log_cmd`.
