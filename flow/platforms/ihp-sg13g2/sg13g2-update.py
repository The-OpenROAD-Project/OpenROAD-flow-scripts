import requests
import os

def download_github_file(repo_owner, repo_name, branch, file_path, local_dir):
    """
    Download a file from a specific branch of a GitHub repository.
    
    Args:
    repo_owner (str): Owner of the repository.
    repo_name (str): Name of the repository.
    branch (str): Branch name from which to download the file.
    file_path (str): Path to the file in the repository.
    local_dir (str): Local directory to save the file.
    
    Returns:
    None
    """
    # Construct the URL to access the file
    base_url = f"https://raw.githubusercontent.com/{repo_owner}/{repo_name}/{branch}/{file_path}"
    
    # Send a GET request to download the file
    response = requests.get(base_url)
    response.raise_for_status()  # Raise an exception for HTTP errors
    
    # Ensure the local directory exists
    if not os.path.exists(local_dir):
        os.makedirs(local_dir)
    
    # Define the local path to save the file
    local_file_path = os.path.join(local_dir, os.path.basename(file_path))
    
    # Write the content to the file
    with open(local_file_path, 'wb') as file:
        file.write(response.content)
    
    print(f"File saved to {local_file_path}")

#owner= 'IHP-GmbH'
owner= 'KrzysztofHerman'
repo_name= 'IHP-Open-PDK'
branch = 'dev'

# Klayout 
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.tech/klayout/tech/sg13g2.lyp', '.')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.tech/klayout/tech/sg13g2.lyt', '.')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.tech/klayout/tech/drc/sg13g2.lydrc', 'drc')
# LIB
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_slow_1p35V_125C.lib', 'lib')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_slow_1p08V_125C.lib', 'lib')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_fast_1p32V_m40C.lib', 'lib')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_fast_1p65V_m40C.lib', 'lib')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib', 'lib')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p50V_25C.lib', 'lib')
# wait for official update 
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_io/liberty/sg13g2_io_dummy.lib', 'lib')
# GDS
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds', 'gds')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_io/gds/sg13g2_io.gds', 'gds')
# LEF
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef', 'lef')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef', 'lef')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_io/lef/sg13g2_io.lef', 'lef')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_io/lef/sg13g2_io_notracks.lef', 'lef')
# Verilog
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_stdcell/verilog/sg13g2_stdcell.v', 'verilog')
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_io/verilog/sg13g2_io.v', 'verilog')
# CDL
download_github_file(owner, repo_name, branch, 'ihp-sg13g2/libs.ref/sg13g2_stdcell/cdl/sg13g2_stdcell.cdl', 'cdl')





