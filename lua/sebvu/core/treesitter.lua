return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
		-- 	"c",
		-- 	"cpp",
		-- 	"lua",
		-- 	"javascript",
		-- 	"typescript",
			"javascriptreact",
			"typescriptreact",
		-- 	"html",
		-- 	"css",
		-- 	"vim",
		-- 	"vimdoc",
		-- 	"query",
		-- 	"markdown",
		-- 	"markdown_inline",
		},
		sync_install = true,
		auto_install = true, -- will ensure a parser is installed for language
		highlight = { enable = true },
		indent = { enable = true },
	},
}
