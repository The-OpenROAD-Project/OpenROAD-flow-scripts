# Running Claude Code in Docker

The `claude.sh` script runs [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
inside a Docker container with `--dangerously-skip-permissions`. The container
provides a sandboxed environment where Claude Code has full shell access but
cannot affect the host system beyond the mounted repository.

The container supports:

- Building and testing OpenROAD with **CMake** and **Bazel**
- Running **ORFS flows** (Makefile-based RTL-GDSII)
- All file changes reflected on the host via volume mount

## Prerequisites

- [Docker](https://docs.docker.com/engine/install) installed on your machine
- Claude Code credentials (run `claude` on the host once to authenticate,
  or set `ANTHROPIC_API_KEY` in your environment)

## Quick start

```shell
./claude.sh
```

On first run the Docker image is built automatically. Credentials from
`~/.claude/` are mounted into the container. The ORFS environment (`env.sh`)
is sourced automatically so tools are on `PATH` without any manual setup.

## Usage

```
./claude.sh [OPTIONS] [-- CLAUDE_ARGS...]
```

### Options

| Option | Description |
|--------|-------------|
| `--build` | Force rebuild the Docker image |
| `--shell` | Start a bash shell instead of Claude Code |
| `--image NAME` | Override Docker image (default: `openroad/flow-claude:latest`) |
| `--name NAME` | Override container name (default: `claude-orfs`) |
| `-h`, `--help` | Show help |

Arguments after `--` are passed directly to `claude`.

### Examples

```shell
# Interactive Claude Code session
./claude.sh

# Pass a prompt to Claude Code
./claude.sh -- -p "fix the failing test in src/drt"

# Interactive bash shell (for manual builds)
./claude.sh --shell

# Force rebuild the image after updates
./claude.sh --build

# Run a parallel session
CONTAINER_NAME=claude-2 ./claude.sh
```

## Building and testing inside the container

When using `--shell`, tools are already on `PATH`:

```shell
# CMake build
./build_openroad.sh --local --no_init -t $(nproc)

# Bazel build
cd tools/OpenROAD && bazel build //...

# Run an ORFS flow
cd flow && make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk
```

Claude Code can run these same commands autonomously during an interactive
session.

## What persists across runs

The container is removed on exit (`--rm`), but the following host directories
are mounted so their contents survive:

| Host path | Container path | Content |
|-----------|---------------|---------|
| Repository root | `/workspace` | All source and build artifacts |
| `~/.claude/` | `~/.claude/` | Credentials, settings, conversation history |
| `~/.cache/bazel-claude/` | `~/.cache/bazel/` | Bazel external dependencies |
| `~/.gitconfig` | `~/.gitconfig` | Git identity (read-only) |
| `$SSH_AUTH_SOCK` | forwarded | SSH agent for git over SSH |

## Environment variables

All environment variables are optional. They are passed into the container
when set on the host.

| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_API_KEY` | API key (alternative to stored credentials) |
| `ANTHROPIC_MODEL` | Model override |
| `CLAUDE_IMAGE` | Docker image override (same as `--image`) |
| `CONTAINER_NAME` | Container name override (same as `--name`) |
| `BAZEL_CACHE_DIR` | Host path for Bazel cache (default: `~/.cache/bazel-claude`) |
| `CLAUDE_CODE_USE_BEDROCK` | Use AWS Bedrock |
| `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` | AWS credentials for Bedrock |

## How it works

The setup consists of three files:

### `docker/Dockerfile.claude`

Extends the `openroad/flow-ubuntu22.04-dev` base image (which has all
OpenROAD build dependencies) with:

- Java 21 and Bazelisk (for Bazel 8.x builds)
- Node.js 22 LTS and Claude Code CLI
- VS Code CLI, sudo, and other convenience tools

No source code is copied into the image. Everything comes from the
volume mount.

### `docker/claude-entrypoint.sh`

Handles UID/GID mapping so files created inside the container have the
correct ownership on the host. The entrypoint:

1. Creates a user matching the host UID/GID
2. Sources `env.sh` to set up tool paths
3. Drops privileges via `setpriv` before running the command

This follows the same pattern as `tools/OpenROAD/etc/docker-entrypoint.sh`
and the `--user` mode in `flow/util/docker_shell`.

### `claude.sh`

Wrapper script that assembles the `docker run` command with the correct
volume mounts, environment variables, and entrypoint arguments.

## Security model

Claude Code runs with `--dangerously-skip-permissions` **inside** the
container, meaning it can execute any shell command without confirmation.
The Docker container provides the isolation:

- File access is limited to the mounted repository
- No access to host system packages, services, or other projects
- No access to host network services bound to localhost
- `docker kill claude-orfs` stops everything instantly

:::{Warning}
The container has network access (required for the Anthropic API and
Bazel dependency fetching). Claude Code could in principle make outbound
network requests. If this is a concern, use Docker network policies to
restrict egress to only the Anthropic API endpoints.
:::
