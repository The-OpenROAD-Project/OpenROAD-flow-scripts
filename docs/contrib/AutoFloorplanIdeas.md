# Floorplan derivation: open questions and things to try

Working notes for the campaign in
[PR #4487](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/pull/4487).
Everything here is deferred, not done. See `docs/user/AutoFloorplan.md`
for what the derivation currently does.

Ordered roughly by expected value.

## 1. Replace coordinate descent with a joint design

**The most interesting open item.**

The derivation currently walks utilization, then density, then aspect,
each conditioned only on the previous winner. That is a fixed
information path, and it structurally cannot see interactions: aspect is
only ever evaluated at one area point, so "does aspect ratio matter?"
is not actually being asked. The best aspect at 40% utilization need not
be the best at 56%.

Instead, spend the same ~20 evaluations on a **joint design over the
three coordinates** — a Latin hypercube or similar space-filling sample —
and let the data say which coordinate explains the variance. Same budget,
no assumed structure, and it answers the interaction question rather
than assuming it away.

This is the transferable lesson from *Attention Is All You Need*, with
the architecture stripped off: RNNs assume recency and CNNs assume
locality; attention's contribution was to stop hard-coding *which things
are relevant to which* and let the content decide. Our coordinate order
is exactly such a hard-coded assumption, and it is one we have never
tested.

Practical notes:

- The sample must include the incumbent, which stays the reference point
  (see §2).
- With n ≈ 20 over 3 dimensions, a fitted response surface is plausible;
  with the noise floors measured so far (0.3%–10% of clock, design
  dependent) it may not be, and the honest fallback is ranking only.
- This changes what the evidence file records — currently phase-tagged,
  would become a design matrix.

## 2. Multi-fidelity: a cheap estimator with a fitted correction

The pre-route proxy was measured not to rank the utilization axis
(ρ = −1.000 on gcd, +0.100 on gcd-ccs against the finished flow), which
is why the derivation runs the full flow per candidate and is expensive.

The residual framing from *ResNet* suggests the missing option. ResNet's
lesson was not "add skip connections", it was **reparameterise so that
the identity is free and you learn the difference** — and, in the
architecture, *add* a shortcut path alongside the full one rather than
replacing it. Applied here: run the full flow on 3–4 rungs, fit the
proxy's per-design offset against those, and use the corrected proxy for
the rest.

The macro-place race's "pruning cascade" is this shape already. What we
have that it did not is the diagnostic: **ρ between the proxy's deltas
and the flow's deltas, per design, decides whether that design's proxy is
correctable at all.** ρ = −1.00 says no for gcd; it is not −1.00
everywhere, and the measurement is cheap once a full-flow ladder exists.

Caution from what was already tried: the difference-based calibration
(estimated = flow_anchor + proxy delta) was tested across designs and
gave ρ = −0.275 with 2/9 sign agreement. The bias is *not* common-mode,
so a global correction does not work. A per-design correction is a
different and still-open question.

## 3. Widen the ladder, and stop when it saturates

Both ends of the current `{0.9 … 1.4}` utilization ladder are wrong on
real designs:

- **Clipping.** Every design starting at utilization 40 landed on exactly
  56 — the 1.4× ceiling. Those results are a lower bound on the available
  win, not the optimum.
- **Saturation.** On gcd the core stops shrinking past utilization 78
  (the row/site snap quantises it), so the top rungs are wasted
  evaluations.

An adaptive ladder — keep climbing while area still falls and candidates
still survive — costs nothing extra on saturating designs and finds the
real answer on clipping ones.

## 4. Normalisation is where the bugs were

Recorded because it was not obvious in advance. The two worst defects in
this campaign were normalisation failures, not search failures:

- Judging the period axis on **WNS**, a signed quantity that lives near
  zero, so fractional changes explode. `clock − WNS` is the stable
  quantity. This one silently turned a +1.69% period change into
  "catastrophically lost closure".
- Expressing the noise floor as a fraction of **score** rather than of
  the **clock period**, which hid that ethmac's floor was 525% of its
  clock — i.e. that the measurement could not resolve anything at all.

The general rule worth keeping: put a quantity in units that make it
comparable across designs *before* comparing it. `delta_tie` as a unit is
the good version of this.

## 5. Is the scorer over-built?

bazel-orfs#868's E3 found raw gpl HPWL ranks the grt macro-path mean at
ρ +0.67 against the full-STA proxy's +0.72, CIs overlapping at n = 24 —
i.e. the analytic no-STA readout was ranking-equivalent for that KPI at
that operating point.

Our candidates run STA *and* `repair_design` *and* `global_route`. If
HPWL alone ranks equivalently for our KPI too, the flow oracle could be
made much cheaper. This is testable against evidence already produced —
no new flow runs — but note E3's result is for the macro-path mean on
swerv at 30% utilization, a regime that PR measured to be
period-saturated, so it does not transfer for free.

## 6. Known bugs and unfinished work

- **`aes-mbff` derives nothing.** Every candidate fails `IFP-0018`
  "Unable to find site: asap7sc7p5t_pg". The platform adds
  `ADDITIONAL_SITES += asap7sc7p5t_pg` when `CLUSTER_FLOPS = 1`
  (`flow/platforms/asap7/config.mk`), with the site defined in the MBFF
  LEFs; the staged `1_synth.odb` in the derivation does not carry it. The
  normal aes-mbff flow works, so this is specific to the derivation.
- **`<name>_pareto_test` predates the derive/pin split** and still
  describes a per-build feature that no longer exists.
- **Parallel synthesis is broken** for `riscv32i`,
  `riscv32i-mock-sram` and `aes-block` after the bazel-orfs bump
  (`per-module checkpoint missing: partition_*_canonical.rtlil`). Before
  the floorplan stage, so unrelated to this work, but it costs four
  designs from every table.
- **Tier boundaries serialise.** The campaign left ~28 cores idle for
  hours waiting on `jpeg` alone. Overlap tiers, or size them by measured
  cost rather than by guessed size class.

## 7. Where the deep-learning analogies stop

Worth writing down so the borrowing stays honest. ResNet and
transformers are about making *gradient-based* optimisation tractable
across enormous parameter spaces. This problem is derivative-free
optimisation over three coordinates with a black-box, noisy oracle at
~30 minutes per evaluation and a budget of ~20.

The binding constraint is **measurement**, not search: not "we cannot
find the good point" but "we cannot tell two points apart, and each look
is expensive". Architecture cleverness does not touch that. Variance
reduction, common random numbers across arms, cheaper-but-calibrated
evaluations, and racing/successive-halving under noise do — and that is
the literature to read, not the deep-learning one.
