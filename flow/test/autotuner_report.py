import csv
import os

def read_csv(file_path):
    out = []
    with open(file_path, 'r') as file:
        reader = csv.reader(file)
        for idx, row in enumerate(reader):
            if idx == 0: continue            
            out.append(row)
    return out

def write_csv(lst, file_path):
    with open(file_path, 'w') as file:
        writer = csv.writer(file)
        writer.writerows(lst)

if __name__ == "__main__":
    cur_dir = os.path.dirname(__file__)
    log_dir = os.path.join(cur_dir, "../../flow/logs/asap7/gcd")
    os.chdir(log_dir)

    # Get the latest updated dir in the data directory.
    latest_dir = max(os.listdir("."), key=os.path.getmtime)
    folder_name = os.path.basename(latest_dir)

    # Get all the progress.csv file recursively
    progress_files = []
    for root, _, files in os.walk(latest_dir):
        for file in files:
            if file == "progress.csv":
                progress_files.append(os.path.join(root, file))
    
    # Read the progress.csv file
    progress = []
    for file in progress_files:
        progress += read_csv(file)

    # Write the progress.csv file
    write_csv(progress, f"{folder_name}_progress.csv")
