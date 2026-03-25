return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    -- Detect OS and set appropriate PDF viewer
    if vim.fn.has("mac") == 1 then
      vim.g.vimtex_view_method = "skim"
    else
      vim.g.vimtex_view_method = "zathura"
    end

    vim.g.vimtex_compiler_method = "tectonic"
    vim.g.vimtex_compiler_tectonic = {
      options = {
        "--keep-logs",
        "--synctex",
      },
    }

    -- Disable VimTeX completion in favour of texlab LSP via nvim-cmp
    vim.g.vimtex_complete_enabled = 0

    -- Don't auto-open quickfix on compile errors (use <leader> keymaps instead)
    vim.g.vimtex_quickfix_mode = 0
  end,
}
