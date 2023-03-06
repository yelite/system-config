local M = {}

M.main_branch = nil

function M.get_or_ask_base_branch()
    if M.main_branch == nil then
        M.ask_for_base_branch()
    end
    return M.main_branch
end

function M.ask_for_base_branch()
    M.main_branch = vim.fn.input({
        prompt = "Git Main Branch: ",
        default = M.main_branch,
        cancelreturn = "",
    })
end

return M
