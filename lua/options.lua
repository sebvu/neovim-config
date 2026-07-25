local opt = vim.opt

-- Tab / Indentation

opt.tabstop = 2 -- spaces tab takes up
opt.shiftwidth = 2 -- newline indentation spacing
opt.softtabstop = 2 -- how many spaces occur when tabbing in insert mode
opt.expandtab = false -- converts tabs into spaces when opening a file
opt.smartindent = true -- allow for auto indentation
opt.wrap = false -- by default, prevent line wrapping

-- Search

opt.incsearch = true -- as you add letters to search, will highlight all matches associated
opt.ignorecase = true -- non-case sensitive search
opt.smartcase = true -- if capitalization, then start utilizing cases
opt.hlsearch = false -- highlight searches

-- Appearence

opt.relativenumber = true -- self explanatory
opt.number = true -- display normal line numbers
opt.signcolumn = "yes" -- gutter for debug icons
opt.scrolloff = 5
opt.inccommand = "split" -- split preview when splitting
opt.splitbelow = true
opt.splitright = true
opt.laststatus = 3 -- full status line for multiple screens
opt.cursorline = false -- force cursor line highlights to be off
-- vim.opt.guicursor = ""

-- Behavior

opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.undofile = true
opt.clipboard:append("unnamedplus")
opt.isfname:append("@-@")

-- completion helper
opt.completeopt = "menuone,noselect,fuzzy,nosort"
opt.shortmess:append("c")
