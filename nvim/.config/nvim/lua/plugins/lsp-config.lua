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
						client.server_capabilities.hoverProvider = true
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
		config = function()
			require("venv-selector").setup()

			vim.api.nvim_create_autocmd("VimEnter", {
				desc = "Auto select virtualenv nvim open",
				pattern = "*",
				callback = function()
					local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
					if venv ~= "" then
						require("venv-selector").retrieve_from_cache()
					end
				end,
				once = true,
			})
		end,
	},
}
