local async = require("plenary.async")

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

return M
