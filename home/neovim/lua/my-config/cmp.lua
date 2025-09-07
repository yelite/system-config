local blink_cmp = require("blink-cmp")
local util = require("my-config.util")

local disabled_filetypes = { "DressingInput", "text", "sagarename" }

blink_cmp.setup({
    enabled = function()
        return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
    end,
    keymap = {
        preset = "none",

        ["<C-p>"] = {
            function(cmp)
                return cmp.select_prev({ auto_insert = false })
            end,
            "fallback",
        },
        ["<C-n>"] = {
            function(cmp)
                return cmp.select_next({ auto_insert = false })
            end,
            "fallback",
        },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        ["<C-Space>"] = { "show" },
        ["<C-e>"] = { "cancel", "fallback" },

        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<C-i>"] = {
            function(cmp)
                if cmp.is_visible() then
                    util.toggle_copilot_suppression()
                    -- Refresh candidates
                    cmp.reload()
                    return true
                end
            end,
            "fallback",
        },

        ["<C-f>"] = {
            function(cmp)
                -- Confirm if this is the end of line, otherwise abort completion and fallback
                local _, col = unpack(vim.api.nvim_win_get_cursor(0))
                local line = vim.api.nvim_get_current_line()
                if string.sub(line, col + 1) == "" and cmp.accept() then
                    return true
                end
                cmp.cancel()
            end,
            "fallback",
        },
        ["<C-CR>"] = {
            function(cmp)
                -- TODO: Fill completion text as is, don't expand snippet
            end,
            "fallback",
        },
    },
    cmdline = {
        enabled = true,
        keymap = {
            preset = "inherit",
            ["<Tab>"] = { "show", "select_and_accept", "fallback" },
            ["<C-e>"] = { "cancel", "fallback" },
        },
    },
    completion = {
        documentation = { auto_show = true, window = { border = "single" } },
        menu = {
            draw = {
                treesitter = { "lsp" },
            },
        },
        ghost_text = { enabled = true },
    },
    sources = {
        default = { "lsp", "snippets", "copilot", "path", "buffer" },
        per_filetype = {
            AvanteInput = { "avante" },
            AvantePromptInput = { "avante" },
        },
        providers = {
            copilot = {
                name = "copilot",
                module = "blink-copilot",
                score_offset = 100,
                async = true,
                opts = {
                    max_completions = 3,
                },
            },
            avante = {
                module = "blink-cmp-avante",
                name = "Avante",
                opts = {},
            },
        },
    },
})
