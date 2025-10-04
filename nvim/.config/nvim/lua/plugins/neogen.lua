return {
  "danymat/neogen",
  cmd = "Neogen",
  config = function()
    require("neogen").setup({
      enabled = true,
      snippet_engine = "luasnip",
      languages = {
        python = {
          template = {
            annotation_convention = "reST",
          },
        },
        go = {
          template = {
            annotation_convention = "godoc",
          },
        },
      },
    })
  end,
}
