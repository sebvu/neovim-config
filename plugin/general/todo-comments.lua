vim.pack.add({ "https://github.com/folke/todo-comments.nvim" })
-- NOTE: plenary is a dependency, but unmaintained
-- setting up is unecessary
vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim" })

require("todo-comments").setup()

vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "<leader>t", "<cmd>TodoLocList<CR>", { desc = "Open todo locations" })

-- You can also specify a list of valid jump keywords
-- vim.keymap.set("n", "]t", function()
-- 	require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING" } })
-- end, { desc = "Next error/warning todo comment" })

-- PERF: optimized
-- HACK: this is a funky hack
-- TODO: what was i supposed to do??
-- NOTE: note stuff yay
-- FIX: what the fuck is happening
-- WARNING: be careful >:(
