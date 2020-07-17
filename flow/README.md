
## OpenROAD-flow
![alt text](docs/flow.png "flow")
<!-- Original source at: https://docs.google.com/drawings/d/1XGPD7g_X3Pna87XtBf6EB_kCXerGPSeKEWGPO_Q-Sb4 -->

## Quick Start
1. Follow the installation instructions in the top-level
[README](../README.md#installation)
2. Build an example design
```
cd flow
make
```
This will build an example design `gcd` using the `nangate45` platform. The
resulting GDS will be available at `flow/results/nangate45/gcd/6_final.gds`. The
flow should take only a few minutes to produce a GDS.

## Designs
Sample design configurations are available in the `designs` directory. You can
select a design using either of the following methods:
1. The flow [Makefile](Makefile) contains a list of sample design configurations
   at the top of the file. Uncomment the respective line to select the design
2. Specify the design using the shell environment, e.g.
   `make DESIGN_CONFIG=./designs/nangate45/swerv.mk` or
   `export DESIGN_CONFIG=./designs/nangate45/swerv.mk; make`
By default, the simple design `gcd` is selected. We recommend implementing this
design first to validate your tool and flow setup.

### Adding a New Design
To add a new design, we recommend looking at the included designs for examples
of how to set one up.

:warning: Please refer to the known issues and limitations
[document](docs/Known%20Issues%20and%20Limitations.pdf) for information on
conditioning your design/files for the flow. We are working to reduce the issues
and limitations, but it will take time.


## Platforms
OpenROAD-flow supports Verilog to GDS for the following open platforms:
* Nangate45 / FreePDK45

These platforms have a permissive license which allows us to redistribute the
PDK and OpenROAD platform-specific files. The platform files and license(s) are
located in `platforms/{platform}`.

OpenROAD-flow also supports the following commercial platforms:
* TSMC65LP
* GF14 (in progress)

The PDKs and platform-specific files for these kits cannot be provided due to
NDA restrictions. However, if you are able to access these platforms, you can
create the necessary platform-specific files yourself.

Once the platform is setup. Create a new design configuration with information
about the design. See sample configurations in the `design` directory.


### Adding a New Platform
At this time, we recommend looking at [`nangate45`](platforms/nangate45) as an
example of how to set up a new platform for OpenROAD-flow.

## Implement the Design
Run `make` to perform Verilog to GDS. The final output will be located at
`flow/results/{platform}/{design_name}/6_final.gds`

TIP! Start with a small tiny submodule in your design with few pins
