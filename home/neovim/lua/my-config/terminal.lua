local M = {}

require("toggleterm").setup({
    start_in_insert = true,
    shade_terminals = true,
    shading_factor = -8,
    persist_mode = false,
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", display_name = "lazygit", count = 8, direction = "float" })
local process_compose =
    Terminal:new({ cmd = "process-compose", display_name = "process-compose", count = 8, direction = "float" })

function M.toggle_lazygit()
    lazygit:toggle()
end

function M.toggle_process_compose()
    process_compose:toggle()
end

local bv = nil
function M.toggle_bv()
    if vim.fn.executable("bv") ~= 1 then
        vim.notify("bv not found in PATH", vim.log.levels.WARN)
        return
    end
    if not bv then
        bv = Terminal:new({ cmd = "bv", display_name = "bv", count = 9, direction = "float" })
    end
    bv:toggle()
end

return M
