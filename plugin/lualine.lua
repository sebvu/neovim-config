vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })

require("lualine").setup({
    options = {
        globalstatus = true,
        theme = "iceberg_dark",
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_x = {
            "filetype",
            "fileformat",
            "encoding",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})
