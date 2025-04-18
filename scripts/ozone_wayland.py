import os
import sys
import subprocess

location = "/usr/share/applications"
ozone_layer = "--ozone-platform=wayland"
browser_desktops = [
    "google-chrome.desktop",
    "microsoft-edge.desktop",
    "brave-browser.desktop",
    "zen.desktop",
    "bitwarden.desktop",
    "vivaldi-stable.desktop",
]


def check_sudo():
    if os.geteuid() != 0:
        print("This script requires sudo privileges. Re-running with sudo...")
        subprocess.run(["sudo", "python3"] + sys.argv)
        sys.exit()


def file_exists(file_location):
    if os.path.exists(file_location):
        check_ozone(file_location)
    else:
        print(f"File '{file_location}' does not exist.")


def check_ozone(file_location):
    with open(file_location, "r") as file:
        lines = file.readlines()

    modified_lines = []
    for line in lines:
        if line.startswith("Exec="):
            if ozone_layer not in line:
                parts = line.split(" ")
                parts.insert(1, ozone_layer)
                line = " ".join(parts)
        modified_lines.append(line)

    with open(file_location, "w") as file:
        file.writelines(modified_lines)

    print(f"File '{file_location}' modified successfully.")


if __name__ == "__main__":
    check_sudo()
    for browser_desktop in browser_desktops:
        file_location = os.path.join(location, browser_desktop)
        file_exists(file_location)
