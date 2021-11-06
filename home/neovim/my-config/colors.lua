local M = {}

vim.g.nord_borders = true
vim.g.colors_name = "nord"

function M.patchNordColors() 
    local nord = require("nord")
    local nord_colors = require("nord.colors")
    local nord_util = require("nord.util")

    nord_util.highlight("WhichKeyFloating", { bg = nord_colors.nord1_gui })
    nord_util.highlight("WhichKeyFloat", { bg = nord_colors.nord1_gui })
    nord_util.highlight("DiffChange", { fg = nord_colors.nord13_gui })
end

vim.cmd[[
augroup MyColors
    autocmd!
    autocmd ColorScheme nord lua require"my-config.colors".patchNordColors()
augroup end
]]

return M
