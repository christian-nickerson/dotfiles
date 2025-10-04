return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      auto_restore = false,
      auto_save = true,
      auto_create = true,
      suppressed_dirs = { "~/", "~/Downloads", "/" },
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
    })
  end,
}
