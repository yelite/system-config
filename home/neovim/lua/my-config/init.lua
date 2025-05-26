local o = vim.o
local g = vim.g

o.guifont = "Hack Nerd Font Mono:h14"
o.mouse = "a"
o.clipboard = "unnamedplus"

o.cursorline = true
o.cursorlineopt = "number"
o.wrap = false

o.splitbelow = true
o.splitright = true
o.splitkeep = "screen"
o.hidden = true
o.showtabline = 0

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 99 -- Unfold everything by default
o.foldtext =
    [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
o.fillchars = "fold: ,msgsep:─"
o.foldnestmax = 3
o.foldminlines = 1

o.backup = false
o.writebackup = false

o.updatetime = 800

o.signcolumn = "auto"
o.number = true
o.conceallevel = 1

o.completeopt = "menu,preview,noinsert"
o.spelloptions = "camel"
o.spelllang = "en,cjk"
o.spellfile = string.format("%s%s", vim.fn.stdpath("config"), "/spell/spell.add")

-- vim-surround
g.surround_no_mappings = true

if g.neovide then
    g.neovide_remember_window_size = true
    g.neovide_input_use_logo = true
    g.neovide_cursor_animation_length = 0
    g.neovide_cursor_trail_size = 0
    g.neovide_remember_window_size = true
    g.neovide_floating_opacity = 0.9
end

-- bullets.vim
vim.g.bullets_set_mappings = 0
vim.g.bullets_checkbox_markers = " .oOx"

-- Override vim.paste to make terminal paste not add killed content into register
vim.paste = (function(original)
    return function(lines, phase)
        if #lines == 1 and phase == -1 and vim.api.nvim_get_mode().mode == "v" then
            -- paste single line, non-streaming paste, and in visual mode
            -- Taken from https://github.com/neovim/neovim/blob/bb38c066a96512cf8cb2ef2e733494b5bbdfa3fd/runtime/lua/vim/_editor.lua#L280
            -- The only difference is that the first line exec '<Del>' to the black hole register
            vim.api.nvim_command([[exe "silent normal! \"_\<Del>"]])
            local del_start = vim.fn.getpos("'[")
            local cursor_pos = vim.fn.getpos(".")
            -- paste after cursor when replacing text at eol, otherwise paste before cursor
            vim.api.nvim_put(lines, "c", cursor_pos[3] < del_start[3], false)
            -- put cursor at the end of the text instead of one character after it
            vim.fn.setpos(".", vim.fn.getpos("']"))
            return
        end
        original(lines, phase)
    end
end)(vim.paste)

vim.loader.enable()

require("my-config.telescope")

require("hlchunk").setup({
    chunk = {
        enable = false,
    },
    indent = {
        enable = true,
        exclude_filetype = {
            yazi = true,
        },
    },
    line_num = {
        enable = false,
    },
    blank = {
        enable = false,
    },
})

require("zen-mode").setup({
    window = {
        backdrop = 0.8,
        width = 105, -- width of the Zen window
        height = 1, -- height of the Zen window
    },
})

if not g.neovide then
    local pets = require("pets")
    pets.setup({
        default_pet = "rubber-duck",
        default_style = "yellow",
        random = false,
        row = 6,
        col = 25,
        speed_multiplier = 0.3,
    })
end

require("dressing").setup({
    input = {
        get_config = function(opts)
            if opts.kind == "my_setting" or opts.kind == "note_prompt" then
                return {
                    relative = "editor",
                }
            end
        end,
    },
})

require("glow").setup({
    border = "single",
})

require("render-markdown").setup({
    file_types = { "Avante" },
})

require("hop").setup({
    jump_on_sole_occurrence = false,
})

require("flash").setup({
    jump = {
        nohlsearch = true,
    },
    label = {
        min_pattern_length = 2,
    },
    modes = {
        search = {
            enabled = false,
        },
        char = {
            enabled = true,
            config = function(opts)
                if vim.fn.mode(true):find("no") then
                    opts.autohide = true
                    opts.highlight.groups.label = ""
                    opts.highlight.groups.match = ""
                    opts.highlight.backdrop = false
                end
                opts.jump_labels = opts.jump_labels and vim.v.count == 0
            end,
            highlight = {
                backdrop = true,
            },
        },
    },
})

require("auto-save").setup({
    enabled = true,
    trigger_events = { "InsertLeave", "TextChanged" },
    write_all_buffers = false,
    debounce_delay = 250,
})
vim.api.nvim_create_augroup("MyAutoSave", { clear = true })
vim.api.nvim_create_autocmd("BufLeave", {
    group = "MyAutoSave",
    callback = function(data)
        if vim.fn.filereadable(vim.fn.expand("%:p")) == 0 then
            return
        end
        if vim.api.nvim_eval([[&modifiable]]) == 0 then
            return
        end
        vim.cmd([[ update ]])
    end,
})

require("gitsigns").setup({
    signcolumn = false,
    numhl = true,
})

require("trouble").setup({
    indent_line = false,
    auto_preview = false,
})

require("todo-comments").setup({
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
})

require("yazi").setup({})

require("Comment").setup({})

require("neoclip").setup({
    history = 30,
    enable_persistent_history = true,
    db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
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
})

---@diagnostic disable-next-line: missing-fields
require("notify").setup({
    on_open = function(win)
        vim.api.nvim_win_set_config(win, { focusable = false })
    end,
})
vim.notify = require("notify")

vim.g.code_action_menu_show_diff = false

require("gitlinker").setup({
    mappings = nil,
})

require("my-config.keymap")
require("my-config.session")
require("my-config.terminal")
require("my-config.treesitter")
require("my-config.edit")
require("my-config.note")
require("my-config.cmp")
require("my-config.languages")
require("my-config.statusline")
-- Put color the last to make it obvious if something goes wrong in previous config
require("my-config.colors")
