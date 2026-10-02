#!/usr/bin/env python3
import time
import subprocess

MAX_LEN = 25       # Character limit before scrolling
SCROLL_SPEED = 0.2  # Seconds between scroll steps
DELAY = 1.0         # Seconds to wait before scrolling starts

ICON_PLAY = ""
ICON_PAUSE = "" 

cached_player = "ca.edestcroix.Recordbox"
cached_title = "Recordbox Track"
cached_artist = ""

def get_player_data():
    global cached_player, cached_title, cached_artist
    priority_list = ["ca.edestcroix.Recordbox", "vlc", "spotify", "firefox", "chromium", "brave"]
    
    for player in priority_list:
        try:
            status = subprocess.getoutput(f"playerctl -p '{player}' status 2>/dev/null").strip()
            if status in ["Playing", "Paused"]:
                artist = subprocess.getoutput(f"playerctl -p '{player}' metadata artist 2>/dev/null").strip()
                title = subprocess.getoutput(f"playerctl -p '{player}' metadata title 2>/dev/null").strip()
                
                if not title or "No player" in title:
                    title = subprocess.getoutput(f"playerctl -p '{player}' metadata xesam:title 2>/dev/null").strip()
                if not artist or "No player" in artist:
                    artist = subprocess.getoutput(f"playerctl -p '{player}' metadata xesam:artist 2>/dev/null").strip()

                if title and "No player" not in title and "Unknown" not in title:
                    cached_title = title
                    cached_artist = artist if (artist and "No player" not in artist) else ""
                    cached_player = player
                    
                return status, cached_artist, cached_title, cached_player
        except:
            continue
            
    return None, None, None, None

def main():
    scroll_index = 0
    waited = 0
    last_track_signature = ""
    
    while True:
        status, artist, title, player_name = get_player_data()
        
        if not status or not player_name:
            print("", flush=True)
            time.sleep(1)
            continue

        track_signature = f"{player_name}_{title}"

        if track_signature != last_track_signature:
            scroll_index = 0
            waited = 0
            last_track_signature = track_signature

        if artist and title:
            full_text = f"{artist} - {title}"
        elif title:
            full_text = title
        else:
            full_text = "Recordbox Media"

        icon = ICON_PAUSE if status == "Playing" else ICON_PLAY

        if len(full_text) > MAX_LEN:
            display_text = (full_text + "   " + full_text)[scroll_index:scroll_index+MAX_LEN]
            if waited < DELAY / SCROLL_SPEED:
                waited += 1
            else:
                scroll_index += 1
                if scroll_index >= len(full_text) + 3:
                    scroll_index = 0
                    waited = 0
        else:
            display_text = full_text

        # Reverted: Pure left-click play/pause toggle. No right-click bindings.
        output = f"%{{A1:playerctl -p '{player_name}' play-pause:}}{icon}  {display_text}%{{A}}"
        print(output, flush=True)
        time.sleep(SCROLL_SPEED)

if __name__ == "__main__":
    main()