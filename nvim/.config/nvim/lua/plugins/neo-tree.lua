return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },

  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = { ".git" },
        },
      },
    })

    vim.api.nvim_create_autocmd({ "BufLeave" }, {
      pattern = { "*lazygit*" },
      group = vim.api.nvim_create_augroup("git_refresh_neotree", { clear = true }),
      callback = function()
        require("neo-tree.sources.filesystem.commands").refresh(
          require("neo-tree.sources.manager").get_state("filesystem")
        )
      end,
    })
  end,
}
