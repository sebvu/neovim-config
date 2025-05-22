return {
	"stevearc/aerial.nvim",
	opts = {
		on_attach = function(bufnr)
			-- Jump to previous / next symbol just for this buffer
			vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Outline: Prev symbol" })
			vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Outline: Next symbol" })
			vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle<CR>", { desc = "Toggle Outline" })
			vim.keymap.set("n", "<leader>A", "<cmd>AerialOpen<CR>", { desc = "Open Outline" })
		end,
		backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
	},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
}
