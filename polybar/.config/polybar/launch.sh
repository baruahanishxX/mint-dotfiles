#!/bin/bash

# 1. Terminate already running bar instances
killall -q polybar

# 2. Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# 3. Launch Polybar (using your bar name "main")
# Logs are saved to /tmp just in case you need to debug later
echo "---" | tee -a /tmp/polybar.log
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."