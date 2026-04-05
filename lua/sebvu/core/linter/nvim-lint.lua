local linters = {
	-- javascript = { "eslint_d" },
	-- typescript = { "eslint_d" },
	-- javascriptreact = { "eslint_d" },
	-- typescriptreact = { "eslint_d" },
	-- svelte = { "eslint_d" },
	python = { "ruff" },
	-- cpp = { "cpplint" },
	bash = { "shellcheck" },
	-- html = { "markuplint" }, (not needed as it conflicts with prettierd)
	-- css = { "stylelint" }, (not needed as it conflicts with prettierd)
	-- markdown = { "markdownlint" },
}

return {
	"mfussenegger/nvim-lint",
	dependencies = { "williamboman/mason.nvim" },
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		-- ADD NEW LINTER HERE
		local lint = require("lint")
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		lint.linters_by_ft = linters

		-- get rid of .eslintrc creation dependency
		local eslint = lint.linters.eslint_d

		eslint.args = {
			"--no-warn-ignored", -- <-- this is the key argument
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
			-- :h events to list all available events
		})

		-- vim.keymap.set("n", "<leader>l", function()
		-- 	lint.try_lint()
		-- end, { desc = "Lint the current buffer" })
	end,
}
