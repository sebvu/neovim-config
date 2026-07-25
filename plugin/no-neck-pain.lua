vim.pack.add({ "https://github.com/shortcuts/no-neck-pain.nvim" })

require("no-neck-pain").setup({
	width = 150,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	once = true,
	pattern = "*",
	callback = function()
		require("no-neck-pain").toggle()
	end,
})
