return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {},
	init = function()
		local highlight = {
			"AuroraRed",
			"AuroraOrange",
			"AuroraYellow",
			"AuroraGreen",
			"AuroraPurple",
			"FrostGreen",
			"FrostCyan",
			"FrostGray",
			"FrostBlue",
		}
		local hooks = require("ibl.hooks")
		-- create the highlight groups in the highlight setup hook, so they are reset
		-- every time the colorscheme changes
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "AuroraRed", { fg = "#BF616A" })
			vim.api.nvim_set_hl(0, "AuroraOrange", { fg = "#D08770" })
			vim.api.nvim_set_hl(0, "AuroraYellow", { fg = "#EBCB8B" })
			vim.api.nvim_set_hl(0, "AuroraGreen", { fg = "#A3BE8C" })
			vim.api.nvim_set_hl(0, "AuroraPurple", { fg = "#B48EAD" })
			vim.api.nvim_set_hl(0, "FrostGreen", { fg = "#8FBCBB" })
			vim.api.nvim_set_hl(0, "FrostCyan", { fg = "#88C0D0" })
			vim.api.nvim_set_hl(0, "FrostGray", { fg = "#81A1C1" })
			vim.api.nvim_set_hl(0, "FrostBlue", { fg = "#5E81AC" })
		end)
		vim.g.rainbow_delimiters = { highlight = highlight }
		require("ibl").setup({ scope = { highlight = highlight } })

		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end,
}
