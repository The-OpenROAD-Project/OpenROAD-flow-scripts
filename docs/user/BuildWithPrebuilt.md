# Build from sources using Prebuilt Binaries

You can download pre-built binaries with self contained dependencies
included from the Precision Innovations github repository
[here](https://github.com/Precision-Innovations/OpenROAD/actions/workflows/github-actions-build-deb-package.yml).

The following platforms are supported currently:
- Ubuntu 20.04/22.04
- Debian 10/11

Use following steps to download:

Step 1: Click on the [Precision Innovations Github releases link](https://github.com/Precision-Innovations/OpenROAD/releases).

Step 2: Download the artifacts for your distribution.

Step 3: Run the install command based on platform use package installer.
        For example Ubuntu 20.04 use:
```shell
sudo apt install ./openroad_2.0_amd64-ubuntu20.04.deb
```

You can install these binaries within docker as well.

> **Thanks** to [Precision Innovations](https://precisioninno.com) for providing
> and supporting this daily release of pre built installers to the community.


