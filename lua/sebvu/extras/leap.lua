return {
	-- "ggandor/leap.nvim",
	url = "https://codeberg.org/andyg/leap.nvim",
	config = function()
		require("leap").create_default_mappings()
	end,
}
