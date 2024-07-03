local navic = require("nvim-navic")
local copilot_status = require("copilot_status")
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

require("copilot_status").setup({
    icons = {
        idle = " ",
        error = " ",
        offline = "",
        warning = " ",
        loading = " ",
    },
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

local function get_copilot_status()
    if util.is_copilot_suppressed() then
        return " "
    end
    return copilot_status.status_string()
end

require("lualine").setup({
    options = {
        theme = "nord",
        globalstatus = true,
        disabled_filetypes = { winbar = { "toggleterm" } },
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
        lualine_x = {
            { "diagnostics", sources = { "nvim_diagnostic", "coc" } },
            get_copilot_status,
            "filetype",
        },
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
