# Source the 1Password session management script
source "${0:a:h}/op-session.zsh"

# Export the Anthropic API key using our session management
if ANTHROPIC_API_KEY=$(op_read_secret "op://Personal/Claude API Key/credential"); then
  export ANTHROPIC_API_KEY
else
  echo "Warning: Failed to retrieve Anthropic API key from 1Password" >&2
fi

