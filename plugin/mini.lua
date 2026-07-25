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

-- mini surround
local MiniSurround = require("mini.surround")

MiniSurround.setup({})

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
    -- disable tabstop indicators
    -- expand = {
    --     insert = function(snippet)
    --         MiniSnippets.default_insert(snippet, { empty_tabstop = "", empty_tabstop_final = "" })
    --     end,
    -- }
})

MiniSnippets.start_lsp_server({ match = false })

local make_stop = function()
    local au_opts = { pattern = '*:n', once = true }
    au_opts.callback = function()
        while MiniSnippets.session.get() do
            MiniSnippets.session.stop()
        end
    end
    vim.api.nvim_create_autocmd('ModeChanged', au_opts)
end
local opts = { pattern = 'MiniSnippetsSessionStart', callback = make_stop }
vim.api.nvim_create_autocmd('User', opts)

-- tabline --

local MiniTabline = require("mini.tabline")

MiniTabline.setup({
    -- Whether to show file icons (requires 'mini.icons')
    show_icons = true,

    -- Function which formats the tab label
    -- By default surrounds with space and possibly prepends with icon
    format = function(buf_id, label)
        local suffix = vim.bo[buf_id].modified and '🫪 ' or ''
        return MiniTabline.default_format(buf_id, label) .. suffix
    end,

    -- Where to show tabpage section in case of multiple vim tabpages.
    -- One of 'left', 'right', 'none'.
    tabpage_section = 'left',
})


-- mini git

local MiniGit = require("mini.git")

MiniGit.setup({
    -- General CLI execution
    job = {
        -- Path to Git executable
        git_executable = 'git',

        -- Timeout (in ms) for each job before force quit
        timeout = 30000,
    },

    -- Options for `:Git` command
    command = {
        -- Default split direction
        split = 'auto',
    },
})

vim.keymap.set({ "n", "x" }, "<Leader>gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>",
    { desc = "Show Git History at Cursor" })

-- mini diff

local MiniDiff = require("mini.diff")

MiniDiff.setup({
    -- No need to copy this inside `setup()`. Will be used automatically.
    -- Options for how hunks are visualized
    view = {
        -- Visualization style. Possible values are 'sign' and 'number'.
        -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
        -- style = vim.go.number and 'number' or 'sign',
        style = "sign",

        -- Signs used for hunks with 'sign' view
        signs = { add = '▒', change = '▒', delete = '▒' },

        -- Priority of used visualization extmarks
        priority = 199,
    },

    -- Source(s) for how reference text is computed/updated/etc
    -- Uses content from Git index by default
    source = nil,

    -- Delays (in ms) defining asynchronous processes
    delay = {
        -- How much to wait before update following every text change
        text_change = 200,
    },

    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
        -- Apply hunks inside a visual/operator region
        apply = 'gh',

        -- Reset hunks inside a visual/operator region
        reset = 'gH',

        -- Hunk range textobject to be used inside operator
        -- Works also in Visual mode if mapping differs from apply and reset
        textobject = 'gh',

        -- Go to hunk range in corresponding direction
        goto_first = '[H',
        goto_prev = '[h',
        goto_next = ']h',
        goto_last = ']H',
    },

    -- Various options
    options = {
        -- Diff algorithm (see `:h vim.text.diff()`)
        algorithm = 'histogram',

        -- Whether to use "indent heuristic" (see `:h vim.text.diff()`)
        indent_heuristic = true,

        -- The amount of second-stage diff to align lines
        linematch = 60,

        -- Whether to wrap around edges during hunk navigation
        wrap_goto = false,
    },
})
