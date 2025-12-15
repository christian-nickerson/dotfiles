return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      provider = {
        snacks = {
          win = {
            position = "float",
            enter = true,
            border = true,
          },
        },
      },
    }
    vim.o.autoread = true
  end,
}
