return { -- actual autocompletion engine
	"saghen/blink.cmp",
	event = { "BufReadPre", "BufNewFile" },
	lazy = true,
	-- optional: provides snippets for the snippet source
	dependencies = {
		{ -- snippet engine
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = { "rafamadriz/friendly-snippets" },
		},
		{ -- provides better UI for autocompletions
			"onsails/lspkind.nvim",
			opts = {
				completion = {
					menu = {
						draw = {
							components = {
								kind_icon = {
									text = function(ctx)
										return require("lspkind").symbol_map[ctx.kind] or ""
									end,
								},
							},
						},
					},
				},
			},
		},
	},
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		require("luasnip.loaders.from_vscode").lazy_load() -- required by friendly-snippets

		vim.lsp.config("*", {
			capabilities = capabilities,
		})
	end,
}
