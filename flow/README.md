
## OpenROAD-flow
![alt text](docs/flow.png "flow")

## Quick Start
```
# Clone the repository and submodules
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow

# Build the OpenROAD app
cd OpenROAD
make

# Setup your environment
source setup_env.sh

# Implement the example gcd design
cd flow
make
```
The resulting GDS will be available at `flow/results/nangate45/gcd/6_final.gds`

## Setting up the Flow

1. Clone the repository
```
git clone https://github.com/The-OpenROAD-Project/OpenROAD-flow
cd OpenROAD-flow/flow
```
2. The `openroad` app must be setup to implement designs or run tests. See setup
   instructions in the repository [README](../README.md#Setup)
3. Setup your shell environment. If the tools are built locally using the setup
   [instructions](../README.md#Setup), you can run `source setup_env.sh`

## Designs
Sample design configurations are available in the `designs` directory. You can
select a design using either of the following methods:
1. The flow [Makefile](Makefile) contains a list of sample design configurations
   at the top of the file. Uncomment the respective line to select the design
2. Specify the design using the shell environment, e.g.
   `make DESIGN_CONFIG=./designs/nangate45/swerv.mk` or
   `export DESIGN_CONFIG=./designs/nangate45/swerv.mk; make`
By default, the simple design gcd is selected. We recommend implementing this
design first to validate your flow and tool setup.

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
At this time, we recommend looking at the [Nangate45](platforms/nangate45) as an
example of how to set up a new platform for OpenROAD-flow.

## Implement the Design
Run `make` to perform Verilog to GDS. The final output will be located at
`flow/results/{platform}/{design_name}/6_final.gds`

## Miscellaneous
### tiny-tests - easy to add, single concern, single Verilog file

The tiny-tests are have been designed with two design goals in mind:

1. It should be trivial to add a new test: simply add a tiny standalone
   Verilog file to `OpenROAD-flow/flow/designs/src/tiny-tests`
2. Each test should be as small and as standalone as possible and be a single
   concern test.

To run a test:

```
make DESIGN_NAME=SmallPinCount DESIGN_CONFIG=`pwd`/designs/tiny-tests.mk
```

### nangate45 smoke-test harness for top level Verilog designs

1. Drop your Verilog files into designs/src/harness
2. Start the workflow:

```
make DESIGN_NAME=TopLevelName DESIGN_CONFIG=`pwd`/designs/harness.mk
```

TIP! Start with a small tiny submodule in your design with few pins
