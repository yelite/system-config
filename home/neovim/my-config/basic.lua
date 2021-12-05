local o = vim.o
local g = vim.g

o.guifont = "FiraCode Nerd Font Mono:h12"
o.mouse = "a"
o.clipboard = "unnamedplus"

o.cursorline = true
vim.cmd [[
augroup MyCursorLine
    au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
]]
o.wrap = false
-- Until https://github.com/neovim/neovim/issues/14209 is fixed
vim.wo.colorcolumn = "99999"

o.splitbelow = true
o.splitright = true
o.hidden = true

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 99 -- Unfold everything by default

o.backup = false
o.writebackup = false

o.updatetime = 800

o.signcolumn = "no"
o.number = true

o.completeopt = "menu,preview,noinsert"

g.neovide_remember_window_size = true
g.neovide_input_use_logo = true

if g.neovide then
    g.neovide_cursor_animation_length = 0
    g.neovide_cursor_trail_size = 0
    g.neovide_remember_window_size = true
end

local ts_actions = require "telescope.actions"
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = ts_actions.close,
            },
        },
    },
}
require("telescope").load_extension "fzf"

require("stabilize").setup {
    force = true,
}

require("indent_blankline").setup()

require("nvim-autopairs").setup {
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    map_cr = false,
    map_c_w = false,
}

require("auto-session").setup {
    auto_session_enable_last_session = true,
    auto_session_suppress_dirs = { "/etc" },
}
require("session-lens").setup {}

require("autosave").setup {
    enabled = true,
    execution_message = "",
    events = { "BufLeave", "CursorHold" },
    conditions = {
        exists = true,
        filename_is_not = {},
        filetype_is_not = {},
        modifiable = true,
    },
    write_all_buffers = false,
    on_off_commands = false,
    clean_command_line_interval = 0,
    debounce_delay = 500,
}

require("gitsigns").setup {
    signcolumn = false,
    numhl = true,
}

require("Comment").setup {
    mappings = {
        extended = true,
    },
}
