# OpenROAD Flow
[![Gitter](https://badges.gitter.im/The-OpenROAD-Project/community.svg)](https://gitter.im/The-OpenROAD-Project/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)


## Introduction
The OpenROAD ("Foundations and Realization of Open, Accessible Design") project
was launched in June 2018 within the DARPA IDEA program. OpenROAD aims to bring
down the barriers of cost, expertise and unpredictability that currently block
designers' access to hardware implementation in advanced technologies. The
project team (Qualcomm, Arm and multiple universities and partners, led by UC
San Diego) is developing a fully autonomous, open-source tool chain for digital
layout generation across die, package and board, with initial focus on the
RTL-to-GDSII phase of system-on-chip design. Thus, OpenROAD holistically attacks
the multiple facets of today's design cost crisis: engineering resources, design
tool licenses, project schedule, and risk.

The IDEA program targets no-human-in-loop (NHIL) design, with 24-hour turnaround
time and eventual zero loss of power-performance-area (PPA) design quality. No
humans means that tools must adapt and self-tune, and never get stuck: thus,
machine intelligence must replace today's human intelligence within the layout
generation process. 24 hours means that problems must be aggressively decomposed
into bite-sized subproblems for the design process to remain within the schedule
constraint. Eventual zero loss of PPA quality requires parallel and distributed
search to recoup the solution quality lost by problem decomposition.

For a technical description of the OpenROAD flow, please refer to our DAC paper:
[Toward an Open-Source Digital Flow: First Learnings from the OpenROAD
Project](https://vlsicad.ucsd.edu/Publications/Conferences/371/c371.pdf). Also,
available from ACM Digital Library
([doi:10.1145/3316781.3326334](https://dl.acm.org/citation.cfm?id=3326334))

## Code Organization
This repository serves as an example RTL-to-GDS flow using the OpenROAD tools.
The two main components are:
1. **OpenROAD**: This submodule contains the source code for all the `openroad`
   app as well as other tools required for the flow. The Makefile in this
   repository will automatically build the OpenROAD toolchain.

2. **flow**: This directory contains reference recipes and scripts to run
   designs through the flow. It also contains platforms and test designs.

## Setup
The tools required to run through the OpenROAD flow can either be obtained from
a pre-compiled build export or can be built manually. The tools in the flow have
the following dynamic/runtime dependencies:

### Option 1: Installing build exports
1.  Clone the OpenROAD-flow repository
```
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow.git
```
2. Navigate to the "Releases" tab and download the latest release
3. Extract the tar to `OpenROAD-flow/OpenROAD`
4. Update your shell environment
```
source setup_env.sh
```

### Option 2: Building the tools using docker
This build options leveraged docker to build the seperate tool binaries in
different docker images. You must have docker installed and have permissions to
run docker to follow these instructions.
1.  Clone the OpenROAD-flow repository
```
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow.git
```
2. Build the Dockerfiles using the Makefile.
```
make
```
Make sure that `docker` is in your PATH and detected by the Makefile.

3. Update your shell environment
```
source setup_env.sh
```

### Option 3: Building the tools locally
Reference the Dockerfiles and READMEs for the separate tools on the build
prerequisites and steps.
```
./OpenROAD/Dockerfile
./OpenROAD/yosys/Dockerfile
./OpenROAD/TritonRoute/Dockerfile
```
After building, ensure that the `PATH` variable and shell environment is setup to point to the binaries

## Using the flow
See the flow [README](flow) for details about the flow and how
to run designs through the flow


## Useful Resources
Your feedback is very welcome.
- **Website**: Visit our [website](https://theopenroadproject.org/) for more
  information on the project, participants and objectives.
- **GitHub Issues**: Please submit GitHub issues for any bugs, improvements, or
  new feature requests. Feedback can be directed at this repository or the
  repository for the tool, component or design as appropriate. This
  [link](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+archived%3Afalse+user%3AThe-OpenROAD-Project+)
  is an aggregate of all OpenROAD related issues
- **Community**: Find us on the public [Gitter
  community](https://gitter.im/The-OpenROAD-Project/community) where you can ask
  quick questions or discuss anything OpenROAD related.
- **Twitter**: Follow us on twitter -
  [@OpenROAD_EDA](https://twitter.com/OpenROAD_EDA).


## Contributing
We welcome any comments, patches and designs to help us improve the tool. At
this time we are focused on overhauling the build process, build testing, and
the continuous integration framework. This will set us up for better integration
with contributors. Please stay tuned.

## License
The OpenROAD-flow repository (build and run scripts) has a BSD 3-Clause License.
The flow relies on several tools, platforms and designs that each have their own
licenses:
- Find the tool license at: `OpenROAD/src/{tool}/`
- Find the platform license at: `flow/platforms/{platform}/`
- Find the design license at: `flow/designs/src/{design}/`
