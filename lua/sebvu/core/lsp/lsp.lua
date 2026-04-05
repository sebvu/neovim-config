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
			ensure_installed = requiredLsps,
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			"nvimdev/lspsaga.nvim",
			"saghen/blink.cmp",
		},
	},
	{ -- set of awesome pre-configured lsp configurations
		"neovim/nvim-lspconfig",
		lazy = true,
	},
	{ -- amazing lsp and other binary package manager
		"mason-org/mason.nvim",
		lazy = true,
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
}
