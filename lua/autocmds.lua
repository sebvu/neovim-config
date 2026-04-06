-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }), -- clear = prevents duplication of autocmds on source
	pattern = "*",
	desc = "Highlighting selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 500, visual = true })
	end,
})

local general_group = vim.api.nvim_create_augroup("GeneralAutocmds", { clear = true })

-- restore cursor to file position in previous editing sessions
vim.api.nvim_create_autocmd("BufReadPost", {
  group = general_group,
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- set help windows to the left of screen
vim.api.nvim_create_autocmd("FileType", {
  group = general_group,
	pattern = "help",
	command = "wincmd R",
})

-- auto resize to be equal when terminal window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = general_group,
	command = "wincmd =",
})

-- no auto continue comments on new lines
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {clear = true}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

local lsp_group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true })

-- ide highlighting other of the same keywords when stopping cursor
vim.api.nvim_create_autocmd("CursorMoved", {
	group = lsp_group,
	desc = "Highlight references under cursor",
	callback = function()
		-- run if cursor is not in insert mode
		if vim.fn.mode() ~= "i" then
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break -- found supporting client, terminate here
				end
			end

			-- proceed only if LSP is active and supports feature
			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMovedI", {
	group = lsp_group,
	desc = "Clear highlights when entering insert mode",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})
