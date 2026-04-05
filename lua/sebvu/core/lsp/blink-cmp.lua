return { -- actual autocompletion engine
	{
		"saghen/blink.cmp",
		event = { "BufReadPre", "BufNewFile" },
		-- optional: provides snippets for the snippet source
		dependencies = {
			"L3MON4D3/LuaSnip",
			"onsails/lspkind.nvim",
			"folke/lazydev.nvim",
		},
		build = "cargo build --release",
		version = "v1.*",
		opts = {
			keymap = { preset = "default" },
			signature = { enabled = true },
			fuzzy = { implementation = "prefer_rust_with_warning" },
			snippets = { preset = "luasnip" },
			-- ensure you have the `snippets` source (enabled by default)
			sources = {
				default = { "lsp", "lazydev", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev top priority i.e. :h blink.cmp
						score_offset = 100,
					},
				},
			},
			cmdline = {
				enabled = true,
				keymap = { preset = "cmdline" },
				sources = { "buffer", "cmdline" },
				completion = {
					menu = { auto_show = true },
				},
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
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
		config = function(_, opts)
			require("blink.cmp").setup(opts) -- config overwrites opts, so setup opts
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("luasnip.loaders.from_vscode").lazy_load() -- required by friendly-snippets

			vim.lsp.config("*", {
				capabilities = capabilities,
			})
		end,
	},
	{ -- citrusy snippet engine
		"L3MON4D3/LuaSnip",
		lazy = true,
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
	},
	{ -- provides better UI for autocompletions
		"onsails/lspkind.nvim",
		lazy = true,
		opts = {},
	},
}
