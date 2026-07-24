# Fast local OpenROAD-SYN testing loop

The maintainers' QoR signal comes from Jenkins runs published at
<https://dashboard.precisioninno.com/>. The targets described here are
its local counterpart: the same designs, gated by the same
`rules-base.json` files with the same `checkMetadata.py`, but built
locally through Bazel so the loop can be sharpened onto exactly the
design, engine, and stage being worked on — fast enough for an agent
(e.g. Claude) to iterate against.

Every design gets manual forced-engine flow variants (see
`design.bzl`), regardless of the engine its config.mk selects:

- `<name>_syn_*` pins `SYNTH_USE_SYN=1` (OpenROAD-SYN), so any design
  can be tested under SYN before its config.mk officially switches.
- `<name>_yosys_*` pins the yosys engine, so the baseline stays
  reproducible after a design switches (asap7/gcd today).

Designs with a `rules-base.json` get two QoR tiers per variant:

- `<name>_<engine>_synth_test` — the fast tier: synthesis only,
  checked against the `synth__`/`constraints__` subset of the rules.
  Minutes. QoR-only — without LEC it cannot prove correctness, so use
  it to iterate, not to conclude.
- `<name>_<engine>_test` — the full flow against all rules: the real,
  dashboard-equivalent gate. It reuses the fast tier's synthesis
  action, so escalating from fast to full never repeats synthesis.

## The loop

Build/test whatever is relevant to what you are changing — one design,
one stage, one tier, or a whole suite:

```sh
# fastest signal for one design
bazelisk test //flow/designs/asap7/jpeg:jpeg_encoder_syn_synth_test

# the real gate for that design
bazelisk test //flow/designs/asap7/jpeg:jpeg_encoder_syn_test

# a single stage, for triage
bazelisk build //flow/designs/asap7/jpeg:jpeg_encoder_syn_route

# yosys A/B on an officially-SYN design
bazelisk test //flow/designs/asap7/gcd:gcd_yosys_test

# suite-wide status (asap7): fast tier, then the full flows
bazelisk test --keep_going //flow/designs/asap7:syn_synth_test
bazelisk test --keep_going //flow/designs/asap7:syn_test
```

Then display what you have — deliberately a separate concern from
deciding what to test or build:

```sh
bazelisk run //flow/designs:syn-dashboard
```

It prints a GitHub-markdown TL;DR table of every forced-engine test
result already in `bazel-testlogs` — pass/fail per tier and engine,
failing rule fields, result age — without building anything. Paste it
into a PR or issue as-is. Because the display reads whatever exists,
the loop stays fast: iterate on the one target you care about, and the
dashboard aggregates across everything you (or earlier sessions) have
built so far.

The suites include designs that fail OpenROAD-SYN today on purpose —
they are a status signal, not a green-only gate. A build failure (e.g.
synthesis dies) records no test result at all, so run the suites with
`--keep_going` and check their output for `FAILED TO BUILD`; designs
too slow for the suites are listed in `SYN_SLOW_DESIGNS`
(`asap7/BUILD`) and reproduced individually.
