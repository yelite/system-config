-- A module to do customized text folding, replacing the foldtext from core.norg.concealer
-- The concealer module should get config `folds.enable = false` to avoid conflict

require("neorg.modules.base")

local module = neorg.modules.create("myconfig.foldtext")
local concealer = require("neorg.modules.core.norg.concealer.module")

module.setup = function()
    return { success = true }
end

module.public = {
    foldtext = function()
        local folded = concealer.public.foldtext()
        local foldstart = vim.v.foldstart
        local foldend = vim.v.foldend
        return folded .. string.format(" ... (%s lines)", foldend - foldstart + 1)
    end,
}

module.on_event = function(event)
    if event.type == "core.autocommands.events.bufenter" and event.content.norg then
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt_local.foldtext = "v:lua.neorg.modules.get_module('" .. module.name .. "').foldtext()"
    end
end

module.events.subscribed = {
    ["core.autocommands"] = {
        bufenter = true,
    },
}

return module
