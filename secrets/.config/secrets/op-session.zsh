#!/usr/bin/env zsh

# File: op-session.zsh
# Purpose: Manage 1Password CLI sessions to avoid login prompts for each terminal session

# Directory to store the session token
OP_SESSION_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/op"
OP_SESSION_FILE="$OP_SESSION_DIR/session_token"

# Create the session directory if it doesn't exist
if [[ ! -d "$OP_SESSION_DIR" ]]; then
  mkdir -p "$OP_SESSION_DIR"
  chmod 700 "$OP_SESSION_DIR"
fi

# Function to check if the session is valid
function op_is_session_valid() {
  if [[ ! -f "$OP_SESSION_FILE" ]]; then
    return 1
  fi
  
  # Load the session token
  local token=$(cat "$OP_SESSION_FILE")
  
  # Check if the token is valid by making a simple request
  if OP_SESSION_TOKEN="$token" op account get >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# Function to create a new session
function op_create_session() {
  echo "Creating new 1Password session..."
  
  # Sign in and get the session token
  local token=$(op signin --raw)
  
  # If successful, save the token
  if [[ $? -eq 0 && -n "$token" ]]; then
    echo "$token" > "$OP_SESSION_FILE"
    chmod 600 "$OP_SESSION_FILE"
    return 0
  else
    echo "Failed to sign in to 1Password" >&2
    return 1
  fi
}

# Function to get a valid session token
function op_get_session() {
  if ! op_is_session_valid; then
    op_create_session
  fi
  
  if [[ -f "$OP_SESSION_FILE" ]]; then
    cat "$OP_SESSION_FILE"
  else
    return 1
  fi
}

# Function to read a secret from 1Password
function op_read_secret() {
  local secret_path="$1"
  local token=$(op_get_session)
  
  if [[ -n "$token" ]]; then
    OP_SESSION_TOKEN="$token" op read "$secret_path" 2>/dev/null
    return $?
  else
    return 1
  fi
}

# Export the functions
export -f op_is_session_valid
export -f op_create_session
export -f op_get_session
export -f op_read_secret

