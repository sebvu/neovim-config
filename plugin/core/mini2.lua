vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
})

local MiniFiles = require("mini.files")
local MiniNotify = require("mini.notify")
local MiniIcons = require("mini.icons")
local MiniSurround = require("mini.surround")
local MiniCmdline = require("mini.cmdline")
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
local MiniCompletion = require("mini.completion")
local MiniSnippets = require("mini.snippets")
local MiniTabline = require("mini.tabline")
local MiniGit = require("mini.git")
local MiniDiff = require("mini.diff")

-- MiniFiles.setup({})
MiniNotify.setup({})
MiniIcons.setup({})
MiniSurround.setup({})
MiniCmdline.setup({})
MiniPick.setup({})
MiniExtra.setup({})
-- MiniCompletion.setup({})
-- MiniSnippets.setup({})
-- MiniTabline.setup({})
MiniGit.setup({})
MiniDiff.setup({})

----- Keymaps -----

-- mini files
vim.keymap.set("n", "<leader>e", function()
	MiniFiles.open()
end, { desc = "Open Minifiles" })

-- mini picker
vim.keymap.set("n", "<leader>ff", function()
	MiniPick.builtin.files()
end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>fg", function()
	MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Mini Grep Picker" })
vim.keymap.set("n", "<leader>fh", function()
	MiniPick.builtin.help()
end, { desc = "Mini Help Picker" })

-- mini extras
vim.keymap.set("n", "<leader>D", function()
	MiniExtra.pickers.diagnostic()
end, { desc = "Mini Picker Diagnostic" })
vim.keymap.set("n", "<leader>pk", function()
	MiniExtra.pickers.keymaps()
end, { desc = "Search Keymaps" })

-- mini git

vim.keymap.set(
	{ "n", "x" },
	"<Leader>gs",
	"<Cmd>lua MiniGit.show_at_cursor()<CR>",
	{ desc = "Show Git History at Cursor" }
)

----- Customization w/setups -----

-- mini files

MiniFiles.setup({
	mappings = {
		go_in = "<CR>",
	},
})

-- mini completions

MiniCompletion.setup({
	lsp_completion = {
		auto_setup = true,
	},
})

-- mini snippets

MiniSnippets.setup({
	snippets = {
		MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets automatically
	},
})

MiniSnippets.start_lsp_server({ match = false })

local make_stop = function()
	local au_opts = { pattern = "*:n", once = true }
	au_opts.callback = function()
		while MiniSnippets.session.get() do
			MiniSnippets.session.stop()
		end
	end
	vim.api.nvim_create_autocmd("ModeChanged", au_opts)
end
local opts = { pattern = "MiniSnippetsSessionStart", callback = make_stop }
vim.api.nvim_create_autocmd("User", opts)

-- mini tabline

MiniTabline.setup({
	-- Whether to show file icons (requires 'mini.icons')
	show_icons = true,

	-- Function which formats the tab label
	-- By default surrounds with space and possibly prepends with icon
	format = function(buf_id, label)
		local suffix = vim.bo[buf_id].modified and "🫪 " or ""
		return MiniTabline.default_format(buf_id, label) .. suffix
	end,

	-- Where to show tabpage section in case of multiple vim tabpages.
	-- One of 'left', 'right', 'none'.
	tabpage_section = "left",
})
