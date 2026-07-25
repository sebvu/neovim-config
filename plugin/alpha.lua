vim.pack.add({
	"https://github.com/goolord/alpha-nvim",
	-- dependencies
	"https://github.com/nvim-tree/nvim-web-devicons",
})

local quotes = {
	"I love Cristal so much",
	"keep working, you got this!",
	"life will get better, trust.",
}

local function getRandomQuote()
	math.randomseed(os.time())
	return quotes[math.random(#quotes)]
end

local dashboard = require("alpha.themes.dashboard")
require("alpha").setup(dashboard.config)

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
