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
-- MiniDiff.setup({})

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

-- thank you so much https://gist.github.com/bassamsdata/eec0a3065152226581f8d4244cce9051#file-notes-md
local function addMiniFileGitIntegration()
	local nsMiniFiles = vim.api.nvim_create_namespace("mini_files_git")
	local autocmd = vim.api.nvim_create_autocmd

	-- Cache for git status
	local gitStatusCache = {}
	local cacheTimeout = 2000 -- in milliseconds
	local uv = vim.uv or vim.loop

	local function isSymlink(path)
		local stat = uv.fs_lstat(path)
		return stat and stat.type == "link"
	end

	---@type table<string, {symbol: string, hlGroup: string}>
	---@param status string
	---@return string symbol, string hlGroup
	local function mapSymbols(status, is_symlink)
		local statusMap = {
    -- stylua: ignore start 
    [" M"] = { symbol = "•", hlGroup  = "MiniDiffSignChange"}, -- Modified in the working directory
    ["M "] = { symbol = "✹", hlGroup  = "MiniDiffSignChange"}, -- modified in index
    ["MM"] = { symbol = "≠", hlGroup  = "MiniDiffSignChange"}, -- modified in both working tree and index
    ["A "] = { symbol = "+", hlGroup  = "MiniDiffSignAdd"   }, -- Added to the staging area, new file
    ["AA"] = { symbol = "≈", hlGroup  = "MiniDiffSignAdd"   }, -- file is added in both working tree and index
    ["D "] = { symbol = "-", hlGroup  = "MiniDiffSignDelete"}, -- Deleted from the staging area
    ["AM"] = { symbol = "⊕", hlGroup  = "MiniDiffSignChange"}, -- added in working tree, modified in index
    ["AD"] = { symbol = "-•", hlGroup = "MiniDiffSignChange"}, -- Added in the index and deleted in the working directory
    ["R "] = { symbol = "→", hlGroup  = "MiniDiffSignChange"}, -- Renamed in the index
    ["U "] = { symbol = "‖", hlGroup  = "MiniDiffSignChange"}, -- Unmerged path
    ["UU"] = { symbol = "⇄", hlGroup  = "MiniDiffSignAdd"   }, -- file is unmerged
    ["UA"] = { symbol = "⊕", hlGroup  = "MiniDiffSignAdd"   }, -- file is unmerged and added in working tree
    ["??"] = { symbol = "?", hlGroup  = "MiniDiffSignDelete"}, -- Untracked files
    ["!!"] = { symbol = "!", hlGroup  = "MiniDiffSignChange"}, -- Ignored files
			-- stylua: ignore end
		}

		local result = statusMap[status] or { symbol = "?", hlGroup = "NonText" }
		local gitSymbol = result.symbol
		local gitHlGroup = result.hlGroup

		local symlinkSymbol = is_symlink and "↩" or ""

		-- Combine symlink symbol with Git status if both exist
		local combinedSymbol = (symlinkSymbol .. gitSymbol):gsub("^%s+", ""):gsub("%s+$", "")
		-- Change the color of the symlink icon from "MiniDiffSignDelete" to something else
		local combinedHlGroup = is_symlink and "MiniDiffSignDelete" or gitHlGroup

		return combinedSymbol, combinedHlGroup
	end

	---@param cwd string
	---@param callback function
	---@return nil
	local function fetchGitStatus(cwd, callback)
		local clean_cwd = cwd:gsub("^minifiles://%d+/", "")
		---@param content table
		local function on_exit(content)
			if content.code == 0 then
				callback(content.stdout)
				-- vim.g.content = content.stdout
			end
		end
		---@see vim.system
		vim.system({ "git", "status", "--ignored", "--porcelain" }, { text = true, cwd = clean_cwd }, on_exit)
	end

	---@param buf_id integer
	---@param gitStatusMap table
	---@return nil
	local function updateMiniWithGit(buf_id, gitStatusMap)
		vim.schedule(function()
			local nlines = vim.api.nvim_buf_line_count(buf_id)
			local cwd = vim.fs.root(buf_id, ".git")
			local escapedcwd = cwd and vim.pesc(cwd)
			escapedcwd = vim.fs.normalize(escapedcwd)

			for i = 1, nlines do
				local entry = MiniFiles.get_fs_entry(buf_id, i)
				if not entry then
					break
				end
				local relativePath = entry.path:gsub("^" .. escapedcwd .. "/", "")
				local status = gitStatusMap[relativePath]

				if status then
					local symbol, hlGroup = mapSymbols(status, isSymlink(entry.path))
					vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
						sign_text = symbol,
						sign_hl_group = hlGroup,
						priority = 2,
					})
					-- This below code is responsible for coloring the text of the items. comment it out if you don't want that
					local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1]
					-- Find the name position accounting for potential icons
					local nameStartCol = line:find(vim.pesc(entry.name)) or 0

					if nameStartCol > 0 then
						vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, nameStartCol - 1, {
							end_col = nameStartCol + #entry.name - 1,
							hl_group = hlGroup,
						})
					end
				else
				end
			end
		end)
	end

	-- Thanks for the idea of gettings https://github.com/refractalize/oil-git-status.nvim signs for dirs
	---@param content string
	---@return table
	local function parseGitStatus(content)
		local gitStatusMap = {}
		-- lua match is faster than vim.split (in my experience )
		for line in content:gmatch("[^\r\n]+") do
			local status, filePath = string.match(line, "^(..)%s+(.*)")
			-- Split the file path into parts
			local parts = {}
			for part in filePath:gmatch("[^/]+") do
				table.insert(parts, part)
			end
			-- Start with the root directory
			local currentKey = ""
			for i, part in ipairs(parts) do
				if i > 1 then
					-- Concatenate parts with a separator to create a unique key
					currentKey = currentKey .. "/" .. part
				else
					currentKey = part
				end
				-- If it's the last part, it's a file, so add it with its status
				if i == #parts then
					gitStatusMap[currentKey] = status
				else
					-- If it's not the last part, it's a directory. Check if it exists, if not, add it.
					if not gitStatusMap[currentKey] then
						gitStatusMap[currentKey] = status
					end
				end
			end
		end
		return gitStatusMap
	end

	---@param buf_id integer
	---@return nil
	local function updateGitStatus(buf_id)
		if not vim.fs.root(buf_id, ".git") then
			return
		end
		local cwd = vim.fs.root(buf_id, ".git")
		-- local cwd = vim.fn.expand("%:p:h")
		local currentTime = os.time()

		if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
			updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
		else
			fetchGitStatus(cwd, function(content)
				local gitStatusMap = parseGitStatus(content)
				gitStatusCache[cwd] = {
					time = currentTime,
					statusMap = gitStatusMap,
				}
				updateMiniWithGit(buf_id, gitStatusMap)
			end)
		end
	end

	---@return nil
	local function clearCache()
		gitStatusCache = {}
	end

	local function augroup(name)
		return vim.api.nvim_create_augroup("MiniFiles_" .. name, { clear = true })
	end

	autocmd("User", {
		group = augroup("start"),
		pattern = "MiniFilesExplorerOpen",
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			updateGitStatus(bufnr)
		end,
	})

	autocmd("User", {
		group = augroup("close"),
		pattern = "MiniFilesExplorerClose",
		callback = function()
			clearCache()
		end,
	})

	autocmd("User", {
		group = augroup("update"),
		pattern = "MiniFilesBufferUpdate",
		callback = function(args)
			local bufnr = args.data.buf_id
			local cwd = vim.fs.root(bufnr, ".git")
			if gitStatusCache[cwd] then
				updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
			end
		end,
	})
end

addMiniFileGitIntegration()

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

-- mini diff

MiniDiff.setup({
	view = {
		style = "sign",
	},
})
