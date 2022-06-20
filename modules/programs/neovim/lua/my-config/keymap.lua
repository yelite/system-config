local window_util = require "my-config.window"
local harpoon_ui = require "harpoon.ui"
local harpoon_mark = require "harpoon.mark"

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
    m = { harpoon_mark.add_file, "Mark File" },
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
    f = { "<cmd>Neoformat<cr>", "Format Code" },

    -- TODO: Move to lsp on_attach
    s = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },
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
}
-- t -> toggle mode
local toggle_feature_keymap = {
    name = "toggle features",
    b = { [[<cmd>Gitsigns toggle_current_line_blame<cr>]], "Toggle Blame Line" },
    d = { [[<cmd>TroubleToggle<cr>]], "Trouble Window" },
    f = { [[<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<cr>]], "Open Terminal" },
    i = { [[<cmd>IlluminationToggle<cr>]], "Illuminate Variable" },
    n = { toggle_line_number, "Line Number" },
    o = { "<cmd>AerialToggle!<cr>", "Symbol Outline" },
    O = { "<cmd>AerialTreeToggle!<cr>", "Symbol Outline at Current Location" },
    p = { [[<cmd>TSPlaygroundToggle<cr>]], "Treesitter Playground" },
    s = { toggle_auto_save, "Auto Save" },
    t = { [[<cmd>exe v:count1 . "ToggleTerm direction=float"<cr>]], "Open Floating Terminal" },
}
-- v -> version control
local vcs_keymap = {
    name = "version control",
    v = { [[<cmd>lua require("my-config.terminal").toggle_lazygit()<cr>]], "Open lazygit" },
    f = { [[<cmd>Telescope git_status<cr>]], "Git Status" },
    s = { [[<cmd>Gitsigns stage_hunk<cr>]], "Stage Hunk" },
    u = { [[<cmd>Gitsigns undo_stage_hunk<cr>]], "Undo Stage Hunk" },
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
    l = { "<cmd>SearchSession<cr>", "Search Sessions" },
    s = { "<cmd>SaveSession<cr>", "Save Session" },
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
    ["[c"] = { "&diff ? '[c' : '<cmd>Gitsigns previous_hunk<CR>'", "Previous Hunk", expr = true },
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

--  to clear search highlight in addition to redraw
m.cnoremap("<C-l>", "<cmd>noh<cr><C-l>")

-- Quickly paste in insert and visual modes
-- TODO: Identify the register type, call :put if it's linewise
m.inoremap("<C-y>", "<C-r><C-o>+")
m.cnoremap("<C-y>", "<C-r><C-o>+")
m.vnoremap("<C-y>", [["+p]])

-- Lighspeed
m.nmap("s", "<Plug>Lightspeed_omni_s")
m.xmap("s", "<Plug>Lightspeed_omni_s")
m.omap("z", "<Plug>Lightspeed_s")
m.omap("Z", "<Plug>Lightspeed_S")
m.omap("x", "<Plug>Lightspeed_omni_x")
m.omap("X", "<Plug>Lightspeed_omni_X")

m.nmap("f", "<Plug>Lightspeed_f")
m.xmap("f", "<Plug>Lightspeed_f")
m.omap("f", "<Plug>Lightspeed_f")
m.nmap("F", "<Plug>Lightspeed_F")
m.xmap("F", "<Plug>Lightspeed_F")
m.omap("F", "<Plug>Lightspeed_F")

m.nmap("t", "<Plug>Lightspeed_t")
m.xmap("t", "<Plug>Lightspeed_t")
m.omap("t", "<Plug>Lightspeed_t")
m.nmap("T", "<Plug>Lightspeed_T")
m.xmap("T", "<Plug>Lightspeed_T")
m.omap("T", "<Plug>Lightspeed_T")

m.nmap(";", "<Plug>Lightspeed_;_ft")
m.xmap(";", "<Plug>Lightspeed_;_ft")
m.omap(";", "<Plug>Lightspeed_;_ft")

m.nmap(",", "<Plug>Lightspeed_,_ft")
m.xmap(",", "<Plug>Lightspeed_,_ft")
m.omap(",", "<Plug>Lightspeed_,_ft")
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
    m.nnoremap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opt, "Definition")
    m.nnoremap("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opt, "Declaration")
    m.nnoremap("gt", "<cmd>Telescope lsp_type_definitions<cr>", opt, "Type Definition")
    m.nnoremap("gr", "<cmd>Lspsaga lsp_finder<cr>", opt, "Lsp Finder")
    m.nnoremap("gR", "<cmd>Trouble lsp_references<cr>", opt, "References")
    m.nnoremap("gs", "<cmd>Telescope lsp_document_symbols<cr>", opt, "Document Symbols")
    m.nnoremap("gS", "<cmd>Telescope lsp_workspace_symbols<cr>", opt, "Workspace Symbols")
    m.nnoremap("go", "<cmd>Lspsaga show_line_diagnostics<cr>", opt, "Show Line Diagnostics")
    m.nnoremap("ga", "<cmd>Lspsaga code_action<cr>", opt, "Code Actions")
    m.nnoremap("K", "<cmd>Lspsaga hover_doc<cr>", opt, "LSP Hover")
    m.nnoremap("[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opt, "Prevous Diagnostic")
    m.nnoremap("]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opt, "Next Diagnostic")

    m.inoremap("<C-h>", "<cmd>Lspsaga signature_help<cr>", opt)
    m.inoremap("<C-k>", "<cmd>Lspsaga hover_doc<cr>", opt)
    m.inoremap("<C-o>", "<cmd>Lspsaga code_action<cr>", opt)

    if client.name == "rust_analyzer" then
        bind_rust_lsp_keys(bufnr)
    elseif client.name == "clangd" then
        m.nnoremap("gi", "<cmd>ClangdSwitchSourceHeader<cr>", opt, "Goto header/source")
    end
end

-- Keys for terminal mode
function M.set_terminal_keymaps()
    m.tnoremap([[<C-s>]], [[<cmd>ToggleTerm<cr>]], m.buffer)
    m.inoremap([[<C-s>]], [[<cmd>ToggleTerm<cr>]], m.buffer)
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
