return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		opts = { ensure_installed = { "black", "mypy", "ruff", "goimports", "golines" } },
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = { auto_install = true },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "ruff", "gopls", "golangci_lint_ls" },
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({ capabilities = capabilities })

			lspconfig.pyright.setup({
				capabilities = capabilities,
				settings = {
					pyright = {
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							ignore = { "*" },
						},
					},
				},
			})

			lspconfig.ruff.setup({
				capabilities = capabilities,
				trace = "messages",

				on_attach = function(client, buffer)
					if client.name == "ruff" then
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.hoverProvider = false
					end
				end,

				init_options = {
					settings = {
						logLevel = "debug",
						fix = true,
					},
				},
			})

			lspconfig.mypy.setup({ capabilities = capabilities })

			lspconfig.gopls.setup({
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gotmpl", "gowork" },
				root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
					},
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		end,
	},

	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
			"mfussenegger/nvim-dap-python",
		},

		branch = "regexp",
		keys = {
			{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "VenvSelect select" },
			{ "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "VenvSelect select cached" },
		},

		config = function()
			require("venv-selector").setup()
		end,
	},
}
