
## Testing Layout
![alt text](docs/flow.png "flow")

## Running the Flow
1. Clone the repository
```
git clone https://github.com/The-OpenROAD-Project/alpha-release
cd alpha-release/flow
```
2. An OpenROAD release must be setup to run the tests. More info in the build [README](../build/README.md)
3. Run `make` to peform verilog to gds. This will run the default gcd_nangate45 test which runs very quickly

## Selecting a testcase
Sample desgin configurations are available in the `designs` directory. After running the default test to validate, you can select a new test using either of the following methods:
1. Update the top of the Makefile to point to a design configuration file. Simply uncomment the testcase of interest to overwrite the default test
2. When running any make commands, specify the design of interest. e.g. `make DESIGN_CONFIG=./designs/swerv_nangate45.mk`
3. Export the `DESIGN_CONFIG` variable in your shell (e.g. `export DESIGN_CONFIG=./designs/swerv_nangate45.mk`) and all subsequent commands will use that design. 


## Adding new platforms
The flow runs all of the steps sequentially to achieve Verilog to GDS. There is an initial platform setup required in order to use the OpenROAD flow. This has already been performed for the Nangate45 and TSMC65LP (under NDA so not in the alpha-release git repository) platforms. See sample platforms setup in the `platforms` directory.

Once the platform is setup. Create a new design configuration with information about the design.  See sample configurations in the `design` directory

Also refer to the [known issues and limitations documents](docs/Known%20Issues%20and%20Limitations.pdf) for information on conditioning your design/files for the flow

## Miscellenous
### tiny-tests - easy to add, single concern, single Verilog file

The tiny-tests are have been designed with two design goals in mind:

1. It should be trivial to add a new test: simply add a tiny standalone
   Verilog file to alpha-release/flow/designs/src/tiny-tests
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


