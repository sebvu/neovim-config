local masonToolList = {
	"ruff", -- python linter and formatter
	"shellcheck", -- bash linter
	"clang-format", -- c++ formatter
	"prettierd", -- formatter
	"prettier", -- same case stuff
	"stylua",
}

return { -- used exclusively for installing formatters and linters
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		require("mason-tool-installer").setup({
			ensure_installed = masonToolList,
		})
	end,
}
