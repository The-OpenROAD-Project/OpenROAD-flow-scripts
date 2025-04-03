# Welcome to the OpenROAD Flow Scripts documentation!

The OpenROAD ("Foundations and Realization of Open, Accessible Design")
project was launched in June 2018 within the DARPA IDEA program. OpenROAD
aims to bring down the barriers of cost, expertise and unpredictability that
currently block designers access to hardware implementation in advanced
technologies. The project team (Qualcomm, Arm and multiple universities and
partners, led by UC San Diego) is developing a fully autonomous, open-source
tool chain for digital SoC layout generation, focusing on the RTL-to-GDSII
phase of system-on-chip design. Thus, OpenROAD holistically attacks the
multiple facets of today's design cost crisis: engineering resources,
design tool licenses, project schedule, and risk.

The IDEA program targets no-human-in-loop (NHIL) design, with 24-hour
turnaround time and zero loss of power-performance-area (PPA) design quality.

The NHIL target requires tools to adapt and auto-tune successfully to
flow completion, without (or, with minimal) human intervention. Machine
intelligence augments human expertise through efficient modeling and
prediction of flow and optimization outcomes throughout the synthesis,
placement and routing process. This is complemented by development of
metrics and machine learning infrastructure.

The 24-hour runtime target implies that problems must be strategically
decomposed throughout the design process, with clustered and partitioned
subproblems being solved and recomposed through intelligent distribution
and management of computational resources. This ensures that the NHIL design
optimization is performed within its available `[threads * hours]` "box" of
resources. Decomposition that enables parallel and distributed search over
cloud resources incurs a quality-of-results loss, but this is subsequently
recovered through improved flow predictability and enhanced optimization.

Learn more about the project at our website and our resources page
[here](https://theopenroadproject.org/resources/).

## Getting Started with OpenROAD Flow Scripts

OpenROAD Flow is a full RTL-to-GDS flow built entirely on open-source tools.
The project aims for automated, no-human-in-the-loop digital circuit design
with 24-hour turnaround time. For more information, refer to our repository
[README](mainREADME.md).

```{tip}
See these [tips](user/FAQS.md#how-do-i-get-better-search-results) to help improve your search results.
```

### Setup

#### System Requirements

To build the binaries and run `gcd` through the flow:

- Minimum: 1 CPU core and 8GB RAM.
- Recommended: 4 CPU cores and 16GB of RAM.

```{note}
`gcd` is a small design, and thus requires less computational power.
Larger designs may require better hardware.

```
#### Build or Installing ORFS Dependencies

We support four major ways of installation:

- [Docker](./user/BuildWithDocker.md)
- [Pre-built Binaries](./user/BuildWithPrebuilt.md)
- [Windows Subsystem for Linux (WSL)](./user/BuildWithWSL.md)
- [Local Installation](./user/BuildLocally.md)

You may also choose and use the build script to customise your build process.
See more in the next section.

##### Build Command and options

``` shell
./build_openroad.sh --help
```

Options for `./build_openroad.sh` script
| Argument                      | Description                                                                           |
|-------------------------------|---------------------------------------------------------------------------------------|
| `-h` or `--help`              | Print help message.                                                                   |
| `-o` or  `--local`            | Build locally instead of building a Docker image.                                     |
| `-l` or  `--latest`           | Use the head of branch --or_branch or 'master' by default for tools/OpenROAD.         |
| `--or_branch BRANCH_NAME`     | Use the head of branch BRANCH for tools/OpenROAD.                                     |
| `--or_repo REPO_URL`          | Use a fork at REPO-URL (https/ssh) for tools/OpenROAD.                                |
| `--no_init`                   | Skip initializing submodules.                                                         |
| `-t N` or `--threads N`       | Use N cpus when compiling software.                                                   |
| `-n` or `--nice`              | Nice all jobs. Use all cpus unless `--threads` is also given, then use N threads.     |
| `--yosys-args-overwrite`      | Do not use default flags set by this scrip during Yosys compilation.                  |
| `--yosys-args STRING`         | Aditional compilation flags for Yosys compilation.                                    |
| `--openroad-args-overwrite`   | Do not use default flags set by this script during OpenROAD app compilation.          |
| `--openroad-args STRING`      | Aditional compilation flags for OpenROAD app compilation.                             |
| `--install-path PATH`         | Path to install tools. Default is `${INSTALL_PATH}`.                                  |
| `--clean`                     | Call git clean interactively before compile. Useful to remove old build files.        |
| `--clean-force`               | Call git clean before compile. WARNING: this option will not ask for confirmation. Useful to remove old build files. |
| `-c` or `--copy-platforms`    | Only applicable for docker builds. Copy platforms to inside docker image.             |
| `--docker-args-overwrite`     | Only applicable for docker builds. Do not use default flags set by this script for Docker builds.  |
| `--docker-args STRING`        | Only applicable for docker builds. Additional compilation flags for Docker build.     |


### Running a Design

Sample design configurations are available in the `designs` directory.
You can select a design using either of the following methods:

1. The flow
   [Makefile](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/blob/master/flow/Makefile)
   contains a list of sample design configurations at the top of the
   file. Uncomment the respective line to select the design.
2. Specify the design using the shell environment. For example:

```shell
# Make sure you are in ./flow
make DESIGN_CONFIG=./designs/nangate45/swerv/config.mk
# or
export DESIGN_CONFIG=./designs/nangate45/swerv/config.mk
make
```

By default, the `gcd` design is selected using the
`nangate45` platform. The resulting GDS will be available at
`flow/results/nangate45/gcd/6_final.gds`. The flow should take only a few
minutes to produce a GDS for this design. We recommend implementing this
design first to validate your flow and tool setup.

### Design exploration and automatic parameter tuning

AutoTuner is an automatic parameter tuning framework capable of performing
automatic parameter tuning framework for commercial and academic RTL-to-GDS
flows. The two main functionalities that AutoTuner provides are:

- Automatic hyperparameter tuning framework for OpenROAD-flow-scripts
- Parametric sweeping experiments for OpenROAD-flow-scripts

```{tip}
Refer to the detailed [instructions here](./user/InstructionsForAutoTuner.md) for AutoTuner.

```

### Adding a Design

To add a new design to the `flow` directory, refer to the document [here](./user/AddingNewDesign.md).

### Platforms

OpenROAD-flow-scripts supports Verilog to GDS for the following open platforms:

- ASAP7
- Nangate45 / FreePDK45
- SKY130
- GF180

These platforms have a permissive license which allows us to
redistribute the PDK and OpenROAD platform-specific files. The platform
files and license(s) are located in `platforms/{platform}`.

OpenROAD-flow-scripts also supports the following proprietary platforms:

- GF55
- GF12
- Intel22
- Intel16
- TSMC65

The PDKs and platform-specific files for these kits cannot be provided
due to NDA restrictions. However, if you are able to access these
platforms, you can create the necessary platform-specific files
yourself.

Once the platform is set up, you can create a new design configuration with
information about the design. See sample configurations in the `design`
directory.
Refer to the [Flow variables](./user/FlowVariables.md) document for details on how to use
environment variables in OpenROAD-flow-scripts to configure platform and design specific parameters.

#### Adding a Platform

Refer to the [platform bring up](./contrib/PlatformBringUp.md) documentation
to set up a new platform for OpenROAD-flow-scripts.

### Implement the Design

Run `make` to perform Verilog to GDS. The final output will be located
at `flow/results/{platform}/{design_name}/6_final.gds`

### Miscellaneous

#### Smoke-test harness for top-level Verilog designs

1. Drop your Verilog files into `designs/src/harness`
2. Start the workflow:

```{tip}
Start with a very small submodule in your design that has only a few pins.
```

```shell
make DESIGN_NAME=TopLevelName DESIGN_CONFIG=$(pwd)/designs/harness.mk
```

## How to contribute

If you are willing to **contribute**, see the
[Getting Involved](contrib/GettingInvolved.md) section.

If you are a **developer** with EDA background, learn more about how you
can use OpenROAD as the infrastructure for your tools in the
[Developer Guide](contrib/DeveloperGuide.md) section.

## How to get in touch

We maintain the following channels for communication:

- Project homepage and news: <https://theopenroadproject.org>
- Twitter: <https://twitter.com/OpenROAD_EDA>
- Issues and bugs:
  - OpenROAD Flow: <https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/issues>
  - OpenROAD with OpenROAD Flow Scripts: <https://github.com/The-OpenROAD-Project/OpenROAD/issues/>
- Discussions:
  - OpenROAD Flow: <https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/discussions>
- Inquiries: openroad@ucsd.edu

See also our [FAQs](user/FAQS.md).

## Code of conduct

Please read our code of conduct [here](./contrib/CODE_OF_CONDUCT.md).

## Site Map

```{tableofcontents}

```
