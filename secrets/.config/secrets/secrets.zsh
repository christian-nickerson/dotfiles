#!/usr/bin/env zsh

# Only proceed if ANTHROPIC_API_KEY is not already set
if [[ -z "$ANTHROPIC_API_KEY" ]]; then
  # Check if 1Password CLI is installed
  if command -v op &>/dev/null; then
    # Try to get the key directly - this will prompt for authentication if needed
    API_KEY=$(op read "op://Personal/Claude API Key/credential" 2>/dev/null)
    
    if [[ -n "$API_KEY" ]]; then
      export ANTHROPIC_API_KEY="$API_KEY"
      echo "Successfully retrieved Anthropic API key from 1Password"
    fi
  fi
fi

