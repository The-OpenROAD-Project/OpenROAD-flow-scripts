"""Module to download latest files from IHP"s Open PDK."""

# fmt: off
# pylint: disable=line-too-long
import os
import requests

REPO_OWNER = "IHP-GmbH"
REPO_NAME = "IHP-Open-PDK"
REPO_BRANCH = "main"


def download_github_file(
    file_path,
    local_dir=".",
    repo_owner=REPO_OWNER,
    repo_name=REPO_NAME,
    branch=REPO_BRANCH,
):
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
    with open(local_file_path, "wb") as file:
        file.write(response.content)

    print(f"File saved to {local_file_path}")


sram_files = [
    "RM_IHPSG13_1P_1024x16_c2_bm_bist",
    "RM_IHPSG13_1P_1024x64_c2_bm_bist",
    "RM_IHPSG13_1P_1024x8_c2_bm_bist",
    "RM_IHPSG13_1P_2048x64_c2_bm_bist",
    "RM_IHPSG13_1P_256x48_c2_bm_bist",
    "RM_IHPSG13_1P_256x64_c2_bm_bist",
    "RM_IHPSG13_1P_4096x16_c3_bm_bist",
    "RM_IHPSG13_1P_4096x8_c3_bm_bist",
    "RM_IHPSG13_1P_512x64_c2_bm_bist",
    "RM_IHPSG13_1P_64x64_c2_bm_bist",
]
sram_lib_corners = [
    "slow_1p08V_125C",
    "typ_1p20V_25C",
    "fast_1p32V_m55C",
]

# Klayout
download_github_file("ihp-sg13g2/libs.tech/klayout/tech/sg13g2.lyp")
download_github_file("ihp-sg13g2/libs.tech/klayout/tech/sg13g2.lyt")
download_github_file("ihp-sg13g2/libs.tech/klayout/tech/drc/sg13g2_minimal.lydrc", "drc")
download_github_file("ihp-sg13g2/libs.tech/klayout/tech/drc/sg13g2_maximal.lydrc", "drc")
# LIB
download_github_file("ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_slow_1p35V_125C.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_slow_1p08V_125C.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_fast_1p32V_m40C.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_fast_1p65V_m40C.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p50V_25C.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_dummy.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_fast_1p32V_3p6V_m40C.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_fast_1p65V_3p6V_m40C.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_slow_1p08V_3p0V_125C.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_slow_1p35V_3p0V_125C.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_typ_1p2V_3p3V_25C.lib", "lib")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_typ_1p5V_3p3V_25C.lib", "lib")
for sram in sram_files:
    for corner in sram_lib_corners:
        download_github_file(f"ihp-sg13g2/libs.ref/sg13g2_sram/lib/{sram}_{corner}.lib", "lib")
# GDS
download_github_file("ihp-sg13g2/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds", "gds")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_io/gds/sg13g2_io.gds", "gds")
for sram in sram_files:
    download_github_file(f"ihp-sg13g2/libs.ref/sg13g2_sram/gds/{sram}.gds", "gds")
# LEF
download_github_file("ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef", "lef")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef", "lef")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_io/lef/sg13g2_io.lef", "lef")
for sram in sram_files:
    download_github_file(f"ihp-sg13g2/libs.ref/sg13g2_sram/lef/{sram}.lef", "lef")
# Verilog
download_github_file("ihp-sg13g2/libs.ref/sg13g2_stdcell/verilog/sg13g2_stdcell.v", "verilog")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_io/verilog/sg13g2_io.v", "verilog")
for sram in sram_files:
    download_github_file(f"ihp-sg13g2/libs.ref/sg13g2_sram/verilog/{sram}.v", "verilog")
# CDL
download_github_file("ihp-sg13g2/libs.ref/sg13g2_stdcell/cdl/sg13g2_stdcell.cdl", "cdl")
download_github_file("ihp-sg13g2/libs.ref/sg13g2_io/cdl/sg13g2_io.cdl", "cdl")
for sram in sram_files:
    download_github_file(f"ihp-sg13g2/libs.ref/sg13g2_sram/cdl/{sram}.cdl", "cdl")
