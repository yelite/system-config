local toggleterm = require("toggleterm")
local leap = require("leap")
local leap_util = require("leap.util")

local my_window = require("my-config.window")
local my_settings = require("my-config.settings")
local my_git = require("my-config.git")
local my_util = require("my-config.util")

local M = {}

vim.g.mapleader = " "
vim.o.timeoutlen = 1200

local wk = require("which-key")
wk.setup({
    win = { border = "single" },
    icons = { separator = " " },
    layout = {
        height = { max = 18 },
        width = { max = 36 },
    },
})

local function copy_expansion_result(s)
    local path = vim.fn.expand(s)
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end

-- TODO: generalize this to a window selector so that the open/move in other window function can use it.
local function leap_to_window()
    local target_windows = leap_util.get_enterable_windows()
    local targets = {}
    for _, win in ipairs(target_windows) do
        local wininfo = vim.fn.getwininfo(win)[1]
        local pos = { wininfo.topline, 1 } -- top/left corner
        table.insert(targets, { pos = pos, wininfo = wininfo })
    end

    leap.leap({
        target_windows = target_windows,
        targets = targets,
        action = function(target)
            vim.api.nvim_set_current_win(target.wininfo.winid)
        end,
    })
end

-- e -> edit
local edit_keymap = {
    name = "edit",
    s = { "<plug>(SubversiveSubstituteWordRange)", "Substitute Word in Range" },
    S = { "<plug>(SubversiveSubstituteRange)", "Substitue Range" },
    t = { "<cmd>Telescope spell_suggest<cr>", "Spell Suggests" },
    p = { "<cmd>Telescope neoclip<cr>", "Clipboard History" },
    m = { "<cmd>Glow<cr>", "Preview Markdown" },
}
-- f -> file
local file_keymap = {
    name = "file",
    e = {
        "<cmd>lua require'telescope'.extensions.file_browser.file_browser{path='%:p:h'}<cr>",
        "Browser in current directory",
    },
    E = { "<cmd>lua require'telescope'.extensions.file_browser.file_browser{files=false}<cr>", "Browser folders" },
    f = {
        [[<cmd>lua require('telescope.builtin').find_files({cwd="%:p:h", results_title=vim.fn.expand("%:h")})<cr>]],
        "Find Files",
    },
    F = { "<cmd>Telescope find_files no_ignore=true<cr>", "Find All Files" },
    r = { [[<cmd>lua require('telescope.builtin').oldfiles({only_cwd=true})<cr>]], "Recent Files" },
    R = { [[<cmd>lua require('telescope.builtin').oldfiles({})<cr>]], "Global Recent Files" },
    s = { "<cmd>w<cr>", "Save File" },
    p = {
        function()
            copy_expansion_result("%:.")
        end,
        "Copy relative path",
    },
    P = {
        function()
            copy_expansion_result("%:.:h")
        end,
        "Copy relative path of the current directory",
    },
    y = {
        function()
            require("yazi").yazi(nil, vim.fn.expand("%:p:h"))
        end,
        "Open yazi in cwd",
    },
    Y = {
        function()
            require("yazi").yazi(nil, vim.fn.getcwd())
        end,
        "Open yazi in cwd",
    },
}
-- b -> buffer
local buffer_keymap = {
    name = "buffer",
    b = { "<cmd>Telescope buffers<cr>", "Switch Buffer" },
    d = { "<cmd>Bdelete<cr>", "Close Buffer" },
    D = { "<cmd>Bdelete!<cr>", "Force Close Buffer" },
    n = { "<cmd>bn<cr>", "Next Buffer" },
    p = { "<cmd>bp<cr>", "Previous Buffer" },
}
-- w -> window
local window_keymap = {
    name = "window",
    w = { leap_to_window, "Jump to Window" },
    o = { my_window.move_to_next_window, "Move Buffer to Next Window" },
    O = { my_window.open_in_next_window, "Open Buffer in Next Window" },
    p = {
        "<cmd>lua require'my-config.window'.move_to_next_window(true)<cr>",
        "Move Buffer to Next Window And Enter",
    },
}
-- i -> code intelligence
local code_keymap = {
    name = "code actions",
    -- TODO: Move to lsp on_attach
    s = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
    S = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    d = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
    D = { "<cmd>Trouble document_diagnostics<cr>", "Document Diagnostics" },
    a = { "<cmd>Telescope lsp_range_code_actions<cr>", "Code Actions" },
    r = { "<cmd>Lspsaga rename<cr>", "Rename Symbol" },
}
-- s -> search
local search_keymap = {
    name = "search",
    r = { "<cmd>lua require('spectre').open()<CR>", "Search and replace" },
    R = { "viw:lua require('spectre').open_file_search()<CR>", "Search and replace current symbol" },
    f = {
        [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>]],
        "Search",
    },
    F = {
        [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({cwd="%:p:h", results_title=vim.fn.fnamemodify(vim.fn.expand("%:h"), ":~:.")})<cr>]],
        "Search in the directory of current file",
    },
    h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymap" },
    i = { "<cmd>Telescope treesitter<cr>", "Search Syntax Node" },
}
-- t -> toggle / settings
local toggle_feature_keymap = {
    name = "toggle features",
    b = { [[<cmd>Gitsigns toggle_current_line_blame<cr>]], "Toggle Blame Line" },
    c = { my_util.toggle_copilot_suppression, "Toggle Copilot suppression" },
    C = { [[<cmd>Copilot panel<cr>]], "Toggle Copilot panel" },
    d = { [[<cmd>TroubleToggle<cr>]], "Trouble Window" },
    n = { [[<cmd>set invnumber<cr>]], "Line Number" },
    p = { [[<cmd>InspectTree<cr>]], "Treesitter Playground" },
    s = { require("auto-save").toggle, "Auto Save" },
    S = { [[<cmd>set invspell<cr>]], "Spell Check" },
    g = {
        name = "git",
        b = { my_util.make_async_func(my_settings.prompt_setting, "git_base_branch"), "Set Git Base Branch" },
        r = {
            my_util.make_async_func(my_settings.prompt_setting, "git_alternative_remote"),
            "Set Git Alternative Remote",
        },
    },
    f = { require("zen-mode").toggle, "Focus Mode" },
}
-- v -> version control
local vcs_keymap = {
    name = "version control",
    v = { [[<cmd>lua require("my-config.terminal").toggle_lazygit()<cr>]], "Open lazygit" },
    f = { [[<cmd>Telescope git_status<cr>]], "Git Status" },
    s = { [[<cmd>Gitsigns stage_hunk<cr>]], "Stage Hunk" },
    u = { [[<cmd>Gitsigns undo_stage_hunk<cr>]], "Undo Stage Hunk" },
    l = { my_git.copy_link_to_remote, "Copy link to repo remote" },
    L = { my_git.copy_link_to_alternative_remote, "Copy link to alternative remote" },
    h = { [[<cmd>Gitsigns setqflist all<cr>]], "List All Hunks" },
    H = { [[<cmd>Gitsigns setqflist<cr>]], "List Buffer Hunks" },
    r = { [[<cmd>Gitsigns reset_hunk<cr>]], "Reset Hunk" },
    R = { [[<cmd>Gitsigns reset_buffer<cr>]], "Reset Buffer" },
    p = { [[<cmd>Gitsigns preview_hunk<cr>]], "Preview Hunk" },
    b = { [[<cmd>lua require"gitsigns".blame_line{}<cr>]], "Blame" },
    B = { [[<cmd>lua require"gitsigns".blame_line{full=true}<cr>]], "Blame Full Hunk" },
    S = { [[<cmd>Gitsigns stage_buffer<cr>]], "Stage Buffer" },
    U = { [[<cmd>Gitsigns reset_buffer_index<cr>]], "Reset Buffer Index" },
}
-- q -> session
local session_keymap = {
    name = "state",
    q = { "<cmd>qa<cr>", "Quit" },
    Q = { "<cmd>wa<cr><cmd>qa<cr>", "Save and Quit" },
    l = { require("my-config.session").list_sessions, "Search Sessions" },
    s = { "<cmd>PossessionSave<cr>", "Save Session" },
    t = { "<cmd>Telescope resume<cr>", "Resume Last Telescope Picker" },
    T = { "<cmd>Telescope pickers<cr>", "Previous Telescope Pickers" },
}
-- p -> project
local project_keymap = {
    name = "project",
    t = { "<cmd>TodoTelescope<cr>", "Todo Items" },
    f = { "<cmd>Telescope git_files<cr>", "Project Files" },
}
-- n -> notes
local notes_keymap = {
    name = "notes",
}

wk.register({
    b = buffer_keymap,
    e = edit_keymap,
    f = file_keymap,
    i = code_keymap,
    n = notes_keymap,
    p = project_keymap,
    q = session_keymap,
    s = search_keymap,
    t = toggle_feature_keymap,
    v = vcs_keymap,
    w = window_keymap,
    ["j"] = { require("my-config.telescope").git_changed_files, "Changed Files in Git Branch" },
    ["J"] = search_keymap.F, -- Search in the current directory
    ["k"] = { require("my-config.telescope").quick_find_files, "Quick Find Files" },
    ["K"] = file_keymap.e, -- Start broswer in the same directory
    ["l"] = code_keymap.s, -- Workspace Symbols
    ["L"] = file_keymap.E, -- Open file browser in folder mode
    ["x"] = { "<cmd>Telescope commands<cr>", "Commands" },
    ["."] = session_keymap.t, -- Resume last telescope picker
    [">"] = session_keymap.T, -- View cached telescope pickers
}, {
    prefix = "<leader>",
})

wk.register({
    ["]c"] = { "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", "Next Hunk", expr = true },
    ["[c"] = { "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", "Previous Hunk", expr = true },
}, { mode = "n", prefix = "" })

-- Hop
wk.register({
    l = { "<cmd>HopLineStart<cr>", "Hop Line" },
    h = {
        name = "other hops",
        w = { [[<cmd>lua require"hop-extensions".hint_cword()<cr>]], "Hop Current Word" },
        W = { [[<cmd>lua require"hop-extensions".hint_cWORD()<cr>]], "Hop Current WORD" },
        l = { [[<cmd>lua require"hop-extensions".hint_locals()<cr>]], "Hop Locals" },
        s = { [[<cmd>lua require"hop-extensions".hint_scopes()<cr>]], "Hop Scopes" },
        d = { [[<cmd>lua require"hop-extensions".hint_definitions()<cr>]], "Hop Definitions" },
        k = { [[<cmd>lua require"hop-extensions".hint_textobjects('function')<cr>]], "Hop Functions" },
        a = { [[<cmd>lua require"hop-extensions".hint_textobjects('parameter')<cr>]], "Hop Parameter" },
    },
}, { mode = "n", prefix = "g" })

-- Text object labels
local text_objects = {
    -- tree-sitter
    ["af"] = "function",
    ["if"] = "inner function",
    ["ac"] = "class",
    ["ic"] = "inner class",
    ["aa"] = "parameter",
    ["ia"] = "inner parameter",
    -- textobj-entire
    ["ae"] = "entire buffer",
    ["ie"] = "entire buffer (without surrounding empty lines)",
    -- gitsign
    ["ih"] = { ":<C-U>Gitsigns select_hunk<CR>", "Git Hunk" },
}
wk.register(text_objects, { mode = "o", prefix = "" })
wk.register(text_objects, { mode = "x", prefix = "" })

local function mapkey(lhs, modes, rhs, opts, desc)
    -- shortcut for vim.keymap.set so that lhs will be
    -- aligned vertically in a series of key bindings
    if desc ~= nil then
        opts = vim.tbl_extend("force", opts, { desc = desc })
    end
    vim.keymap.set(modes, lhs, rhs, opts)
end

local function goto_start_of_line()
    local current_col = vim.api.nvim_win_get_cursor(0)[2]
    vim.api.nvim_command([[normal! ^]])
    local new_col = vim.api.nvim_win_get_cursor(0)[2]
    if new_col == current_col then
        vim.api.nvim_command([[normal! 0]])
    end
end

mapkey("0", { "n", "x" }, goto_start_of_line)
mapkey("^", { "n", "x" }, "0")

-- Emacs-like movement keybindings
mapkey("<C-p>", { "i", "c" }, "<Up>")
mapkey("<C-n>", { "i", "c" }, "<Down>")

mapkey("<C-b>", { "i", "c" }, "<Left>")
mapkey("<C-f>", { "i", "c" }, "<Right>")
mapkey("<C-a>", { "i" }, "<cmd>normal! ^<cr>")
mapkey("<C-a>", { "c" }, "<Home>")
mapkey("<C-e>", { "i", "c" }, "<End>")

mapkey("<C-f>", "s", "<Esc>`>a")
mapkey("<C-e>", "s", "<Esc>`>a")
mapkey("<C-b>", "s", "<Esc>`<i")
mapkey("<C-a>", "s", "<Esc>`<i")

-- Join line above
mapkey("<C-j>", "i", "<cmd>normal! kJ<cr>")
-- Open new line
mapkey("<S-CR>", "i", "<cmd>normal! o<cr>")

-- Quickly paste in insert and visual modes
local function paste_in_insert_mode()
    local reg_type = vim.fn.getregtype("+")
    if reg_type == "V" then
        -- For linewise register, break the line at cursor and paste content
        -- in between the broken parts.
        return "<Enter><Up><cmd>put<cr>"
    else
        return "<C-r><C-o>+"
    end
end
mapkey("<C-y>", "i", paste_in_insert_mode, { expr = true })
mapkey("<C-y>", "c", "<C-r><C-o>+")

-- leap
local function leap_both_direction()
    leap.leap({ target_windows = { vim.fn.win_getid() } })
end

mapkey("s", { "n" }, leap_both_direction)
mapkey("x", { "o", "x" }, "<Plug>(leap-forward-till)")
mapkey("X", { "o", "x" }, "<Plug>(leap-backward-till)")
mapkey("gs", { "n" }, "<Plug>(leap-cross-window)")

-- flash
mapkey("s", { "x" }, [[<cmd>lua require("flash").treesitter()<cr>]], {}, "Flash TS Search")
mapkey("r", { "o" }, function()
    require("flash").remote()
end, {}, "Remote Flash")
mapkey("R", { "o", "x" }, function()
    require("flash").treesitter_search()
end, {}, "Remote Flash")

-- Substitue
mapkey("S", { "n", "x" }, "<Plug>(SubversiveSubstitute)")
mapkey("R", { "n", "x" }, "<Plug>(SubversiveSubstituteRange)")
mapkey("SS", { "n" }, "<Plug>(SubversiveSubstituteLine)")
mapkey("RR", { "n" }, "<Plug>(SubversiveSubstituteWordRange)")

-- p in visual should not replace register
mapkey("p", "x", "<Plug>(SubversiveSubstitute)")

-- c should not put deleted text into register
mapkey("c", { "n", "x" }, [["_c]])
mapkey("C", { "n", "x" }, [["_C]])

-- zp/P to force linewise put
mapkey("zp", "n", "<cmd>put<cr>")
mapkey("zP", "n", "<cmd>put!<cr>")

-- Tool windows
mapkey("<C-1>", { "n", "t" }, "<cmd>Trouble diagnostics toggle focus=false filter.buf=0<cr>")
mapkey(
    "<C-2>",
    { "n", "t" },
    "<cmd>Trouble symbols toggle pinned=true focus=true win.position=left win.relative=win<cr>"
)
mapkey("<C-3>", { "n", "t" }, function()
    toggleterm.toggle(3, nil, nil, "float")
end)
mapkey("<C-4>", { "n", "t" }, function()
    toggleterm.toggle(4, nil, nil, "horizontal")
end)
mapkey("<C-5>", { "n", "t" }, function()
    toggleterm.toggle(2, nil, nil, "horizontal")
end)

-- LSP
local function bind_rust_lsp_keys(bufnr)
    local opt = { buffer = bufnr, silent = true }
    mapkey("<leader>ie", "n", "<cmd>RustRunnables<cr>", opt, "Rust Runnables")
    mapkey("<leader>ih", "n", "<cmd>RustToggleInlayHints<cr>", opt, "Toggle Rust Inlay Hints")
    mapkey("<leader>im", "n", "<cmd>RustExpandMacro<cr>", opt, "Rust Expand Macro")
    mapkey("<leader>ip", "n", "<cmd>RustParentModule<cr>", opt, "Parent Module")
    mapkey("<leader>ioc", "n", "<cmd>RustOpenCargo<cr>", opt, "Open Cargo")
end

function M.bind_lsp_keys(client, bufnr)
    local opts = { buffer = bufnr, silent = true }
    mapkey("<leader>if", "n", "<cmd>lua vim.lsp.buf.format({timeout_ms = 2000})<cr>", opts, "Format")
    if client.server_capabilities.documentRangeFormattingProvider then
        mapkey("<leader>if", "x", "<cmd>lua vim.lsp.buf.format({timeout_ms = 2000})<cr>", opts, "Format")
    end

    mapkey("<leader>ic", "n", "<cmd>Lspsaga incoming_calls<cr>", opts, "Incoming Calls")
    mapkey("<leader>iC", "n", "<cmd>Lspsaga outgoing_calls<cr>", opts, "Outgoing Calls")

    mapkey("gd", "n", "<cmd>Telescope lsp_definitions<cr>", opts, "Definition")
    mapkey("gD", "n", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts, "Declaration")
    mapkey("gt", "n", "<cmd>Telescope lsp_type_definitions<cr>", opts, "Type Definition")
    mapkey("gr", "n", "<cmd>Telescope lsp_references<cr>", opts, "References")
    mapkey("gR", "n", "<cmd>Lspsaga finder<cr>", opts, "Lsp Finder")
    mapkey("gS", "n", "<cmd>Telescope lsp_document_symbols<cr>", opts, "Document Symbols")
    mapkey("gk", "n", "<cmd>Lspsaga hover_doc ++keep<cr>", opts, "Pin LSP Hover Window")
    mapkey("gi", "n", "<cmd>Telescope lsp_implementations<cr>", opts, "Implementations")
    mapkey("goo", "n", "<cmd>Lspsaga show_line_diagnostics<cr>", opts, "Show Line Diagnostics")
    mapkey("god", "n", "<cmd>Lspsaga peek_definition<cr>", opts, "Preview Definition")
    mapkey("got", "n", "<cmd>Lspsaga peek_type_definition<cr>", opts, "Preview Type Definition")
    mapkey("ga", "n", "<cmd>Lspsaga code_action<cr>", opts, "Code Actions")
    mapkey("K", "n", "<cmd>Lspsaga hover_doc<cr>", opts, "LSP Hover")

    mapkey("[e", "n", function()
        require("lspsaga.diagnostic"):goto_prev()
    end, opts, "Next diagnostic")
    mapkey("]e", "n", function()
        require("lspsaga.diagnostic"):goto_next()
    end, opts, "Previous diagnostic")
    mapkey("[E", "n", function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end, opts, "Next error")
    mapkey("]E", "n", function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
    end, opts, "Previous error")

    -- map for selection mode for snippet insert node
    mapkey("<C-o>", { "s", "i" }, require("lsp_signature").toggle_float_win, opts)
    mapkey("<C-k>", "i", "<cmd>Lspsaga hover_doc<cr>", opts)
    mapkey("<C-g>", "i", "<cmd>Lspsaga code_action<cr>", opts)

    if client.name == "rust_analyzer" then
        bind_rust_lsp_keys(bufnr)
    elseif client.name == "clangd" then
        mapkey("gi", "n", "<cmd>ClangdSwitchSourceHeader<cr>", opts, "Goto header/source")
    end
end

-- Keys for terminal mode
local function set_terminal_keymaps()
    local opts = { buffer = vim.fn.bufnr(), silent = true }
    mapkey("<C-s>", { "t", "n" }, "<cmd>ToggleTerm<cr>", opts)
    mapkey("<C-w>h", "t", [[<C-\><C-n><C-W>h]], opts)
    mapkey("<C-w>j", "t", [[<C-\><C-n><C-W>j]], opts)
    mapkey("<C-w>k", "t", [[<C-\><C-n><C-W>k]], opts)
    mapkey("<C-w>l", "t", [[<C-\><C-n><C-W>l]], opts)
end

vim.api.nvim_create_augroup("MyToggleTerm", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*",
    group = "MyToggleTerm",
    callback = set_terminal_keymaps,
})

local function enable_text_mode()
    vim.bo.textwidth = 80

    local opts = { buffer = vim.fn.bufnr(), silent = true }

    mapkey("<CR>", "i", "<Plug>(bullets-newline)", opts)
    mapkey("<C-CR>", "i", "<CR>", vim.tbl_extend("force", opts, { remap = false }))

    mapkey("o", "n", "<Plug>(bullets-newline)", opts)

    mapkey("gy", "n", "<Plug>(bullets-toggle-checkbox)", opts)
    mapkey("gN", { "v", "n" }, "<Plug>(bullets-renumber)", opts)

    mapkey("<C-t>", "i", "<Plug>(bullets-demote)", opts)
    mapkey(">>", "n", "<Plug>(bullets-demote)", opts)
    mapkey(">", "v", "<Plug>(bullets-demote)", opts)
    mapkey("<C-d>", "i", "<Plug>(bullets-promote)", opts)
    mapkey("<<", "n", "<Plug>(bullets-promote)", opts)
    mapkey("<", "v", "<Plug>(bullets-promote)", opts)
end

vim.api.nvim_create_augroup("TextMode", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown,text,gitcommit,scratch",
    group = "TextMode",
    callback = enable_text_mode,
})

return M
