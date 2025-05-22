return {
	-- easier to comment
	"numToStr/Comment.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- load when a new buffer/pre-existing is opened | open new buffer for file that doesn't exist
	opts = {},
}
