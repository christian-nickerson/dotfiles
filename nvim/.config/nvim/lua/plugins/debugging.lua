return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      require("dapui").setup()

      local function setup_python_dap()
        local venv = require("venv-selector")
        local python_path = venv.python()
        if python_path then
          require("dap-python").setup(python_path)
        else
          require("dap-python").setup("python")
        end
      end

      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = setup_python_dap,
      })

      require("dap-go").setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end

      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
