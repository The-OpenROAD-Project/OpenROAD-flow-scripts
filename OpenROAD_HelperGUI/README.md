# OpenROAD GUI For Design Setup For Ubuntu

This repository provides a graphical user interface (GUI) for the OpenROAD flow, designed to streamline and simplify the process of setting up design and PDK files OpenROAD tools in an intuitive manner. It is intended to be run in an Ubuntu environment and uses **PyQt6** for the GUI.

## Features

- **Interactive GUI** for the OpenROAD flow with easy-to-use controls.
- **Real-time log output**: View OpenROAD tool logs and messages during execution.
- **Flow visualization**: Track the progress of the design process through visual feedback.
- **Customizable settings**: Configure tool settings such as the design library, technology file, and more.
- **Support for full OpenROAD flow**: Includes synthesis, placement, routing, and timing analysis.

## Prerequisites

Before using this GUI, ensure the following dependencies are installed:

1. **Ubuntu 20.04 or later**.
2. **OpenROAD flow tools**. You can install OpenROAD from the [official repository][(https://github.com/The-OpenROAD-Project/OpenROAD](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)).
3. **Python 3.x** and **PyQt6** for the GUI:

   ```bash
   sudo apt update && sudo apt upgrade -y && sudo apt install -y python3 python3-pip && pip install --upgrade pip && pip install PyQt6
   ```

## Installation

1. Clone this repository to your local machine in the "OpenROAD-flow-scripts/" Directory:
   ```bash
   rm -rf OpenROAD_HelperGUI && git clone https://github.com/BattusaiKuroKame/OpenROAD_HelperGUI.git
   ```

2. Install the required Python dependencies:
   ```bash
   cd OpenROAD_HelperGUI && pip3 install -r requirements.txt
   ```

3. Ensure OpenROAD tools are installed and properly set up in your system. Refer to the [OpenROAD documentation](https://openroad.readthedocs.io/) for setup instructions.

## Usage

1. Launch the GUI:
   ```bash
   python3 main.py
   ```

2. Once the GUI is open, you can:
   - Load your design files.
   - Configure tool parameters and settings.
   - Start the OpenROAD flow with a simple button click.
   - Monitor the process through real-time logs and progress updates.

3. Upon completion, you will be able to view the results and make any necessary adjustments to your design.

## Configuration

The GUI allows you to configure the following settings:
- **Design Files**: Input the design netlist and technology files.
- **OpenROAD Tools Configuration**: Set the paths to your OpenROAD installation and configure specific tool options.
- **Flow Options**: Select the individual OpenROAD flow steps to run (synthesis, placement, routing, etc.).

These options can be adjusted directly through the GUI interface.

## Troubleshooting

- Ensure that OpenROAD tools are correctly installed and accessible from the command line.
- Check that all required Python dependencies are installed by running:
  ```bash
  pip3 install -r ORHG/requirements.txt
  ```
- If any errors occur, refer to the **Log Output** section in the GUI for details on what might have gone wrong.

## License

This project is licensed under the **GPU License**. For more information, refer to the [LICENSE](LICENSE) file.


## Contributing

Contributions are welcome! If you have suggestions or improvements, feel free to fork the repository and submit a pull request. Ensure that your code follows the existing style and includes appropriate tests.

## Acknowledgements

- OpenROAD team for providing the OpenROAD flow tools.
- PyQt6 for the GUI framework.
- The open-source community for their continued support and contributions.
- **[Nishit Bayen](https://github.com/nishit0072e)** for his valuable guidance and expertise in the field.


--- 

This version reflects the use of **PyQt6** and the **GPU License**. If you need further adjustments, feel free to ask!
