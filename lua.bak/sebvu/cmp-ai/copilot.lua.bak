return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = { enabled = false },
			panel = { enabled = false },
		})
	end,
	dependencies = {
		{
			-- make copilot suggestions into snippets
			"zbirenbaum/copilot-cmp",
			opts = {},
		},
		{
			-- adds icons to snippets
			"onsails/lspkind.nvim",
			opts = {
				mode = "symtol_text",
			},
		},
	},
}
