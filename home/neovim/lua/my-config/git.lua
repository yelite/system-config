local gitlinker = require("gitlinker")

local my_util = require("my-config.util")
local my_settings = require("my-config.settings")

local M = {}

function M.copy_link_to_remote()
    gitlinker.link({})
end

M.copy_link_to_alternative_remote = my_util.make_async_func(function()
    gitlinker.link({ remote = my_settings.get_or_prompt_setting("git_alternative_remote", "origin") })
end)

return M
