local lsp_status = require "lsp-status"
local gps = require "nvim-gps"
local terms = require "toggleterm.terminal"
local nord_colors = require "nord.colors"

gps.setup()

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
    symbols = { added = " ", modified = "柳", removed = " " },
}

local lsp_status_component = {
    require("lsp-status").status_progress,
    cond = function()
        return #vim.lsp.get_active_clients() > 0
    end,
}

lsp_status.register_progress()
lsp_status.config {
    diagnostics = false,
    current_function = false,
}

require("lualine").setup {
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
                file_status = false,
                cond = function()
                    return not is_toggleterm()
                end,
            },
            {
                get_term_name,
            },
        },
        lualine_c = { { gps.get_location, cond = gps.is_available } },
        lualine_x = {
            lsp_status_component,
            { "diagnostics", sources = { "nvim_diagnostic", "coc" } },
            diff_component,
            "location",
            "filetype",
        },
        lualine_y = { "branch" },
        lualine_z = { "tabs" },
    },
    -- TODO: reenable winbar after https://github.com/neovim/neovim/issues/19458
    -- winbar = {
    --     lualine_a = {},
    --     lualine_b = { { "filename", color = { fg = nord_colors.nord5_gui } } },
    --     lualine_c = { { gps.get_location, cond = gps.is_available } },
    --     lualine_x = {},
    --     lualine_y = { "location", "progress" },
    --     lualine_z = {},
    -- },
    -- inactive_winbar = {
    --     lualine_a = {},
    --     lualine_b = { { "filename", color = { fg = nord_colors.nord3_gui_bright } } },
    --     lualine_c = {},
    --     lualine_x = {},
    --     lualine_y = {},
    --     lualine_z = {},
    -- },
}

require("incline").setup {
    debounce_threshold = {
        falling = 50,
        rising = 10,
    },
    render = "basic",
    window = {
        margin = {
            horizontal = 2,
            vertical = 0,
        },
        options = {
            signcolumn = "no",
            wrap = false,
        },
        padding = 1,
        padding_char = " ",
        placement = {
            horizontal = "right",
            vertical = "top",
        },
        width = "fit",
        winhighlight = {
            active = {
                Normal = "InclineNormal",
            },
            inactive = {
                EndOfBuffer = "None",
                Normal = "InclineNormalNC",
                Search = "None",
            },
        },
        zindex = 50,
    },
}
