local o = vim.o
local g = vim.g

o.guifont = "Hack Nerd Font Mono:h12"
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
o.showtabline = 0

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 99 -- Unfold everything by default
o.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
o.fillchars = "fold: "
o.foldnestmax = 3
o.foldminlines = 1

o.backup = false
o.writebackup = false

o.updatetime = 800

o.signcolumn = "no"
o.number = true

o.completeopt = "menu,preview,noinsert"

-- vim-surround
g.surround_no_insert_mappings = true

if g.neovide then
    g.neovide_remember_window_size = true
    g.neovide_input_use_logo = true
    g.neovide_cursor_animation_length = 0
    g.neovide_cursor_trail_size = 0
    g.neovide_remember_window_size = true
    g.neovide_floating_opacity = 0.9
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

require("hop").setup {
    jump_on_sole_occurrence = false,
}

vim.g.lightspeed_no_default_keymaps = true
require("lightspeed").setup {
    ignore_case = false,
}

o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
require("auto-session").setup {
    auto_session_suppress_dirs = { "/etc" },
    post_restore_cmds = { [[normal `"]] }, -- restore the last cursor position
}
require("session-lens").setup {}

require("auto-save").setup {
    enabled = true,
    events = { "InsertLeave", "FocusLost" },
    write_all_buffers = false,
    on_off_commands = true,
    clean_command_line_interval = 0,
    debounce_delay = 150,
}
vim.api.nvim_create_augroup("MyAutoSave", { clear = true })
vim.api.nvim_create_autocmd("BufLeave", {
    group = "MyAutoSave",
    callback = function(data)
        if vim.fn.filereadable(vim.fn.expand "%:p") == 0 then
            return
        end
        if vim.api.nvim_eval [[&modifiable]] == 0 then
            return
        end
        vim.cmd [[ update ]]
    end,
})

require("gitsigns").setup {
    signcolumn = false,
    numhl = true,
    keymaps = {},
}

require("trouble").setup {
    indent_line = false,
    auto_preview = false,
}

require("todo-comments").setup {
    signs = false,
    keywords = {
        FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
    },
    merge_keywords = false,
    highlight = {
        after = "",
    },
}

require("Comment").setup {
}

require("neoclip").setup {
    history = 30,
    enable_persistent_history = true,
    db_path = vim.fn.stdpath "data" .. "/databases/neoclip.sqlite3",
    filter = nil,
    preview = true,
    default_register = "+",
    content_spec_column = false,
    on_paste = {
        set_reg = false,
    },
    keys = {
        telescope = {
            i = {
                select = "<cr>",
                paste = "<C-CR>",
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
    },
}

require("aerial").setup {}

require('goto-preview').setup {
    width = 135; -- Width of the floating window
    height = 20; -- Height of the floating window
    border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }; -- Border characters of the floating window
    default_mappings = false; -- Bind default mappings
    resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
    references = { -- Configure the telescope UI for slowing the references cycling window.
        telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
    };
    -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
    focus_on_open = true; -- Focus the floating window when opening it.
    dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
    force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
    bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
}

vim.g.code_action_menu_show_diff = false

require('gitlinker').setup({
    mappings = nil
})

require "my-config.keymap"
require "my-config.terminal"
require "my-config.treesitter"
require "my-config.autopairs"
require "my-config.languages"
require "my-config.neorg"
require "my-config.colors"
require "my-config.statusline"

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
    completion = false,
    exclude = {}, -- tabout will ignore these filetypes
}
