return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
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
