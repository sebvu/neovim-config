vim.pack.add({
    'https://github.com/nvim-mini/mini.nvim',
    "https://github.com/rafamadriz/friendly-snippets",
})

--- notifications
local MiniNotify = require("mini.notify")

MiniNotify.setup({
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

--- mini cmd correction
local MiniCmdline = require("mini.cmdline")

MiniCmdline.setup({
    autocorrect = { enable = false }
})

--- mini picker
local MiniPick = require("mini.pick")

MiniPick.setup()

vim.keymap.set("n", "<leader>ff", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>fg", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
    { desc = "Mini Grep Picker" })
vim.keymap.set("n", "<leader>fh", function() MiniPick.builtin.help() end, { desc = "Mini Help Picker" })

-- extras
local MiniExtra = require("mini.extra")

MiniExtra.setup()

vim.keymap.set("n", "<leader>D", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostic" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = "Search Keymaps" })

-- mini completions --
local MiniCompletion = require("mini.completion")

MiniCompletion.setup({
    lsp_completion = {
        auto_setup = true,
    }
})

-- mini snippets
local MiniSnippets = require("mini.snippets")

MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets automatically
    },
})
MiniSnippets.start_lsp_server({ match = false })
