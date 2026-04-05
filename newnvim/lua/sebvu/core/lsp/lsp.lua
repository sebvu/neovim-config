-- Names abide w/https://github.com/neovim/nvim-lspconfig/blob/master/lsp/
-- NOT the language server name
local requiredLsps = {
	"lua_ls",
	"ts_ls",
	"html",
	"cssls",
	"tailwindcss",
	"svelte",
	"pyright",
	"eslint",
	"clangd",
	"bashls",
}

return {
	{ -- automatically install and enable installed servers and translate between server names on nvim-lspconfig and mason.nvim
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensured_installed = requiredLsps,
		},
		dependencies = {
			{ -- lsp, dap, linter, formatters.. package manager. we love mason!
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
		},
		{ -- amazing quickstart configs from nvim-config
			"neovim/nvim-lspconfig",
		},
		{ -- lspsaga for improved lsp experience https://nvimdev.github.io/lspsaga/
			"nvimdev/lspsaga.nvim",
			dependencies = {
				"nvim-treesitter/nvim-treesitter", -- optional
				"nvim-tree/nvim-web-devicons", -- optional
			},
			opts = {
				ui = {
					code_action = "󰇺",
				},
				lightbulb = {
					enable = true,
				},
				code_action = {
					num_shortcut = true,
					show_server_name = true,
					extend_gitsigns = true,
				},
			},
		},
	},
	{
		"saghen/blink.cmp",
	},
}
