return {
  "catppuccin/nvim",
  name = "catppuccin",

  lazy = false,
  priority = 999,

  opts = {},

  config = function()
    require("catppuccin").setup({
      flavour = "macchiato",
      transparent_background = false,
      integrations = {
        treesitter = true,
        treesitter_context = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")

    -- Make only the main buffer background transparent, text stays opaque
    local transparent_groups = {
      "Normal",
      "NormalNC",
      "SignColumn",
      "EndOfBuffer",
    }
    for _, group in ipairs(transparent_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "NONE" })
    end
  end,
}
