return {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {
			globalstatus = true,
			theme = "iceberg_dark",
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_x = {
        {
          require("noice").api.statusline.mode.get,
          cond = require("noice").api.statusline.mode.has,
        },
				"filetype",
				"fileformat",
				"encoding",
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}
