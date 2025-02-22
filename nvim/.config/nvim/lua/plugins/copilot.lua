return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "BufReadPost",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",

        keys = {
            { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat Toggle" },
            { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat Models" },
            {
                "<leader>ap",
                function()
                    local actions = require("CopilotChat.actions")
                    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
                end,
                desc = "CopilotChat Prompt actions",
            },
            {
                "<leader>ap",
                ":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
                mode = "x",
                desc = "CopilotChat Prompt actions",
            },
        },

        config = function()
            require("CopilotChat").setup({
                auto_insert_mode = true,
                window = {
                    layout = "vertical",
                    width = 0.3,
                },
            })
        end,
    },
}
