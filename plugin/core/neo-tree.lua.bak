vim.pack.add({
	{
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = vim.version.range("3"),
	},
	-- dependencies
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	-- icons
	"https://github.com/nvim-tree/nvim-web-devicons",
})

require("neo-tree").setup({
	event_handlers = {
		{
			event = "neo_tree_buffer_enter",
			handler = function()
				vim.cmd([[
                    setlocal relativenumber
                    setlocal number
                ]])
			end,
		},
	},
	filesystem = {
		filtered_items = {
			visible = true,
			hide_dotfile = false,
			hide_gitignored = false,
		},
	},
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree filesystem reveal right<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>q", "<cmd>Neotree close<CR>", { desc = "Close file explorer" })
