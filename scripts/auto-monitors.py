import os
import time
import subprocess


def is_hdmi_connected():
    result = subprocess.run(["wlr-randr"], capture_output=True, text=True)
    return "HDMI-A-1" in result.stdout


def update_monitors(hdmi_connected):
    config_path = os.path.expanduser("~/.config/hypr/monitors.conf")
    with open(config_path, "w") as f:
        if hdmi_connected:
            f.write("monitor=eDP-1,disable\n")
            f.write("monitor=HDMI-A-1,1920x1080@60.0,0x0,1.2\n")
        else:
            f.write("monitor=eDP-1,1920x1080@60.0,1600x0,1.2\n")


def apply_changes():
    subprocess.run(["hyprctl", "reload"])


def monitor_loop():
    last_state = None
    while True:
        current_state = is_hdmi_connected()
        if current_state != last_state:
            update_monitors(current_state)
            apply_changes()
            last_state = current_state
        time.sleep(5)


# Run the loop
monitor_loop()
