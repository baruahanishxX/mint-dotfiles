#!/usr/bin/env python3
import time
import subprocess

# --- CONFIGURATION ---
MAX_LEN = 25        # Character limit before scrolling
SCROLL_SPEED = 0.2  # Seconds between scroll steps
DELAY = 1.0         # Seconds to wait before scrolling starts

# Icons
ICON_PLAY = ""
ICON_PAUSE = "" 

def get_player_data():
    # Define the priority order explicitly
    player_list = ["vlc", "spotify", "firefox", "chromium", "brave"]
    
    # Check players in order. The first one found "Playing" or "Paused" wins.
    for player in player_list:
        try:
            status = subprocess.getoutput(f"playerctl -p {player} status 2>/dev/null").strip()
            
            if status in ["Playing", "Paused"]:
                # We found the active player! Get its data.
                artist = subprocess.getoutput(f"playerctl -p {player} metadata artist 2>/dev/null").strip()
                title = subprocess.getoutput(f"playerctl -p {player} metadata title 2>/dev/null").strip()
                
                # VLC Fallback: If title is missing, use filename
                if not title and player == "vlc":
                    title = subprocess.getoutput(f"playerctl -p {player} metadata xesam:url 2>/dev/null").split("/")[-1]
                
                # Return data AND the specific player name
                return status, artist, title, player
        except:
            continue
            
    return None, None, None, None

def main():
    scroll_index = 0
    waited = 0
    
    while True:
        status, artist, title, player_name = get_player_data()
        
        if not status:
            print("", flush=True)
            time.sleep(1)
            continue

        # Format Text
        if artist:
            full_text = f"{artist} - {title}"
        elif title:
            full_text = title
        else:
            full_text = "Unknown Media"

        # Determine Icon
        icon = ICON_PAUSE if status == "Playing" else ICON_PLAY

        # Scrolling Logic
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

        # --- THE FIX IS HERE ---
        # We inject 'player_name' into the click command (-p {player_name})
        # This ensures we pause VLC if we are looking at VLC.
        output = f"%{{A1:playerctl -p {player_name} play-pause:}}{icon}  {display_text}%{{A}}"
        
        print(output, flush=True)
        time.sleep(SCROLL_SPEED)

if __name__ == "__main__":
    main()