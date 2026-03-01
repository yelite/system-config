local nord_utils = require("nord.utils")

require("nord").setup({
    errors = { mode = "none" },
    styles = {
        comments = { italic = false },
    },
    on_highlights = function(highlights, colors)
        highlights["CmpGhostText"] = { fg = colors.polar_night.light }

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

        highlights["DiffAdd"] = { bg = "#3a4a3f", fg = "NONE" } -- muted aurora.green
        highlights["DiffDelete"] = { bg = "#4c383e", fg = "NONE" } -- muted aurora.red
        highlights["DiffChange"] = { bg = "#323c4a", fg = "NONE" } -- muted frost.artic_ocean
        highlights["DiffText"] = { bg = "#4a5e77", fg = "NONE" } -- muted frost.artic_ocean
    end,
})

vim.o.termguicolors = true
vim.cmd([[colorscheme nord]])
