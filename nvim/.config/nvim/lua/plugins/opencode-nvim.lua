return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		{ "folke/snacks.nvim", opts = { input = { enabled = true } } },
	},
	---@type opencode.Opts
	opts = {
		terminal = {
			win = {
				position = "float",
				enter = true,
			},
		},
	},
}
