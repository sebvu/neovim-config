return {
	"jbyuki/venn.nvim",
	config = function()
		function Toggle_venn()
			local vennStatus = vim.inspect(vim.b.venn_enabled)
			if vennStatus == "nil" then
				vim.cmd([[setlocal ve=all]])
				vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
				vim.b.venn_enabled = true
				vennStatus = true
			else
				vim.cmd([[setlocal ve=]])
				-- resetting keymaps
				vim.api.nvim_buf_del_keymap(0, "n", "J")
				vim.api.nvim_buf_del_keymap(0, "n", "K")
				vim.api.nvim_buf_del_keymap(0, "n", "L")
				vim.api.nvim_buf_del_keymap(0, "n", "H")
				vim.api.nvim_buf_del_keymap(0, "v", "f")
				vim.b.venn_enabled = nil
				vennStatus = nil
			end
			print("VENN plugin is " .. tostring(vennStatus))
		end
	end,
	keys = {
		{ "<leader>v", "<cmd>lua Toggle_venn()<CR>", noremap = true, desc = "Enable/Disable Venn Mode" },
	},
}
