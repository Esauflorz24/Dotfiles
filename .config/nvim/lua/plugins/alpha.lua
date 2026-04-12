return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                     ]],
			[[       ████ ██████           █████      ██                     ]],
			[[      ███████████             █████                             ]],
			[[      █████████ ███████████████████ ███   ███████████   ]],
			[[     █████████  ███    █████████████ █████ ██████████████   ]],
			[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
			[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
			[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
			[[                                                                       ]],
			[[                                                                       ]],
			[[                                                                       ]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("e", "New file", "<cmd>ene <CR>"),
			dashboard.button("ff", "Find file", "<cmd>Telescope find_files<CR>"),
			dashboard.button("fo", "Recent Files", "<cmd>Telescope oldfiles<CR>"),
			dashboard.button("SPC s r", "Resume Telescope"),
		}
		_Gopts = {
			position = "center",
			hl = "Type",
		}

		local function footer()
			return "The programmatic expression of my will. I live for this shit"
		end

		dashboard.section.footer.val = footer()

		dashboard.opts.opts.noautocmd = true

		alpha.setup(dashboard.opts)
	end,
}
