local keymap = vim.keymap

-- keymaps for lsps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		keymap.set("n", "<leader>gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to Definition" }) -- go to definition
		keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Check Code Actions" }) -- see available code actions
		keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Check Hover Documentation" }) -- show documentation for what is under cursor
		keymap.set("n", "<leader>ln", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic Jump" })
		keymap.set("n", "<leader>nl", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Prev Diagnostic Jump" })
		keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Globally Rename" }) -- smart rename
	end,
})

local severity = vim.diagnostic.severity

vim.diagnostic.config({
	signs = {
		text = {
			[severity.ERROR] = "⁉️ ",
			[severity.WARN] = " ",
			[severity.HINT] = "󰠠 ",
			[severity.INFO] = " ",
		},
	},
})
