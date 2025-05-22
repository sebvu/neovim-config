-- guarantee folding for all levels
vim.wo.foldlevel = 99

-- allow line wrapping for markdown due to readability issues
-- allow concealement for markdown
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"markdown",
	},
	callback = function()
		vim.opt.wrap = true
		vim.opt.tabstop = 2
		vim.opt.shiftwidth = 2
		vim.opt.expandtab = true

		vim.wo.conceallevel = 2
	end,
})
