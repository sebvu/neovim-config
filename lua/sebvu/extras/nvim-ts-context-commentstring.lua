return {
	-- provide context comment for stuff (like jsx) that needs it
	"JoosepAlviste/nvim-ts-context-commentstring",
	config = function()
		local contcomment = require("ts_context_commentstring")
		contcomment.setup({
			enable_autocmd = false,
		})
	end,
}
