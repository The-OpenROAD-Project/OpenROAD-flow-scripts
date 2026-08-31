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

If you are taping out, pin the values: run with `AUTO_FLOORPLAN=1` once,
read the winner out of the evidence, and write it into `config.mk` with
`AUTO_FLOORPLAN=0`. That converts a measurement into a decision, which
is what sign-off needs.

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
the smallest core whose score is still within `delta_tie` of the
incumbent's, and if none qualifies, keep the incumbent. Density and
aspect are then scored at that fixed area, which is a like-for-like
period comparison. The incumbent is replaced only when the winner
actually buys area.

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
