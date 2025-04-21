import os
import time
import subprocess
import logging
from pathlib import Path

# --- Config ---
CHECK_INTERVAL = 5  # seconds
MONITOR_CONFIG_PATH = Path.home() / ".config/hypr/monitors.conf"
HDMI_NAME = "HDMI-A-1"
INTERNAL_NAME = "eDP-1"

# --- Logging ---
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)


# --- Functions ---
def is_hdmi_connected() -> bool:
    try:
        result = subprocess.run(
            ["wlr-randr"], capture_output=True, text=True, check=True
        )
        return HDMI_NAME in result.stdout
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to run wlr-randr: {e}")
        return False


def generate_config(hdmi_connected: bool) -> str:
    if hdmi_connected:
        return f"monitor={INTERNAL_NAME},disable\nmonitor={HDMI_NAME},1920x1080@60.0,0x0,1.25\n"
    else:
        return f"monitor={INTERNAL_NAME},1920x1080@60.0,1600x0,1.25\n"


def update_monitors(hdmi_connected: bool):
    new_config = generate_config(hdmi_connected)
    if MONITOR_CONFIG_PATH.exists():
        with open(MONITOR_CONFIG_PATH, "r") as f:
            existing_config = f.read()
        if existing_config == new_config:
            logging.info("Monitor config unchanged.")
            return
    try:
        with open(MONITOR_CONFIG_PATH, "w") as f:
            f.write(new_config)
        logging.info("Monitor config updated.")
    except Exception as e:
        logging.error(f"Failed to write monitor config: {e}")


def apply_changes():
    try:
        subprocess.run(["hyprctl", "reload"], check=True)
        logging.info("Hyprland reloaded.")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to reload Hyprland: {e}")


def monitor_loop():
    last_state = None
    try:
        while True:
            current_state = is_hdmi_connected()
            if current_state != last_state:
                logging.info(f"HDMI connected: {current_state}")
                update_monitors(current_state)
                apply_changes()
                last_state = current_state
            time.sleep(CHECK_INTERVAL)
    except KeyboardInterrupt:
        logging.info("Script terminated by user.")


# --- Run ---
if __name__ == "__main__":
    logging.info("Starting monitor hotplug watcher...")
    monitor_loop()
