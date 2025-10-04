return {
  "catppuccin/nvim",
  name = "catppuccin",

  lazy = false,
  priority = 999,

  opts = {
    integrations = {
      treesitter = true,
      treesitter_context = true,
    },
  },

  config = function()
    require("catppuccin").setup({ flavour = "macchiato" })
    vim.cmd.colorscheme("catppuccin")
  end,
}
