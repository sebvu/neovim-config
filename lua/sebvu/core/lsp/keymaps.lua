local M = {}

local keymap = vim.keymap

-- keymaps for lsps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }
		opts.desc = "Go to Definition"

		keymap.set("n", "<leader>gd", "<cmd>Lspsaga goto_definition<CR>", opts) -- go to definition

		opts.desc = "Check Code Actions"
		keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions

		opts.desc = "Check Hover Documentation"
		keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor

		opts.desc = "Next Diagnostic Jump"
		keymap.set("n", "<leader>ln", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)

		opts.desc = "Prev Diagnostic Jump"
		keymap.set("n", "<leader>nl", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)

		opts.desc = "Globally Rename"
		keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	end,
})

local severity = vim.diagnostic.severity

vim.diagnostic.config({
	signs = {
		text = {
			[severity.ERROR] = " ",
			[severity.WARN] = " ",
			[severity.HINT] = "󰠠 ",
			[severity.INFO] = " ",
		},
	},
})

return M
