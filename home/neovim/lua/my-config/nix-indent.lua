--  Adapted from https://github.com/nvim-treesitter/nvim-treesitter/blob/fa611f612a7b04c239d07f61ba80e09cb95c5af4/lua/nvim-treesitter/indent.lua
--  The ts indent module isn't expressive enough to indent Nix in the way I like.
--  The indent function
---@diagnostic disable: need-check-nil

local ts = vim.treesitter
local parsers = require("nvim-treesitter.parsers")

local M = {}

M.comment_parsers = {
    comment = true,
    jsdoc = true,
    phpdoc = true,
}

local function getline(lnum)
    return vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
end

---@param root TSNode
---@param lnum integer
---@param col? integer
---@return TSNode?
local function get_first_node_at_line(root, lnum, col)
    col = col or vim.fn.indent(lnum)
    return root:descendant_for_range(lnum - 1, col, lnum - 1, col + 1)
end

---@param root TSNode
---@param lnum integer
---@param col? integer
---@return TSNode?
local function get_last_node_at_line(root, lnum, col)
    col = col or (#getline(lnum) - 1)
    return root:descendant_for_range(lnum - 1, col, lnum - 1, col + 1)
end

---@param node TSNode
---@return number
local function node_length(node)
    local _, _, start_byte = node:start()
    local _, _, end_byte = node:end_()
    return end_byte - start_byte
end

local node_type_to_indent = {
    ["["] = true,
    ["{"] = true,
    ["("] = true,
    ["let"] = true,
}

---@param lnum number (1-indexed)
function M.get_nix_indent(lnum)
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = parsers.get_parser(bufnr)
    if not parser or not lnum then
        return -1
    end

    parser:parse({ vim.fn.line("w0") - 1, vim.fn.line("w$") })

    -- Get language tree with smallest range around node that's not a comment parser
    local root ---@type TSNode
    parser:for_each_tree(function(tstree, tree)
        if not tstree or M.comment_parsers[tree:lang()] then
            return
        end
        local local_root = tstree:root()
        if ts.is_in_node_range(local_root, lnum - 1, 0) then
            if not root or node_length(root) >= node_length(local_root) then
                root = local_root
            end
        end
    end)

    local is_empty_line = string.match(getline(lnum), "^%s*$") ~= nil
    if is_empty_line then
        local prevlnum = vim.fn.prevnonblank(lnum)
        local previndent = vim.fn.indent(prevlnum)
        local prevline = vim.trim(getline(prevlnum))
        -- The final position can be trailing spaces, which should not affect indentation
        local node = get_last_node_at_line(root, prevlnum, previndent + #prevline - 1)
        if node:type():match("comment") then
            -- The final node we capture of the previous line can be a comment node, which should also be ignored
            -- Unless the last line is an entire line of comment, ignore the comment range and find the last node again
            local first_node = get_first_node_at_line(root, prevlnum, previndent)
            local _, scol, _, _ = node:range()
            if first_node:id() ~= node:id() then
                -- In case the last captured node is a trailing comment node, re-trim the string
                prevline = vim.trim(prevline:sub(1, scol - previndent))
                -- Add back indent as indent of prevline was trimmed away
                local col = previndent + #prevline - 1
                node = get_last_node_at_line(root, prevlnum, col)
            end
        end

        print(node:type())
        if node_type_to_indent[node:type()] then
            return previndent + vim.fn.shiftwidth()
        end
    else
        local node = get_first_node_at_line(root, lnum)
        -- `in` of the let expression will have the same indent as the first line of the let exp
        if node:type() == "in" then
            local srow, _, _, _ = node:parent():range()
            return vim.fn.indent(srow + 1)
        end
    end

    return -1
end

vim.api.nvim_exec2(
    [[
function! GetNixIndent() abort
	return luaeval(printf('require"my-config.nix-indent".get_nix_indent(%d)', v:lnum))
endfunction
]],
    {}
)

return M
