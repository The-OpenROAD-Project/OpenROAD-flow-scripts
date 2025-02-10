# OpenROAD Docker Quickstart Guide

# Setup Guide

The easiest method for running the OpenROAD flow scripts (ORFS) on a cloud machine is through a Docker container, which doesn’t require any code compilation. We suggest running a Ubuntu 22.04 or Red Hat Enterprise Linux 8 image with at least 32 CPUs, 128 GB memory, and 500 GB disk.

The cloud machine serves three purposes:

1. Hosts the Docker container  
2. Hosts the persistent filesystem for the results of your OpenROAD runs  
3. Enables you to view the OpenROAD results through the OpenROAD GUI

# Host Machine Setup Requirements

Running the OpenROAD flow a Docker container requires a few software packages to be installed on the cloud machine:

- [Docker (or Podman)](DockerORPackageQuickstart.md#docker-installation)
- [Podman-docker](DockerORPackageQuickstart.md#podman-docker-installation) (if using Podman)  
- [VNC](DockerORPackageQuickstart.md#vnc-installation)  
- [XHost access](DockerORPackageQuickstart.md#xhost-access)  
- [Git](DockerORPackageQuickstart.md#git-installation) (RHEL only)

If these packages are already installed on your cloud machine, you are ready to run ORFS. Otherwise, please follow the instructions in the links above to install the packages.

# Choosing The ORFS Version

See the [Choosing The ORFS Version](DockerORPackageQuickstart.md#choosing-the-orfs-version) section for instructions on how to choose an ORFS version and create your workspace.

# OpenROAD Execution

## Using Docker Shell

The ORFS tools provide a utility called docker\_shell, which can be used to execute commands within a Docker container. The script is located in flow/utils/docker\_shell under the ORFS root directory.

To execute our Docker container as a shell, we can run the following command on our cloud machine:

```
cd flow  
export OR_IMAGE=openroad/orfs:v3.0-2144-gd8465608  
util/docker_shell <shell_command>
```

We use the OR\_IMAGE environment variable to tell docker\_shell which version of ORFS we want to run. Then we can run docker\_shell with the shell command we want to execute within the container, which allows us to run the ORFS flow just like if it was installed on your cloud machine.

Note that on RHEL, you might need to include the location of the docker repository in the OR\_IMAGE environment variable:

```
export OR_IMAGE=docker.io/openroad/orfs:v3.0-2144-gd8465608
```

## Running OpenROAD

The ORFS flow leverages “make” to define the flow variables that control the flow and manages the tool execution based on dependencies. To build all stages for the IBEX design on the ASAP7 platform, execute:

```
./util/docker_shell make DESIGN_CONFIG=designs/asap7/ibex/config.mk
```

All of the data is stored in the flows directory in the following sub-directories:

- results: contains the ORFS generated databases and design files  
- logs: contains the ORFS stage log files  
- reports: contains the ORFS stage reports

## Running the OpenROAD GUI

To run the OpenROAD GUI to view the final stage results:

```
./util/docker_shell make DESIGN_CONFIG=designs/asap7/ibex/config.mk gui_final
````

You can explore the design hierarchy, heat maps, clock tree, and timing reports directly from within the GUI.

# References

OpenROAD-flow-scripts documentation: [link](https://openroad-flow-scripts.readthedocs.io/en/latest/index2.html)  
OpenROAD-flow-scripts tutorial: [link](https://openroad-flow-scripts.readthedocs.io/en/latest/tutorials/FlowTutorial.html)  
OpenROAD-flow-scripts GUI tutorial: [link](https://openroad-flow-scripts.readthedocs.io/en/latest/tutorials/FlowTutorial.html#openroad-gui)