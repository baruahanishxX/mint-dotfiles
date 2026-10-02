#!/bin/bash

# --- EVENT-DRIVEN OPTIMIZATION ---
# "xprop -spy" monitors the active window property and pipes updates instantly.
# This prevents the need for an interval loop, saving CPU.

xprop -spy -root _NET_ACTIVE_WINDOW | while read -r _ _ _ _ id; do
    
    # 1. Handle Empty/Desktop State
    if [[ -z "$id" || "$id" == "0x0" ]]; then
        echo "  Desktop"
        continue
    fi

    # 2. Get Window Class (Fast fetch)
    wm_class=$(xprop -id "$id" WM_CLASS 2>/dev/null)
    
    # 3. Match App Name (Case Insensitive)
    case "${wm_class,,}" in
        
        # --- WEB ---
        *firefox*|*navigator*|*librewolf*)      icon=""; name="Firefox" ;;
        *google-chrome*|*chrome*|*brave*)       icon=""; name="Chrome" ;;
        
        # --- DEV (Matches your Recent Apps) ---
        *code*|*vscode*|*cursor*)               icon="󰨞"; name="VS Code" ;;
        *sublime*|*subl*)                       icon=""; name="Sublime" ;;
        *terminal*|*alacritty*|*kitty*)         icon=""; name="Terminal" ;;
        *python*|*idle*)                        icon=""; name="Python" ;; 
        
        # --- COLLEGE / LABS ---
        *libreoffice-writer*)                   icon="󰈙"; name="Writer" ;;
        *libreoffice-calc*)                     icon="󱎏"; name="Calc" ;;
        *evince*|*atril*|*pdf*)                 icon=""; name="PDF Viewer" ;;
        
        # --- MEDIA ---
        *spotify*)                              icon=""; name="Spotify" ;;
        *vlc*|*mpv*|*media*)                    icon="󰕼"; name="Media" ;;
        *rhythmbox*)                            icon="󰎈"; name="Music" ;;
        *pix*|*viewnior*|*gimp*)                icon="󰄄"; name="Image" ;;
        
        # --- SOCIAL ---
        *discord*|*webcord*|*vesktop*)          icon=""; name="Discord" ;;
        *whatsapp*|*zapzap*)                    icon=""; name="WhatsApp" ;;
        *telegram*)                             icon=""; name="Telegram" ;;

        # --- SYSTEM / GAMES ---
        *thunar*|*nemo*|*files*)                icon=""; name="Files" ;;
        *steam*)                                icon=""; name="Steam" ;;
        *undertale*)                            icon="󰓓"; name="Undertale" ;;

        # --- FALLBACK ---
        *)
            icon=""
            # Pure Bash Regex to extract name (Faster than awk)
            if [[ "$wm_class" =~ \"([^\"]+)\"$ ]]; then
                name="${BASH_REMATCH[1]}"
            else
                name="Window"
            fi
            # Capitalize first letter
            name="${name^}"
            ;;
    esac

    # 4. Anti-Slide (Truncate to 15 chars max)
    if [ ${#name} -gt 15 ]; then
        name="${name:0:13}.."
    fi

    # Output with double space for clean look
    echo "$icon  $name"
    
done