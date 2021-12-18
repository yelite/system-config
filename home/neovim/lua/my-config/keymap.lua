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
    p = { "<cmd>Telescope neoclip<cr>", "Clipboard History" },
}
-- f -> file
local file_keymap = {
    name = "file",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    F = { "<cmd>Telescope file_browser<cr>", "File Browser" },
    r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
    s = { "<cmd>w<cr>", "Save File" },
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
-- i -> code intelligence
local code_keymap = {
    name = "code actions",
    f = { "<cmd>Neoformat<cr>", "Format Code" },

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
    s = { "<cmd>Telescope grep_string<cr>", "Search Current Symbol" },
    f = { "<cmd>Telescope live_grep<cr>", "Search File" },
    i = { "<cmd>Telescope treesitter<cr>", "Search Syntax Node" },
}
-- t -> toggle mode
local toggle_feature_keymap = {
    name = "toggle features",
    f = { [[<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<cr>]], "Open Terminal" },
    t = { [[<cmd>exe v:count1 . "ToggleTerm direction=float"<cr>]], "Open Floating Terminal" },
    d = { [[<cmd>TroubleToggle<cr>]], "Trouble Window" },
    p = { [[<cmd>TSPlaygroundToggle<cr>]], "Treesitter Playground" },
    n = { toggle_line_number, "Line Number" },
    s = { toggle_auto_save, "Auto Save" },
}
-- v -> version control
local vcs_keymap = {
    name = "version control",
    v = { [[<cmd>lua require("my-config.terminal").toggle_lazygit()<cr>]], "Open lazygit" },
}
-- q -> session
local session_keymap = {
    name = "state",
    q = { "<cmd>qa<cr>", "Quit" },
    Q = { "<cmd>wa<cr><cmd>qa<cr>", "Save and Quit" },
    l = { "<cmd>SearchSession<cr>", "Search Sessions" },
    s = { "<cmd>SaveSession<cr>", "Save Session" },
}
-- p -> project
local project_keymap = {
    name = "project",
    t = { "<cmd>TodoTelescope<cr>", "Todo Items" },
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
    ["j"] = buffer_keymap.b, -- Switch Buffer
    ["k"] = file_keymap.f, -- Find Files
    ["l"] = code_keymap.s, -- Workspace Symbols
}, {
    prefix = "<leader>",
})

-- Text object labels
wk.register({
    ["af"] = "function",
    ["if"] = "inner function",
    ["ac"] = "class",
    ["ic"] = "inner class",
    ["aa"] = "parameter",
    ["ia"] = "inner parameter",
}, { mode = "o", prefix = "" })

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
m.inoremap("<C-a>", "<C-o>^")
m.inoremap("<C-e>", "<End>")

m.cnoremap("<C-b>", "<Left>")
m.cnoremap("<C-f>", "<Right>")
m.cnoremap("<C-p>", "<Up>")
m.cnoremap("<C-n>", "<Down>")
m.cnoremap("<C-a>", "<Home>")
m.cnoremap("<C-e>", "<End>")

--  to clear search highlight in addition to redraw
m.cnoremap("<C-l>", "<cmd>noh<cr><C-l>")

-- Quickly paste in insert and visual modes
-- TODO: Identify the register type, call :put if it's linewise
m.inoremap("<C-y>", "<C-r><C-r>+")
m.vnoremap("<C-y>", [["+p]])

-- Substitue
m.nmap("R", "<plug>(SubversiveSubstitute)")
m.nmap("RR", "<plug>(SubversiveSubstituteLine)")
-- c without putting deleted text into register
m.nnoremap("c", [["_c]])
m.xnoremap("c", [["_c]])
m.nnoremap("C", [["_C]])
m.xnoremap("C", [["_C]])
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
    m.nnoremap("gr", "<cmd>Trouble lsp_references<cr>", opt, "References")
    m.nnoremap("gs", "<cmd>Telescope lsp_workspace_symbols<cr>", opt, "Workspace Symbols")
    m.nnoremap("gS", "<cmd>Telescope lsp_document_symbols<cr>", opt, "Document Symbols")
    m.nnoremap("go", "<cmd>Lspsaga show_line_diagnostics<cr>", opt, "Show Line Diagnostics")
    m.nnoremap("ga", "<cmd>Lspsaga code_action<cr>", opt, "Code Actions")
    m.nnoremap("K", "<cmd>lua vim.lsp.buf.hover()<cr>", opt, "LSP Hover")
    m.nnoremap("[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opt, "Prevous Diagnostic")
    m.nnoremap("]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opt, "Next Diagnostic")

    m.inoremap("<C-h>", "<cmd>Lspsaga signature_help<cr>", opt)
    m.inoremap("<C-k>", "<cmd>lua vim.lsp.buf.hover()<cr>", opt)
    m.inoremap("<C-o>", "<cmd>Lspsaga code_action<cr>", opt)

    if client.name == "rust_analyzer" then
        bind_rust_lsp_keys(bufnr)
    end
end

-- Keys for terminal mode
function M.set_terminal_keymaps()
    m.tnoremap([[<C-t>]], [[<cmd>ToggleTerm<cr>]], m.buffer)
    m.inoremap([[<C-t>]], [[<cmd>ToggleTerm<cr>]], m.buffer)
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
