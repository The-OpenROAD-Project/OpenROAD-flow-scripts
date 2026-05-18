# Developer Guide

- Integrate a new platform to OpenROAD Flow: [Guide](./PlatformBringUp.md).
- Adding a new design: [Guide](../user/AddingNewDesign.md).
- Continuous Integration: [Guide](./CI.md).
- How do I update the codebase? There are different ways to update your codebase depending on the method you installed it. We provide detailed instructions in this [guide](../user/FAQS.md).
- How do I contribute? Follow our Git Quickstart guide [here](./GitGuide.md).

## Timing and Logging (`run_command.py`)

Every flow stage (synthesis, floorplan, CTS, routing, etc.) is wrapped by
`flow/scripts/run_command.py`, which replaces the previous GNU `time` + `tee`
shell pipeline with a pure-Python implementation.

### What it does

`run_command.py` runs a command and:

- Measures **wall-clock time**, **CPU time** (user + sys), and **peak memory**
  using Python's `time.monotonic()` and `resource.getrusage()`.
- Streams output **line-by-line** to both the console and a log file
  (replacing `tee`), flushing after every line for real-time `tail -f`
  observability.
- Appends an `Elapsed time: ...` line in the format expected by
  `genElapsedTime.py` and `genMetrics.py`.

### Usage

```
python3 flow/scripts/run_command.py [--log FILE] [--append] [--tee] -- command [args...]
```

| Flag       | Effect |
|------------|--------|
| `--log FILE` | Write command output + timing line to FILE |
| `--append`   | Append to log file instead of overwriting |
| `--tee`      | Also write output to stdout (like the `tee` command) |

### Monitoring long-running stages

When running under Bazel (`bazelisk test ...`) or other batch systems that
hide console output, you can monitor progress by finding and tailing the log:

```bash
# Find the running stage's log file
ps -Af | grep run_command
# or
ps -Af | grep tmp.log

# Watch it in real time
tail -f /path/to/logs/4_cts.tmp.log
```

Output appears immediately in the log file (line-buffered with flush),
so `tail -f` shows real-time progress.

### Cross-platform support

Works on both Linux and macOS using only Python standard library modules.
Peak memory is normalized automatically (`ru_maxrss` is KB on Linux,
bytes on macOS).

### Testing

```bash
python3 -m pytest flow/test/test_run_command.py -v
```
