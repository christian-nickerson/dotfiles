return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.opts.position = "center"
		dashboard.section.footer.opts.position = "center"
		dashboard.section.header.val = {
			"                                                                              ",
			"=================     ===============     ===============   ========  ========",
			"\\\\ . . . . . . .\\\\   //. . . . . . .\\\\   //. . . . . . .\\\\  \\\\. . .\\\\// . . //",
			"||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||",
			"|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||",
			"||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||",
			"|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||",
			"||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\\_ . .|. .||",
			"|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| . ||",
			"||_-' ||  .|/    || ||    \\|.  || `-_|| ||_-' ||  .|/    || ||   | \\  / |-_.||",
			"||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \\  / |  `||",
			"||    `'         || ||         `'    || ||    `'         || ||   | \\  / |   ||",
			"||            .===' `===.         .==='.`===.         .===' /==. |  \\/  |   ||",
			"||         .=='   \\_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \\/  |   ||",
			"||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \\/  |   ||",
			"||   .=='    _-'          `-__\\._-'         `-_./__-'         `' |. /|  |   ||",
			"||.=='    _-'                                                     `' |  /==.||",
			"=='    _-'                        N E O V I M                         \\/   `==",
			"\\   _-'                                                                `-_   /",
			" `''                                                                      ``'  ",
		}

		local function footer()
			return "And now, they will fear you..."
		end

		dashboard.section.footer.val = footer()

		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "Include"
		dashboard.section.buttons.opts.hl = "Keyword"

		dashboard.opts.opts.noautocmd = true
		alpha.setup(dashboard.opts)
	end,
}
