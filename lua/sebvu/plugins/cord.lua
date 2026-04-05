return { -- this is basically required. cannot survive without cord.
	"vyfor/cord.nvim",
	event = "VeryLazy",
	build = ":Cord update",
	opts = {
		editor = {
			tooltip = "cowboyvim",
			client = "neovim",
			icon = "https://i.etsystatic.com/35912885/r/il/76c29d/3949868785/il_fullxfull.3949868785_cw0v.jpg",
		},
		display = {
			swap_fields = true,
			swap_icons = true,
		},
		idle = {
			timeout = 200000, -- 200 seconds
			tooltip = "zzzz",
			icon = "https://cdn-prd.content.metamorphosis.com/wp-content/uploads/sites/6/2022/01/sleeping-dog-images.jpg",
			details = "sleepin' in the barn",
		},
		text = {
			workspace = "YEE YEE 🤠",
			viewing = "watchin' caaattle 👀" ,
			editing = "tap tap 👢",
			file_browser = "scrollin' tequila 🍸",
			docs = "reading man pages :(",
		},
	},
}
