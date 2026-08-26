return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ruff",
          "ty",
          "gopls",
          "golangci_lint_ls",
          "dockerls",
          "texlab",
        },
      })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      -- nixfmt is intentionally excluded: mason's registry only ships a
      -- linux_x64 asset for it. Install via `brew install nixfmt` instead.
      ensure_installed = { "stylua", "hadolint", "goimports", "golines" },
      run_on_start = true,
      auto_update = false,
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local format_augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

      -- Single format-on-save handler for every LSP client.
      -- Prefers null-ls (none-ls) when it offers formatting for the filetype,
      -- otherwise falls back to any other capable client. Python is the one
      -- carve-out: ruff owns formatting/imports, pyright owns hover only.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = format_augroup,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false -- let pyright handle hover
          end

          if not client:supports_method("textDocument/formatting") then
            return
          end

          vim.api.nvim_clear_autocmds({ group = format_augroup, buffer = args.buf })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = format_augroup,
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({
                bufnr = args.buf,
                async = false,
                filter = function(c)
                  if c.name == "pyright" then
                    return false -- ruff owns Python formatting
                  end
                  local has_null_ls = vim.iter(vim.lsp.get_clients({ bufnr = args.buf })):any(function(nc)
                    return nc.name == "null-ls"
                  end)
                  if has_null_ls then
                    return c.name == "null-ls"
                  end
                  return true
                end,
              })
            end,
          })
        end,
      })

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

      -- ty
      vim.lsp.config("ty", {
        capabilities = capabilities,
        settings = {
          ty = {
            diagnosticMode = "workspace",
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

      -- mason-lspconfig's automatic_enable (default true) already enables
      -- every server in its ensure_installed list. Only enable the servers
      -- managed outside mason here.
      vim.lsp.enable("templ")
      vim.lsp.enable("rust_analyzer")
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
