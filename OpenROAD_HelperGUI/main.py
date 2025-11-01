import sys
import os
import shutil
import requests
import re
import json
from PyQt6.QtWidgets import QLineEdit,QApplication,QDialog,QFileDialog,QGraphicsDropShadowEffect, QMainWindow, QTextEdit, QSplitter, QVBoxLayout, QHBoxLayout, QPushButton, QComboBox, QLabel, QWidget
from PyQt6.QtCore import Qt,QProcess,QProcessEnvironment  # Import Qt for alignment
from PyQt6.QtGui import QIcon

filepath = ""
comStart = "cd .. && cd flow && "
comEnd = "&& cd .. && cd OpenROAD_HelperGUI"

def command(command:str):
    return comStart + command + comEnd

#Settings Window
class SettingsWindow(QDialog):

    themes = []

    def reposition(self,parent=None):
        """Center the settings window relative to the main window."""
        parent_geometry = parent.geometry()
        x = parent_geometry.x() + (parent_geometry.width() - self.width()) // 2
        y = parent_geometry.y() + (parent_geometry.height() - self.height()) // 2
        self.move(x, y)

    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle("Settings")
        self.setGeometry(150, 150, 300, 200)

        # self.setSizePolicy(QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Minimum)
        # self.setMinimumSize(200, 100)  # Set a reasonable minimum size
        # self.adjustSize()  # Adjust size dynamically

        # Apply shadow effect
        shadow = QGraphicsDropShadowEffect(self)
        shadow.setBlurRadius(15)
        shadow.setXOffset(0)
        shadow.setYOffset(0)
        shadow.setColor(Qt.GlobalColor.black)
        self.setGraphicsEffect(shadow)
        self.reposition(parent)
        # if parent:  # Ensure we have a parent window
        #     parent_geometry = parent.geometry()
        #     x = parent_geometry.x() + (parent_geometry.width() - self.width()) // 2
        #     y = parent_geometry.y() + (parent_geometry.height() - self.height()) // 2
        #     self.move(x, y)

        

        layout = QVBoxLayout()
        layout.setAlignment(Qt.AlignmentFlag.AlignTop)  # Align contents to the top

        # Theme Selection
        self.theme_label = QLabel("Select Theme:")
        self.theme_dropdown = QComboBox()

        #Load Settings from file
        with open(filepath+"settings.json",'r') as file:
            data = json.load(file)

        self.themes = data["themes"]

        self.theme_dropdown.addItems([theme["name"] for theme in data["themes"]])
        self.theme_dropdown.currentTextChanged.connect(self.change_theme)  # Apply theme on selection change
        # self.theme_dropdown.move(self.theme_dropdown.currentIndex(),0)
                    
        # self.theme_dropdown.removeItem(self.theme_dropdown.currentIndex)
        # self.theme_dropdown.move(self.theme_dropdown.currentIndex,0)
        layout.addWidget(self.theme_label)
        layout.addWidget(self.theme_dropdown)

        # # Apply and Close Buttons
        # self.apply_button = QPushButton("Apply")
        # self.apply_button.clicked.connect(self.apply_settings)

        self.update_button = QPushButton("Display Update Command")
        self.update_button.clicked.connect(self.updateGUI)
        self.update_button.setToolTip("Update to latest version")
        layout.addWidget(self.update_button)

        # self.close_button = QPushButton("Close")
        # self.close_button.clicked.connect(self.close)

        # layout.addWidget(self.apply_button)
        # layout.addWidget(self.close_button)

        self.setLayout(layout)

    def updateGUI(self):
        # self.parent().run("rm -rf temp_repo && git clone https://github.com/BattusaiKuroKame/OpenROAD_HelperGUI.git temp_repo && cp -r temp_repo/* temp_repo/.[!.]* . ")
        # self.parent().log("UPDATED")

        command = "rm -rf OpenROAD_HelperGUI && git clone https://github.com/BattusaiKuroKame/OpenROAD_HelperGUI.git"

        self.parent().log("\nUpdate Command"+"\n"+command +"\n\nRun this command in the 'OpenROAD-flow-scripts/' Directory")



    def change_theme(self):
        """Apply settings and update the main window"""
        theme = self.theme_dropdown.currentText()

        for el in self.themes:
            if el["name"] == theme:
                self.parent().setStyleSheet(el["data"])

        #Load Settings from file
        with open(filepath+"settings.json",'w+') as file:
            # print(data)

            for el in self.themes:
                if el["name"] == theme:
                    sel = el
            self.themes.insert(0,self.themes.pop(self.themes.index(sel)))
            # print(self.themes)
            data = {}
            data["themes"] = self.themes
            json.dump(data,file,indent=4)
        
        self.parent().log("Theme Applied!")
        # print("Settings Applied!")  # Debugging message

class ColorBox(QLabel):
    def __init__(self):
        super().__init__()
        # self.setFixedSize(100, 100)
        self.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.setStyleSheet("background-color: white; border: 1px solid black;")

    def setColor(self,col = "white"):
        self.setStyleSheet(f"background-color: {col}; border: 1px solid black;")

# Widget to display log messages
class LogWidget(QWidget):
    def __init__(self,main_window):
        super().__init__()
        self.main_window = main_window
        self.log = main_window.log  # Reference to main app's log method

        # self.main_window = main_window
        self.layout = QVBoxLayout()
        # Text area for log messages
        self.log_display = QTextEdit()
        self.log_display.setReadOnly(True)  # Make it read-only
        
        self.layout.addWidget(self.log_display)

        # Horizontal layout for input and button
        # Input field and Run button
        input_layout = QHBoxLayout()
        self.input_box = QLineEdit()
        self.reset_path_button = QPushButton("Reset Path")
        input_layout.addWidget(self.input_box,9)
        input_layout.addWidget(self.reset_path_button,1)

        self.layout.addLayout(input_layout)

        #ColorBox
        self.indicator = ColorBox()
        self.layout.addWidget(self.indicator)
        self.setLayout(self.layout)

        # Connect the Run button
        self.input_box.returnPressed.connect(self.handle_run_clicked)
        self.reset_path_button.clicked.connect(self.handle_reset_clicked)

    def handle_run_clicked(self,):
        cmd = self.input_box.text().strip()
        self.main_window.run(cmd)
        self.input_box.clear()

    def handle_reset_clicked(self):
        cmd = "cd "+ self.main_window.path
        self.main_window.run(cmd)
        

        
    # Method to append log messages
    def append_log(self, message):
        self.log_display.append(message)

# Widget for configuration controls
class ConfigWidget(QWidget):
    def __init__(self,main_window):
        super().__init__()
        self.main_window = main_window
        self.log = main_window.log  # Reference to main app's log method
        
        self.current_file = None
        self.imported_design = None  # Store the last imported design name
        self.layout = QVBoxLayout()
        self.layout.setAlignment(Qt.AlignmentFlag.AlignTop)

        repo_name = "BattusaiKuroKame/OpenROAD_HelperGUI"
        with open(filepath+"settings.json","r") as file:
            data = json.load(file)
            self.version = data["version"]

        aVersion = self.check_latest_version(repo_name, self.version)

        if self.version != aVersion:
            comm = f"\nnewer version {aVersion} is available"
        else:
            comm = ""

        # Version
        self.versionLabel = QLabel(f"{self.version}{comm}")
        self.versionLabel.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.layout.addWidget(self.versionLabel)
        
        # Settings Button
        self.settings_button = QPushButton("⚙ Settings")
        self.settings_button.clicked.connect(self.open_settings)
        self.layout.addWidget(self.settings_button)
        
        self.setup = QLabel("Setup")
        self.setup.setAlignment(Qt.AlignmentFlag.AlignHCenter)
        self.layout.addWidget(self.setup)

        # Select PDK (Dropdown)
        self.pdk_label = QLabel("Select PDK:")
        self.pdk_dropdown = QComboBox()
        self.populate_pdk_dropdown()
        self.pdk_dropdown.currentTextChanged.connect(self.pdk_changed)
        self.pdk_dropdown.setToolTip("Select one from available PDKs")
        self.layout.addWidget(self.pdk_label)
        self.layout.addWidget(self.pdk_dropdown)

        self.pdk = self.pdk_dropdown.currentText()
        
        # Imported Design Label
        self.imported_design_label = QLabel("Imported Design: None")
        self.layout.addWidget(self.imported_design_label)
        
        # Import Design Button
        import_layout = QHBoxLayout()
        self.import_design_button = QPushButton("Import Design")
        self.import_design_button.clicked.connect(self.import_design)
        self.import_design_button.setToolTip("Select you design from disk")

        self.reset_import_button = QPushButton("↺")
        self.reset_import_button.clicked.connect(self.reset_import)
        self.reset_import_button.setToolTip("Reset import")

        import_layout.addWidget(self.import_design_button,9)
        import_layout.addWidget(self.reset_import_button,1)
        self.layout.addLayout(import_layout)
        
        # Config Buttons (Edit & Reset in same row)
        config_layout = QHBoxLayout()
        self.config_button = QPushButton("Edit config.mk")
        self.config_button.clicked.connect(lambda: self.edit_file("config.mk"))
        self.config_button.setToolTip("Edit the Config File")

        # self.reset_config_button = QPushButton("Reset config.mk")
        self.reset_config_button = QPushButton("↺")
        self.reset_config_button.clicked.connect(self.reset_config)
        self.reset_config_button.setToolTip("Reset the Config File to default")

        config_layout.addWidget(self.config_button,9)
        config_layout.addWidget(self.reset_config_button,1)
        self.layout.addLayout(config_layout)
        
        # Constraints Buttons (Edit & Reset in same row)
        constraints_layout = QHBoxLayout()
        self.constraints_button = QPushButton("Edit constraint.sdc")
        self.constraints_button.clicked.connect(lambda: self.edit_file("constraint.sdc"))

        self.reset_constraint_button = QPushButton("↺")
        self.reset_constraint_button.clicked.connect(self.reset_constraint)
        self.reset_constraint_button.setToolTip("Reset the Constraint File to default")

        constraints_layout.addWidget(self.constraints_button,9)
        constraints_layout.addWidget(self.reset_constraint_button,1)
        self.layout.addLayout(constraints_layout)


        self.gen = QLabel("Generate")
        self.gen.setAlignment(Qt.AlignmentFlag.AlignHCenter)
        self.layout.addWidget(self.gen)

        # Source .env Button
        self.source_env_button = QPushButton("Source Env")
        self.source_env_button.clicked.connect(self.source_env)
        self.source_env_button.setToolTip("Source the .env file in the flow scripts directory")
        self.main_window.log_widget.indicator.setColor("white")
        self.layout.addWidget(self.source_env_button)
        
        #Run Make Button
        self.run_make_button = QPushButton("Run Make")
        self.run_make_button.clicked.connect(self.run_make)
        self.run_make_button.setToolTip("Run the make command")
        self.layout.addWidget(self.run_make_button)

        # Set Makefile Button
        self.set_makefile_button = QPushButton("Set Makefile")
        self.set_makefile_button.clicked.connect(self.set_makefile)
        self.set_makefile_button.setToolTip("Modify the makefile for your design")
        self.layout.addWidget(self.set_makefile_button)

        # Run OpenROAD GUI
        self.openGui_button = QPushButton("OpenROAD Gui")
        self.openGui_button.clicked.connect(self.openGui)
        self.openGui_button.setToolTip("Open Generated GDSII File")
        self.layout.addWidget(self.openGui_button)

        # Run make clean
        self.openGui_button = QPushButton("Make clean")
        self.openGui_button.clicked.connect(self.makeClean)
        self.openGui_button.setToolTip("Reset files")
        self.layout.addWidget(self.openGui_button)
        
        # Edit File Area
        self.text_edit = QTextEdit()
        self.text_edit.setVisible(False)
        self.layout.addWidget(self.text_edit)
        
        self.save_button = QPushButton("Save File")
        self.save_button.setVisible(False)
        self.save_button.clicked.connect(self.save_file)
        self.layout.addWidget(self.save_button)
        
        self.setLayout(self.layout)
    
    def is_ubuntu(self):
        try:
            # with open("/etc/os-release") as f:
            #     return any("ubuntu" in line.lower() for line in f)
            with open("/etc/os-release") as f:
                content = f.read().lower()  # Read all content and convert to lowercase

                if "ubuntu" in content:
                    return "Ubuntu"
                elif "centos" in content:
                    return "CentOS"
                elif "debian" in content:
                    return "Debian"
                else:
                    return "Unknown Linux distribution"
        except FileNotFoundError:
            return False


    def populate_pdk_dropdown(self):
        pdk_path = "../flow/designs"
        if os.path.exists(pdk_path):
            items = [item for item in os.listdir(pdk_path) if item != 'src']
            self.pdk_dropdown.addItems(items)
            # self.pdk_dropdown.addItems(os.listdir(pdk_path))

    def check_latest_version(self,repo: str, current_version: str = None):
        """
        Checks the latest release version of a GitHub repository.

        Parameters:
            repo (str): GitHub repository in "owner/repo" format.
            current_version (str): (Optional) Your currently installed version.

        Returns:
            str: The latest version tag name.
        """
        url = f"https://api.github.com/repos/{repo}/releases/latest"

        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()

            latest_release = response.json()
            latest_version = latest_release["tag_name"]

            # print(f"Latest version on GitHub: {latest_version}")

            return latest_version

        except requests.exceptions.RequestException as e:
            self.log("Error checking for updates:", e)

    
    # Button action methods
    def open_settings(self):
        # self.log("Settings button clicked")
        # self.settings_window = SettingsWindow(self)
        self.settings_window = SettingsWindow(self.main_window)  # Pass main window
        self.settings_window.exec()
    
    def pdk_changed(self, text):
        # self.log(f"PDK changed to: {text}")
        self.pdk = text
        self.main_window.log(f"PDK changedto: {self.pdk}")
        # self.imported_design_label.setText(f"Imported Design: {self.imported_design}")
        
    
    def source_env(self):
        # self.log("Source Env button clicked")
        if self.is_ubuntu():
            self.main_window.run("cd .. && source ./env.sh && cd OpenROAD_HelperGUI")
        else:
            self.log("NOT UBUNTU")
            # self.log(self.main_window.path)

    def reset_import(self):
        self.imported_design = None
        self.imported_design_label.setText(f"Imported Design: {self.imported_design}")
        
    def combine_verilog_files(self,input_dir, output_dir,name):
        """
        Combines all .v files in the given directory into a single .v file.

        Parameters:
        input_dir (str): Path to the directory containing .v files.
        output_file (str): Path to the output .v file to be created.
        """
        if not os.path.isdir(input_dir):
            raise ValueError(f"The path '{input_dir}' is not a valid directory.")

        verilog_files = sorted(
        [f for f in os.listdir(input_dir) if f.endswith(".v")],
        key=lambda x: x.lower()
        )

        if not verilog_files:
            raise FileNotFoundError("No .v files found in the specified directory.")
        
        filepath = output_dir + "/" + name

        with open(filepath, "w") as outfile:
            for filename in verilog_files:
                file_path = os.path.join(input_dir, filename)
                with open(file_path, "r") as infile:
                    outfile.write(f"// --- Start of {filename} ---\n")
                    outfile.write(infile.read())
                    # outfile.write(f"\n// --- End of {filename} ---\n\n")

        self.log(f"Combined {len(verilog_files)} files into '{filepath}'.")
    
    def import_design(self):
        # self.log("Import Design button clicked")
        design_folder = QFileDialog.getExistingDirectory(self, "Select Design Folder")
        if design_folder:
            self.imported_design = os.path.basename(design_folder)
            self.imported_design_label.setText(f"Imported Design: {self.imported_design}")
            selected_pdk = self.pdk_dropdown.currentText()
            dest_src = f"../flow/designs/src/{self.imported_design}"
            dest_pdk = f"../flow/designs/{selected_pdk}/{self.imported_design}"
            
            shutil.copytree(design_folder, dest_src, dirs_exist_ok=True)
            # shutil.copytree(design_folder, dest_pdk, dirs_exist_ok=True)
            os.makedirs(dest_pdk, exist_ok=True)
            
            self.combine_verilog_files(input_dir=design_folder, output_dir = dest_src ,name = self.imported_design + ".v")
            
            self.reset_config()
            self.reset_constraint()

            # shutil.copy("defaultConstraints.txt", f"{dest_pdk}/constraint.sdc")
            # shutil.copy("defaultConfig.txt", f"{dest_pdk}/config.mk")
            self.log(f"Imported {self.imported_design} into {dest_pdk} and {dest_src}")
    
    def reset_config(self):
        # self.log("Reset config.mk button clicked")
        selected_pdk = self.pdk_dropdown.currentText()
        # shutil.copy("defaultConfig.txt", f"../flow/design/{selected_pdk}/{self.imported_design}/config.mk")

        path = f"../flow/designs/{selected_pdk}/gcd/config.mk"

        if self.imported_design and selected_pdk and os.path.exists(path):
            with open(path, "r") as file:
                    makefile_data = (file.read().replace("gcd",self.imported_design))
                    with open(f"../flow/designs/{selected_pdk}/{self.imported_design}/config.mk", "w") as file:
                        file.write(makefile_data)

            if self.current_file == f"../flow/designs/{selected_pdk}/{self.imported_design}/config.mk":
                self.edit_file("config.mk")
            self.log("Reset config.mk")
        else:
            if os.path.exists(path):
                self.log("SELECT DESIGN AND PDK FIRST")
            else:
                self.log("gcd constraint and config file missing\nUnable to copy reference content")
    
    def reset_constraint(self):
        # self.log("Reset constraint.sdc button clicked")
        selected_pdk = self.pdk_dropdown.currentText()
        # shutil.copy("defaultconstraint.txt", f"../flow/design/{selected_pdk}/{self.imported_design}/constraint.sdc")

        path = f"../flow/designs/{selected_pdk}/gcd/constraint.sdc"

        if self.imported_design and selected_pdk and os.path.exists(path):
            with open(path, "r") as file:
                    makefile_data = (file.read().replace("gcd",self.imported_design))
                    with open(f"../flow/designs/{selected_pdk}/{self.imported_design}/constraint.sdc", "w") as file:
                        file.write(makefile_data)

            if self.current_file == f"../flow/designs/{selected_pdk}/{self.imported_design}/constraint.sdc":
                self.edit_file("constraint.sdc")
            self.log("Reset constraint.sdc")
        else:
            if os.path.exists(path):
                self.log("SELECT DESIGN AND PDK FIRST")
            else:
                self.log("gcd constraint and constraint file missing\nUnable to copy reference content")
    
    def set_makefile(self):
        # self.log("Set Makefile button clicked")
        path = "../flow/"
        if self.imported_design:
            with open("defaultMakefile.txt", "r") as file:
                makefile_data = file.read().replace("DESIGN_CONFIG ?= ./designs/nangate45/gcd/config.mk", "DESIGN_CONFIG ?= ./designs/"+self.pdk_dropdown.currentText()+"/"+self.imported_design+"/config.mk")
            with open(path+"Makefile", "w") as file:
                file.write(makefile_data)
            self.log("Makefile updated")
        else:
            self.log("No design has been imported yet.")
    
    def run_make(self):
        # self.log("Run Make button clicked")
        if self.is_ubuntu():
            # subprocess.Popen(["gnome-terminal", "--", "bash", "-c", "make"])
            # self.main_window.run('make')
            if self.imported_design and self.pdk:
                temp = f'\nMAKE\nDesign: {self.imported_design}\n PDK: {self.pdk}'
                self.main_window.log(temp)
                self.main_window.run(f"cd .. && cd flow && make DESIGN_CONFIG=./designs/{self.pdk}/{self.imported_design}/config.mk"+f' && cd .. && cd OpenROAD_HelperGUI;echo "{temp}"')
                self.log("Running make...")
            else:
                # self.log("SELECT DESIGN AND PDK FIRST")
                self.main_window.log('\nDEFAULT MAKE')
                self.main_window.run('make')
        else:
            self.log("NOT UBUNTU")

    def openGui(self):
        if self.is_ubuntu():
            self.main_window.run(command('make gui_final'))
            self.log("Opening OpenROAD GUI")
        else:
            self.log("NOT UBUNTU")

    def makeClean(self):
        if self.is_ubuntu():
            self.main_window.run(command('make clean'))
            self.log("make clean")
        else:
            self.log("NOT UBUNTU")

    def edit_file(self, file_name):
        selected_pdk = self.pdk_dropdown.currentText()

        if self.imported_design and selected_pdk:
            file_path = f"../flow/designs/{selected_pdk}/{self.imported_design}/{file_name}"
            if os.path.exists(file_path):
                self.current_file = file_path
                
                with open(file_path, "r") as file:
                    self.text_edit.setText(file.read())
                self.text_edit.setVisible(True)
                self.save_button.setVisible(True)
        else:
            self.log("SELECT DESIGN AND PDK FIRST")
    
    def save_file(self):

        if self.current_file:
            with open(self.current_file, "w") as file:
                file.write(self.text_edit.toPlainText())
            self.text_edit.setVisible(False)
            self.save_button.setVisible(False)
            self.log(f"Saved {self.current_file}")
        
# Main application window
class SimpleMainWindow(QMainWindow):

    path = ""

    def __init__(self):

        super().__init__()
        self.initUI()
        self.process = QProcess(self)  # Persistent shell process
        env = QProcessEnvironment.systemEnvironment()
        env.insert("TERM", "dumb")
        self.process.setProcessEnvironment(env)
        self.process.setProcessChannelMode(QProcess.ProcessChannelMode.MergedChannels)
        self.process.readyReadStandardOutput.connect(self.read_output)
        self.path = os.path.dirname(os.path.abspath(__file__))
        self.log("Current Directory:\n"+self.path)

        # Start a persistent bash shell
        self.process.start("bash", ["-i"])
        
        self.setWindowTitle("OpenROAD HelperGUI")  # Set window title
        self.setGeometry(100, 100, 600, 300)  # Set window size and position
        
    def initUI(self):
        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)  # Set central widget
        
        self.layout = QVBoxLayout()
        
        # Splitter to allow dynamic resizing
        self.splitter = QSplitter(Qt.Orientation.Horizontal)
        

        # Log widget to display application logs
        #LEFT
        self.log_widget = LogWidget(self)
        self.splitter.addWidget(self.log_widget)
        
        # Config widget where most of the buttons exist
        #RIGHT
        self.config_widget = ConfigWidget(self)
        self.splitter.addWidget(self.config_widget)
        
        self.layout.addWidget(self.splitter)
        
        self.central_widget.setLayout(self.layout)
        
        self.log("Application started.")  # Log initial message
        # self.log("Path is "+ self.path)  # Log initial message

    def is_ubuntu(self):
        try:
            # with open("/etc/os-release") as f:
            #     return any("ubuntu" in line.lower() for line in f)
            with open("/etc/os-release") as f:
                content = f.read().lower()  # Read all content and convert to lowercase

                if "ubuntu" in content:
                    return "Ubuntu"
                elif "centos" in content:
                    return "CentOS"
                elif "debian" in content:
                    return "Debian"
                else:
                    return "Unknown Linux distribution"
        except FileNotFoundError:
            return False

    def run(self, cmd ):
        if not(self.is_ubuntu() == False):
            """Send a command to the persistent shell"""
            if cmd:     #self.run_command(cmd = "ls")
                self.log_widget.indicator.setColor("red")

                #Wrapper to encase the command into
                wrapper = f"{cmd}\n\n"

                self.process.write((wrapper).encode())
                if not self.process.waitForStarted():
                    error_type = self.process.error()             # e.g., QProcess.FailedToStart
                    error_string = self.process.errorString()     # e.g., "Process failed to start"
                    
                    self.log("Error Occured")
                    self.log(f"Error type: {error_type}")
                    self.log(f"Error details: {error_string}")
                    
                    self.log_widget.indicator.setColor("lime")
        else:
            self.log("Windows cannot run bash commands")
    
    def read_output(self):
        """Read the output from the shell and clean it."""
        output = self.process.readAllStandardOutput().data().decode()

        if output.endswith("$ "):
            self.log_widget.indicator.setColor("lime")#"green")
        else:
            self.log_widget.indicator.setColor("red")

        def filter_prompt_lines(output):
            lines = output.splitlines(keepends=True)  # Keep '\n'
            if lines:
                lines.pop()
            return "".join(lines)

        
        self.log(""+filter_prompt_lines(output)+"\n")
    
    # Method to log messages to the log widget
    def log(self, message):
        self.log_widget.append_log(message)

# Entry point of the application
if __name__ == "__main__":
    app = QApplication(sys.argv)
    with open(filepath+"settings.json") as file:
        data = json.load(file)
        themes = data["themes"]
        last_theme = themes[0]["data"]
    app.setStyleSheet(last_theme)#dark_stylesheet)
    window = SimpleMainWindow()
    window.show()
    sys.exit(app.exec())