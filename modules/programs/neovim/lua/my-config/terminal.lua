local M = {}

require("toggleterm").setup({
    start_in_insert = true,
    shade_terminals = true,
    shading_factor = -8,
    persist_mode = false,
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", display_name = "lazygit", count = 8, direction = "float" })

function M.toggle_lazygit()
    lazygit:toggle()
end

return M
