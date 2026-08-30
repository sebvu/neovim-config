vim.pack.add({ "https://github.com/mistricky/codesnap.nvim" })

require("codesnap").setup({
	show_line_number = true,
	show_workspace = false,
	snapshot_config = {
		-- theme = "kanagawa-dragon@https://raw.githubusercontent.com/paccodes/kanagawa-vscode-theme/refs/heads/main/themes/kanagawa-dragon-color-theme.json",
		theme = "candy",
		window = {
			mac_window_bar = true,
		},
		-- },
		code_config = {
			-- NOTE: this font is installed locally
			font_family = "Monaspace Radon",
			breadcrumbs = {
				enable = true,
				separator = "/",
				color = "#80848b",
				font_family = "Monaspace Krypton",
			},
		},
		watermark = {
			content = "sebvu 🫪",
			font_family = "Pacifico",
			color = "#D3D3FF",
		},
		background = "#00000000",
	},
})

vim.keymap.set("v", "<leader>sc", "<cmd>CodeSnap<CR>", { desc = "Screenshot Code Snippet" })
vim.keymap.set("v", "<leader>sC", "<cmd>CodeSnapHighlight<CR>", { desc = "Screenshot Highlight Code Snippet" })
