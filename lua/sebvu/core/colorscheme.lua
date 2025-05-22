-- return {
-- 	-- after about a year, i am finally trying another color theme
-- 	-- if i want to manually changes and view on the fly, do :NightfoxInteractive
-- 	"EdenEast/nightfox.nvim",
-- 	lazy = false,
-- 	priority = 1000, -- to avoid weird highlight groups
-- 	opts = {
-- 		options = {
-- 			transparent = true,
-- 			styles = {
-- 				comments = "italic",
-- 				keywords = "bold",
-- 				types = "italic,bold",
-- 			},
-- 			-- inverse = {
-- 			-- 	match_paren = true,
-- 			-- 	visual = true,
-- 			-- 	search = true,
-- 			-- },
-- 		},
-- 	},
-- 	init = function()
-- 		vim.cmd("colorscheme nordfox")
-- 		-- setting colors for line numbers
-- 		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#5E81AC", bold = false })
-- 		vim.api.nvim_set_hl(0, "LineNr", { fg = "#EBCB8B", bold = true })
-- 		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#5E81AC", bold = false })
-- 		vim.cmd("highlight NormalFloat ctermbg=NONE guibg=NONE")
-- 	end,
-- 	build = function()
-- 		require("nightfox").compile() -- compile and save to reduce re-initializing every time
-- 	end,
-- }
--
--
return {
	-- catppuccin colorscheme
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			-- all integrated plugins to catppuccin theme
			integrations = {
				cmp = true,
				gitsigns = true,
				neotree = true,
				treesitter = true,
				treesitter_context = true,
				notify = true,
				noice = true,
				-- mason = true,
				telescope = true,
				alpha = true,
			},
		})
		vim.cmd.colorscheme("catppuccin-mocha")

		-- setting colors for line
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#6c7086", bold = false })
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#f9e2af", bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#6c7086", bold = false })

    --
		vim.wo.foldlevel = 99
		vim.wo.conceallevel = 2
	end,
}
