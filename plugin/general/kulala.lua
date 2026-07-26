vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" })

require("kulala").setup({})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "http", "rest", "javascript", "typescript", "lua" },
	callback = function()
		vim.keymap.set({ "n", "v" }, "<leader>Rs", function()
			require("kulala").run()
		end, { desc = "Send Request" })
		vim.keymap.set({ "n", "v" }, "<leader>Ra", function()
			require("kulala").run_all()
		end, { desc = "Send All Requests" })
		vim.keymap.set({ "n", "v" }, "<leader>Rr", function()
			require("kulala").replay()
		end, { desc = "Replay the Last Request" })
	end,
})

-- { "<leader>Rs", desc = "Send request" },
-- { "<leader>Ra", desc = "Send all requests" },
-- { "<leader>Rb", desc = "Open scratchpad" },
