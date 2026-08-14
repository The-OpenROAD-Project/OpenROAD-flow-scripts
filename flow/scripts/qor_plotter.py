import sys
import os
import subprocess
import pandas as pd
try:
    from PySide6.QtWidgets import QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QTableView, QComboBox, QLabel, QMessageBox
    from PySide6.QtCore import QAbstractTableModel, Qt
except ImportError:
    print("PySide6 is required. Please install it.")
    sys.exit(1)

import matplotlib
matplotlib.use('qtagg')
from matplotlib.backends.backend_qtagg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure

class PandasModel(QAbstractTableModel):
    def __init__(self, data):
        super().__init__()
        self._data = data

    def rowCount(self, parent=None):
        return self._data.shape[0]

    def columnCount(self, parent=None):
        return self._data.shape[1]

    def data(self, index, role=Qt.DisplayRole):
        if index.isValid() and role == Qt.DisplayRole:
            val = self._data.iloc[index.row(), index.column()]
            if pd.isna(val):
                return ""
            if isinstance(val, float):
                return f"{val:.4f}"
            return str(val)
        return None

    def headerData(self, col, orientation, role):
        if orientation == Qt.Horizontal and role == Qt.DisplayRole:
            return self._data.columns[col]
        return None

class QoRPlotter(QMainWindow):
    def __init__(self, csv_file):
        super().__init__()
        self.csv_file = csv_file
        self.pdk = "asap7" if "asap7" in csv_file.lower() else "sky130hd"
        self.setWindowTitle(f"QoR Path Correlation Debugger - {os.path.basename(csv_file)}")
        self.df = pd.read_csv(csv_file)
        
        main_widget = QWidget()
        self.setCentralWidget(main_widget)
        layout = QVBoxLayout(main_widget)
        
        # Controls
        ctrl_layout = QHBoxLayout()
        self.x_stage_cb = QComboBox()
        self.y_stage_cb = QComboBox()
        self.metric_cb = QComboBox()
        
        stages = ["3_place", "5_grt", "6_route"]
        allowed_metrics = ["min_clk_period", "net_delay", "logic_delay", "total_cap", "buffers"]
        
        metrics = set()
        for col in self.df.select_dtypes(include=['float64', 'int64']).columns:
            for stage in stages:
                if col.startswith(f"{stage}_"):
                    m = col[len(f"{stage}_"):]
                    if m in allowed_metrics:
                        metrics.add(m)
        
        self.x_stage_cb.addItems(stages)
        self.y_stage_cb.addItems(stages)
        self.metric_cb.addItems(sorted(list(metrics)))
        
        # Try to set sensible defaults
        self.x_stage_cb.setCurrentText("5_grt")
        self.y_stage_cb.setCurrentText("6_route")
        if "min_clk_period" in metrics:
            self.metric_cb.setCurrentText("min_clk_period")
            
        self.x_stage_cb.currentTextChanged.connect(self.update_plot)
        self.y_stage_cb.currentTextChanged.connect(self.update_plot)
        self.metric_cb.currentTextChanged.connect(self.update_plot)
        
        ctrl_layout.addWidget(QLabel("X-Axis Stage:"))
        ctrl_layout.addWidget(self.x_stage_cb)
        ctrl_layout.addWidget(QLabel("Y-Axis Stage:"))
        ctrl_layout.addWidget(self.y_stage_cb)
        ctrl_layout.addWidget(QLabel("Metric:"))
        ctrl_layout.addWidget(self.metric_cb)
        layout.addLayout(ctrl_layout)
        
        # Plot
        self.fig = Figure(figsize=(8, 6))
        self.canvas = FigureCanvas(self.fig)
        self.ax = self.fig.add_subplot(111)
        layout.addWidget(self.canvas)
        
        # Table
        self.table = QTableView()
        self.model = PandasModel(self.df)
        self.table.setModel(self.model)
        layout.addWidget(self.table)
        
        self.update_plot()
        
    def update_plot(self):
        if self.df is None or self.df.empty:
            return
            
        x_stage = self.x_stage_cb.currentText()
        y_stage = self.y_stage_cb.currentText()
        metric = self.metric_cb.currentText()
        
        x_col = f"{x_stage}_{metric}"
        y_col = f"{y_stage}_{metric}"
        
        if x_col not in self.df.columns or y_col not in self.df.columns:
            return
            
        valid_df = self.df[[x_col, y_col]].dropna()
        x_data = valid_df[x_col]
        y_data = valid_df[y_col]
        
        self.ax.clear()
        self.ax.scatter(x_data, y_data, alpha=0.5)
        
        self.csv_file = csv_file
        self.pdk = "asap7" if "asap7" in csv_file.lower() else "sky130hd"
        
        # Unit label
        unit_str = ""
        if "clk_period" in metric or "delay" in metric:
            if "asap7" in self.pdk:
                unit_str = " (ps)"
            else:
                unit_str = " (ns)"
        elif "cap" in metric:
            unit_str = " (fF)"
            
        # Diagonal line
        if len(x_data) > 0 and len(y_data) > 0:
            min_val = float(min(x_data.min(), y_data.min()))
            max_val = float(max(x_data.max(), y_data.max()))
            self.ax.plot([min_val, max_val], [min_val, max_val], 'r--')
            
        self.ax.set_xlabel(f"{x_col}{unit_str}")
        self.ax.set_ylabel(f"{y_col}{unit_str}")
        self.ax.grid(True)
        self.ax.set_title(f"Correlation: {x_col} vs {y_col}")
        self.fig.tight_layout()
        self.canvas.draw()

def build_and_extract_data(pdk, design):
    print(f"Building and extracting path data for {pdk} {design}...")
    cwd = os.getcwd()
    dump_dir = os.path.join(cwd, f"qor_dumps_{pdk}_{design}")
    os.makedirs(dump_dir, exist_ok=True)
    
    cmd = [
        "bazelisk", "build", 
        "--define=GPL_USE_ENGINE_DEFAULTS=1",
        "--spawn_strategy=local",
        f"--action_env=DUMP_DIR={dump_dir}",
        f"--define=POST_GLOBAL_PLACE_TCL={cwd}/flow/scripts/dump_paths_place.tcl",
        f"--define=POST_GLOBAL_ROUTE_TCL={cwd}/flow/scripts/dump_paths_grt.tcl",
        f"--define=POST_DETAIL_ROUTE_TCL={cwd}/flow/scripts/dump_paths_route.tcl",
        f"//flow/designs/{pdk}/{design}:{design}_route"
    ]
    
    result = subprocess.run(cmd, cwd=cwd)
    if result.returncode != 0:
        print(f"Error: Build failed for {pdk} {design}.")
        sys.exit(1)
        
    reports_dir = os.path.join(cwd, "bazel-bin", "flow", "designs", pdk, design, "reports", pdk, design, "base")
    try:
        df3 = pd.read_csv(os.path.join(reports_dir, "3_place_timing_paths.csv"))
        df5 = pd.read_csv(os.path.join(reports_dir, "5_grt_timing_paths.csv"))
        df6 = pd.read_csv(os.path.join(reports_dir, "6_route_timing_paths.csv"))
    except Exception as e:
        print(f"Error reading CSVs: {e}")
        sys.exit(1)
        
    def get_worst_paths(df, stage_prefix):
        if f'{stage_prefix}_min_clk_period' in df.columns:
            df = df.sort_values(f'{stage_prefix}_min_clk_period', ascending=False)
        elif f'{stage_prefix}_slack' in df.columns:
            df = df.sort_values(f'{stage_prefix}_slack', ascending=True)
        return df.drop_duplicates(subset=['startpoint', 'endpoint'], keep='first')
        
    df3 = get_worst_paths(df3, "3_place")
    df5 = get_worst_paths(df5, "5_grt")
    df6 = get_worst_paths(df6, "6_route")
    
    df_merged = df3.merge(df5, on=['startpoint', 'endpoint'], how='outer')
    df_merged = df_merged.merge(df6, on=['startpoint', 'endpoint'], how='outer')
    
    out_csv = os.path.join(cwd, f"path_data_{pdk}_{design}.csv")
    df_merged.to_csv(out_csv, index=False)
    print(f"Saved aggregated data to {out_csv}")
    return out_csv

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="QoR Correlation Plotter")
    parser.add_argument('csv_file', nargs='?', help='Merged CSV file or design name')
    parser.add_argument('--design', help='Design platform/variant name, e.g., sky130hd/gcd')
    
    args = parser.parse_args()
    
    csv_file = args.csv_file
    if args.design:
        parts = args.design.strip('/').split('/')
        if len(parts) == 2:
            pdk, design = parts
        else:
            pdk, design = "sky130hd", parts[0]
        csv_file = build_and_extract_data(pdk, design)
    elif csv_file and '/' in csv_file and not csv_file.endswith('.csv'):
        parts = csv_file.strip('/').split('/')
        if len(parts) == 2:
            pdk, design = parts
        else:
            pdk, design = "sky130hd", parts[0]
        csv_file = build_and_extract_data(pdk, design)
    elif csv_file:
        build_dir = os.environ.get("BUILD_WORKING_DIRECTORY", os.getcwd())
        if not os.path.isabs(csv_file):
            if os.path.exists(csv_file):
                csv_file = os.path.abspath(csv_file)
            elif os.path.exists(os.path.join(build_dir, csv_file)):
                csv_file = os.path.abspath(os.path.join(build_dir, csv_file))
    elif not csv_file:
        csv_file = build_and_extract_data("sky130hd", "gcd")
        
    if not csv_file or not os.path.exists(csv_file):
        print("Error: Could not locate or build CSV data file.")
        sys.exit(1)
        
    app = QApplication(sys.argv)
    window = QoRPlotter(csv_file)
    window.resize(1000, 800)
    window.show()
    sys.exit(app.exec())
