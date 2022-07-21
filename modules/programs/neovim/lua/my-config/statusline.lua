local lsp_status = require "lsp-status"
local gps = require "nvim-gps"
gps.setup()

-- Pad the mode string so that switching between common
-- modes will not cause width change in mode component
local function pad_mode(mode)
    return mode .. string.rep(" ", 7 - #mode)
end

-- We need to redraw tabline if cursor moves to update nvim-gps
vim.cmd [[  
augroup MyTablineUpdate
    au!
    au CursorMoved * redrawtabline
    au CursorMovedI * redrawtabline
augroup END
]]

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
        lualine_b = { "filename" },
        lualine_c = {
            { gps.get_location, cond = gps.is_available },
        },
        lualine_x = {
            lsp_status_component,
            { "diagnostics", sources = { "nvim_diagnostic", "coc" } },
            diff_component,
            "filetype",
        },
        lualine_y = {},
        lualine_z = { "location" },
    },
    tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
            { "filename", path = 1, file_status = false, shorting_target = 0 },
        },
        lualine_y = { "branch" },
        lualine_z = {},
    },
}
