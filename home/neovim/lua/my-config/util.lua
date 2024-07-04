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

local copilot_suppressed = false

M.is_copilot_installed = function()
    return vim.g._copilot_enabled
end

M.is_copilot_suppressed = function()
    return copilot_suppressed
end

M.toggle_copilot_suppression = function()
    if not M.is_copilot_installed() then
        print("Tried to toggle copilot suppression without copilot installed. No action taken.")
        return
    end

    local copilot_client = require("copilot.client")
    local copilot_command = require("copilot.command")

    if not copilot_client.is_disabled() then
        copilot_command.disable()
        copilot_suppressed = true
    elseif copilot_suppressed then
        copilot_command.enable()
        copilot_suppressed = false
    else
        print("Tried to toggle copilot suppression without copilot enabled. No action taken.")
    end

    lualine.refresh({
        place = { "statusline" },
        tirgger = "copilot_suppression",
    })
end

return M
