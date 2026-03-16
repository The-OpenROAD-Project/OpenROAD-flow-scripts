Diagnose pr-head CI instabilities for an ORFS pull request by checking build determinism.

Usage: /diagnose-pr-head <github-pr-url>

## Known non-determinism sources

- **`repair_timing` (RSZ) is non-deterministic with threads > 1** — the multi-threaded STA timing analysis produces different results between runs, causing different repair decisions. With `-threads 1` it is deterministic. Filed as https://github.com/The-OpenROAD-Project/OpenROAD/issues/9781
- The following are **deterministic** (even multi-threaded): `pin_access`, `global_route`, `repair_design`, `detailed_placement`
- The non-determinism in `repair_timing` propagates through subsequent incremental GRT, affecting final metrics

## Arguments

- `$ARGUMENTS` contains a GitHub PR URL (e.g., https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/pull/3991)

## Procedure

### 1. Fetch PR information

Extract the PR number from `$ARGUMENTS` (the number after `/pull/`). Extract owner/repo from the URL.

```bash
gh pr view <number> --repo <owner>/<repo> --json number,title,headRefName,headRefOid,baseRefName,state,statusCheckRollup
gh pr checks <number> --repo <owner>/<repo>
```

For failed Jenkins checks, get the details URL and fetch status context:
```bash
HEAD_SHA=$(gh pr view <number> --repo <owner>/<repo> --json headRefOid -q .headRefOid)
gh api repos/<owner>/<repo>/statuses/$HEAD_SHA
```

### 2. Identify failed designs

Parse CI output for design/platform pairs and metric threshold violations. If specific failing designs cannot be determined from CI output, proceed — the idempotency sweep will still reveal systemic issues.

### 3. Save current state and check out pr-head

```bash
ORIG_BRANCH=$(git branch --show-current || git rev-parse HEAD)
git stash
gh pr checkout <number>
```

Do NOT use `--recurse-submodules` or `git submodule update --init --recursive` — it's unnecessary and slow.

### 4. Build OpenROAD

Build from inside the `tools/OpenROAD` directory (it has its own MODULE.bazel). First ensure `src/sta` matches:
```bash
cd tools/OpenROAD
git submodule update --init src/sta
bazelisk run //:install
```

**Common build issue:** If the build fails with STA API mismatches (e.g., `StringSeq` vs `StdStringSeq`, pointer vs value), the `src/sta` submodule inside `tools/OpenROAD` is likely at the wrong commit (left over from a previous checkout). Fix with:
```bash
cd tools/OpenROAD && git submodule update --init src/sta
```
Do NOT try to fix the API mismatches in OpenROAD source — just get the right STA version.

Verify the binary:
```bash
tools/install/OpenROAD/bin/openroad -version
```

### 5. Idempotency sweep — escalate from fast to slow designs

Use `flow/util/test_idempotency.sh` to run each design twice and compare per-stage ODB hashes automatically:

```bash
cd flow
./util/test_idempotency.sh asap7/gcd
./util/test_idempotency.sh nangate45/gcd
./util/test_idempotency.sh <failing-platform>/<failing-design>
```

Test in this order, stopping as soon as non-determinism is found:

1. **asap7/gcd** — fastest (~1-2 min), catches systemic issues
2. **nangate45/gcd** — different platform, still fast
3. **The specific failing design** from step 2 (e.g., nangate45/swerv_wrapper)
4. If all deterministic so far, keep testing progressively larger designs from the CI job

The script exits 0 if deterministic, 1 if non-deterministic. If ALL designs pass, the failure is a real regression or flaky threshold, not non-determinism. Report and stop.

If ANY design fails, note the earliest diverging stage. Proceed to step 6.

### 6. Drilldown with A/B tricks

Run the drilldown script which tests all A/B perturbation tricks in parallel, each using a unique `FLOW_VARIANT` so they write to independent directories:

```bash
cd flow
./util/drilldown_idempotency.sh <platform/design>
```

This tests: plain re-run, single-threaded (`NUM_CORES=1`), ASLR disabled, `MALLOC_PERTURB_=1`. All run in parallel.

If any variant diverges from the baseline, you've found an A/B pair.

### 7. Bisect within a stage's TCL script

The flow stages (e.g., `5_1_grt`) often run multiple OpenROAD commands internally. Use `make <stage>_issue` to create an isolated environment, then bisect by creating TCL scripts that include progressively more commands:

```bash
make DESIGN_CONFIG=./designs/<platform>/<design>/config.mk <stage_script>_issue
```

Inside the issue directory, create bisection TCL scripts adding one command at a time. Run each twice and compare hashes to find the specific command that introduces non-determinism. Test with `-threads 1` vs `-threads N` to determine if it's threading-related.

Use `FLOW_VARIANT` overrides for each run so they write to separate directories and can run in parallel.

### 8. Restore and report

```bash
git checkout $ORIG_BRANCH
git stash pop 2>/dev/null || true
```

Print a structured report:

```
## pr-head Idempotency Diagnosis

**PR:** #<number> - <title>
**PR Head Commit:** <sha>
**Failed Designs:** <list>

### Idempotency Results

| Design | Stage | Run 1 Hash | Run 2 Hash | Match? |
|--------|-------|------------|------------|--------|
| asap7/gcd | 1_1_yosys | abc123... | abc123... | YES |
| ... | ... | ... | ... | ... |

### Conclusion

- Build is DETERMINISTIC / NON-DETERMINISTIC at stage <X>.
- Root cause: <command> is non-deterministic with threads > 1.
```

## Reference: checking build determinism

The flow logs SHA1 hashes of each stage's `.odb` via `genElapsedTime.py`:

    python3 flow/util/genElapsedTime.py -d flow/logs/<platform>/<design>/base/

The `sha1sum .odb [0:20)` column is the hash to compare. Use `FLOW_VARIANT` to run A/B tests in parallel with independent output directories.

To diff divergent ODB files as human-readable DEF:

    openroad -exit -cmd "read_db run1.odb; write_def run1.def"
    openroad -exit -cmd "read_db run2.odb; write_def run2.def"
    diff run1.def run2.def

## Reference: common sources of non-determinism

- **Thread scheduling** — parallel algorithms (OpenMP `schedule(dynamic)`, thread pools) accumulate results in arrival order. Test with `-threads 1`.
- **Unordered container iteration** — `std::unordered_map`/`set` iterate in implementation-defined order. Replace with `std::map`/`set` or sort keys before iterating.
- **Pointer-based sorting** — sorting by pointer value varies due to ASLR. Test with `setarch $(uname -m) -R`.
- **Uninitialized memory** — use of freed/uninitialized memory. Test with `MALLOC_PERTURB_=1`.
- **Random seeds** — algorithms using `rand()` or `std::mt19937` without a fixed seed.

## Reference: A/B techniques

Use these make variables to perturb runs (each with its own `FLOW_VARIANT`):

| Technique | Make override | What it tests |
|-----------|--------------|---------------|
| Single thread | `NUM_CORES=1` | Thread scheduling |
| No ASLR | wrap with `setarch $(uname -m) -R` | Pointer-dependent ordering |
| Malloc perturb | `env MALLOC_PERTURB_=1` | Uninitialized memory |

## Reference: whittle.py for non-determinism

For non-determinism the "error" is that two runs differ. Create a wrapper that runs the stage twice, compares hashes, and prints a marker:

```bash
#!/bin/bash
STAGE_ODB=results/<platform>/<design>/base/<stage>.odb
make DESIGN_CONFIG=... EQUIVALENCE_CHECK=0 <stage>
HASH1=$(sha1sum $STAGE_ODB | cut -c1-40)
make DESIGN_CONFIG=... EQUIVALENCE_CHECK=0 clean_<stage> <stage>
HASH2=$(sha1sum $STAGE_ODB | cut -c1-40)
[ "$HASH1" != "$HASH2" ] && echo "NON_DETERMINISTIC"
```

Then: `whittle.py --error_string NON_DETERMINISTIC --step ./wrapper.sh --base_db_path <input>.odb`

Only whittle if the reproducer takes >10 minutes. For fast reproducers, whittling can make the bug harder to trigger.

## Important

- Always use `EQUIVALENCE_CHECK=0` to skip the eqy dependency
- Use relative paths from the repo root
- Use `git commit -s` for DCO sign-off on any commits
- If the PR modifies `tools/OpenROAD`, the build step is essential
- Do NOT recurse submodules from the ORFS root — only the top-level checkout is needed
- Before building OpenROAD, ALWAYS run `git submodule update --init src/sta` inside `tools/OpenROAD/` to ensure `src/sta` matches the pinned commit. A stale `src/sta` from a previous checkout causes misleading API mismatch errors. NEVER try to "fix" these mismatches in OpenROAD source — the fix is always to get the right submodule version.
