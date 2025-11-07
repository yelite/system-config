local async = require("plenary.async")
local lualine = require("lualine")

local M = {}

function M.make_async_func(f, ...)
    local async_f = async.void(f)
    local args_to_pass = { ... }
    return function()
        async_f(unpack(args_to_pass))
    end
end

function M.my_script_path(name)
    return vim.g._my_config_script_folder .. "/" .. name
end

function M.open_float_window()
    local width = vim.o.columns
    local height = vim.o.lines

    local win_height = math.ceil(height * 0.68 - 4)
    local win_width = math.ceil(width * 0.68)

    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    local opts = {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded",
    }

    vim.api.nvim_open_win(0, true, opts)
end

vim.api.nvim_create_user_command("OpenFloat", M.open_float_window, { desc = "Open a float window" })

M.toggle_auto_formatting = function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify("Auto formatting is now " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
end

M.code_action = function()
    vim.lsp.buf.code_action({
        filter = function(action)
            return action.kind ~= "gopls.doc.features"
        end,
    })
end

return M
