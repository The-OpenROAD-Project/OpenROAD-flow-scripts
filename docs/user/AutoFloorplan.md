# Deriving a floorplan

A design's `config.mk` carries a handful of numbers that decide its
floorplan:

| Variable | What it is |
|---|---|
| `CORE_UTILIZATION` | a guess at the smallest core the netlist closes in |
| `DIE_AREA` / `CORE_AREA` | the same guess, written as a rectangle |
| `CORE_ASPECT_RATIO` | folklore, per design |
| `PLACE_DENSITY` | a local bin-packing cap |
| `PLACE_DENSITY_LB_ADDON` | headroom above the measured density lower bound |

Each is a human prediction of downstream behaviour standing where a
measurement should be. The right utilization is "the smallest core in
which this netlist still closes" — a question about `repair_design`, CTS
and routing, none of which have happened when the number is read.

These two targets measure them instead:

```bash
bazelisk build //flow/designs/asap7/gcd:gcd_auto_floorplan_data
bazelisk run   //flow/designs/asap7/gcd:gcd_auto_floorplan_pin
```

The first races candidate floorplans and writes the evidence. The second
writes the winner into `config.mk` as ordinary variables. **Nothing runs
during a normal build** — the flow reads `config.mk` exactly as it always
has, and both targets are `manual`, so no wildcard starts a derivation.

## Why it is a job and not a flow mode

An earlier version was a flow variable that raced candidates on every
build. Two things killed that.

**The cadence is wrong.** What changes in ORFS is the OpenROAD binary,
and binary churn rarely moves the Pareto front, so a per-build race
re-derives a number that did not need re-deriving — while adding
run-to-run variance to a benchmark suite whose whole value is stable
comparison. A real design's RTL changes during the day and wants a
nightly re-derivation, which is a job, not a flag.

**A cheap scorer cannot answer the question.** The per-build version
scored candidates with a fast pre-route proxy: global placement plus a
sampled-path timing readout. Measured against the finished flow across a
utilization ladder:

| design | ρ (proxy vs flow) | noise floor |
|---|---:|---:|
| gcd | **−1.000** | 1.1% of clock |
| gcd-ccs | +0.100 | 0.3% of clock |

On gcd the proxy is perfectly inverted: it improves 338 → 335 across the
ladder while the flow degrades 349.2 → 355.1 ps. Selection driven by
those numbers picked a core 11.2% *larger* with a worse period on `aes`.

So each candidate here runs the production flow from floorplan to finish
and reports what it achieved. That is expensive, and it is exactly why
this is something you run rather than something the flow does.

## What gets raced

Three coordinates, each on a dimensionless ladder. There is no per-design
constant anywhere in the implementation.

- **Utilization** — fractions of the incumbent, `{0.9 … 1.4}`.
- **Density** — fractions of the headroom above the measured lower bound
  (`gpl::get_global_placement_uniform_density`), `{0.00 … 0.20}`. That
  fraction *is* `PLACE_DENSITY_LB_ADDON`, now measured.
- **Aspect ratio** — `{0.8, 1.0, 1.25}` at the winning area point. Often
  a tie, which is a result: the folklore value gets graded rather than
  assumed.

Coordinate descent, not a grid — utilization, then density, then aspect.
A full cross product is 90 flows; this is about 20. Interactions between
the coordinates are therefore not explored, which is a real limitation
and is recorded in the evidence rather than papered over.

The design's own `config.mk` values enter as a candidate, so a design
whose folklore was already right keeps it.

## How the winner is chosen

```
P_eff = T + τ·ln(1 + e^((p−T)/τ))          τ = 2% of the clock
J     = ln(A) + λ·ln(P_eff)                 λ = 3
                                            minimise J
```

`λ` is an **exchange rate**: one percent of achieved period is worth
three percent of core area. That is a product decision someone has an
opinion about, not a threshold nobody can defend.

`P_eff` tracks the achieved period when the design is slower than its
target and flattens to the target when it is faster, so speed nobody
asked for has no value and area spent buying it is never repaid. That
removes the regime switch: the same expression minimises area down to the
target on a design that closes, and trades period against area on one
that does not.

Both constants are flat: every verdict on an asap7 sweep is unchanged for
λ ∈ [2, 5] and τ ∈ [1%, 10%], and the smooth form agrees with a hard
`max(p, T)` on all 15 designs. A policy whose decisions survive a 2.5×
range in one constant and 10× in the other is a shape, not a fitted
number.

Two behaviours fall out rather than being coded: a candidate that gives
up period and returns no area can never lower `J`, and the incumbent is
just another candidate, so "nothing beat it" needs no special case.

### Guards

- **A floorplan that routes with violations is eliminated**, not scored.
  No amount of area buys past a DRC.
- **A flow that fails is an eliminated candidate**, not a crash — a
  floorplan that cannot be built is a legitimate answer about that
  floorplan.
- **Hysteresis in `J`.** The winner must beat the incumbent by more `J`
  than the measured period noise could account for on its own, or the
  design keeps what it has. Area is exact — the same coordinates give the
  same core every time — so only the period term carries noise.

### `delta_tie` is measured, never chosen

The noise floor comes from re-running one candidate under eight different
placer seeds and taking two standard deviations. Not the range: the range
of a small sample is biased low and its expectation grows with `n`, so a
range-based floor would move every threshold purely by changing the seed
count.

On gcd it comes out at 1.20% of the clock period, independently
reproducing the ~1.1% measured for gcd by a separate experiment.

## Splitting derive from pin

`_data` is a normal build target with a declared output, so bazel caches
it. Iterating on the pin never re-derives — a `pin` run against cached
data takes under a second. And `_pin` **depends on** `_data`, so it can
never write stale values: bazel's dependency graph is the freshness
check, and a changed netlist, SDC or toolchain re-derives before the pin
sees it.

Nothing lands in your source tree except the `config.mk` edit; the
evidence lives in `bazel-out`.

Derive as many designs in one command as the machine warrants:

```bash
bazelisk build --keep_going \
  //flow/designs/asap7/gcd:gcd_auto_floorplan_data \
  //flow/designs/asap7/ibex:ibex_core_auto_floorplan_data
```

### Provisioning

The derivation is **one bazel action that forks its own candidates**.
Bazel provisions roughly one core per action while each candidate runs a
multi-threaded flow, so expressing candidates as separate targets would
overprovision by the thread count of every concurrent flow.

Total concurrency is `--jobs × AF_JOBS × AF_THREADS`. Pick a shape:

| goal | `--jobs` | `AF_JOBS` | `AF_THREADS` |
|---|---|---|---|
| one design, all cores | 1 | 8 | 4 |
| many designs at once | 8 | 2 | 2 |

## What the pin writes

Ordinary `config.mk` variables, updated in place, keeping their position,
alignment and assignment operator. No markers, no generated block, no
banner — somebody reading a `config.mk` to understand a design should not
have to care which numbers were typed and which were measured. The
provenance is printed by the pinning run, for the commit message.

It answers in the form the design asked the question in: a design stating
`DIE_AREA`/`CORE_AREA` gets a rectangle back, one stating
`CORE_UTILIZATION` gets a utilization. The rectangle is not recomputed
from the utilization — each candidate reads back the die and core its own
`initialize_floorplan` produced, so the two forms cannot disagree.

Exactly one density variable is written. `PLACE_DENSITY_LB_ADDON` and
`PLACE_DENSITY` are not additive: `place_density_with_lb_addon` returns
the addon form whenever the addon is set and only falls back to
`PLACE_DENSITY` otherwise, so writing both would leave a dead variable
and hand the flow an addon that re-resolves to something other than what
was measured.

### Bringing up a new design

Wire up only the strictly necessary variables — sources, SDC, platform —
and let the pin fill in the floorplan:

```bash
bazelisk run //flow/designs/<platform>/<design>:<name>_auto_floorplan_pin
```

## When to re-run it

| | cadence |
|---|---|
| **ORFS itself** | rarely — when the flow or PDK moves materially, not per OpenROAD bump |
| **A design under development** | nightly, against the day's RTL |

Ideas for making this better, and the bugs still open, are collected in
[docs/contrib/AutoFloorplanIdeas.md](../contrib/AutoFloorplanIdeas.md).

## Limits worth knowing

- **Interactions between the coordinates are not explored.** Coordinate
  descent finds a good point, not necessarily the best one.
- **The ladder can saturate or clip.** On gcd the core stops shrinking
  past utilization 78, so the top rungs are wasted candidates; on ibex
  the best `J` was at the top rung, meaning the ladder was too narrow and
  left area unclaimed.
- **A design that meets timing with a small margin can lose it.** The
  objective values period against area at a fixed rate; it does not know
  that crossing zero slack is a change in kind. Check the reported
  achieved period against your target before accepting a shrink.
- **`FLOORPLAN_DEF` and `FOOTPRINT` designs are skipped.** A die that
  comes from a DEF or a pad ring is a constraint, not a choice.
