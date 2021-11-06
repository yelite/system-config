local gps = require("nvim-gps")
gps.setup()

-- Pad the mode string so that switching between common
-- modes will not cause width change in mode component
function pad_mode(mode) 
    vim.cmd[[redrawtabline]]
    return mode .. string.rep(" ", 7 - #mode)
end

local diff_component = {
    'diff', 
    symbols = { added = ' ', modified = '柳', removed = ' ' },
}

require('lualine').setup{
    options = { theme = 'nord' },
    sections = {
        lualine_a = { {'mode', fmt = pad_mode} },
        lualine_b = {},
        lualine_c = { 'filename', {gps.get_location, cond = gps.is_available} },
        lualine_x = { 
            {'diagnostics', sources={'nvim_lsp', 'coc'}}, 
            'filetype' 
        },
        lualine_y = { 
            diff_component
        },
        lualine_z = { 'location' }, 
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {
            {'diagnostics', sources={'nvim_lsp', 'coc'}}, 
            diff_component,
        },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {},
        lualine_b = { 'branch', {'filename', path = 1, file_status = false, shorting_target = 0} },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    }
}

