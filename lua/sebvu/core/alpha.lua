return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		-- helper methods
		local quotes = {
			"The only way to do great work is to love what you do. - Steve Jobs",
			"The seats are empty, the theatre is dark... why do you keep acting? - M. Gaby Cayambe Tenemaza",
			"I must change my life so I can live it, not wait for it. - M. Gaby Cayambe Tenemaza",
			"The biggest risk is not taking a risk at all - M. Gaby Cayambe Tenemaza",
			"koko is BABES - M. Gaby Cayambe Tenemaza",
			"just keep trying jester - Jester Santos",
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
			[[       myself 💙 `Y'             ]],
			[[                                 ]],
			[[     _._     _,-'""`-._          ]],
			[[    (,-.`._,'(       |\`-/|      ]],
			[[        `-.-' \ )-`( , o o)      ]],
			[[              `-    \`_`"'-      ]],
			[[                                 ]],
			[[      latte 💛 maya 😒 koko      ]],
			[[                                 ]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find Files", "<cmd>Telescope find_files<CR>"),
			dashboard.button("p", "⥯  Enter Previous File", "<cmd>Telescope oldfiles<CR>"),
			dashboard.button("c", "💉 Check Healh", "<cmd>checkhealth<CR>"),
			dashboard.button("q", "💔 Quit The Grind", "<cmd>qa<CR>"),
		}
		dashboard.section.footer.val = getRandomQuote()

		require("alpha").setup(dashboard.config)
	end,
}
