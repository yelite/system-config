local gps = require "nvim-gps"
gps.setup()

-- Pad the mode string so that switching between common
-- modes will not cause width change in mode component
local function pad_mode(mode)
    return mode .. string.rep(" ", 7 - #mode)
end

-- We need to redraw tabline if cursor moves to update nvim-gps
vim.cmd [[  
augroup TablineUpdate
    au!
    au CursorMoved * redrawtabline
    au CursorMovedI * redrawtabline
augroup END
]]

local diff_component = {
    "diff",
    symbols = { added = " ", modified = "柳", removed = " " },
}

require("lualine").setup {
    options = { theme = "nord" },
    sections = {
        lualine_a = { { "mode", fmt = pad_mode } },
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {
            { "diagnostics", sources = { "nvim_lsp", "coc" } },
            "filetype",
        },
        lualine_y = {
            diff_component,
        },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {
            { "diagnostics", sources = { "nvim_lsp", "coc" } },
            diff_component,
        },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {
        lualine_a = {},
        lualine_b = {
            { "filename", path = 1, file_status = false, shorting_target = 0 },
        },
        lualine_c = {
            { gps.get_location, cond = gps.is_available },
        },
        lualine_x = {},
        lualine_y = { "branch" },
        lualine_z = {},
    },
}
