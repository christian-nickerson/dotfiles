#!/usr/bin/env bash
# wlogout launcher - generates style.css with absolute paths and launches wlogout

CONFIG_DIR="$HOME/.config/wlogout"

# Configuration: Sizing as fraction of screen dimensions (0.0 - 1.0)
HEIGHT_RATIO="0.60"      # Fraction of screen height occupied by buttons (e.g. 0.60 = 60%)
WIDTH_MAX_RATIO="0.85"   # Maximum fraction of screen width occupied by buttons

# Generate style.css from template (only if template is newer or style.css missing)
if [[ ! -f "$CONFIG_DIR/style.css" ]] || [[ "$CONFIG_DIR/style.css.template" -nt "$CONFIG_DIR/style.css" ]]; then
    sed "s|__CONFIG_DIR__|$CONFIG_DIR|g" "$CONFIG_DIR/style.css.template" > "$CONFIG_DIR/style.css"
fi

# Dynamically calculate margins based on focused monitor resolution and scale
read -r margin_x margin_y < <(
    hyprctl monitors -j 2>/dev/null | jq -r --argjson hr "$HEIGHT_RATIO" --argjson wr "$WIDTH_MAX_RATIO" '
        if type == "array" and length > 0 then
            ((.[] | select(.focused == true)) // .[0]) as $m |
            (if ($m.transform // 0) % 2 == 1 then ($m.height / ($m.scale // 1) | floor) else ($m.width / ($m.scale // 1) | floor) end) as $w |
            (if ($m.transform // 0) % 2 == 1 then ($m.width / ($m.scale // 1) | floor) else ($m.height / ($m.scale // 1) | floor) end) as $h |
            ($h * $hr | floor) as $h_bar |
            (($h - $h_bar) / 2 | floor) as $my |
            ([400, ([($w * $wr | floor), ($h_bar * 3.5 | floor)] | min)] | max) as $w_bar |
            (($w - $w_bar) / 2 | floor) as $mx |
            "\($mx) \($my)"
        else
            empty
        end
    ' 2>/dev/null || true
)

# Fallback to sensible defaults if monitor detection failed
margin_x="${margin_x:-200}"
margin_y="${margin_y:-240}"

margin_args=(-L "$margin_x" -R "$margin_x" -T "$margin_y" -B "$margin_y")

exec wlogout -b 6 -r 1 "${margin_args[@]}" -l "$CONFIG_DIR/layout"
