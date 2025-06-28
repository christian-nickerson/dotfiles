#!/bin/bash

# Path to the Mailspring database
MAILSPRING_DB="$HOME/.config/Mailspring/edgehill.db"

# Check if the database file exists
if [ ! -f "$MAILSPRING_DB" ]; then
  # Fallback for snap installs
  SNAP_MAILSPRING_DB="$HOME/snap/mailspring/current/.config/Mailspring/edgehill.db"
  if [ -f "$SNAP_MAILSPRING_DB" ]; then
    MAILSPRING_DB="$SNAP_MAILSPRING_DB"
  else
    echo "{\"text\": \"\", \"tooltip\": \"Mailspring database not found\"}"
    exit 1
  fi
fi

# Query for unread emails in the last 30 days
UNREAD_COUNT=$(sqlite3 "$MAILSPRING_DB" "SELECT count(*) FROM Message WHERE unread = 1 AND date > strftime('%s', 'now', '-30 days');")

# Default icon and class
ICON="" # fa-envelope-o
CLASS="read"
TOOLTIP="No new mail"

# If there are unread emails, change the icon, class and tooltip
if [ "$UNREAD_COUNT" -gt 0 ]; then
  ICON="" # fa-envelope
  CLASS="unread"
  TOOLTIP="$UNREAD_COUNT unread message(s)"
fi

# Output in JSON format for Waybar
printf '{"text": "%s", "tooltip": "%s"}\n' "$ICON" "$TOOLTIP"


