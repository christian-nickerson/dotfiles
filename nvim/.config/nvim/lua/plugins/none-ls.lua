return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    -- Format-on-save is handled centrally in lsp-config.lua's LspAttach
    -- autocmd, which prefers null-ls when it has a formatter for the
    -- filetype and falls back to other clients otherwise.
    null_ls.setup({
      sources = {
        -- lua
        null_ls.builtins.formatting.stylua,
        -- go
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.golines,
        null_ls.builtins.diagnostics.golangci_lint,
        -- docker
        null_ls.builtins.diagnostics.hadolint,
      },
    })
  end,
}
