# OpenROAD Flow
OpenROAD Flow is a full RTL-to-GDS flow built entirely on open-source tools.
The project aims for automated, no-human-in-the-loop digital circuit design
with 24-hour turnaround time.

[![Build Status](https://jenkins.openroad.tools/buildStatus/icon?job=OpenROAD-flow-script-Public%2Fpublic_tests_all%2Fmaster)](https://jenkins.openroad.tools/view/Public/job/OpenROAD-flow-script-Public/job/public_tests_all/job/master/) [![Gitter](https://badges.gitter.im/The-OpenROAD-Project/community.svg)](https://gitter.im/The-OpenROAD-Project/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## Contents
* [Code Organization](#code-organization)
* [Installation](#installation)
  * [Dependencies](#dependencies)
  * [Building from Source](#building-from-source)
    * [Option 1: Docker](#option-1-docker)
    * [Option 2: Local](#option-2-local)
* [Using the flow](#using-the-flow)
* [Useful Resources](#useful-resources)
* [Contributing](#contributing)
* [About the Project](#about-the-project)
* [Citing this Work](#citing-this-work)
* [License](#license)

## Code Organization
This repository serves as an example RTL-to-GDS flow using the OpenROAD tools.
The two main components are:
1. **tools**: This directory contains the source code for the entire `openroad`
   app (via submodules) as well as other tools required for the flow. The script
   `build_openroad.sh` in this repository will automatically build the OpenROAD
   toolchain.

2. **flow**: This directory contains reference recipes and scripts to run
   designs through the flow. It also contains platforms and test designs.

## Installation
### Dependencies
* OpenROAD*
* TritonRoute*
* Yosys*
* [KLayout](https://www.klayout.de)

\*At this time, we strongly recommend using the
[`build_openroad.sh`](build_openroad.sh) script to install OpenROAD,
TritonRoute, and Yosys. Due to the early development stage, the API changes
frequently and it is otherwise difficult to ensure compatibility between tool
and OpenROAD Flow versions.

Be sure to check for nested dependencies when installing from source! You may
reference the Dockerfiles and READMEs for the dependencies:
```
OpenROAD-flow-scripts/tools/OpenROAD/Dockerfile
OpenROAD-flow-scripts/tools/yosys/Dockerfile
OpenROAD-flow-scripts/tools/TritonRoute/Dockerfile
```

### Prebuilt Binaries
Prebuilt binaries are not available at this time. We aim to create automated
releases in the near future.

### Building from Source
Building dependencies from scratch can take up to an hour.

#### Option 1: Docker
This build option leverages a multi-step docker flow to install the tools and
dependencies to a runner image. To follow these instructions, you must have
docker installed, permissions to run docker, and docker container network access
enabled. This step will create a runner image tagged as `openroad/flow`.
1.  Clone the OpenROAD-flow-scripts repository
```
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git
cd OpenROAD-flow-scripts
```
2. Ensure the docker daemon is running and `docker` is in your `PATH`, then run
the docker build:
```
./build_openroad.sh
```
3. Start an interactive shell in a docker container using your user credentials
```
docker run -it -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow/platforms:/OpenROAD-flow/flow/platforms:ro openroad/flow bash
```
4. Update your container environment
```
source ./setup_env.sh
```

To transfer files between your host system and container, it is often useful to
use [docker bind mounts](https://docs.docker.com/storage/bind-mounts/) instead.

#### Option 2: Local
1.  Clone the OpenROAD-flow-scripts repository
```
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git
cd OpenROAD-flow-scripts
```
2. Run the build script
```
./build_openroad.sh --local
```
3. Update your shell environment
```
source setup_env.sh
```

## Using the Flow
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

## About the Project
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

The [IDEA program](https://www.darpa.mil/program/intelligent-design-of-electronic-assets)
targets no-human-in-loop (NHIL) design, with 24-hour turnaround time and eventual
zero loss of power-performance-area (PPA) design quality. No humans means that
tools must adapt and self-tune, and never get stuck: thus, machine intelligence
must replace today's human intelligence within the layout generation process. 24
hours means that problems must be aggressively decomposed into bite-sized
subproblems for the design process to remain within the schedule constraint.
Eventual zero loss of PPA quality requires parallel and distributed search to
recoup the solution quality lost by problem decomposition.

## Citing this Work

If you use this software in any published work, we would appreciate a citation!
Please use the following references:

```
@article{ajayi2019openroad,
  title={OpenROAD: Toward a Self-Driving, Open-Source Digital Layout Implementation Tool Chain},
  author={Ajayi, T and Blaauw, D and Chan, TB and Cheng, CK and Chhabria, VA and Choo, DK and Coltella, M and Dobre, S and Dreslinski, R and Foga{\c{c}}a, M and others},
  journal={Proc. GOMACTECH},
  pages={1105--1110},
  year={2019}
}
```
A copy of this paper is available
[here](http://people.ece.umn.edu/users/sachin/conf/gomactech19.pdf) (PDF).
```
@inproceedings{ajayi2019toward,
  title={Toward an open-source digital flow: First learnings from the openroad project},
  author={Ajayi, Tutu and Chhabria, Vidya A and Foga{\c{c}}a, Mateus and Hashemi, Soheil and Hosny, Abdelrahman and Kahng, Andrew B and Kim, Minsoo and Lee, Jeongsup and Mallappa, Uday and Neseem, Marina and others},
  booktitle={Proceedings of the 56th Annual Design Automation Conference 2019},
  pages={1--4},
  year={2019}
}
```
A copy of this paper is availble
[here](https://vlsicad.ucsd.edu/Publications/Conferences/371/c371.pdf) (PDF).

If you like the tools, please give us a star on our GitHub repos!

## License
The OpenROAD-flow-scripts repository (build and run scripts) has a BSD 3-Clause License.
The flow relies on several tools, platforms and designs that each have their own
licenses:
- Find the tool license at: `OpenROAD-flow-scripts/tools/{tool}/` or
`OpenROAD-flow-scripts/tools/OpenROAD/src/{tool}/`
- Find the platform license at: `OpenROAD-flow-scripts/flow/platforms/{platform}/`
- Find the design license at: `OpenROAD-flow-scripts/flow/designs/src/{design}/`
