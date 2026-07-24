vim.pack.add({ "https://github.com/akinsho/bufferline.nvim" })

require("bufferline").setup({
    options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        separator_style = { "", "" },
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
        indicator = {
            style = "underline",
        },
        hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
        },
        offsets = {
            {
                filetype = "neo-tree",
                text = "󰄛 Neo-Tree 󰄛",
                highlight = "Directory",
                seperator = true,
            },
        },
        custom_areas = {
            right = function()
                local result = {}
                local seve = vim.diagnostic.severity
                local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
                local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
                local info = #vim.diagnostic.get(0, { severity = seve.INFO })
                local hint = #vim.diagnostic.get(0, { severity = seve.HINT })

                if error ~= 0 then
                    table.insert(result, { text = "  " .. error, link = "DiagnosticError" })
                end

                if warning ~= 0 then
                    table.insert(result, { text = "  " .. warning, link = "DiagnosticWarn" })
                end

                if hint ~= 0 then
                    table.insert(result, { text = "  " .. hint, link = "DiagnosticHint" })
                end

                if info ~= 0 then
                    table.insert(result, { text = "  " .. info, link = "DiagnosticInfo" })
                end
                return result
            end,
        },
    }
})
vim.keymap.set("n", "L", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "H", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete Current Buffer" })
vim.keymap.set("n", "<leader>bc", "<cmd>BufferLinePickClose<CR>", { desc = "Select a Buffer to Delete" })
vim.keymap.set("n", "<leader>bH", "<cmd>BufferLineCloseLeft<CR>", { desc = "Delete all left buffers" })
vim.keymap.set("n", "<leader>bL", "<cmd>BufferLineCloseRight<CR>", { desc = "Delete all right buffers" })
