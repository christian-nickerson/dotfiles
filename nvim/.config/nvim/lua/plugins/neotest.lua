return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      build = ":TSUpdate go",
    },
    "nvim-neotest/neotest-python",
    "fredrikaverpil/neotest-golang",
  },

  config = function()
    require("neotest").setup({
      adapters = {

        require("neotest-python")({
          dap = { justMyCode = false },
          args = { "--rootdir=.", "-c", "pyproject.toml" },
        }),

        require("neotest-golang")({
          go_test_args = { "-v", "-race", "-count=1" },
        }),
      },
    })
  end,
}
