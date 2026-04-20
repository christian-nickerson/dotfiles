return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ensure_installed = {
          "stylua",
          "mypy",
          "goimports",
          "golines",
          "nixfmt",
          "rustfmt",
        },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = { auto_install = true },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ruff",
          "gopls",
          "golangci_lint_ls",
          "dockerls",
          "texlab",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- lua_ls
      vim.lsp.config("lua_ls", { capabilities = capabilities })

      -- pyright
      vim.lsp.config("pyright", {
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

      -- ruff
      vim.lsp.config("ruff", {
        capabilities = capabilities,
        init_options = {
          settings = {
            logLevel = "debug",
          },
        },
      })

      -- Format on save for ruff (Python files)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "ruff" then
            -- Enable formatting capability
            client.server_capabilities.hoverProvider = false -- Let pyright handle hover
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({
                  async = false,
                  filter = function(c)
                    return c.name == "ruff"
                  end,
                })
              end,
            })
          end
        end,
      })

      -- templ
      vim.lsp.config("templ", {
        capabilities = capabilities,
        cmd = { "templ", "lsp" },
        filetypes = { "templ" },
        root_markers = { "go.mod", ".git" },
      })

      -- gopls
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gotmpl", "gowork" },
        root_markers = { "go.work", "go.mod", ".git" },
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
        on_attach = function(client, bufnr)
          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      })

      -- rust_analyzer
      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
            },
          },
        },
        on_attach = function(client, bufnr)
          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      })

      -- tflint
      vim.lsp.config("tflint", {
        capabilities = capabilities,
      })

      -- terraformls
      vim.lsp.config("terraformls", {
        capabilities = capabilities,
      })

      -- texlab
      local texlab_forward_search = {}
      if vim.fn.has("mac") == 1 then
        texlab_forward_search = {
          executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
          args = { "%l", "%p", "%f" },
        }
      else
        texlab_forward_search = {
          executable = "zathura",
          args = { "--synctex-forward", "%l:1:%f", "%p" },
        }
      end

      vim.lsp.config("texlab", {
        capabilities = capabilities,
        settings = {
          texlab = {
            build = {
              executable = "tectonic",
              args = { "-X", "compile", "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
              onSave = true,
              forwardSearchAfter = false,
            },
            forwardSearch = texlab_forward_search,
            chktex = {
              onOpenAndSave = true,
              onEdit = false,
            },
            diagnosticsDelay = 300,
            latexFormatter = "latexindent",
            bibtexFormatter = "texlab",
          },
        },
      })

      -- Enable all configured servers
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("ruff")
      vim.lsp.enable("templ")
      vim.lsp.enable("gopls")
      vim.lsp.enable("rust_analyzer")
      vim.lsp.enable("texlab")
      vim.lsp.enable("tflint")
      vim.lsp.enable("terraformls")
    end,
  },

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      require("venv-selector").setup({
        settings = {
          options = {
            notify_user_on_venv_activation = true,
          },
        },
      })

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
