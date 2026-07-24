vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

-- update treesitter parsers installed by plugin
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
            vim.cmd("TSupdate")
        end
    end
})

-- determine if installed and whether to run fallback parser or treesitter parser
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype

        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
            return
        end

        local ok_add = pcall(vim.treesitter.language.add, lang)
        if not ok_add then
            return
        end

        pcall(vim.treesitter.start, buf, lang)
    end,
})

local treesitter = require("nvim-treesitter")

local ensure_installed = {
    -- main languages
    "c",
    "cpp",
    "java",
    "python",
    "lua",
    "bash",

    -- web dev
    "javascript",
    "typescript",
    "tsx",
    "jsx",
    "html",
    "css",
    "json",

    -- general
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "http",
    "dockerfile",
    "regex",
    "diff",
}

treesitter.install(ensure_installed)
