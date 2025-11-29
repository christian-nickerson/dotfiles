#!/usr/bin/env bash

# Path to Thunderbird profiles
THUNDERBIRD_PROFILES="$HOME/.thunderbird"

# Find the default profile directory
PROFILE_DIR=$(find "$THUNDERBIRD_PROFILES" -maxdepth 1 -type d -name "*.default*" | head -n 1)

if [ -z "$PROFILE_DIR" ]; then
  echo "{\"text\": \"\", \"tooltip\": \"Thunderbird profile not found\"}"
  exit 1
fi

# Initialize unread counter
UNREAD_COUNT=0

# Find all mbox files (mail folders) - check both ImapMail and Mail directories
# Exclude Trash, Junk, Sent, Drafts folders
MAIL_DIRS=$(find "$PROFILE_DIR/ImapMail" "$PROFILE_DIR/Mail" -type d -name "*.com*" 2>/dev/null)

for MAIL_DIR in $MAIL_DIRS; do
  # Find all mbox files (files without extensions, excluding .msf)
  for MBOX_FILE in "$MAIL_DIR"/*; do
    # Skip if not a regular file, or if it's an .msf, .sbd, or hidden file
    [[ ! -f "$MBOX_FILE" ]] && continue
    [[ "$MBOX_FILE" =~ \.(msf|sbd)$ ]] && continue
    [[ "$(basename "$MBOX_FILE")" =~ ^\..*$ ]] && continue

    # Skip Trash, Junk, Sent, Drafts folders
    BASENAME=$(basename "$MBOX_FILE")
    [[ "$BASENAME" =~ ^(Trash|Junk|Sent|Drafts)$ ]] && continue

    # Count messages where X-Mozilla-Status does NOT have the 0x0001 (read) flag set
    # Status format is 4 hex digits, read flag is the last digit being odd
    # Unread = 0000, 0002, 0004, 0006, 0008, 000a, 000c, 000e (even last digit)
    COUNT=$(grep -E "^X-Mozilla-Status: [0-9a-fA-F]{4}$" "$MBOX_FILE" 2>/dev/null | \
            awk '{
              # Extract the hex value
              status = $2
              # Convert to decimal
              dec = strtonum("0x" status)
              # Check if read bit (0x0001) is NOT set
              if (and(dec, 1) == 0) print status
            }' | wc -l)

    UNREAD_COUNT=$((UNREAD_COUNT + COUNT))
  done
done

# Default icon and tooltip
ICON="󰇰"
TOOLTIP="No new mail"
TEXT="$ICON"

# If there are unread emails, change the icon and tooltip
if [ "$UNREAD_COUNT" -gt 0 ]; then
  ICON="󰇮"
  TEXT="$ICON $UNREAD_COUNT"
  TOOLTIP="$UNREAD_COUNT unread message(s)"
fi

# Output in JSON format for Waybar
printf '{"text": "%s", "tooltip": "%s"}\n' "$TEXT" "$TOOLTIP"
