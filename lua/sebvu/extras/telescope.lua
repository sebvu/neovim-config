--[[
contains two plugins:
- telescope.nvim
- telescope-ui-select.nvim
]]

return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep", "sharkdp/fd" },
		opts = {
			defaults = {
				file_ignore_patterns = { "node_modules", ".git", "lazy%-lock.json", "pack" },
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
					},
				},
			},
			pickers = {
				find_files = {
					theme = "dropdown",
					previewer = true,
					hidden = true,
				},
				live_grep = {
					theme = "dropdown",
					previewer = true,
				},
				buffers = {
					theme = "dropdown",
					previewer = true,
				},
			},
		},
		keys = {
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find Help Tags" },
			{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
		},
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		opts = { extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown({}) } } },
		config = function()
			require("telescope").load_extension("ui-select")
		end,
	},
}
