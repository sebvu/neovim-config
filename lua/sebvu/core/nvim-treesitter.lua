return { -- thank you maintainer..
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
      -- main languages
			"c",
			"cpp",
			"java",
			"python",
			"lua",
			"bash",

      -- web dev
			"javascript",
			"typescript",
			"tsx",
			"jsx",
			"html",
			"css",

      -- general
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
			"regex",
			"diff",
		},
		sync_install = true,
		auto_install = true, -- will ensure a parser is installed for language
		highlight = { enable = true },
		indent = { enable = true },
	},
}
