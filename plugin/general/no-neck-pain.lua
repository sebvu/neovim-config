vim.pack.add({ "https://github.com/shortcuts/no-neck-pain.nvim" })

require("no-neck-pain").setup({
	width = 180,
	autocmds = {
		enableOnVimEnter = true,
		enableOnTabEnter = true,
	},
})
