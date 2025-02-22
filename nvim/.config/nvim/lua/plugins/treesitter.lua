return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    init = function(plugin)
        require("lazy.core.loader").add_to_rtp(plugin)
        require("nvim-treesitter.query_predicates")
    end,

    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            auto_install = true,
            ensure_installed = { "lua", "python", "go", "ninja", "rst", "http" },
            highlight = { enable = true, additional_vim_regex_highlighting = false },
            indent = { enable = true },
        })
    end,
}
