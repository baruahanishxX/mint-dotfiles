#!/usr/bin/env bash

# 1. Get the wireless interface (usually wlo1 or wlan0)
INTERFACE=$(nmcli -t -f DEVICE,TYPE device | grep :wifi | cut -d: -f1 | head -n1)

# 2. Check current WiFi status (enabled/disabled)
STATUS=$(nmcli radio wifi)
if [ "$STATUS" = "enabled" ]; then
    TOGGLE="  Disable Wi-Fi"
else
    TOGGLE="  Enable Wi-Fi"
fi

# 3. Build the list of options
# - We add "Disable/Enable" and "Disconnect" at the top.
# - Then we list the available networks unique by SSID.
OPTIONS="$TOGGLE\n  Disconnect\n$(nmcli --fields "SSID,SECURITY,BARS" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.*/🔒/g" | sed "s/^--/🔓/g" | sed "s/🔒  /🔒 /g" | awk '!x[$0]++')"

# 4. Open the Rofi menu
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Wi-Fi Menu" -lines 15 -width 30)

# 5. Execute the selected command
case "$CHOICE" in
    "  Disable Wi-Fi")
        nmcli radio wifi off
        ;;
    "  Enable Wi-Fi")
        nmcli radio wifi on
        ;;
    "  Disconnect")
        nmcli device disconnect "$INTERFACE"
        ;;
    *)
        # If the user selected a network (it won't match the commands above)
        if [ -n "$CHOICE" ]; then
            # Clean up the string to get just the SSID (remove lock icons/bars)
            SSID=$(echo "$CHOICE" | sed "s/🔒 //g" | sed "s/🔓 //g" | awk '{$NF=""; print $0}' | xargs)
            
            # Connect
            nmcli device wifi connect "$SSID"
        fi
        ;;
esac