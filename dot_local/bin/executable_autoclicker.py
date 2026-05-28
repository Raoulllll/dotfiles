#!/usr/bin/env python3
import os
import subprocess

LOCK_FILE = "/tmp/autoclicker.lock"

# Align with your user socket environment
env = os.environ.copy()
env["YDOTOOL_SOCKET"] = f"/run/user/{os.getuid()}/.ydotool_socket"

if os.path.exists(LOCK_FILE):
    # --- STOP LOGIC ---
    # Forcefully terminate any active ydotool click instances globally
    subprocess.run(["pkill", "-9", "-f", "ydotool click"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
    # Clean up the lock file
    if os.path.exists(LOCK_FILE):
        os.remove(LOCK_FILE)
else:
    # --- START LOGIC ---
    # Touch the lock file to latch the active state
    with open(LOCK_FILE, "w") as f:
        f.write("active")
    
    # Fire the 20 CPS macro
    subprocess.Popen(
        ["ydotool", "click", "--repeat", "999999", "--next-delay", "44", "0xC0"],
        env=env,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
