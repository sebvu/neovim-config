vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-mini/mini.nvim", -- if you use the mini.nvim suite
	-- 'https://github.com/nvim-mini/mini.icons',        -- if you use standalone mini plugins
	-- 'https://github.com/nvim-tree/nvim-web-devicons', -- if you prefer nvim-web-devicons
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
	-- `file_types` is the current option name (`ft` was removed)
	file_types = { "markdown", "codecompanion" },
	-- CodeCompanion's prompt is a floating `nofile` window over the chat buffer,
	-- so allow rendering there as well
	overrides = {
		buftype = {
			nofile = {
				anti_conceal = { enabled = true },
			},
		},
	},
})
