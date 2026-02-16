#!/usr/bin/env bash
# wlogout launcher - generates style.css with absolute paths and launches wlogout

CONFIG_DIR="$HOME/.config/wlogout"

# Generate style.css from template (only if template is newer or style.css missing)
if [[ ! -f "$CONFIG_DIR/style.css" ]] || [[ "$CONFIG_DIR/style.css.template" -nt "$CONFIG_DIR/style.css" ]]; then
    sed "s|__CONFIG_DIR__|$CONFIG_DIR|g" "$CONFIG_DIR/style.css.template" > "$CONFIG_DIR/style.css"
fi

# Get screen resolution for dynamic margins
resolution=$(hyprctl monitors -j 2>/dev/null | jq -r '.[0] | "\(.width)x\(.height)"')

case "$resolution" in
    3840x1600|3440x1440) # Ultrawide
        margins="-L 600 -R 600 -T 550 -B 550"
        ;;
    3840x1200) # Ultrawide shorter
        margins="-L 600 -R 600 -T 300 -B 300"
        ;;
    3840x2160) # 4K
        margins="-L 800 -R 800 -T 900 -B 900"
        ;;
    2560x1440) # 1440p
        margins="-L 400 -R 400 -T 550 -B 550"
        ;;
    1920x1080) # 1080p
        margins="-L 200 -R 200 -T 400 -B 400"
        ;;
    *)
        margins="-L 200 -R 200 -T 400 -B 400"
        ;;
esac

wlogout -b 6 -c 6 -r 1 "$margins" -l "$CONFIG_DIR/layout"
