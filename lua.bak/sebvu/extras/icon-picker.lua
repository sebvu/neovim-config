return {
	"ziontee113/icon-picker.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- load when a new buffer/pre-existing is opened | open new buffer for file that doesn't exist
	keys = {
		vim.keymap.set(
			"n",
			"<Leader><Leader>i",
			"<cmd>IconPickerNormal<cr>",
			{ desc = "Enable Icon Picker", noremap = true, silent = true }
		),
	},
	init = function()
		require("icon-picker").setup({ disable_legacy_commands = true })
	end,
}
