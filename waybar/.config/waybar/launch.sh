#!/usr/bin/env bash

# Quit running waybar instances
pkill waybar

# Dynamic configuration based on physical laptop battery presence
CONFIG_SRC="$HOME/.config/waybar/config.json"
CONFIG_DEST="$HOME/.config/waybar/config"

if [ -f "$CONFIG_SRC" ]; then
    # Laptop batteries typically start with BAT in sysfs
    if ls /sys/class/power_supply/BAT* >/dev/null 2>&1; then
        cp "$CONFIG_SRC" "$CONFIG_DEST"
    else
        # Safely remove the battery module on desktops using jq
        jq '.["modules-right"] -= ["battery"]' "$CONFIG_SRC" > "$CONFIG_DEST"
    fi
fi

# Compile SCSS to CSS
sass ~/.config/waybar/style.scss ~/.config/waybar/style.css

# Launch waybar
nohup waybar > /dev/null 2>&1 &
