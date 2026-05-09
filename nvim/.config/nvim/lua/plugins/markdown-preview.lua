return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,
  init = function()
    -- On Linux, xdg-open can be unreliable (e.g., on minimal NixOS setups without gio).
    -- Pick an available browser explicitly to bypass xdg-open.
    -- macOS and Windows use their native opener, which correctly uses the system default.
    if vim.fn.has("unix") == 1 and vim.fn.has("mac") == 0 then
      local candidates = {
        vim.env.BROWSER,
        "google-chrome-stable",
        "google-chrome",
        "chromium",
        "firefox",
        "brave",
        "zen-beta",
        "zen",
      }
      for _, browser in ipairs(candidates) do
        if browser and browser ~= "" and vim.fn.executable(browser) == 1 then
          vim.g.mkdp_browser = browser
          break
        end
      end
    end
  end,
  config = function()
    vim.cmd([[do FileType]])
  end,
}
