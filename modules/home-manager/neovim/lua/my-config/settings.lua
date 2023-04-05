local async = require("plenary.async")
local errors = require("plenary.errors")

local M = {}

local prompt_setting_input = async.wrap(function(prompt, text, callback)
    vim.ui.input({
        prompt = prompt,
        default = text,
        kind = "my_setting",
    }, callback)
end, 3)

M.settings = {
    git_base_branch = nil,
    git_alternative_remote = nil,
}

function M.get_or_prompt_setting(key, default)
    if M.settings[key] == nil then
        M.prompt_setting(key)
    end

    if M.settings[key] == nil then
        return default
    else
        return M.settings[key]
    end
end

function M.prompt_setting(key)
    if not coroutine.running() then
        errors.traceback_error("Not in async context")
    end

    local input = prompt_setting_input(key .. ":", M.settings[key])

    if input == "" then
        M.settings[key] = nil
    elseif input ~= nil then
        M.settings[key] = input
    end
end

return M
