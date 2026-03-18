# Platform config.py variable rules

Rules for writing and consuming platform `config.py` files.

## Path variables must stay symbolic

Output values must use `$(PLATFORM_DIR)/...` and `$(PLATFORM)`, never
baked-in absolute paths. Consumers expand on their end:

- **Make shim**: `$(eval)` expands `$(PLATFORM_DIR)` and `$(PLATFORM)`
  naturally, matching the original config.mk behavior.
- **bazel-orfs**: Python string substitution when the Bazel rule
  executes. The sandbox has platform files at a different path than
  the developer's machine.

`PlatformConfig._unexpand()` handles this automatically at output time.

### Variables that use $(PLATFORM_DIR)

All 6 platforms. Every path-valued variable: `TECH_LEF`, `SC_LEF`,
`LIB_FILES`, `GDS_FILES`, `PDN_TCL`, `TAPCELL_TCL`, `FASTROUTE_TCL`,
`KLAYOUT_TECH_FILE`, `RCX_RULES`, `LATCH_MAP_FILE`, etc.

### Variables that use $(PLATFORM)

sky130hd, sky130hs only. Used in filenames within `$(PLATFORM_DIR)`:
`KLAYOUT_TECH_FILE`, `KLAYOUT_DRC_FILE`, `CDL_FILE`, `KLAYOUT_LVS_FILE`.

Example: `$(PLATFORM_DIR)/$(PLATFORM).lyt` not `$(PLATFORM_DIR)/sky130hd.lyt`.

## Assignment semantics

| Syntax | PlatformConfig method | Behavior |
|--------|----------------------|----------|
| `=`    | `cfg.set(key, val)`  | Unconditional. Always sets. |
| `?=`   | `cfg.set(key, val, conditional=True)` | Set only if not already defined (internally or in env). |
| `+=`   | `cfg.append(key, val)` | Append to existing value. Reads env if not set internally. |

## Glob results

`$(sort $(wildcard ...))` and `$(wildcard ...)` require real filesystem
paths at config.py runtime. `PlatformConfig.sorted_glob()` and
`wildcard_glob()` use the real `platform_dir` for glob operations.
The `_unexpand()` step replaces the prefix back to `$(PLATFORM_DIR)`
in output.

## Environment variable inputs

These env vars are **read** by config.py to control logic but do NOT
appear as `$(...)` references in output:

| Input | Platforms | Purpose |
|-------|-----------|---------|
| `CORNER` | asap7, gf180 | Select lib files (BC/WC/TC) |
| `TRACK_OPTION` | gf180 | Track variant (9t/7t) |
| `METAL_OPTION` | gf180 | Metal stack (5LM_1TM) |
| `KVALUE` | gf180 | K value (9/11) |
| `POWER_OPTION` | gf180 | Power variant (5v0/3v3) |
| `LIB_MODEL` | asap7 | NLDM or CCS |
| `ASAP7_USE_VT` | asap7 | VT list (RVT LVT SLVT) |
| `CLUSTER_FLOPS` | asap7 | Enable flop clustering |
| `BLOCKS` | asap7 | Hierarchical block PDN |
| `FOOTPRINT_TCL` | ihp-sg13g2 | IO placement file |
| `LOAD_ADDITIONAL_FILES` | ihp-sg13g2 | Enable IO libs/lefs |
| `SDC_FILE` | ihp-sg13g2 | Parsed for clock period |
| `ABC_CLOCK_PERIOD_IN_PS` | ihp-sg13g2 | Override clock period |

These env vars are **concatenated into output values** (their content
is embedded in variables like `LIB_FILES`, `GDS_FILES`):

| Input | Output vars | Platforms |
|-------|-------------|-----------|
| `ADDITIONAL_LIBS` | `LIB_FILES` | all 6 |
| `ADDITIONAL_GDS` | `GDS_FILES` | all 6 |
| `ADDITIONAL_LEFS` | `ADDITIONAL_LEFS` | ihp-sg13g2, asap7 |
| `ADDITIONAL_SLOW_LIBS` | `SLOW_LIB_FILES` | ihp-sg13g2 |
| `ADDITIONAL_FAST_LIBS` | `FAST_LIB_FILES` | ihp-sg13g2 |
| `ADDITIONAL_TYP_LIBS` | `TYP_LIB_FILES` | ihp-sg13g2 |
| `BC_ADDITIONAL_LIBS` | `BC_CCS_LIB_FILES` | asap7 |

In Make, these come from design configs as concrete paths. In bazel-orfs,
the Bazel rule provides them — no `$(...)` syntax.

## Why variables.mk does not need porting

`variables.mk` computes tool paths (`OPENROAD_EXE`, `YOSYS_EXE`,
`KLAYOUT_CMD`), output directories (`LOG_DIR`, `RESULTS_DIR`), macro
wrappers (`WRAPPED_LEFS`), stream format selection (`GDS` vs `OAS`),
and Make debugging introspection. This is Make-flow plumbing that
bazel-orfs replaces with Bazel-native equivalents. The only shared
concern is platform config variables, which `config.py` provides.

## Make functions already resolved by config.py

These Make constructs appeared in the original config.mk files. config.py
resolves all of them — none leak into output:

| Make function | Python equivalent | Platforms |
|---------------|-------------------|-----------|
| `$(sort $(wildcard ...))` | `sorted_glob()` | nangate45 |
| `$(wildcard ...)` | `wildcard_glob()` | sky130hd, sky130hs, gf180 |
| `$(abspath ...)` | `os.path.abspath()` | gf180 |
| `$(realpath ...)` | `os.path.realpath()` | asap7 |
| `$(origin VAR)` | `"VAR" in os.environ` | ihp-sg13g2 |
| `$(shell sed ...)` | `re.search()` | ihp-sg13g2 |
| `$(foreach)/$(eval)` | `for` loop | asap7 |
| `$(subst ...)` | `str.replace()` | asap7 |
| `$(patsubst ...)` | `str.replace()` | asap7 |
| `$(addsuffix ...)` | string concat | asap7 |
| `$(word N,...)` | `str.split()[N]` | asap7 |
| `$(wordlist ...)` | `str.split()[N:]` | asap7 |
| `$(strip ...)` | `str.strip()` | asap7 |
| `$(if ...)` | `if` statement | asap7 |
