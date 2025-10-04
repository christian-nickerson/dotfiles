# Agent Guidelines for dotfiles

## Testing & Linting

- Run all pre-commit hooks: `pre-commit run --all-files`
- Format Lua files: `stylua --config-path nvim/.config/nvim/.stylua.toml nvim/`
- Format JSON/YAML/MD: `prettier --write <file>`
- Shell linting: `shellcheck <file>` (excludes p10k/.p10k.zsh)

## Code Style

**Lua (Neovim config):**

- 2 space indentation, 120 char line width, Unix line endings
- Use `require()` for imports, double quotes preferred
- Call parentheses always required
- Local variables: `local var = require("module")`
- No trailing whitespace, files end with newline

**Neovim Keymaps:**

- All keymaps MUST be defined in `nvim/.config/nvim/lua/keymaps.lua`
- Do NOT define keymaps in plugin configuration files
- Group keymaps logically under leader keys with descriptive names
- Every root leader key group MUST have an emoji icon
- Use `which-key` syntax for all keymap definitions

**Shell Scripts:**

- Must pass shellcheck validation

**General:**

- No mixed line endings
- Check YAML/TOML/JSON syntax before committing
- No large files (pre-commit enforces this)
