local lsp_status = require "lsp-status"
local gps = require "nvim-gps"
gps.setup()

-- Pad the mode string so that switching between common
-- modes will not cause width change in mode component
local function pad_mode(mode)
    return mode .. string.rep(" ", 7 - #mode)
end

local diff_component = {
    "diff",
    symbols = { added = " ", modified = "柳", removed = " " },
}

local lsp_status_component = {
    require("lsp-status").status_progress,
    cond = function()
        return #vim.lsp.buf_get_clients() > 0
    end,
}

lsp_status.register_progress()
lsp_status.config {
    diagnostics = false,
    current_function = false,
}

require("lualine").setup {
    options = { theme = "nord", globalstatus = true },
    sections = {
        lualine_a = { { "mode", fmt = pad_mode } },
        lualine_b = { { "filename", path = 1, file_status = false } },
        lualine_c = {
            { gps.get_location, cond = gps.is_available },
        },
        lualine_x = {
            { "diagnostics", sources = { "nvim_diagnostic", "coc" } },
            diff_component,
            "filetype",
        },
        lualine_y = { "location" },
        lualine_z = { "branch" },
    },
    tabline = {
        lualine_a = {},
        lualine_b = { lsp_status_component },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { { "tabs" } },
        lualine_z = {},
    },
}

require("incline").setup {
    debounce_threshold = {
        falling = 50,
        rising = 10,
    },
    render = "basic",
    window = {
        margin = {
            horizontal = 0,
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
