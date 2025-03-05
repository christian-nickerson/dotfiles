return {
	"danymat/neogen",
	config = function()
		require("neogen").setup({
			enabled = true,
			snippet_engine = "luasnip",
			languages = {
				python = {
					template = {
						annotation_convention = "reST",
					},
				},
			},
		})

		vim.api.nvim_set_keymap(
			"n",
			"<Leader>df",
			":lua require('neogen').generate()<CR>",
			{ noremap = true, silent = true, desc = "Docstring format" }
		)
	end,
}
