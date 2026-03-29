#!/usr/bin/env bash

# Quit running waybar instances
pkill waybar

# Compile SCSS to CSS
sass ~/.config/waybar/style.scss ~/.config/waybar/style.css

# Launch waybar
nohup waybar > /dev/null 2>&1 &
