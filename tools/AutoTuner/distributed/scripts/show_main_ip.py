import subprocess
import re


def get_main_ip():
    """
    Get the main IP address of the Ray head node.
    """
    result = subprocess.run(["ip", "a"], capture_output=True, text=True)
    ip_output = result.stdout

    # Regex to find all inet addresses (excluding loopback 127.x.x.x and docker/bridge)
    matches = re.findall(r"inet (\d+\.\d+\.\d+\.\d+)/\d+", ip_output)
    for ip in matches:
        # TODO: Add more checks to filter out unwanted IPs
        if (
            not ip.startswith("127.")
            and not ip.startswith("169.")
            and not ip.startswith("172.17.")
        ):
            return ip
    return "No valid IP found"


def main():
    print(f"Main IP address: {get_main_ip()}")


if __name__ == "__main__":
    main()
