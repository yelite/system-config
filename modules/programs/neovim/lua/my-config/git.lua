local gitlinker = require("gitlinker")

local M = {}

-- The branch name to diff against when fetching changed files in dev branch
M.base_branch = nil
-- The alternative remote name to generate url in gitlinker
M.alternative_remote = nil

function M.get_or_ask_base_branch()
    if M.base_branch == nil then
        M.ask_for_base_branch()
    end
    return M.base_branch
end

function M.ask_for_base_branch()
    local input = vim.fn.input({
        prompt = "Git Main Branch: ",
        default = M.base_branch,
        cancelreturn = "",
    })
    if input ~= "" then
        M.base_branch = input
    end
end

function M.get_or_ask_alternative_remote()
    if M.alternative_remote == nil then
        M.ask_for_alternative_remote()
    end
    return M.alternative_remote
end

function M.ask_for_alternative_remote()
    local input = vim.fn.input({
        prompt = "Git Alternative Remote: ",
        default = M.alternative_remote,
        cancelreturn = "",
    })
    if input ~= "" then
        M.alternative_remote = input
    end
end

function M.copy_link_to_remote()
    gitlinker.get_buf_range_url("n", {})
end

function M.copy_link_to_alternative_remote()
    gitlinker.get_buf_range_url("n", { remote = M.get_or_ask_alternative_remote() })
end

return M
