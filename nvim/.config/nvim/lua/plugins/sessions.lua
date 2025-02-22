return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			sessions_lens = {
				buftypes_to_ignore = {},
				load_on_setup = true,
				theme_conf = { border = true },
				previewer = false,
			},
		})

		vim.keymap.set(
			"n",
			"<leader>fs",
			require("auto-session.session-lens").search_session,
			{ noremap = true, desc = "Telescope search sessions" }
		)
	end,
}
