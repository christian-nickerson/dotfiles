return {
	"mgierada/lazydocker.nvim",
	dependencies = { "akinsho/toggleterm.nvim" },
	config = function()
		require("lazydocker").setup({
			border = "curved", -- valid options are "single" | "double" | "shadow" | "curved"
		})
	end,
	event = "BufRead",
}
