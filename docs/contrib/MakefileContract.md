# Makefile Contract

`flow/Makefile` is written in make, a rich programming language behind a
terse syntax: recursive and simple expansion, `=` against `:=` against `?=`,
the origin of a variable, exports to sub-makes, a graph built in one pass and
run in another. ORFS keeps the Makefile as simple as it can, and over time a
handful of conventions have grown up that keep it that way. Most of them were
never written down.

This page writes them down as rules a review can check a change against: a
change to `flow/Makefile`, `flow/scripts/*.mk`, the stage scripts in
`flow/scripts/*.tcl` or `flow/scripts/variables.yaml`. It is written for
automated review of AI maintenance of these files: an agent that changes one
of them, or reviews such a change, checks it against every rule here.

The rules are hard stops: a change that breaks one is wrong, whatever else it
fixes. Each rule says what breaks when it is broken. Existing code that breaks
a rule is debt to fix, not a precedent to follow.

Some flows run the Makefile one step at a time, each step in a fresh tree that
holds only that step's inputs, and track the dependencies themselves;
[bazel-orfs](https://github.com/The-OpenROAD-Project/bazel-orfs) is one.
Several of the rules exist for them.

## Targets

- **A `do-` target never builds anything.** It runs its one step on the files
  already in the tree. Its prerequisites are checks (`check-kepler-formal`),
  the step's source files and one-time markers (`$(OBJECTS_DIR)/copyright.txt`):
  never an order-only prerequisite, never a file another target writes.
  *Breaks:* a flow that runs each `do-` target alone in a fresh tree rebuilds
  the prerequisite every time.
- **Dependencies live only on the file targets and stage aliases**
  (`$(RESULTS_DIR)/2_1_floorplan.odb`, `synth`, `floorplan`, ...), never on a
  `do-` target. The file target checks the dependencies and calls the `do-`
  target to run the step.
  *Breaks:* a flow that tracks dependencies itself cannot run one step on
  existing results.
- **`open_*`, `gui_*`, `web_*` and `run` never build anything.** `run` writes
  `$(LOG_DIR)/$(RUN_LOG_NAME_STEM).log` and nothing under `RESULTS_DIR`,
  `REPORTS_DIR` or `OBJECTS_DIR`.
  *Breaks:* opening or scripting a stage changes the tree it looks at, and a
  caller that runs several `make run` at once on one tree gets them writing
  the same files.
- **The graph never depends on a variable.** No `ifeq` chooses which steps run
  or which files they write. A step with nothing to do for a design runs
  anyway and copies its `.odb` and `.sdc` through; the choice is made in its
  `.tcl`.
  *Breaks:* a flow that names a step's outputs before running it gets a
  different set for each design.

## Steps

- **A step never writes next to its inputs or into one.** It writes new files
  under names of its own, as `2_floorplan.odb` → `3_place.odb`.
  *Breaks:* a rerun reads what the last run wrote, and a flow that keeps
  inputs read-only cannot run the step.
- **A step never skips an output because the file exists.** "Up to date" is
  the file target's decision.
  *Breaks:* a tree that kept a file from an earlier run and a fresh tree give
  different results.
- **A step never reads a file it does not declare.**
  *Breaks:* it works under `make synth`, where an earlier target happened to
  build the file, and fails when the step runs alone.
- **A step never reads an input it does not use.**
  *Breaks:* every change to that input reruns the step and every step after
  it.
- **A step never leaves configuration for a later step.** A command gets its
  options in its own `log_cmd` line; a setting it needs is set right before
  the call and reset right after. State that crosses steps is in the `.odb` or
  another result file.
  *Breaks:* the later step's log does not show what it ran with, and a
  checkpoint changes when the design did not.
- **A step never draws an unseeded random number.** The seed comes from a
  variable and is recorded.
  *Breaks:* caching a step's result, the QoR check against a baseline, and
  bisecting a regression.
- **A failing step never calls `exit`.** It writes `<step>-failed.odb` and
  calls `error`, as `flow/scripts/global_place.tcl` does.
  *Breaks:* the log and the exit status stop saying where the step failed,
  and there is no checkpoint to inspect.
- **A `PRE_<STEP>_TCL` hook never runs before the design is loaded.** Hooks
  run through `source_step_tcl` in `flow/scripts/util.tcl`, after
  `load_design`.
  *Breaks:* the hook has no design to act on.

## Variables

- **A variable a design sets is never assigned with `=` in the Makefile.** It
  is assigned with `?=`. `RUN_CMD` in `flow/scripts/variables.mk` is the
  exception; it can be set only on the make command line.
  *Breaks:* a flow that passes a design's variables in `DESIGN_CONFIG` as
  `export VAR?=value` lines is overridden.
- **A variable the environment supplies is never exported with
  `export VAR := $(VAR)`.** It is exported bare, `export VAR`, and its default
  is a `?=` fallback to the in-tree install.
  *Breaks:* `:=` rebinds the variable to origin "file", `UNSET_AND_MAKE`
  unsets it before the sub-make, and the fallback fires there with an in-tree
  path that a flow supplying its own tools does not have (the "HERE BE
  DRAGONS" comment in `flow/scripts/variables.mk`).
- **Only the Makefile sets `RESULTS_DIR`, `LOG_DIR`, `REPORTS_DIR` and
  `OBJECTS_DIR`.** It derives them from `WORK_HOME`, which a flow sets. A
  variable a flow adds never reuses one of these names.
  *Breaks:* a flow that relocates the tree through `WORK_HOME` finds results
  where the Makefile did not put them.
- **A variable is never missing from `flow/scripts/variables.yaml`.** Its entry
  has its default, when it has one, and `stages:` when not every stage reads
  it.
  *Breaks:* a flow that checks variable names against `variables.yaml`
  refuses it, and a flow that passes each stage only its own variables
  passes it nowhere, or everywhere.
- **A variable that has a default is never read through an existence check.**
  It is read as `$::env(VAR)`, never through `env_var_exists_and_non_empty`
  with a fallback. A boolean is `0`/`1` and has a default.
  *Breaks:* a misspelled or unpropagated variable takes the other branch
  quietly, instead of stopping at the line that reads it.
- **A script never overwrites a variable that is set.** It sets one only when
  it is unset.
  *Breaks:* the design's or the user's value is ignored.
- **A platform default is never repeated in a design's `config.mk`.** It is in
  the platform's `config.mk`, assigned with `?=`.
  *Breaks:* a change to the platform default misses the designs that copied
  it, and a design can no longer override it.
- **A variable never has a negative name** (`LEC_CHECK=1`, never
  `DISABLE_LEC_CHECK`), **never duplicates an existing one** (`ADDITIONAL_LIBS`
  for an extra library), **and is never a default-off feature toggle** that no
  CI design sets. A variable with no effect is deleted, not deprecated.
  *Breaks:* double negatives in settings, two variables for one choice, and
  code no CI run exercises.
- **A variable's value is never computed with `$(shell awk ...)` or
  `$(shell sed ...)`.** That logic is in Python with unit tests.
  *Breaks:* a heuristic nobody can test, read, or run on a machine without
  that tool.
