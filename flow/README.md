Building example design using Docker image
==========================================

The `or` script is used as a prefix to launch a command within the OpenROAD docker image.

This script is set up to run the OpenROAD GUI from
within the Docker image on the host platform.

Also, the current working directory is mapped into the Docker image using the current user's credentials.

Build docker image
------------------

First build the docker image:

```
cd OpenROAD-flow-scripts
sudo ./setup.sh
./build_openroad.sh
```

Build an example design and run the GUI:

```
cd flow
./or make
./or make gui_final
```
