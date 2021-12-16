local M = {}

vim.g.nord_borders = true

function M.patchNordColors()
    local nord = require "nord"
    local nord_colors = require "nord.colors"
    local nord_util = require "nord.util"

    nord_util.highlight("illuminatedWord", { bg = nord_colors.nord1_gui })
    vim.cmd [[hi clear illuminatedCurWord]]
    nord_util.highlight("WhichKeyFloating", { bg = nord_colors.nord1_gui })
    nord_util.highlight("WhichKeyFloat", { bg = nord_colors.nord1_gui })
    nord_util.highlight("DiffChange", { fg = nord_colors.nord13_gui })
    nord_util.highlight("Folded", { style = "bold" })
end

vim.cmd [[colorscheme nord]]
M.patchNordColors()

vim.cmd [[
augroup MyColors
    autocmd!
    autocmd ColorScheme nord lua require"my-config.colors".patchNordColors()
augroup end
]]

return M
