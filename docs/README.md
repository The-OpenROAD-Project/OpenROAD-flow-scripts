# OpenROAD_7nm Physical Design Contest by VSD (VLSI System Design) 
The repository reflects my learnings and concepts I understood during the OpenROAD Design Contest. Details for the contest can be found on (https://www.openroaddesigncontest.org/)
#About OpenROAD and it's Flow Controllers (OpenROAD Flow Scripts and OpenLANE)

ORFS is a short form for OpenROAD Flow Scripts. OpenROAD flow scripts and OpenLANE are flow-controllers supported by the OpenROAD Design project repository.
ORFS provides a collection of open-source tools required for automating the digital design from synthesis to layout for complete RTL to GDSII flow, includes Synthesis, Placement and Routing (PnR), Static Timing Analysis (STA), Design Rule check (DRC) and Layout versus Schematic (LVS) check.

OpenROAD is a foundational application for building designs from complete RTL-to-GDSII flow which is built entirely on open-source tools for semiconductor digital designs. It is an integrated chip design which takes a design from synthesis, floorplanning, placement, routing, sign-off parasitic extraction, timing analysis leading to a final GDSII layout. It is also a tool that focuses on delivering autonomous, no-human intervention in-loop and 24 hour turnaround for RTL to GDSII for design exploration and physical design implementation. The placement algorithm works on minimizing the wire length, improving the timing, area and power consumption. Since it’s an open-source design, it allows the users to add their own algorithm if optimized and update more features to it.

Before moving ahead to the OpenROAD and it's usage, let's understand the processes carried out in the VLSI Physical Design Flow.
![image](https://user-images.githubusercontent.com/114659084/228913886-d52ecd74-94ae-4a71-b96d-03b6d8cc47ce.png)

#The Design Flow and Tools utilized in OpenROAD Flow Scripts:

Verilog is used as a basic input method to do the design entries for any specific design project.
And once ORFS is installed, we can specify the design parameters like technology node, the design constraints and tools settings to meet the user’s design projects.
And then, for Synthesis to Layout process, below tools were used,

    .Yosys and ABC for Synthesis
    .Capo and RePIAce for Floorplanning
    .OpenROAD for Placement, which is also a plugin for Physical Design Stage, that can be configured and customized to meet specific design projects
    .FastRoute and TritonRoute for Routing purpose
    .OpenRCX for Parasitic Extraction, a PEC extraction tool used to extract the Resistance and Capacitance of wires, based on coupling distance to the nearest wire and track density over/under the wire of interest, as well as abstracts. OpenRCX can also generate an '.spef' file
    .Magic for layout corrections and layout verification
    .Magic and kLayout for final GDSII Layout file

More details on the OpenROAD flow design can be found here.
The tutorial to run the complete flow from RTL to GDSII using OpenROAD flow scripts can be found here.
#Installation of ORFS tool on your system

You can also find the resource for the steps of installation here. I have demonstrated the steps I took for installation below.
I use Windows by default on my system. But, Since ORFS Supports Linux based systems, I have downloaded and configured the Ubuntu 22.04 OS on a Virtual machine platform called Virtual Box.
Other supported Linux based OS are Centos7, Ubuntu 20.04, Ubuntu 22.04, RHEL 8, Debian 10 and Debian 11. To correctly install the dependencies with the script you need to run as root or prepend sudo to the commands below.

After logging to the Ubuntu 22.04 OS, follow the below steps,
Clone Repository of ORFS

git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts

Change directory to the ORFS folder and install all the dependencies using the script.
The script installs all the required dependencies and packages for the OpenROAD flow.

cd OpenROAD-flow-scripts
sudo ./etc/DependencyInstaller.sh

Now, for CentOS 7 users, run below two commands before moving to further to build an openroad script.

source /opt/rh/devtoolset-8/enable
source /opt/rh/llvm-toolset-7.0/enable

    Note: If you are Ubuntu or Debian OS versions, skip the above steps.

Next is to build and install the OpenROAD tool

./build_openroad.sh --local

To verify the installation, you can run below and check

source ./setup_env.sh
yosys -help
openroad -help
exit

    Note: Every time when you open the new terminal, you need to source the setup_env.sh file
#Directory Structure and File Formats in OpenROAD Flow Scripts:

It is recommended strictly to not rename any files and directories in the OpenROAD-flow-scripts directory as it may give compilation errors in future. You can add new designs inside the "flow" directory with the required directory structures. I will give a brief overview of the directories inside ORFS -

    .docker - For the docker based installation, it has a Dependency Installer Script which installs all the required tools and packages for ORFS design.
    .docs - It contains basis documentation or tutorial for the flow. Here is a direct link for the Flow Tutorial
    .flow - Contains all the required files responsible to compile complete RTL to GDSII flow including Floorplanning, Placement, Clock Tree Synthesis, Routing, Static Timing Analysis (STA), Design Rule Check (DRC), Layout vs Schematic (LVS) and Parasitic Extraction.
    .etc - This is a main directory when it comes to new installation of ORFS. It contains a Dependency Installer, which takes care all the installation resources for design.
    .jenkins - Contains the regression test files for build updates.
    .tools - Contains all the required tools for running complete RTL to GDSII flow as listed above.
    .setup_env.sh - This is a source file which sources all the openroad tools to run full RTL to GDSII flow.
    .build_openroad.sh - To build the openroad tools.

#Updating OpenROAD Flow Scripts

Keeping the repository up-to-date is better as it keeps changing and updating by the contributors for improvements and optimization of the tool scripts

cd OpenROAD-flow-scripts
git checkout master
git pull
git submodule update
./build_openroad.sh --local --clean
#How to run the processor designs with desired supported PDKs to perform the RTL to GDSII flow?

OpenROAD has made it way easier to run the designs for testing the performance metrics of any design. You just need to modify the MakeFile in the flow directory. There are several designs already present in the Makefile configured for running on different supported PDKs. The default PDK is set as 'NANGATE45' to run the 'gcd' processor design.
To run the design, simply enter below command,

make

If you wish to run some other design with different PDK, you can comment the default NANGATE45 based design line 'DESIGN_CONFIG ?= ./designs/nangate45/gcd/config.mk' as below,

#DESIGN_CONFIG ?= ./designs/nangate45/gcd/config.mk

And uncommment the design you wish to run to perform the full RTL to GDSII flow for the same.
For example, if I want to run 'swerv_wrapper' processor using 'TSMC65LP' PDK Uncomment the line 'DESIGN_CONFIG=./designs/tsmc65lp/swerv_wrapper/config.mk' in the Makefile.

# DESIGN_CONFIG=./designs/tsmc65lp/jpeg/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/swerv/config.mk
DESIGN_CONFIG=./designs/tsmc65lp/swerv_wrapper/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/tinyRocket/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/vanilla5/config.mk

And then run make. That's it.

In my case, I have ran the default NANGATE45 based design. It took around 2 to 5 minutes only for me to perform full RTL to GDSII flow and got the results as below,

[INFO] Writing out GDS/OAS 'results/nangate45/gcd/base/6_1_merged.gds'
Elapsed time: 0:03.35[h:]min:sec. CPU time: user 1.18 sys 0.94 (63%). Peak memory: 373444KB.
cp results/nangate45/gcd/base/6_1_merged.gds results/nangate45/gcd/base/6_final.gds

In the flow directory, if you open the Makefile, you will see all the designs and platforms along with the complete RTL to GDS2 flow with each step. If you wish to manually run any stage of physical design, for example - If I wish to run only synthesis for the sky130hd gcd design, run the below command.

make DESIGN_CONFIG=./designs/sky130hd/gcd/config.mk synth

To run Floorplan for the same design, run below

make DESIGN_CONFIG=./designs/sky130hd/gcd/config.mk floorplan

Similarly, we can run place, cts, route, finish

Now, in OpenROAD design contest, we are supposed to optimize the OpenROAD runtime and scripts to improve the performance. So, if we made any changes in any config file or any other code/scripts/tools in the ORFS design, hoping to see the changes in the parameters after running the same design to see the improvement. We can try running the same scrips above to see improvements or changes in each stage manually or we can run complete RTL to GDS2 flow (as per user's preference). For eg. To check the improvements in Floorplan of a design, we can run the same command.

make DESIGN_CONFIG=./designs/sky130hd/gcd/config.mk floorplan

However, it may throw an make error as below.

make: Nothing to be done for 'floorplan'

If you get the above error, you can clean the makefile logs for that design by running below command.

make clean_all DESIGN_CONFIG=<path>

That is,

make clean_all DESIGN_CONFIG=./designs/sky130hd/gcd/config.mk
How to run the processor designs with desired supported PDKs to perform the RTL to GDSII flow?

OpenROAD has made it way easier to run the designs for testing the performance metrics of any design. You just need to modify the MakeFile in the flow directory. There are several designs already present in the Makefile configured for running on different supported PDKs. The default PDK is set as 'NANGATE45' to run the 'gcd' processor design.
To run the design, simply enter below command,

make

If you wish to run some other design with different PDK, you can comment the default NANGATE45 based design line 'DESIGN_CONFIG ?= ./designs/nangate45/gcd/config.mk' as below,

#DESIGN_CONFIG ?= ./designs/nangate45/gcd/config.mk

And uncommment the design you wish to run to perform the full RTL to GDSII flow for the same.
For example, if I want to run 'swerv_wrapper' processor using 'TSMC65LP' PDK Uncomment the line 'DESIGN_CONFIG=./designs/tsmc65lp/swerv_wrapper/config.mk' in the Makefile.

# DESIGN_CONFIG=./designs/tsmc65lp/jpeg/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/swerv/config.mk
DESIGN_CONFIG=./designs/tsmc65lp/swerv_wrapper/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/tinyRocket/config.mk
# DESIGN_CONFIG=./designs/tsmc65lp/vanilla5/config.mk

And then run make. That's it.

In my case, I have ran the default NANGATE45 based design. It took around 2 to 5 minutes only for me to perform full RTL to GDSII flow and got the results as below,

[INFO] Writing out GDS/OAS 'results/nangate45/gcd/base/6_1_merged.gds'
Elapsed time: 0:03.35[h:]min:sec. CPU time: user 1.18 sys 0.94 (63%). Peak memory: 373444KB.
cp results/nangate45/gcd/base/6_1_merged.gds results/nangate45/gcd/base/6_final.gds

In the flow directory, if you open the Makefile, you will see all the designs and platforms along with the complete RTL to GDS2 flow with each step. If you wish to manually run any stage of physical design, for example - If I wish to run only synthesis for the sky130hd gcd design, run the below command.

make DESIGN_CONFIG=./designs/sky130hd/gcd/config.mk synth

To run Floorplan for the same design, run below

make DESIGN_CONFIG=./designs/sky130hd/gcd/config.mk floorplan

Similarly, we can run place, cts, route, finish

Now, in OpenROAD design contest, we are supposed to optimize the OpenROAD runtime and scripts to improve the performance. So, if we made any changes in any config file or any other code/scripts/tools in the ORFS design, hoping to see the changes in the parameters after running the same design to see the improvement. We can try running the same scrips above to see improvements or changes in each stage manually or we can run complete RTL to GDS2 flow (as per user's preference). For eg. To check the improvements in Floorplan of a design, we can run the same command.

make DESIGN_CONFIG=./designs/sky130hd/gcd/config.mk floorplan

However, it may throw an make error as below.

make: Nothing to be done for 'floorplan'

If you get the above error, you can clean the makefile logs for that design by running below command.

make clean_all DESIGN_CONFIG=<path>


make clean_all DESIGN_CONFIG=./designs/sky130hd/gcd/config.mk
#OpenROAD GUI

To see the GUI interface of every stage of Physical Design for a particular design in OpenROAD, we can use the GUI command.

For Floorplan GUI, run below command

make gui_floorplan
![gui_riscv](https://user-images.githubusercontent.com/114659084/228919345-7e677cc3-78b4-41cf-b99f-4a5a5ff27fb1.png)
#Viewing reports using the TCL commands in OpenROAD GUI

The main metrics that needs to be considered in a design performance and functionality are,

    .Area - Lower the area, better is the design.
    .Power consumption - Lower the power consumed in such a low-power design, better the design.
    .Timing - (Target -> Worst Negative Slack = O)

Negative Slack: A negative slack occurs when the actual delay of the signal exceeds the expected delay, i.e., the actual arrival time follows the required arrival time. The presence of negative slack indicates that the design is unable to operate at the specified clock frequency.

Worst negative slack (WNS): If WNS is positive then it means that the path passes. If it is negative, then it means the path fails

Total negative slack (TNS): It is the sum of the (real) negative slack in your design. If 0, then the design meets timing. If it is a positive number, then it means that there is negative slack in the design (hence your design fails). It cannot be negative.

To view reports for the same, run the below TCL commands in OpenROAD GUI in the section below,

report_worst_slack
report_tns
report_wns

In my case, the results for 'Nangate45' based 'gcd' design are as below

worst slack -0.08
tns -1.30
wns -0.08

    Any slack value that comes negative, indicates that the design is not meeting the timings and tends to make timing violations.

To see the power utilization report, run below.

report_power

In my case, the reported power is as below,

Group                  Internal  Switching    Leakage      Total
                          Power      Power      Power      Power (Watts)
----------------------------------------------------------------
Sequential             4.50e-04   5.99e-05   3.16e-06   5.13e-04  32.5%
Combinational          5.59e-04   4.96e-04   9.98e-06   1.06e-03  67.5%
Macro                  0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
Pad                    0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
----------------------------------------------------------------
Total                  1.01e-03   5.56e-04   1.31e-05   1.58e-03 100.0%
                          63.9%      35.2%       0.8%

To see the Area utilization report, run below.

report_design_area

In my case, the reported area is as below,

Design area 580 u^2 65% utilization.
#KLAYOUT Visualization
![image](https://user-images.githubusercontent.com/114659084/228921545-87706e36-7595-4995-83fb-07ca709030c2.png)


KLayout is a CAD software user to view and print the finalized GDSII file for printing purpose using lithography. It is an open-source platform which takes the final GDS2 layout files and gives the user an interactive visual view of final design. KLayout is used in the OpenROAD flow to provide GDS merging, DRC, and LVS.

After running the full RTL to GDSII flow using ORFS, you can open the design on klayout using below command

klayout -e -nn ./platforms/nangate45/FreePDK45.lyt -l ./platforms/nangate45/FreePDK45.lyp ./results/nangate45/gcd/base/6_final.gds

It will open the file as below. image
#Running the design using Autotuner for further optimization of PPA (Performance, Power and Area)

Autotuner is a parameter tuning tool that provides the best design parameters after running the RTL to GDSII flow withouit any human intervention. It is a JSON file where users can configure the values to the parameters for improvement of the design. AutoTuner also utilizes METRICS2.1 to capture PPA of individual search trials. It runs the designs on python 3.9 scripts.

AutoTuner provides two main functionalities as follows.

    Automatic hyperparameter tuning framework for OpenROAD-flow-script (ORFS)
    Parametric sweeping experiments for ORFS

#Installing Autotuner for ORFS

Autotuner compulsorily supports on python 3.9 as of now. Without installing python 3.9, the autotuner would not run.

    To install 'Python 3.9', run below commands

    $ sudo add-apt-repository ppa:deadsnakes/ppa $ sudo apt update $ sudo apt install python3.9

    Install 'pip3.9',

    $ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py $ python3.9 get-pip.py

If you get the below error

ModuleNotFoundError: No module named 'distutils.util'

Run below command,

sudo apt install python3.9-distutils

#Running Autotuner Tool for any desired design.

All the designs should be ran from 'Openroad-flow-scripts/flow/util' directory.

Then to run the Autotuner, run

python3.9 distributed.py --design gcd --platform sky130hd --config ../designs/sky130hd/gcd/autotuner.json tune

2023-03-25 19:35:30,314	INFO tune.py:639 -- Total run time: 202.24 seconds (202.02 seconds for the tuning loop).

After completion, it will store the result of the best parameters to autotuner based JSON file.

[INFO TUN-0002] Best parameters found: {'_SDC_CLK_PERIOD': 1.8959980960818625, 'CORE_UTILIZATION': 47, 'CORE_ASPECT_RATIO': 1.5650317306962374, 'CORE_MARGIN': 2, 'CELL_PAD_IN_SITES_GLOBAL_PLACEMENT': 3, 'CELL_PAD_IN_SITES_DETAIL_PLACEMENT': 1, '_FR_LAYER_ADJUST': 0.41994687571365186, 'PLACE_DENSITY_LB_ADDON': 0.6595883330590898, '_PINS_DISTANCE': 2, 'CTS_CLUSTER_SIZE': 187, 'CTS_CLUSTER_DIAMETER': 139, '_FR_GR_OVERFLOW': 1}
(save_best pid=28832) [INFO TUN-0003] Best parameters written to /home/kunal/OpenROAD-flow-scripts/flow/logs/sky130hd/gcd/tes

