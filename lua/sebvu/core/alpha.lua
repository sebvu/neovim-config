return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- helper methods
		local quotes = {
			"why is cristal so cute",
			"just keep going jester",
		}

		local function getRandomQuote() -- no clue if this is the best way to do random nums in lua
			math.randomseed(os.time())
			return quotes[math.random(#quotes)]
		end
		-------------------
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[                                 ]],
			[[                                 ]],
			[[                                 ]],
			[[         ,d88b.d88b,             ]],
			[[         88888888888             ]],
			[[         `Y8888888Y'             ]],
			[[  .*.      `Y888Y'               ]],
			[[  ***        `Y'  jester 💜      ]],
			[[   V                        ***  ]],
			[[ /\|/\         d8b d8b     /\v   ]],
			[[   |          888888888      |/\ ]],
			[[   |          `Y88888P'      |   ]],
			[[               `Y888P'           ]],
			[[                `Y8P'            ]],
			[[      cristal 💙 `Y'             ]],
			[[                                 ]],
			[[     _._     _,-'""`-._          ]],
			[[    (,-.`._,'(       |\`-/|      ]],
			[[        `-.-' \ )-`( , o o)      ]],
			[[              `-    \`_`"'-      ]],
			[[                                 ]],
			[[      latte 💛 maya 🙏 koko      ]],
			[[                                 ]],
		}

		dashboard.section.buttons.val = {}
		dashboard.section.footer.val = getRandomQuote()

		require("alpha").setup(dashboard.config)
	end,
}
