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

return {
		"stevearc/conform.nvim",
		dependencies = { "mason-org/mason.nvim" },
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
}
