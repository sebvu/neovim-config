return {
	"rebelot/kanagawa.nvim",
	opts = {
		transparent = true,
		colors = {
			theme = {
				all = {
					ui = {
						bg_gutter = "none",
					},
				},
			},
		},
		overrides = function(colors)
			local theme = colors.theme
			return {
				NormalFloat = { bg = "none" },
				FloatBorder = { bg = "none" },
				FloatTitle = { bg = "none" },

				-- Save an hlgroup with dark background and dimmed foreground
				-- so that you can use it where your still want darker windows.
				-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
				NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

				-- Popular plugins that open floats will link to NormalFloat by default;
				-- set their background accordingly if you wish to keep them dark and borderless
				LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
				MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
			}
		end,
	},
	init = function()
		vim.cmd("colorscheme kanagawa-dragon")
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#49443C", bold = false })
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#DCA561", bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#49443C", bold = false })
	end,
}
