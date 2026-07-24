local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>re", "<cmd>restart<CR><CR>", { desc = "Restart Neovim " })

-- Split panes

opts.desc = "Vertical Split"
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", opts) -- vertical
opts.desc = "Vertical Horizontal"
vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", opts)  -- horizontal

-- Horizontal scrolling
opts.noremap = false
opts.desc = "Horizontal Move Right"
vim.keymap.set("n", "<leader>ll", "60zl", opts)
opts.desc = "Horizontal Move Left"
vim.keymap.set("n", "<leader>hh", "60zh", opts)
opts.noremap = true

-- Continuous indentation
opts.desc = "Continuous indentation left"
vim.keymap.set("v", ">", "<gv", opts)
opts.desc = "Continuous indentation right"
vim.keymap.set("v", "<", ">gv", opts)

-- Move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv'", { desc = "Move lines up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv'", { desc = "Move lines down" })

-- Cursor wont move while joining lines
vim.keymap.set("n", "J", "mzJ z", { desc = "Join lines without moving cursor" })

-- center cursor when searching
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result cursor centered" })

-- native undotree
vim.keymap.set("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

-- Floating diagnostic
vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float(nil, { border = 'rounded' })<CR>",
    { desc = "Hover Diagnostics" })

-- Buffer actions
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "H", "<cmd>bprev<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete Current Buffer" })

vim.keymap.set("n", "tL", "<cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "tH", "<cmd>tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader>tbd", "<cmd>tabclose<CR>", { desc = "Delete Current Tab" })
