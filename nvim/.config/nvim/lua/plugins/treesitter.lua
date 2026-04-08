return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- main branch does not support lazy-loading
  build = ":TSUpdate",

  config = function()
    -- setup() only accepts install_dir in the main branch rewrite;
    -- all other options from the old configs.setup() are gone.
    require("nvim-treesitter").setup()

    -- Register .templ files as the "templ" filetype so the FileType
    -- autocmd below fires correctly (Neovim has no built-in detection).
    vim.filetype.add({ extension = { templ = "templ" } })

    -- Install parsers asynchronously on startup.
    -- Replaces the old ensure_installed / auto_install options.
    require("nvim-treesitter").install({
      "lua",
      "python",
      "go",
      "templ",
      "ninja",
      "rst",
      "latex",
      "bibtex",
    })

    -- Enable treesitter highlighting and indentation per filetype.
    -- In the main branch these are no longer auto-enabled; they must be
    -- wired up explicitly. Indentation is still marked experimental upstream.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lua", "python", "go", "templ", "ninja", "rst", "latex", "bibtex" },
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
