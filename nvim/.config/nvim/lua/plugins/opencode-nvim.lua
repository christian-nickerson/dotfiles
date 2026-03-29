return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    local opencode_cmd = "opencode --port"

    local function setup_terminal(win)
      local buf = vim.api.nvim_win_get_buf(win)
      local pid
      vim.api.nvim_create_autocmd("TermOpen", {
        buffer = buf,
        once = true,
        callback = function(event)
          local opts = { buffer = event.buf }
          vim.keymap.set("n", "<C-u>", function()
            require("opencode").command("session.half.page.up")
          end, opts)
          vim.keymap.set("n", "<C-d>", function()
            require("opencode").command("session.half.page.down")
          end, opts)
          vim.keymap.set("n", "gg", function()
            require("opencode").command("session.first")
          end, opts)
          vim.keymap.set("n", "G", function()
            require("opencode").command("session.last")
          end, opts)
          vim.keymap.set("n", "<Esc>", function()
            require("opencode").command("session.interrupt")
          end, opts)
          _, pid = pcall(vim.fn.jobpid, vim.b[event.buf].terminal_job_id)
        end,
      })
      local terminate = function()
        if pid then
          if vim.fn.has("unix") == 1 then
            os.execute("kill -TERM -" .. pid .. " 2>/dev/null")
          else
            pcall(vim.uv.kill, pid, "SIGTERM")
          end
        end
      end
      vim.api.nvim_create_autocmd({ "TermClose", "ExitPre" }, { buffer = buf, once = true, callback = terminate })
    end

    ---@type snacks.terminal.Opts
    local snacks_terminal_opts = {
      win = {
        position = "float",
        enter = true,
        border = "rounded",
        on_win = function(win)
          setup_terminal(win.win)
        end,
      },
    }

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts):focus()
        end,
        stop = function()
          require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts):close()
        end,
        toggle = function()
          require("snacks.terminal").focus(opencode_cmd, snacks_terminal_opts)
        end,
      },
    }
    vim.o.autoread = true
  end,
}
