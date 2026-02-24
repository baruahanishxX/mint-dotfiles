#!/bin/bash

case "$1" in
    up)
        # Increases brightness by 5%
        brightnessctl set +5%
        ;;
    down)
        # Decreases brightness by 5%
        brightnessctl set 5%-
        ;;
    *)
        # Default: Prints current percentage (e.g., "70%")
        # -m = machine readable (comma separated)
        # cut -d, -f4 extracts the 4th item (the percentage)
        brightnessctl -m | cut -d, -f4
        ;;
esac
