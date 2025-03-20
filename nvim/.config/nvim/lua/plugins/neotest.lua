return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
		"fredrikaverpil/neotest-golang",
	},

	config = function()
		require("neotest").setup({
			adapters = {

				require("neotest-python")({
					dap = { justMyCode = false },
				}),

				require("neotest-golang")({
					dap = { justMyCode = false },
					args = { "-v" },
					runner = "go test",
				}),
			},
		})
	end,
}
