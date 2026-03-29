.PHONY: waybar

# Recompiles the SCSS to CSS and restarts Waybar
waybar:
	sass waybar/.config/waybar/style.scss waybar/.config/waybar/style.css
	pkill waybar || true
	nohup waybar > /dev/null 2>&1 &
