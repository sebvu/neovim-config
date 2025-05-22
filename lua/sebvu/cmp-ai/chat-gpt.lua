return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim", -- optional
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		api_key_cmd = "pass show api-token/openai",
		openai_params = { -- primed for code related subjects
			model = "gpt-4o",
			frequency_penalty = 0,
			presence_penalty = 0,
			max_tokens = 2500,
			temperature = 0.1,
			top_p = 0.1,
			n = 1,
		},
	},
	keys = {
		{ "<leader>gt", "<cmd>ChatGPT<CR>", mode = { "n", "v" }, desc = "Open ChatGPT", remap = true },
		{ "<leader>gr", ":ChatGPTRun ", desc = "ChatGPT Run []", remap = true },
		{
			"<leader>ge",
			"<cmd>ChatGPTRun explain_code<CR>",
			mode = { "n", "v" },
			desc = "ChatGPT Explain Code",
			remap = true,
		},
	},
}
