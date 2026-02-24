#!/usr/bin/env python3
import time
import subprocess
import sys

# --- CONFIG ---
MAX_LEN = 20        # Width of the 'pill' (Fixed size!)
SCROLL_SPEED = 0.2  # Speed
# --------------

def get_active_window():
    try:
        # Get Active Window ID
        win_id = subprocess.check_output("xdotool getactivewindow 2>/dev/null", shell=True, text=True).strip()
        if not win_id: return None, None

        # Get Window Class (Icon) and Name
        win_class = subprocess.check_output(f"xprop -id {win_id} WM_CLASS 2>/dev/null", shell=True, text=True).strip()
        win_title = subprocess.check_output(f"xdotool getwindowname {win_id} 2>/dev/null", shell=True, text=True).strip()
        return win_class.lower(), win_title
    except:
        return None, None

def get_icon(win_class):
    if not win_class: return " "
    if "firefox" in win_class: return " "
    if "chrome" in win_class or "brave" in win_class: return " "
    if "code" in win_class or "cursor" in win_class: return "󰨞 "
    if "sublime" in win_class: return " "
    if "terminal" in win_class or "kitty" in win_class: return " "
    if "spotify" in win_class: return " "
    if "discord" in win_class: return " "
    if "thunar" in win_class or "nemo" in win_class: return " "
    return " "

def main():
    offset = 0
    while True:
        win_class, title = get_active_window()

        if not title:
            print("  Desktop", flush=True)
            time.sleep(1)
            continue

        icon = get_icon(win_class)
        full_text = f"{title}   |   " # Separator for scrolling

        # SCROLL LOGIC
        if len(title) > MAX_LEN:
            display_text = (full_text * 3)[offset : offset + MAX_LEN]
            offset += 1
            if offset >= len(full_text): offset = 0
        else:
            # Center the text if it's short
            display_text = title.center(MAX_LEN)
            offset = 0

        print(f"{icon} {display_text}", flush=True)
        time.sleep(SCROLL_SPEED)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(0)
