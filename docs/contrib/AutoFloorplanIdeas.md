# Floorplan derivation: open questions and things to try

Working notes for the campaign in
[PR #4487](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/pull/4487).
Everything here is deferred, not done. See `docs/user/AutoFloorplan.md`
for what the derivation currently does.

Ordered roughly by expected value.

## 0. Blocking defects found by the `aes_lvt` existence proof

Found while trying to turn `aes_lvt` into a single-concern upstream PR
(2026-09-01). The attempt was stood down; nothing was filed.

Summary, after all four were chased down:

| | | status |
|---|---|---|
| **0a** | the incumbent ran at a density the design never states | tooling bug, **fixed and verified** |
| **0b** | a 9 ps oracle-vs-flow gap on identical coordinates | **not established** -- inside the noise |
| **0c** | checked-in `rules-base.json` lags the toolchain | not a bug; constrains method |
| **0d** | the objective accepts a lost timing closure | **policy defect, open** |

0d is the one that produced the bad result. It is not a measurement
error and it survives perfect information: substituting the flow's own
numbers for the oracle's, the objective still accepts the losing trade by
five times the noise band. Fixing 0a and 0b would not have saved it.

**0a and 0b are defects in this campaign's own tooling**, which lives
only on this branch -- `auto_floorplan.tcl`,
`auto_floorplan_candidate.tcl`, `auto_floorplan_flow.tcl` and
`pinAutoFloorplan.py` are not in `origin/master`. Neither is an ORFS bug;
`place_density_with_lb_addon` (`flow/scripts/util.tcl:184`) behaves
exactly as this tooling assumed. **0c is not a bug at all** -- it is a
property of ORFS master that constrains what a PR can prove. **0d must be
resolved before any derived floorplan is proposed upstream** -- until the
selector and the acceptance test agree about timing closure, the
derivation can hand back a design the test will reject.

`aes_lvt`, derived winner `CORE_UTILIZATION 40 -> 56`,
`PLACE_DENSITY 0.65 -> 0.611`, measured by the production flow on both
arms:

| | baseline | pinned | |
|---|---:|---:|---|
| `finish__timing__setup__ws` | **+9.00** | **-0.46** | lost closure |
| achieved period (clock - WS) | 351.0 | 360.46 | +2.7% |
| `finish__design__core__area` | 3480.4 | 2484.2 | -28.6% |
| `finish__design__instance__area` | 1308.8 | 1300.4 | -0.6% |
| `detailedroute__route__wirelength` | 51683 | 49648 | -3.9% |
| `detailedroute__route__drc_errors` | 0 | 0 | |

A 28.6% smaller core bought by giving up all 9 ps of setup margin and
crossing zero slack.

Before the 0a fix the derivation scored this as a **win on both axes**,
reporting the winner as both smaller *and* 2.5% faster. With 0a fixed it
reports the shape correctly -- incumbent 3480 um2 at 351, winner 2484
um2 at 359, a trade -- and then accepts it anyway, which is 0d.

### 0a. The incumbent was not run at the design's own density -- FIXED

`auto_floorplan.tcl` substituted `addon 0.10` whenever a design expressed
no incumbent headroom fraction. For a raced candidate the addon *is* the
coordinate and that is the point; for the **incumbent** it silently
replaced the design's stated `PLACE_DENSITY`, so the reference point of
the whole walk was a floorplan the design has never built.

Fixed by `af_incumbent_density` plus an `AF_DENSITY` passthrough: a
design stating a fixed density now has the utilization ladder held at
that density, in that form.

Verified on `aes_lvt`. The incumbent candidate now reports achieved
**351** where the production flow measures **351.0**, and its objective
value `J = 25.82829` matches the `J` computed independently from
production `metadata.json` to five decimals. Before the fix it reported
360.3 -- 9.3 ps pessimistic against a floorplan that did not exist.

### 0b. Oracle-vs-flow gap -- NOT ESTABLISHED

On the winner's own coordinates the candidate harness reads achieved
351.4 and the production flow delivers 360.46, a 9.1 ps gap on runs that
should be identical. The first draft of this section called that 4.4
sigma against a `delta_tie` of 4.15 ps and treated it as a defect. That
was wrong twice over:

- The **noise floor is itself unstable.** Two runs of the same design,
  each taking 2 sigma over 8 placer seeds, gave 4.15 ps and 6.87 ps --
  a 65% swing. Against the larger estimate the gap is 1.3 sigma.
- Per 0c, this design gained +9 ps from six weeks of ordinary toolchain
  drift, so 9 ps is simply the scale on which its timing moves.

So the gap cannot presently be distinguished from noise, and `delta_tie`
over 8 seeds is too imprecise to settle it. That is a measurement
problem, and it is the same one named in section 7: the binding
constraint is that two points cannot be told apart, not that the good
point cannot be found. Resolving it needs a better variance estimate
(more seeds, or common random numbers across arms), not more search.

### 0c. Checked-in `rules-base.json` files are stale, so a rules diff proves nothing

`rules-base.json` in `origin/master` is not a description of what the
current toolchain produces. Last regeneration, asap7:

| date | designs |
|---|---|
| 2026-07-16 | `aes_lvt`, `gcd`, `gcd-ccs`, `jpeg_lvt`, `swerv_wrapper` |
| 2026-08-06 | `aes`, `aes-block`, `aes-mbff`, `cva6`, `ethmac`, `mock-alu`, `mock-cpu`, `riscv32i-mock-sram` |
| 2026-08-12..25 | `uart`, `ibex`, `coralnpu`, `jpeg`, `ethmac_lvt`, `riscv32i` |

For `aes_lvt` (generated 2026-07-16, measured fresh 2026-09-01 on
`origin/master` + its accompanying `tools/OpenROAD`):

| metric | bound | implied when generated | today | drift |
|---|---:|---:|---:|---:|
| `finish__timing__setup__ws` | -18.0 | 0.0 | +9.00 | +9 ps |
| `detailedroute__route__wirelength` | 60074 | 52238 | 51683 | -1.1% |
| `finish__design__instance__area` | 1499 | 1303 | 1309 | +0.4% |

The design gained 9 ps of setup margin from toolchain movement alone in
six and a half weeks. Nothing is wrong with the guard -- it is one-sided
and a design getting faster is not a regression -- but it means the file
lags the flow by however long since the last `update rules`.

Two things follow.

**A `config.mk` + `rules-base.json` PR conflates two changes.**
Regenerating rules on a stale file writes the floorplan change *and* the
accumulated drift into one diff. On `aes_lvt` the drift on WS is +9 ps
and the effect being claimed is ~9 ps, so the two are the same size and a
reviewer cannot separate them. Any such PR must regenerate twice --
once on unmodified master to publish the drift alone, then again with the
`config.mk` change -- or the existence proof is unfalsifiable.

**Never back-solve a baseline out of a checked-in bound.** This was done
once here and produced a baseline of `ws = 0.0` where the real one is
`+9.00`, which inverted the sign of the verdict on the whole design: it
made a lost closure look like a 2.5% speedup. Measure both arms.

### 0d. The objective accepts a lost timing closure

**The defect that actually produced the bad `aes_lvt` result.** Unlike 0a
and 0b it is not a measurement bug at all -- it survives perfect
information.

With the flow's own numbers substituted for the oracle's, `T = 360`,
`tau = 2%`, `lambda = 3`:

| | area | period | `P_eff` | `J` |
|---|---:|---:|---:|---:|
| incumbent | 3480.4 | 351.00 | 361.81 | 25.82829 |
| winner, as the oracle saw it | 2484.2 | 351.40 | 361.90 | 25.49185 |
| winner, as the flow delivers | 2484.2 | 360.46 | 365.22 | 25.51924 |

`dJ = -0.309` against a noise band of 0.057. **The objective still
accepts, comfortably, knowing the truth.** `lambda = 3` prices 28.6% of
area as worth roughly 9.5% of period; the trade costs 2.7%. Correcting
the oracle would not have changed the verdict.

The cause is `P_eff` itself. A soft-plus makes crossing the timing target
a slightly steeper slope and never a wall, which is exactly the property
it was chosen for -- it removed the regime switch and made the policy
differentiable. The cost of that smoothness is that zero slack stops
being special.

And `checkPareto.py` disagrees: it fails a lost closure outright, as "a
change in kind, not a Pareto cost". **The selector and the acceptance
test hold contradictory definitions of closure**, and every derived
floorplan is chosen by the selector and judged by the test. They must be
reconciled before any of this is proposed upstream.

Which one gives is a real design question, not an oversight to patch:

- Making closure a hard constraint in the objective restores the regime
  switch that `P_eff` was introduced to remove, and reintroduces a
  discontinuity at a point the measurement cannot resolve -- with
  `delta_tie` at 4-7 ps and the verdict turning on 0.46 ps, the
  derivation would be gating on noise.
- Leaving the objective alone means accepting that the derivation
  optimises a quantity the project does not actually want, and relying
  on the Pareto test to catch it afterwards -- which works, but wastes a
  full derivation per rejection.
- A third option: keep the smooth objective for *ranking* and apply
  closure as a survival filter, the way DRC already is. A candidate that
  misses the target is eliminated rather than priced, which needs no
  discontinuity in `J` because it never reaches `J`.

The third is the shape the guards already use and is the recommendation,
but it inherits the same resolution problem: eliminating on a 0.46 ps
miss when the noise floor is 6.87 ps is a coin flip. Whatever is chosen
has to state what margin counts as missing.

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
