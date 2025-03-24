return {
	"numToStr/Comment.nvim",
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
