local M = {}

function M.my_script_path(name)
    return vim.g._my_config_script_folder .. "/" .. name
end

return M
