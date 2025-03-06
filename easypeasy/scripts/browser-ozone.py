import os

location = "/usr/share/applications"
ozone_layer = "--ozone-platform=wayland"
browser_desktops = [
    "google-chrome.desktop",
    "microsoft-edge.desktop",
    "brave-browser.desktop",
]


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


for browser_desktop in browser_desktops:
    file_location = os.path.join(location, browser_desktop)
    file_exists(file_location)
