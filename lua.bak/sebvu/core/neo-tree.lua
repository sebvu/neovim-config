return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	opts = {
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
		window = {
			-- mappings = {
			-- 	["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
			-- 	["l"] = "focus_preview",
			-- 	["<C-b>"] = { "scroll_preview", config = { direction = 10 } },
			-- 	["<C-f>"] = { "scroll_preview", config = { direction = -10 } },
			-- },
			position = "right",
		},
		filesystem = {
			filtered_items = {
				visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
				hide_dotfiles = false,
				hide_gitignored = true,
			},
		},
	},
	init = function()
		vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=None]])
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE", ctermbg = "NONE" })
	end,
	keys = {
		{ "<leader>e", "<cmd>Neotree<CR>", desc = "Open NeoTree" }, -- open tree
		{ "<leader>q", "<cmd>Neotree close<CR>", desc = "Close NeoTree" }, -- close tree
	},
}
