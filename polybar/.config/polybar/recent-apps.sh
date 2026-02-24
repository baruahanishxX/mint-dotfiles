#!/bin/bash

# Color Config
BG="#1e1e2e"

print_list() {
    current_ws=$(xdotool get_desktop)
    active_win=$(xdotool getactivewindow 2>/dev/null)
    buffer=""

    while read -r line; do
        win_id_hex=$(echo "$line" | awk '{print $1}')
        win_ws=$(echo "$line" | awk '{print $2}')
        win_class=$(echo "$line" | awk '{print $3}')
        win_id_dec=$(printf "%d" "$win_id_hex")

        if [ "$win_ws" -eq "$current_ws" ]; then
            case "${win_class,,}" in
                *firefox*|*navigator*|*librewolf*)      icon=""; name="Firefox" ;;
                *google-chrome*|*chrome*)       icon="" ;;
                *brave*)                        icon="󰖟" ;;
                *code*|*vscode*|*cursor*)       icon="󰨞" ;;
                *sublime*|*subl*)               icon="" ;;
                *terminal*|*alacritty*|*kitty*) icon="" ;;
                *python*|*idle*)                icon="" ;;
                *thunar*|*nemo*|*files*)        icon="" ;;
                *evince*|*atril*|*pdf*)         icon="" ;;
                *libreoffice-writer*)           icon="󰈙" ;;
                *libreoffice-calc*)             icon="󱎏" ;;
                *spotify*)                      icon="" ;;
                *vlc*|*mpv*|*media*)            icon="󰕼" ;;
                *rhythmbox*)                    icon="󰎈" ;;
                *pix*|*viewnior*|*gimp*)        icon="󰄄" ;;
                *discord*|*webcord*)            icon="" ;;
                *whatsapp*)                     icon="" ;;
                *steam*)                        icon="" ;;
                *undertale*)                    icon="󰓓" ;;
                *)                              icon="" ;;
            esac

            if [ "$win_id_dec" -eq "$active_win" ]; then
                # Active: Blue Underline
                icon_style="%{u#89b4fa}%{+u}%{F#89b4fa}%{T3}$icon%{T-}%{F-}%{-u}"
                click_cmd="xdotool windowminimize $win_id_hex"
            else
                # Inactive: Invisible Underline
                icon_style="%{u#00000000}%{+u}%{F#6c7086}%{T3}$icon%{T-}%{F-}%{-u}"
                click_cmd="wmctrl -ia $win_id_hex"
            fi
            
            # Keep the 24px gap so big icons have room to breathe
            if [ -n "$buffer" ]; then
                buffer+="%{O24}"
            fi
            buffer+="%{A1:$click_cmd:}$icon_style%{A}"
        fi
    done < <(wmctrl -lx)

    if [ -n "$buffer" ]; then
    # Output ONLY the icons. 
    # Polybar config handles the background and rounded ends now.
    echo "$buffer"
else
    echo ""
fi
}

# Run once
print_list

# Spy for changes to update instantly
xprop -spy -root _NET_ACTIVE_WINDOW _NET_CURRENT_DESKTOP | while read -r _; do
    print_list
done