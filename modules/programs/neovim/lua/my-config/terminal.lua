local M = {}

require("toggleterm").setup {
    start_in_insert = true,
    persist_mode = false,
}

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new { cmd = "lazygit", hidden = true, count = 8, direction = "float" }

function M.toggle_lazygit()
    lazygit:toggle()
end

return M
