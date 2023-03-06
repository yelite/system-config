local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")
local ts_cond = require("nvim-autopairs.ts-conds")

local function setup()
    if npairs.config ~= nil then
        npairs.clear_rules()
    end
    npairs.setup({
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        disable_in_macro = true,
        disable_in_visualblock = true,
        map_cr = false,
        map_c_w = false,
    })

    npairs.add_rules({
        Rule("=", ";", "nix")
            :with_pair(cond.not_inside_quote())
            :with_pair(cond.not_after_regex(string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", "")))
            :with_pair(ts_cond.is_not_ts_node({ "comment", "indented_string" }))
            :with_pair(cond.before_regex(".*%w+%s*$", -1))
            :use_undo(true)
            :with_move(cond.none()), -- copied from nvim-autopairs.lua:22
        Rule("{ ", "}", "nix"):only_cr(),
        Rule("{", " }", "nix"):only_cr(),
        Rule("[ ", "]", "nix"):only_cr(),
        Rule("[", " ]", "nix"):only_cr(),
    })
end

setup()
