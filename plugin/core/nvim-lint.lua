vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")

-- available linters in nvim-link repo, downloadable through Mason
lint.linters_by_ft = {
	html = { "htmlhint" },
}

-- enable eslint linter in ./node_modules/.bin/eslint to be run in a sandbox system for security

---@param linter lint.Linter
---@return lint.Linter
local function systemd_run(linter)
	local cwd = vim.fn.getcwd()
	local args = {
		"--user",
		"--collect",
		"--same-dir",
		"--quiet",
		"--pipe",
		"-p",
		"PrivateUsers=true",
		"-p",
		"ProtectSystem=true",
		"-p",
		"PrivateNetwork=true",
		"-p",
		string.format("BindReadOnlyPaths='%s':'%s'", cwd, cwd),
		"-E",
		"PATH=" .. os.getenv("PATH"),
		linter.cmd,
	}
	linter.cmd = "systemd-run"
	vim.list_extend(args, linter.args or {})
	linter.args = args
	return linter
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype
		lint.try_lint(nil, {
			wrap_linter = systemd_run,
		})
	end,
})
