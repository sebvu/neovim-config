--[[
lsp formatter linter woo ❤️ 
when adding a new mason tool, add it to masontools table

installed plugins here
- mason.nvim
- mason-tool-installer.nvim
- lspsaga.nvim
- nvim-lspconfig
- nvim-lint
- conform.nvim
]]

local masontools = {
	"actionlint",
	"bash-language-server",
	"black",
	"clang-format",
	"clangd",
	"eslint_d",
	"isort",
	"lua-language-server",
	-- "markdownlint",
	"marksman",
	"prettier",
	"prettierd",
	"pyright",
	"ruff",
	"shellcheck",
	"stylua",
	"typescript-language-server",
	"yaml-language-server",
	"markuplint",
	"stylelint",
	"html-lsp",
	"css-lsp",
	"taplo",
	"r-languageserver",
	"sqls",
	"omnisharp",
	-- "luau_lsp",
}

-- per language linter
local linters = {
	-- javascript = { "eslint_d" },
	-- typescript = { "eslint_d" },
	-- javascriptreact = { "eslint_d" },
	-- typescriptreact = { "eslint_d" },
	-- svelte = { "eslint_d" },
	python = { "ruff" },
	-- cpp = { "cpplint" },
	bashls = { "shellharden" },
	-- html = { "markuplint" }, (not needed as it conflicts with prettierd)
	-- css = { "stylelint" }, (not needed as it conflicts with prettierd)
	-- markdown = { "markdownlint" },
}

-- per language formatters
local formatters = {
	cpp = { "clang-format" },
	lua = { "stylua" },
	python = { "ruff" },
	javascript = { "prettierd", "prettier" },
	typescript = { "prettierd", "prettier" },
	javascriptreact = { "prettierd", "prettier" },
	typescriptreact = { "prettierd", "prettier" },
	jsonc = { "prettierd", "prettier" },
	yaml = { "prettierd" },
	json = { "clang-format" },
	html = { "prettierd" },
	css = { "prettierd" },
	svelte = { "prettierd" },
	markdown = { "markdownlint" },
	graphql = { "prettierd" },
	ruby = { "rubocop" },
	bashls = { "shellharden" },
}

-- setup all the lsps here
local function lspsetups(capabilities, on_attach)
	vim.lsp.config["lua_ls"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
		on_init = function(client)
			local path = client.workspace_folders[1].name
			if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
				return
			end
		end,
		runtime = {
			version = "LuaJIT",
		},
	}
	vim.lsp.config["clangd"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--completion-style=detailed",
			"--function-arg-placeholders",
			"--fallback-style=llvm",
		},
	}
	vim.lsp.config["bashls"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
	}
	-- lspconfig.marksman.setup({
	-- 	capabilities = capabilities,
	-- 	on_attach = on_attach(),
	-- })
	vim.lsp.config["ts_ls"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
	}
	vim.lsp.config["pyright"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
	}
	vim.lsp.config["yamlls"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
	}
	vim.lsp.config["cssls"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
	}
	vim.lsp.config["html"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
	}
	vim.lsp.config["taplo"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
	}
	vim.lsp.config["r_language_server"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
		-- settings is from nvim-lspconfig to pass in config options
		settings = {
			r = {
				lsps = {
					diagnostics = false,
				},
			},
		},
	}
	vim.lsp.config["sqls"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
	}
	vim.lsp.config["omnisharp"] = {
		capabilities = capabilities,
		on_attach = on_attach(),
	}

  vim.lsp.enable("lua_ls")
  vim.lsp.enable("clangd")
  vim.lsp.enable("bashls")
  vim.lsp.enable("ts_ls")
  vim.lsp.enable("pyright")
  vim.lsp.enable("yamlls")
  vim.lsp.enable("cssls")
  vim.lsp.enable("html")
  vim.lsp.enable("taplo")
  vim.lsp.enable("r_language_server")
  vim.lsp.enable("sqls")
  vim.lsp.enable("omnisharp")
end

return {
	{
		-- portable package manager for installing LSPs, DAPs, linters and formatters.
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		-- automatically install linters and formatters whenever neovim is up
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = masontools,
			})
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			-- symbol_in_winbar = {
			-- 	enable = false,
			-- },
			lightbulb = {
				enable = false,
			},
			ui = {
				code_action = "󰣪",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		event = { "BufReadPre", "BufNewFile" }, -- load when a new buffer/pre-existing is opened | open new buffer for file that doesn't exist
		config = function() -- using config function to keep everything localized
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			local signs = { Error = " ", Warn = " ", Hint = "", Info = "" }

			-- set signs for lsp diagnostics
			for type, icon in pairs(signs) do
				local hl = "LspDiagnosticsSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			local on_attach = function()
				vim.keymap.set("n", "<leader>gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to Definition" }) -- go to definition
				vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Check Code Actions" }) -- see available code actions
				vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Check Hover Documentation" }) -- show documentation for what is under cursor
				vim.keymap.set(
					"n",
					"<leader>ln",
					"<cmd>Lspsaga diagnostic_jump_next<CR>",
					{ desc = "Next Diagnostic Jump" }
				)
				vim.keymap.set(
					"n",
					"<leader>nl",
					"<cmd>Lspsaga diagnostic_jump_prev<CR>",
					{ desc = "Prev Diagnostic Jump" }
				)
				vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Globally Rename" }) -- smart rename
			end
			-- lspconfig.languageserver.setup({})
			-- :LspInfo to check lsps connected to current buffer

			lspsetups(capabilities, on_attach)
		end,
	},
	-- linting w/nvim-lint
	{
		"mfussenegger/nvim-lint",
		dependencies = { "williamboman/mason.nvim" },
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			-- ADD NEW LINTER HERE
			local lint = require("lint")
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			lint.linters_by_ft = linters

			-- get rid of .eslintrc creation dependency
			local eslint = lint.linters.eslint_d

			eslint.args = {
				"--no-warn-ignored", -- <-- this is the key argument
				"--format",
				"json",
				"--stdin",
				"--stdin-filename",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
				-- :h events to list all available events
			})

			vim.keymap.set("n", "<leader>l", function()
				lint.try_lint()
			end, { desc = "Lint the current buffer" })
		end,
	},
	-- formatting with conform
	{
		"stevearc/conform.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("conform").setup({
				opts = {
					stop_after_first = true,
				},
				formatters_by_ft = formatters,
				format_on_save = false,
				-- format_on_save = {
				-- 	lsp_fallback = true, -- if formatter isn't available, fall back to formatting through lsp
				-- 	async = false, -- run formatter in async mode
				-- 	timeout_ms = 500, -- timeout for formatter
				-- },
			})

			vim.keymap.set({ "n", "v" }, "<leader>gf", function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
		opts = {},
	},
}
