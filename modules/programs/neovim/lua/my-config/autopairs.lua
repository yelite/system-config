local npairs = require "nvim-autopairs"
local Rule = require "nvim-autopairs.rule"
local cond = require "nvim-autopairs.conds"

local function remove_nix_from_basic_bracket_rules(start_pair)
    local rules = npairs.get_rule(start_pair)
    if #rules == 0 then
        rules = { rules }
    end
    for _, rule in ipairs(rules) do
        local disabled_filetypes = rule.not_filetypes or {}
        table.insert(disabled_filetypes, "nix")
        rule.not_filetypes = disabled_filetypes
    end
end

local function add_nix_bracket_rule(start_pair, end_pair)
    local end_pair_with_semicolon = end_pair .. ";"
    local should_add_extra_semicolon = function(opts)
        local before_cursor = string.sub(opts.line, 1, opts.col)
        if before_cursor == nil then
            return false
        else
            return string.match(before_cursor, "%.*=%s*$")
        end
    end
    local should_delete_extra_semicolon = function(opts)
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local before_cursor = string.sub(opts.line, 1, col - 1)
        if before_cursor == nil then
            return false
        else
            return string.match(before_cursor, "%.*=%s*$")
        end
    end
    npairs.add_rules {
        -- Here we use replace endpair instead of using '};' as end_pair
        -- because this makes move and nested pair behave correctly
        Rule(start_pair, end_pair, "nix")
            :with_pair(cond.not_add_quote_inside_quote())
            :with_pair(cond.not_after_regex(string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""))) -- copied from nvim-autopairs.lua:22
            :with_pair(cond.is_bracket_line())
            :with_move(cond.move_right())
            :with_del(cond.none())
            :replace_endpair(function(opts)
                if should_add_extra_semicolon(opts) then
                    return end_pair_with_semicolon
                elseif string.sub(opts.line, opts.col, opts.col + 1) == "};" then
                    -- This handles the case of moving right
                    return end_pair_with_semicolon
                else
                    return end_pair
                end
            end)
            :use_undo(true),
        -- Here we add an support rule to just handle deletion
        -- because the deletion doesn't play nicely with replace endpair
        Rule(start_pair, end_pair_with_semicolon, "nix")
            :with_pair(cond.none())
            :with_move(cond.none())
            :with_cr(cond.none())
            :with_del(should_delete_extra_semicolon)
            :use_undo(true),
        Rule(start_pair, end_pair, "nix")
            :with_pair(cond.none())
            :with_move(cond.none())
            :with_cr(cond.none())
            :with_del(function(opts)
                return not should_delete_extra_semicolon(opts)
            end)
            :use_undo(true),
    }
end

local function setup()
    if npairs.config ~= nil then
        npairs.clear_rules()
    end
    npairs.setup {
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        disable_in_macro = true,
        disable_in_visualblock = true,
        map_cr = false,
        map_c_w = false,
    }

    -- Here we add special rule for brackets and parens in nix
    -- Those pairs should be followed by ';' because it's almost always the right thing
    -- by the syntax and it's hard to add one manually (<c-f>;<c-b><c-b>)
    local nix_brackets = { { "{", "}" }, { "[", "]" } }
    for _, pair in ipairs(nix_brackets) do
        local start_pair, end_pair = pair[1], pair[2]
        remove_nix_from_basic_bracket_rules(start_pair)
        add_nix_bracket_rule(start_pair, end_pair)
    end
end

setup()
