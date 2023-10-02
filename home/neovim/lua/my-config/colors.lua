local nord_utils = require("nord.utils")

require("nord").setup({
    errors = { mode = "none" },
    styles = {
        comments = { italic = false },
    },
    on_highlights = function(highlights, colors)
        highlights["CmpGhostText"] = { fg = colors.polar_night.light }

        highlights["LuasnipInsertNodeUnvisited"] = { bg = colors.polar_night.brighter, bold = true }
        highlights["LuasnipChoiceNodeUnvisited"] = { bg = colors.polar_night.brighter, bold = true }
        highlights["LuasnipInsertNode"] = { fg = colors.polar_night.light }

        highlights["LeapMatch"] =
            { fg = colors.polar_night.origin, bg = colors.aurora.yellow, bold = true, nocombine = true }
        highlights["LeapLabelPrimary"] =
            { fg = colors.polar_night.origin, bg = colors.aurora.yellow, bold = true, nocombine = true }
        highlights["LeapLabelSecondary"] =
            { fg = colors.polar_night.origin, bg = colors.aurora.purple, bold = true, nocombine = true }
        highlights["LeapLabelSelected"] =
            { fg = colors.polar_night.origin, bg = colors.aurora.green, bold = true, nocombine = true }

        highlights["TelescopeBorder"] = { fg = colors.snow_storm.origin, bg = nord_utils.make_global_bg() }

        highlights["FlashLabel"] =
            { fg = colors.polar_night.origin, bg = colors.aurora.yellow, bold = true, nocombine = true }
        highlights["FlashCurrent"] = { fg = colors.polar_night.origin, bg = colors.aurora.green, nocombine = true }

        highlights["@error"] = nil
    end,
})

vim.o.termguicolors = true
vim.cmd([[colorscheme nord]])
