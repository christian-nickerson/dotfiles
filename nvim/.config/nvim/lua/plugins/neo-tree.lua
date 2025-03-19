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

				commands = {
					avante_add_files = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local relative_path = require("avante.utils").relative_path(filepath)

						local sidebar = require("avante").get()

						local open = sidebar:is_open()
						-- ensure avante sidebar is open
						if not open then
							require("avante.api").ask()
							sidebar = require("avante").get()
						end

						sidebar.file_selector:add_selected_file(relative_path)

						-- remove neo tree buffer
						if not open then
							sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
						end
					end,
				},

				window = {
					mappings = {
						["oa"] = "avante_add_files",
					},
				},
			},
		})

		vim.keymap.set("n", "<leader>t", ":Neotree toggle<CR>", { desc = "Neotree toggle" })

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
