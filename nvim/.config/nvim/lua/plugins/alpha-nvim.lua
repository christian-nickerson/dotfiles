return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local startify = require("alpha.themes.startify")

		startify.file_icons.provider = "devicons"
		startify.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                     ",
		}

		-- Set menu
		--  startify.section.buttons.val = {
		--	  startify.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
		--	  startify.button("f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
		--	  startify.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
		--	  startify.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
		--	  startify.button("q", "  > Quit NVIM", ":qa<CR>"),
		--  }

		alpha.setup(startify.config)
	end,
}
