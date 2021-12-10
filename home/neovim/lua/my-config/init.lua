local o = vim.o
local g = vim.g

o.guifont = "FiraCode Nerd Font Mono:h12"
o.mouse = "a"
o.clipboard = "unnamedplus"

o.cursorline = true
o.cursorlineopt = "number"
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

-- vim-illuminate
g.Illuminate_delay = 250
g.Illuminate_ftblacklist = {
    "TelescopePrompt",
    "help",
    "man",
}

g.neovide_remember_window_size = true
g.neovide_input_use_logo = true

if g.neovide then
    g.neovide_cursor_animation_length = 0
    g.neovide_cursor_trail_size = 0
    g.neovide_remember_window_size = true
end

require "my-config.telescope"

require("stabilize").setup {
    force = true,
}

require("indent_blankline").setup()
vim.cmd [[
augroup MyIndentBlankline
    au!
    au FileType help lua require'indent_blankline.commands'.disable()
augroup END
]]

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
    events = { "BufLeave", "FocusLost", "CursorHold" },
    conditions = {
        exists = true,
        filename_is_not = {},
        filetype_is_not = {},
        modifiable = true,
    },
    write_all_buffers = false,
    on_off_commands = false,
    clean_command_line_interval = 0,
    debounce_delay = 150,
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

require("neoclip").setup {
    history = 200,
    enable_persistant_history = true,
    db_path = vim.fn.stdpath "data" .. "/databases/neoclip.sqlite3",
    filter = nil,
    preview = true,
    default_register = '"',
    content_spec_column = false,
    on_paste = {
        set_reg = false,
    },
    keys = {
        i = {
            select = "<cr>",
            paste = "<c-j>",
            paste_behind = "<c-k>",
            custom = {},
        },
        n = {
            select = "<cr>",
            paste = "p",
            paste_behind = "P",
            custom = {},
        },
    },
}

require "my-config.keymap"
require "my-config.terminal"
require "my-config.treesitter"
require "my-config.languages"
require "my-config.statusline"
require "my-config.colors"

-- This has to be loaded after treesitter
require("tabout").setup {
    tabkey = "<Tab>",
    backwards_tabkey = "<S-Tab>",
    act_as_tab = true,
    act_as_shift_tab = false,
    enable_backwards = true,
    tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
    },
    ignore_beginning = false,
    exclude = {}, -- tabout will ignore these filetypes
}
