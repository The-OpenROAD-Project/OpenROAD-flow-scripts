Building example design using Docker image
==========================================

The `docker_shell` script is used to launch a command using a OpenROAD-flow-scripts docker image.

Also, the current working directory is mapped into the Docker image using the current user's credentials.

Build docker image
------------------

You can skip this step if you would like to use the latest version from the master
branch. If you are developing ORFS/OR, you should build your own image.

```
cd OpenROAD-flow-scripts
./build_openroad.sh
```

Run ORFS using `docker_shell`
-----------------------------

Build an example design and run the GUI:

```
cd flow
util/docker_shell make
util/docker_shell make gui_final
```

You can also launch an interactive bash session:

```
util/docker_shell bash
```

If you need to use a different Docker image than default, override by using the `docker_shell_IMAGE`
environment variable:

```
OR_IMAGE=openroad/orfs:v1234 util/docker_shell make
```

If you have built your OpenROAD Docker image using prebuilt binaries,
you might want to source custom paths for your modules as follows.

```
OR_IMAGE=openroad_prebuilt_image YOSYS_EXE=/oss-cad-suite/bin/yosys util/docker_shell make
```

Using `docker_shell` from outside of `OpenROAD-flow-scripts/flow` folder
------------------------------------------------------------------------

If you have designs you are keeping in a git source repository that is not
a fork of the OpenROAD-flow-scripts git repository, you can still use
the `docker_shell` script.

Two ways to use `docker_shell`

1. Simply invoke it from the ORFS location.
2. Copy the script into your source folder. This would allow you
   to build and publish a Docker image to a private Docker repository
   and lock the ORFS version to the version of your source code. This
   gives you a way to deploy updates of ORFS
   easily, publish a new Docker image, modify the copy of `docker_shell`
   and create a pull request to possibly test your upgrade on your private
   build serves.
