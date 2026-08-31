# AUTO_FLOORPLAN

`AUTO_FLOORPLAN=1` makes the floorplan stage *measure* the floorplan
shape instead of reading it from `config.mk`. It races candidate
outlines and placement densities, scores each one by running the real
flow elements against it, and uses the winner.

The values it overrides are the last hand-carried numbers in a
`config.mk`:

| Variable | What it was |
|---|---|
| `CORE_UTILIZATION` | a guess at the smallest core the netlist closes in |
| `DIE_AREA` / `CORE_AREA` | the same guess, written as a rectangle |
| `CORE_ASPECT_RATIO` | folklore, per design |
| `PLACE_DENSITY` | a local bin-packing cap |
| `PLACE_DENSITY_LB_ADDON` | headroom above the measured density lower bound |

Each is a human prediction of downstream behaviour standing where a
measurement should be. The right utilization is "the smallest core in
which this netlist still closes" — a question about `repair_design`,
CTS and routing, none of which have happened when the number is read.

## What success looks like

**The bar is parity with a good hand-tuned `config.mk`, reached
automatically — not beating it.**

That is worth saying plainly, because the obvious way to read the tables
below is as a disappointment, and it is not one. The numbers in a
hand-tuned `config.mk` are the accumulated result of somebody sweeping
that specific design, and they are frozen the moment the RTL moves
underneath them. Landing near them from a measurement that re-runs
itself whenever synthesis changes is a large usability win even when it
costs a little on the Pareto front: it removes the knob, it removes the
staleness, and it removes the requirement that a person know the design
well enough to guess.

So the honest framing is a ladder, and each rung is useful on its own:

| | |
|---|---|
| **Explore** | `AUTO_FLOORPLAN=1`, the default. Measured every run, always current, never stale. |
| **Pin** | `bazelisk run //…:<name>_auto_floorplan_pin` writes the raced values into `config.mk` and sets `AUTO_FLOORPLAN=0`. A measurement becomes a decision. |
| **Overfit** | With the netlist frozen, the pinned values are ordinary `config.mk` entries, so AutoTuner and seed sweeps apply to them like any other knob — the last-ditch pass before tapeout. |

Judge the feature against "how close to hand-tuned, with nobody
maintaining it", and against "does it ever quietly make things worse".
The second question is what the guards below exist to answer, and it is
the one worth being strict about.

## Intended use: design-space exploration, not tapeout sign-off

**This is the most important thing to understand before using it.**

It is normal in this field to work on a design with a known target
frequency that does not yet close. When that is true, the flow cannot
tell the difference between two very different intentions:

- *this clock period or we do not tape out*, and
- *this is where we are aiming; the RTL is still moving*.

Nothing in a `config.mk` distinguishes them, and guessing wrong in the
first direction silently ships a worse chip. So AUTO_FLOORPLAN does not
guess: **it is documented and intended as a design-space exploration
tool.** It gives you a gradient — a measured answer to "how much smaller
could this core be, and what does that cost" — and it is not a sign-off
gate.

To make the distinction visible rather than assumed, every run reports
how far the design sits from its SDC period, in units of the design's
own measured noise floor:

```
AUTO_FLOORPLAN: design misses its SDC period by 69.34 (379.3 vs 310)
  = 34 noise floors; period here is a DSE gradient, not a sign-off margin
```

A design a few noise floors off its target is being closed, and period
given up to buy area is a real cost. A design tens or hundreds of noise
floors off is not going to be closed by the backend at all — that gap
gets fixed in the RTL — and its period number is a development signal.
The rule below does not change between the two regimes; the report tells
you which one you are reading.

If you are taping out, pin the values:

```
bazelisk run //flow/designs/asap7/ibex:ibex_core_auto_floorplan_pin
```

That reads the evidence from the design's last floorplan run, writes the
winning coordinates into `config.mk` between generated markers, and sets
`AUTO_FLOORPLAN = 0` so they are used verbatim. It is idempotent —
re-running updates the block in place — and the block records the noise
floor the values were raced against and how far the design was from its
SDC period at the time, so a reviewer can see what they are approving:

```make
# BEGIN AUTO_FLOORPLAN -- generated, do not edit by hand
#
# Raced against a measured noise floor (delta_tie) of 173.9
# at the time of pinning: achieved 2739 against an SDC target of 1000
# (10 noise floors short -- these values were explored, not signed off)
#
export CORE_UTILIZATION = 52
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2
export PLACE_DENSITY_LB_ADDON = 0.1
export PLACE_DENSITY = 0.668

export AUTO_FLOORPLAN = 0
# END AUTO_FLOORPLAN
```

Once pinned there is no machinery left in the way, so the frozen-RTL
endgame works as it always did: the design's `autotuner.json` search
space and a seed sweep can overfit these values as hard as a tapeout
deserves.

## What it does

Three coordinates, each raced on a dimensionless ladder. There is no
per-design constant anywhere in the implementation.

- **Density** — the measured lower bound
  (`gpl::get_global_placement_uniform_density`) stays, because it is
  derived rather than guessed. Raced above it are fractions of the
  available headroom, `{0.00, 0.05, 0.10, 0.15, 0.20}`, which is exactly
  what `PLACE_DENSITY_LB_ADDON` means. The winner also becomes RTL-MP's
  `-target_util`, so one measurement fixes both consumers of the knob.
- **Utilization** — fractions of the incumbent, `{0.9 … 1.4}`.
- **Aspect ratio** — `{0.8, 1.0, 1.25}` at the winning area point. On
  many designs this comes back a tie, which is a result: the folklore
  value gets graded rather than assumed.

The search is coordinate descent (utilization, then density, then
aspect), about 14 candidates rather than the 75 a full grid needs.
Interactions between the coordinates are therefore not explored — a real
limitation, recorded in the evidence rather than papered over.

### Area is a budget, not a score

A bigger core always makes period easier, so any objective that blends
the two just inflates the die — or, as measured on gcd during
development, deflates it and quietly sells the period away.

So utilization is **constraint satisfaction, not minimisation**: take
the smallest core whose score is *no worse than the incumbent's*, and if
none qualifies, keep the incumbent. Density and aspect are then scored
at that fixed area, which is a like-for-like period comparison. The
incumbent is replaced only when the winner actually buys area.

Note the tolerance on that admission is zero, not `delta_tie`. Spending
the noise floor as an allowance sounds reasonable and is not: on the
asap7 sweep `ibex`'s floor came out at 17% of its clock period, so
"within `delta_tie`" would license handing over a sixth of the period in
exchange for area. `delta_tie` decides what counts as *resolved* and
what counts as a *tie*; it is not slack to be spent.

### An unresolved ladder keeps the incumbent

If the spread of scores across a ladder does not exceed the design's own
noise floor, then every candidate is interchangeable with every other
and the measurement has answered nothing. The response to that is to
keep the incumbent — **not** to take the smallest core.

This guard is load-bearing rather than decorative. Without it a large
`delta_tie` makes the admission test vacuous, every candidate qualifies,
and the rule silently degenerates into pure area minimisation with no
period protection at all. Measured during development: `ethmac`'s noise
floor came out at 525% of its clock period and `aes`'s at 31%, with
ladder spreads *smaller* than the floor in both cases — and both duly
shrank their core and gave up large amounts of TNS for a score
difference indistinguishable from noise.

Because of that, the noise floor is always reported against the clock
period, which is the only scale on which a period number means
anything:

```
AUTO_FLOORPLAN: noise floor over 3 seeds: spread 173.9 (7.06% of score,
  17.39% of the clock period). A floor that is a large fraction of the
  clock means this design's proxy cannot resolve small period
  differences at all.
```

A design whose floor is a large fraction of its clock will mostly report
"did not resolve" and keep its `config.mk` values. That is the correct
outcome, not a failure to find one.

### Not overfitting the proxy

Racing hard on a cheap pre-route proxy overfits: the winner scores well
before routing and then produces DRC errors or a repair explosion.
Three rules guard against it.

1. **Feasibility guards are hard filters, not score terms.** A candidate
   that fails to place, fails to globally route, or whose post-placement
   utilization exceeds `AF_MAX_UTIL_POST` is eliminated outright. No
   score buys past a guard.
2. **The objective is an aggregate, never WNS.** The achieved period is
   a max, dominated by one path that repair usually rescues; the mean of
   the sampled worst-quartile paths is what transmits downstream.
3. **Ties break toward headroom.** Among candidates within `delta_tie`,
   take the loosest — lowest density, largest core. When the measurement
   cannot separate two candidates, take the one with more room for the
   growth the proxy never saw.

### delta_tie is measured, never configured

Every verdict is published next to the design's own noise floor, found
by re-running the winning candidate under three placer seeds. A selector
must never be rewarded for predicting noise, and a threshold that came
from anywhere but the design itself would do exactly that.

### Fidelity of the scorer

Candidates run the production stage scripts — `floorplan.tcl`,
`macro_place.tcl` — rather than a reimplementation, then
`global_placement`, `repair_design` and `global_route` with
`estimate_parasitics -global_routing`. That last pair matters: pricing
wires by an ideal-length estimate makes the score blind to the
congestion a denser core actually buys, which was measured to cause a
rank inversion against the flow.

`AF_REPAIR=0` and `AF_GRT=0` drop those rungs for a cheaper, less
faithful race.

## Cost

Candidates run as parallel subprocesses, `AF_JOBS` at a time (default:
half the core count). Each pays a floorplan, a macro placement if the
design has macros, a global placement, a repair pass and a global route.
A separate process also sidesteps `rtl_macro_placer`'s non-re-entrancy
and leaves the parent database untouched, so only the winner is ever
committed.

## Evidence

Every run writes `reports/.../auto_floorplan.json` — every candidate,
its score, why it was eliminated if it was, the measured noise floor,
the period regime, and the winner. Because files in `REPORTS_DIR` are
not declared build outputs and a sandboxed build discards them, the same
JSON is echoed into the floorplan stage log between
`AUTO_FLOORPLAN-EVIDENCE-BEGIN` / `-END` markers.

A verdict without its evidence is an assertion.

## Turning it off

`AUTO_FLOORPLAN=0` uses the `config.mk` values verbatim. It is also
skipped automatically when `FLOORPLAN_DEF` or `FOOTPRINT` is set: a die
that comes from a DEF or a pad ring is a constraint, not a choice.
