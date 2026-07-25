vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

-- must install formatters through :Mas
-- conform.nvim provides a list of formatters as well
local ft_formatters = {
	lua = { "stylua" },
	html = { "prettier" },
	css = { "prettier" },
	javascript = { "prettier" },
	typescript = { "prettier" },
	javascriptreact = { "prettier" },
	typescriptreact = { "prettier" },
	jsonc = { "prettier" },
	json = { "prettier" },
}

-- permanently ignored filetypes
local ft_ignore = {
	"sql",
}

-------------------------------------------------------------

local Conform = require("conform")

Conform.setup({
	stop_after_first = true,
	formatters_by_ft = ft_formatters,
	-- format_on_save = false,
	format_on_save = function(bufnr)
		-- Disable autoformat on certain filetypes
		local ignore_filetypes = ft_ignore
		if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
			return
		end
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		-- Disable autoformat for files in a certain path
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname:match("/node_modules/") then
			return
		end

		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	Conform.format()
end, { desc = "Conform Format Local Buffer" })

vim.keymap.set("n", "<leader>tf", function()
	-- If autoformat is currently disabled for this buffer,
	-- then enable it, otherwise disable it
	if vim.b.disable_autoformat then
		vim.cmd("FormatEnable")
		vim.notify("Enabled autoformat for current buffer")
	else
		vim.cmd("FormatDisable!")
		vim.notify("Disabled autoformat for current buffer")
	end
end, { desc = "Toggle autoformat for LOCAL BUFFER" })

vim.keymap.set("n", "<leader>tF", function()
	-- If autoformat is currently disabled globally,
	-- then enable it globally, otherwise disable it globally
	if vim.g.disable_autoformat then
		vim.cmd("FormatEnable")
		vim.notify("Enabled autoformat globally")
	else
		vim.cmd("FormatDisable")
		vim.notify("Disabled autoformat globally")
	end
end, { desc = "Toggle autoformat GLOBALLY" })

-- user commands to handle enabling/disabling formatting on LOCAL BUFFER or GLOBALLY --
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- :FormatDisable! disables autoformat for this buffer only
		vim.b.disable_autoformat = true
	else
		-- :FormatDisable disables autoformat globally
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true, -- allows the ! variant
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})
