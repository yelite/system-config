local M = {}

vim.g.nord_borders = true
vim.g.nord_italic = false

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

    -- Remove bold style from TS
    nord_util.highlight("TSVariable", { fg = nord_colors.nord4_gui, style = nil })
    nord_util.highlight("TSVariableBuiltin", { fg = nord_colors.nord4_gui, style = nil })
    nord_util.highlight("TSBoolean", { fg = nord_colors.nord9_gui, style = nil })
    -- Add italic to comment only
    nord_util.highlight("TSComment", { fg = nord_colors.nord3_gui_bright, style = "italic" })
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
