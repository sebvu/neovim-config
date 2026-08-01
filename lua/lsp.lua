vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-mini/mini.nvim",
})

-- LSP functions are self aware and checks if an LSP is attached to current buffer

local keymap = vim.keymap
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Check Code Actions" }) -- see available code actions
keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Check Hover Documentation" }) -- show documentation for what is under cursor
keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Globally Rename" }) -- smart rename
keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
-- keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local Buffer" })

vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

-- refer to nvim-lspconfig documentation or :h lspconfig-all for list of available LSPs
-- to correspond with, must install LSPs via :Mason
vim.lsp.enable({
	"lua_ls",
	"ts_ls",
	"emmet_language_server",
	"css_variables",
	"cssls",
	"pyright",
	"clangd",
	"bashls",
	"html",
	"jsonls",
})
