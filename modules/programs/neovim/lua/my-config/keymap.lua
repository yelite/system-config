local window_util = require "my-config.window"
local toggleterm = require "toggleterm"
local leap = require "leap"
local leap_util = require "leap.util"
-- local lspsaga_action = require("lspsaga.action")
local aerial = require "aerial"

local M = {}

vim.g.mapleader = " "
vim.o.timeoutlen = 1200

local wk = require "which-key"
wk.setup {
    window = { border = "single" },
    icons = { separator = " " },
    layout = {
        height = { max = 18 },
        width = { max = 36 },
    },
}

local function toggle_line_number()
    vim.o.number = not vim.o.number
end

local function toggle_auto_save()
    vim.cmd [[ASToggle]]
    if vim.g.autosave_state then
        print "AutoSave on"
    else
        print "AutoSave off"
    end
end

local function copy_rel_path()
    local path = vim.fn.expand "%"
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end

-- TODO: generalize this to a window selector so that the open/move in other window function can use it.
local function leap_to_window()
    target_windows = leap_util.get_enterable_windows()
    local targets = {}
    for _, win in ipairs(target_windows) do
        local wininfo = vim.fn.getwininfo(win)[1]
        local pos = { wininfo.topline, 1 } -- top/left corner
        table.insert(targets, { pos = pos, wininfo = wininfo })
    end

    leap.leap {
        target_windows = target_windows,
        targets = targets,
        action = function(target)
            vim.api.nvim_set_current_win(target.wininfo.winid)
        end,
    }
end

-- e -> edit
local edit_keymap = {
    name = "edit",
    s = { "<plug>(SubversiveSubstituteWordRange)", "Substitute Word in Range" },
    S = { "<plug>(SubversiveSubstituteRange)", "Substitue Range" },
    t = { "<cmd>Telescope spell_suggest<cr>", "Spell Suggests" },
    p = { "<cmd>Telescope neoclip<cr>", "Clipboard History" },
}
-- f -> file
local file_keymap = {
    name = "file",
    e = { "<cmd>lua require'telescope'.extensions.file_browser.file_browser()<cr>", "Browser" },
    E = {
        "<cmd>lua require'telescope'.extensions.file_browser.file_browser{cwd='%:p:h', path='%:p:h'}<cr>",
        "Browser in current directory",
    },
    f = {
        [[<cmd>lua require('telescope.builtin').find_files({cwd="%:p:h", results_title=vim.fn.expand("%:h")})<cr>]],
        "Find Files",
    },
    F = { "<cmd>Telescope find_files no_ignore=true<cr>", "Find All Files" },
    r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
    s = { "<cmd>w<cr>", "Save File" },
    p = { copy_rel_path, "Copy Relative Path" },
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
    o = { window_util.move_to_next_window, "Move Buffer to Next Window" },
    O = { window_util.open_in_next_window, "Open Buffer in Next Window" },
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
    s = { "viw:lua require('spectre').open_file_search()<CR>", "Search Current Symbol" },
    S = { "<cmd>lua require('spectre').open()<CR>", "Search" },
    f = { "<cmd>Telescope live_grep_args<cr>", "Search Text" },
    F = {
        [[<cmd>lua require('telescope.builtin').live_grep({cwd="%:p:h", results_title=vim.fn.expand("%:h")})<cr>]],
        "Search Text in Current File Directory",
    },
    h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
    i = { "<cmd>Telescope treesitter<cr>", "Search Syntax Node" },
    t = { "<cmd>Telescope termfinder find<cr>", "Search Terminals" },
}
-- t -> toggle mode
local toggle_feature_keymap = {
    name = "toggle features",
    b = { [[<cmd>Gitsigns toggle_current_line_blame<cr>]], "Toggle Blame Line" },
    d = { [[<cmd>TroubleToggle<cr>]], "Trouble Window" },
    n = { toggle_line_number, "Line Number" },
    p = { [[<cmd>TSPlaygroundToggle<cr>]], "Treesitter Playground" },
    s = { toggle_auto_save, "Auto Save" },
}
-- v -> version control
local vcs_keymap = {
    name = "version control",
    v = { [[<cmd>lua require("my-config.terminal").toggle_lazygit()<cr>]], "Open lazygit" },
    f = { [[<cmd>Telescope git_status<cr>]], "Git Status" },
    s = { [[<cmd>Gitsigns stage_hunk<cr>]], "Stage Hunk" },
    u = { [[<cmd>Gitsigns undo_stage_hunk<cr>]], "Undo Stage Hunk" },
    g = { [[<cmd>lua require"gitlinker".get_buf_range_url("n", {})<cr>]], "Copy github link" },
    l = { [[<cmd>Gitsigns setqflist all<cr>]], "List All Hunks" },
    L = { [[<cmd>Gitsigns setqflist<cr>]], "List Buffer Hunks" },
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
    t = { "GTD" },
    n = { "New Note" },
    f = { "Search Headings" },
    h = { "Show Headings" },
    l = { "Find Linkable" },
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
    ["J"] = buffer_keymap.b, -- Switch buffer
    ["k"] = { require("my-config.telescope").quick_find_files, "Quick Find Files" },
    ["K"] = file_keymap.E, -- Start broswer in the same directory
    ["l"] = code_keymap.s, -- Workspace Symbols
    ["x"] = { "<cmd>Telescope commands<cr>", "Commands" },
    ["X"] = { "<cmd>Telescope command_history<cr>", "Commands" },
    ["."] = session_keymap.t, -- Resume last telescope picker
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

local m = require "mapx"
m.setup { whichkey = true }

local function goto_start_of_line()
    local current_col = vim.api.nvim_win_get_cursor(0)[2]
    vim.api.nvim_command [[normal! ^]]
    local new_col = vim.api.nvim_win_get_cursor(0)[2]
    if new_col == current_col then
        vim.api.nvim_command [[normal! 0]]
    end
end

m.nnoremap("0", goto_start_of_line)
m.nnoremap("^", "0")

-- Emacs-like movement keybindings
m.inoremap("<C-b>", "<Left>")
m.inoremap("<C-f>", "<Right>")
m.inoremap("<C-p>", "<Up>")
m.inoremap("<C-n>", "<Down>")
m.inoremap("<C-a>", "<cmd>normal! ^<cr>")
m.inoremap("<C-e>", "<End>")

m.cnoremap("<C-b>", "<Left>")
m.cnoremap("<C-f>", "<Right>")
m.cnoremap("<C-p>", "<Up>")
m.cnoremap("<C-n>", "<Down>")
m.cnoremap("<C-a>", "<Home>")
m.cnoremap("<C-e>", "<End>")

-- Manually add mapping for vim-surround
m.imap("<C-S>", "<Plug>Isurround")

-- Join line above
m.imap("<C-j>", "<cmd>normal! kJ<cr>")

--  to clear search highlight in addition to redraw
m.cnoremap("<C-l>", "<cmd>noh<cr><C-l>")

-- Quickly paste in insert and visual modes
-- TODO: Identify the register type, call :put if it's linewise
m.inoremap("<C-y>", "<C-r><C-o>+")
m.cnoremap("<C-y>", "<C-r><C-o>+")
m.vnoremap("<C-y>", [["+p]])

-- leap
local function leap_both_direction()
    leap.leap { target_windows = { vim.fn.win_getid() } }
end

vim.keymap.set({ "n" }, "s", leap_both_direction)
vim.keymap.set({ "o", "x" }, "x", "<Plug>(leap-forward-till)")
vim.keymap.set({ "o", "x" }, "X", "<Plug>(leap-backward-till)")
vim.keymap.set({ "n" }, "gs", "<Plug>(leap-cross-window)")

-- Substitue
m.nmap("S", "<plug>(SubversiveSubstitute)")
m.nmap("SS", "<plug>(SubversiveSubstituteLine)")
m.xmap("S", "<plug>(SubversiveSubstitute)")
m.nmap("R", "<plug>(SubversiveSubstituteRange)")
m.nmap("RR", "<plug>(SubversiveSubstituteWordRange)")
m.xmap("R", "<plug>(SubversiveSubstituteRange)")
-- c should not put deleted text into register
m.nnoremap("c", [["_c]])
m.xnoremap("c", [["_c]])
m.nnoremap("C", [["_C]])
m.xnoremap("C", [["_C]])
-- p in visual should not replace register
m.xmap("p", "<plug>(SubversiveSubstitute)")
-- zp/P to force linewise put
m.nnoremap("zp", "<cmd>put<cr>")
m.nnoremap("zP", "<cmd>put!<cr>")

-- Tool windows
vim.keymap.set({ "n", "t" }, "<C-1>", "<cmd>TroubleToggle<cr>")
vim.keymap.set({ "n", "t" }, "<C-2>", function()
    toggleterm.toggle(2, nil, nil, "horizontal")
end)
vim.keymap.set({ "n", "t" }, "<C-3>", function()
    toggleterm.toggle(3, nil, nil, "float")
end)
vim.keymap.set({ "n", "t" }, "<C-4>", function()
    toggleterm.toggle(4, nil, nil, "horizontal")
end)
vim.keymap.set({ "n", "t" }, "<C-5>", function()
    aerial.toggle(true, "right")
end)

-- LSP
local function bind_rust_lsp_keys(bufnr)
    local opt = { buffer = bufnr, silent = true }
    m.nnoremap("<leader>ie", "<cmd>RustRunnables<cr>", opt, "Rust Runnables")
    m.nnoremap("<leader>ih", "<cmd>RustToggleInlayHints<cr>", opt, "Toggle Rust Inlay Hints")
    m.nnoremap("<leader>im", "<cmd>RustExpandMacro<cr>", opt, "Rust Expand Macro")
    m.nnoremap("<leader>ip", "<cmd>RustParentModule<cr>", opt, "Parent Module")
    m.nnoremap("<leader>ic", "<cmd>RustOpenCargo<cr>", opt, "Open Cargo")
end

function M.bind_lsp_keys(client, bufnr)
    local opt = { buffer = bufnr, silent = true }
    m.nnoremap("<leader>if", "<cmd>lua vim.lsp.buf.format({timeout_ms = 2000})<cr>", opt, "Format")
    -- TODO: only bind if client supports it
    m.xnoremap("<leader>if", "<cmd>lua vim.lsp.buf.format({timeout_ms = 2000})<cr>", opt, "Range Format")

    m.nnoremap("gd", "<cmd>Telescope lsp_definitions<cr>", opt, "Definition")
    m.nnoremap("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opt, "Declaration")
    m.nnoremap("gt", "<cmd>Telescope lsp_type_definitions<cr>", opt, "Type Definition")
    m.nnoremap("gr", "<cmd>Telescope lsp_references<cr>", opt, "References")
    m.nnoremap("gR", "<cmd>Lspsaga lsp_finder<cr>", opt, "Lsp Finder")
    m.nnoremap("gS", "<cmd>Telescope lsp_document_symbols<cr>", opt, "Document Symbols")
    m.nnoremap("goo", "<cmd>Lspsaga show_line_diagnostics<cr>", opt, "Show Line Diagnostics")
    m.nnoremap("god", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", opt, "Preview Definition")
    m.nnoremap("gor", "<cmd>lua require('goto-preview').goto_preview_references()<cr>", opt, "Preview Reference")
    m.nnoremap(
        "got",
        "<cmd>lua require('goto-preview').goto_preview_type_definition()<cr>",
        opt,
        "Preview Type Definition"
    )
    m.nnoremap(
        "goi",
        "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>",
        opt,
        "Preview Implementation"
    )
    -- TODO: Smart close all tool windows
    m.nnoremap("<Esc>", "<cmd>lua require('goto-preview').close_all_win()<cr>", opt, "Close all preview windows")
    m.nnoremap("ga", "<cmd>CodeActionMenu<cr>", opt, "Code Actions")
    m.nnoremap("K", "<cmd>Lspsaga hover_doc<cr>", opt, "LSP Hover")

    vim.keymap.set("n", "[e", function()
        require("lspsaga.diagnostic"):goto_prev()
    end, { silent = true, noremap = true, desc = "Next diagnostic" })
    vim.keymap.set("n", "]e", function()
        require("lspsaga.diagnostic"):goto_next()
    end, { silent = true, noremap = true, desc = "Previous diagnostic" })
    vim.keymap.set("n", "[E", function()
        require("lspsaga.diagnostic"):goto_prev { severity = vim.diagnostic.severity.ERROR }
    end, { silent = true, noremap = true, desc = "Next error" })
    vim.keymap.set("n", "]E", function()
        require("lspsaga.diagnostic"):goto_next { severity = vim.diagnostic.severity.ERROR }
    end, { silent = true, noremap = true, desc = "Previous error" })

    m.inoremap("<C-o>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opt)
    m.inoremap("<C-k>", "<cmd>Lspsaga hover_doc<cr>", opt)
    m.inoremap("<C-g>", "<cmd>CodeActionMenu<cr>", opt)

    if client.name == "rust_analyzer" then
        bind_rust_lsp_keys(bufnr)
    elseif client.name == "clangd" then
        m.nnoremap("gi", "<cmd>ClangdSwitchSourceHeader<cr>", opt, "Goto header/source")
    end
end

-- Keys for terminal mode
function M.set_terminal_keymaps()
    m.tnoremap([[<C-s>]], [[<cmd>ToggleTerm<cr>]], m.buffer)
    m.nnoremap([[<C-s>]], [[<cmd>ToggleTerm<cr>]], m.buffer)
    m.tnoremap([[<C-w>h]], [[<C-\><C-n><C-W>h]], m.buffer)
    m.tnoremap([[<C-w>j]], [[<C-\><C-n><C-W>j]], m.buffer)
    m.tnoremap([[<C-w>k]], [[<C-\><C-n><C-W>k]], m.buffer)
    m.tnoremap([[<C-w>l]], [[<C-\><C-n><C-W>l]], m.buffer)
end

vim.cmd [[
augroup MyToggleTerm
    au!
    au TermOpen term://* lua require("my-config.keymap").set_terminal_keymaps()
augroup END
]]

-- Keys for coq and auto-pairs
local npairs = require "nvim-autopairs"

local function combined_cr()
    if vim.fn.pumvisible() ~= 0 then
        if vim.fn.complete_info({ "selected" }).selected ~= -1 then
            return npairs.esc "<c-y>"
        else
            return npairs.esc "<c-e>" .. npairs.autopairs_cr()
        end
    else
        return npairs.autopairs_cr()
    end
end

local function combined_bs()
    if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
        return npairs.esc "<c-e>" .. npairs.autopairs_bs()
    else
        return npairs.autopairs_bs()
    end
end

m.inoremap("<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], m.expr)
m.inoremap("<c-c>", [[pumvisible() ? "<c-e>" : "<c-c>"]], m.expr)
m.inoremap("<cr>", combined_cr, m.expr)
m.inoremap("<bs>", combined_bs, m.expr)

return M
