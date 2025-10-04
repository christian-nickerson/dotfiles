return {
  "numToStr/Comment.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("Comment").setup({
      padding = true,
      mappings = {
        basic = true,
        extra = false,
        extended = false,
      },
    })
  end,
}
