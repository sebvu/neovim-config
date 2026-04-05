-- general options
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Split planes
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", opts) -- Vertical Svlit
vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", opts) -- Horizontal Split

-- Scroll horizontally
vim.keymap.set("n", "<leader>ll", "60zl", { remap = true })
vim.keymap.set("n", "<leader>hh", "60zh", { remap = true })

-- Re-highlight line after indenting
vim.keymap.set("v", ">", "<gv")
vim.keymap.set("v", "<", ">gv")

-- Hover diagnostics
vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float(nil, { border = 'rounded' })<CR>")
