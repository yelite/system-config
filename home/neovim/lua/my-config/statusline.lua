local navic = require("nvim-navic")
local terms = require("toggleterm.terminal")
local nord_colors = require("nord.colors").palette
local util = require("my-config.util")

navic.setup({
    icons = {
        File = " ",
        Module = " ",
        Namespace = " ",
        Package = " ",
        Class = " ",
        Method = " ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = " ",
        Interface = " ",
        Function = " ",
        Variable = " ",
        Constant = " ",
        String = " ",
        Number = " ",
        Boolean = " ",
        Array = " ",
        Object = " ",
        Key = " ",
        Null = " ",
        EnumMember = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
    },
    lsp = {
        auto_attach = true,
        preference = nil,
    },
    highlight = true,
    depth_limit = 5,
})

-- Pad the mode string so that switching between common
-- modes will not cause width change in mode component
local function pad_mode(mode)
    return mode .. string.rep(" ", 7 - #mode)
end

local function is_toggleterm()
    return vim.bo.filetype == "toggleterm"
end

local function get_term_name()
    local id, term = terms.identify()
    if term ~= nil and term.display_name ~= nil then
        return "Terminal: " .. term.display_name
    else
        return "Terminal " .. id
    end
end

local diff_component = {
    "diff",
    symbols = { added = " ", modified = " ", removed = " " },
}

local lualine_x = {
    {
        "diagnostics",
        sources = { "nvim_diagnostic", "coc" },
    },
    "filetype",
}
if util.is_copilot_installed() then
    table.insert(lualine_x, 2, {
        "copilot",
        symbols = {
            status = {
                icons = {
                    enabled = " ",
                    sleep = " ", -- auto-trigger disabled
                    disabled = " ",
                    warning = " ",
                    unknown = " ",
                },
                hl = {
                    enabled = "#50FA7B",
                    sleep = "#AEB7D0",
                    disabled = "#6272A4",
                    warning = "#FFB86C",
                    unknown = "#FF5555",
                },
            },
            spinners = "dots", -- has some premade spinners
            spinner_color = "#6272A4",
        },
        show_colors = false,
        show_loading = true,
    })
end

require("lualine").setup({
    options = {
        theme = "nord",
        globalstatus = true,
        disabled_filetypes = {
            statusline = {},
            winbar = {
                "toggleterm",
                "dap-repl",
                "dapui_console",
            },
        },
        ignore_focus = {
            "dapui_watches",
            "dapui_breakpoints",
            "dapui_scopes",
            "dapui_console",
            "dapui_stacks",
            "dap-repl",
        },
    },
    sections = {
        lualine_a = { { "mode", fmt = pad_mode } },
        lualine_b = {
            {
                "filename",
                path = 1,
                file_status = true,
                cond = function()
                    return not is_toggleterm()
                end,
            },
            {
                get_term_name,
            },
        },
        lualine_c = {},
        lualine_x = lualine_x,
        lualine_y = {
            diff_component,
            "branch",
        },
        lualine_z = { "tabs" },
    },
    winbar = {
        lualine_a = {},
        lualine_b = { { "filename", color = { fg = nord_colors.snow_storm.brighter } } },
        lualine_c = {
            {
                "navic",
                fmt = function(s)
                    -- navic will return a string ends with #*, which reset the highlight
                    -- group to default, creating a black block in the winbar because
                    -- lualine pads a space after the returned string. This fmt function
                    -- adds a space filler right after the returned string from navic, which
                    -- removes the black block.
                    return s .. "%#lualine_c_normal#%="
                end,
                color_correction = "static",
                navic_opts = nil,
            },
        },
        lualine_x = {},
        lualine_y = { "location", "progress" },
        lualine_z = {},
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = { { "filename", color = { fg = nord_colors.polar_night.light } } },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
})
