local function editorStr()
	local m = {
		"koko is FAT",
		"maya is a CAT",
		"latte is a BAT",
		"gaby is a RAT",
		"neovim is life waster (please help me)",
	}
	return m[math.random(1, #m)]
end

local function sleepStr()
	local m = {
		"psst jester is asleep wake him up",
		"jester is slacking of as we speak",
		"SPAM HIS DMS HE ISN'T WORKING RIGHT NOW HE'S SLACKING",
	}
	return m[math.random(1, #m)]
end

return {
	"vyfor/cord.nvim",
	event = "VeryLazy",
	build = ":Cord update",
	opts = {
		editor = {
			tooltip = "the official kdot editor ✨",
			client = "neovim",
			icon = "https://storage.ko-fi.com/cdn/useruploads/post/39d7fa2f-9353-4cb1-91f9-7c5c1c2d4f61_0f217d0189f841ae794500966ab1845a.jpg",
		},
		display = {
			swap_fields = true,
			swap_icons = true,
		},
		idle = {
			timeout = 200000, -- 200 seconds
			tooltip = "wake him up he's slacking off",
			icon = "https://i.pinimg.com/736x/87/44/b5/8744b5ca5200968378fd6617e9653120.jpg",
			details = "sleeping bleghh 💤",
		},
		text = {
			workspace = "IN OVHOE",
			viewing = "watching.. 👀",
			editing = "crafting?? 💪 ",
			file_browser = "looking at files 🤧",
			docs = "reading docs 📚",
		},
	},
}

-- return {
-- 	"vyfor/cord.nvim",
-- 	build = "./build || .\\build",
-- 	event = "VeryLazy",
-- 	opts = { -- calls require('cord').setup()
-- 		usercmds = true, -- Enable user commands
-- 		log_level = "error", -- One of 'trace', 'debug', 'info', 'warn', 'error', 'off'
-- 		timer = {
-- 			interval = 1500, -- Interval between presence updates in milliseconds (min 500)
-- 			reset_on_idle = false, -- Reset start timestamp on idle
-- 			reset_on_change = false, -- Reset start timestamp on presence change
-- 		},
-- 		editor = {
-- 			image = nil, -- Image ID or URL in case a custom client id is provided
-- 			client = "neovim", -- vim, neovim, lunarvim, nvchad, astronvim or your application's client id
-- 			tooltip = "The Sexiest Text Editor", -- Text to display when hovering over the editor's image
-- 		},
-- 		display = {
-- 			show_time = true, -- Display start timestamp
-- 			show_repository = true, -- Display 'View repository' button linked to repository url, if any
-- 			show_cursor_position = true, -- Display line and column number of cursor's position
-- 			swap_fields = false, -- If enabled, workspace is displayed first
-- 			swap_icons = false, -- If enabled, editor is displayed on the main image
-- 			workspace_blacklist = {}, -- List of workspace names that will hide rich presence
-- 		},
-- 		lsp = {
-- 			show_problem_count = false, -- Display number of diagnostics problems
-- 			severity = 1, -- 1 = Error, 2 = Warning, 3 = Info, 4 = Hint
-- 			scope = "workspace", -- buffer or workspace
-- 		},
-- 		idle = {
-- 			enable = true, -- Enable idle status
-- 			show_status = true, -- Display idle status, disable to hide the rich presence on idle
-- 			timeout = 300000, -- Timeout in milliseconds after which the idle status is set, 0 to display immediately
-- 			disable_on_focus = false, -- Do not display idle status when neovim is focused
-- 			text = "vim coping", -- Text to display when idle
-- 			icon = "https://ih1.redbubble.net/image.5292131909.9696/st,small,507x507-pad,600x600,f8f8f8.u4.jpg",
-- 			tooltip = "💤", -- Text to display when hovering over the idle image
-- 		},
-- 		text = {
-- 			viewing = "Contemplating {}", -- Text to display when viewing a readonly file
-- 			editing = "Butchering {}", -- Text to display when editing a file
-- 			file_browser = "Browing painfully in {}", -- Text to display when browsing files (Empty string to disable)
-- 			plugin_manager = "Managing plugins in {}", -- Text to display when managing plugins (Empty string to disable)
-- 			lsp_manager = "Configuring LSP in {}", -- Text to display when managing LSP servers (Empty string to disable)
-- 			vcs = "Commiting sub-optimal code in {}", -- Text to display when using Git or Git-related plugin (Empty string to disable)
-- 			workspace = "Vimming in {}", -- Text to display when in a workspace (Empty string to disable)
-- 		},
-- 		buttons = {
-- 			{
-- 				label = "some bad repo", -- Text displayed on the button
-- 				url = 'git', -- URL where the button leads to ('git' = automatically fetch Git repository URL)
-- 			},
-- 		},
-- 		-- assets = nil, -- Custom file icons, see the wiki*
-- 		assets = {
-- 			--   lazy = {                                 -- Vim filetype or file name or file extension = table or string
-- 			--     name = 'Lazy',                         -- Optional override for the icon name, redundant for language types
-- 			--     icon = 'https://example.com/lazy.png', -- Rich Presence asset name or URL
-- 			--     tooltip = 'lazy.nvim',                 -- Text to display when hovering over the icon
-- 			--     type = 2,                              -- 0 = language, 1 = file browser, 2 = plugin manager, 3 = lsp manager, 4 = vcs; defaults to language
-- 			--   },
-- 			--   ['Cargo.toml'] = 'crates',
-- 			-- cpp = {
-- 			-- 	name = "cpp",
-- 			-- 	icon = "https://ih1.redbubble.net/image.5292131909.9696/st,small,507x507-pad,600x600,f8f8f8.u4.jpg",
-- 			-- 	tooltip = "C (with classes)",
-- 			-- 	type = 0,
-- 			-- },
-- 			-- h = {
-- 			-- 	name = "header file",
-- 			-- 	icon = "https://ih1.redbubble.net/image.5292131909.9696/st,small,507x507-pad,600x600,f8f8f8.u4.jpg",
-- 			-- 	tooltip = "header filesies",
-- 			-- 	type = 0,
-- 			-- },
-- 		},
-- 	},
-- }
