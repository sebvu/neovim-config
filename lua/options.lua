local opt = vim.opt

-- Tab / Indentation

opt.tabstop = 2        -- spaces tab takes up
opt.shiftwidth = 2     -- newline indentation spacing
opt.softtabstop = 2    -- how many spaces occur when tabbing in insert mode
opt.expandtab = true   -- converts tabs into spaces when opening a file
opt.smartindent = true -- allow for auto indentation
opt.wrap = false       -- by default, prevent line wrapping

-- Search

opt.incsearch = true  -- as you add letters to search, will highlight all matches associated
opt.ignorecase = true -- non-case sensitive search
opt.smartcase = true  -- if capitalization, then start utilizing cases
opt.hlsearch = false  -- highlight searches

-- Appearence

opt.relativenumber = true -- self explanatory
opt.number = true         -- display normal line numbers
opt.signcolumn = "yes"    -- gutter for debug icons
opt.scrolloff = 5
opt.inccommand = "split"  -- split preview when splitting
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 3 -- full status line for multiple screens
-- vim.opt.guicursor = ""

-- Behavior

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true
vim.opt.clipboard:append("unnamedplus")
vim.opt.isfname:append("@-@")

-- completion helper
vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
vim.opt.shortmess:append("c")
