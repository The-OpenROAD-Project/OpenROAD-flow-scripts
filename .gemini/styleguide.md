# OpenROAD-flow-scripts code-review guidance

A change to `flow/scripts/*.tcl` is reviewed against every rule in
[TclContract.md](../docs/contrib/TclContract.md); a change to `flow/Makefile`,
`flow/scripts/*.mk`, `flow/scripts/variables.yaml` or a `config.mk` against
every rule in [MakefileContract.md](../docs/contrib/MakefileContract.md). This
guide does not repeat them.

A wrong comment costs the author time to refute it, and a wrong comment that
gets followed costs more: it can turn a loud failure into a silent wrong result,
which in ORFS can mean an hours-long run that finishes green and measures
nothing. The rules below are hard stops; a comment that breaks one is not posted.

## Hard stops: never suggest silencing an error

ORFS wants loud, early failures. A missing file, a malformed setting or an
unexpected tool output stops the flow where it is found, with a message that
names it.

- Never suggest guarding a variable that has a `default:` in
  `flow/scripts/variables.yaml`. ORFS sets it; a bare `$::env(VAR)` is correct,
  and `env_var_exists_and_non_empty` or `env_var_or_empty` around it hides a
  broken setup.
- Never suggest a fallback that runs without saying so: `or 0.0` or `.get(key,
  default)` on a required setting, `try`/`except: pass`, `catch` without
  rethrowing, a tolerant parser for a file ORFS writes itself, `mkdir -p` or
  `$(wildcard ...)` that makes a misspelt path vanish, or "if this fails, skip
  the step".
- A missing input is reported as a stop with a clearer message, never turned
  into an empty result.

## Ground findings in the current code

- Before claiming a tool option, PDK layer or via, Python package version or
  repository file does not exist, find it: the yosys `help` text, the OpenROAD
  docs, the LEF, the package index, the tree. Before saying a helper such as
  `write_lec_verilog` gets a path wrong, read the helper.
- Check shell, make, Tcl and yosys semantics before calling something a bug.
  An empty `for` word list is valid shell and runs zero times. In
  `$(eval $(call ...))`, `$$$$` passes a literal `$` through to the shell, so
  work out which expansion the code needs before suggesting it. In make, `target: prerequisite` means the target depends on the
  prerequisite. A yosys `select` with several arguments is a union.
- ORFS runs on Linux. RHEL 7 and paths with spaces are not supported anywhere;
  do not ask for quoting, arrays or compiler probes for them.

## Keep comments in scope

- Do not comment on code moved verbatim, vendored PDK files or files copied
  from upstream projects; they are kept identical to their source.
- `rules-base.json` limits, QoR trade-offs and constraint choices are the
  maintainers' decision. Do not lecture on a degradation the PR description
  explains.
- Do not suggest one-off cleanups (encoding arguments, wording, extra file
  extensions) that belong in a sweep of their own.
- Do not repeat resolved findings, or a finding the author answered in an
  earlier round. Read earlier rounds; never ask to undo a change an earlier
  round asked for. Keep comments concise and omit unsolicited PR summaries.
