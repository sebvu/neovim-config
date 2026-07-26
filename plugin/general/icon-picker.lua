vim.pack.add({ "https://github.com/ziontee113/icon-picker.nvim" })

require("icon-picker").setup({ disable_legacy_commands = true })

vim.keymap.set(
	"n",
	"<Leader><Leader>i",
	"<cmd>IconPickerNormal<cr>",
	{ desc = "Enable Icon Picker", noremap = true, silent = true }
)
