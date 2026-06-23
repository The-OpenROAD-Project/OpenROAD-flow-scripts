# Quickstart: Run gcd on nangate45 with Docker

This guide runs the smallest ORFS smoke test -- the `gcd` design on the
`nangate45` platform -- from RTL to GDS using the pre-built Docker image.
No local compilation is required.

For the full RTL-to-GDS walkthrough with interactive examples, see the
[Flow Tutorial](FlowTutorial.md).

## Prerequisites

- Docker installed and running (Docker Desktop with WSL integration on Windows)
- At least 1 CPU core and 8 GB RAM (4 cores recommended)
- A clone of [OpenROAD-flow-scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)

## One-time setup: pull the Docker image

Downloading the image is separate from running the flow. Do this once:

```shell
docker pull openroad/orfs:latest
```

## Run the flow

From the root of your `OpenROAD-flow-scripts` clone:

```shell
cd flow
util/docker_shell make
```

The `Makefile` defaults to `DESIGN_CONFIG=./designs/nangate45/gcd/config.mk`,
so no extra flags are needed for this quickstart.

To select the design explicitly:

```shell
util/docker_shell make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk
```

On success, `make` prints a stage summary table at the end. For `gcd`, the
total runtime is typically **under five minutes** on a modern machine. A full
clean run on WSL2 with Docker Desktop completed in about one minute in our
verification (see [Verified environment](#verified-environment) below).

## Expected output

Final layout files are written under the `base` flow variant:

| Artifact | Path |
|----------|------|
| GDSII | `results/nangate45/gcd/base/6_final.gds` |
| DEF | `results/nangate45/gcd/base/6_final.def` |
| Logs | `logs/nangate45/gcd/base/` |

Confirm the GDS exists:

```shell
ls -lh results/nangate45/gcd/base/6_final.gds
```

## Optional: view the layout in the GUI

If you have an X11 display available (for example, WSLg on Windows 11):

```shell
util/docker_shell make gui_final
```

This opens the finished layout in the OpenROAD GUI. It is not required to
validate that the flow completed successfully.

## Troubleshooting

### `xauth` warnings when running headless

When no graphical display is available, `util/docker_shell` may print `xauth`
warnings. These can be ignored for `make`; they do not affect RTL-to-GDS
execution.

### Image not found

If Docker reports that `openroad/orfs:latest` is missing, run:

```shell
docker pull openroad/orfs:latest
```

### Re-running from scratch

To remove previous results for this design and run all stages again:

```shell
util/docker_shell make clean_all
util/docker_shell make
```

## Next steps

- Read the [Flow Tutorial](FlowTutorial.md) for stage-by-stage exploration
- See [Docker Shell](../user/DockerShell.md) for other `docker_shell` options
- See [Adding New Designs](../user/AddingNewDesign.md) to bring your own RTL

## Verified environment

This quickstart was verified with:

- OS: WSL2 (Linux)
- Docker: Docker Desktop 28.4.0
- Image: `openroad/orfs:latest`
- Command: `util/docker_shell make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk`
- Full clean run (`make clean_all` then `make`): ~61 seconds wall time
- Output: `results/nangate45/gcd/base/6_final.gds` present
