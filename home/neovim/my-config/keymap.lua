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
    n = { "<cmd>bn<cr>", "Next Buffer" },
    p = { "<cmd>bp<cr>", "Previous Buffer" },
}
-- i -> code intelligence
local code_keymap = {
    name = "code actions",
    f = { "<cmd>Neoformat<cr>", "Format Code" },
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

wk.register({
    f = file_keymap,
    b = buffer_keymap,
    i = code_keymap,
    t = toggle_feature_keymap,
    s = search_keymap,
    v = vcs_keymap,
    q = session_keymap,
    ["j"] = buffer_keymap.b,
    ["k"] = file_keymap.f,
}, {
    prefix = "<leader>",
})

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

-- Quickly paste in insert and visual modes
m.inoremap("<C-y>", "<C-r>+")
m.vnoremap("<C-y>", [["+p]])

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
    m.nnoremap("gr", "<cmd>Telescope lsp_references<cr>", opt, "References")
    m.nnoremap("gs", "<cmd>Telescope lsp_document_symbols<cr>", opt, "Document Symbols")
    m.nnoremap("gS", "<cmd>Telescope lsp_workspace_symbols<cr>", opt, "Workspace Symbols")
    m.nnoremap("go", "<cmd>Lspsaga show_line_diagnostics<cr>", opt, "Show Line Diagnostics")
    m.nnoremap("ga", "<cmd>Lspsaga code_action<cr>", opt, "Code Actions")
    m.nnoremap("K", "<cmd>lua vim.lsp.buf.hover()<cr>", opt, "LSP Hover")
    m.nnoremap("[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opt, "Prevous Diagnostic")
    m.nnoremap("]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opt, "Next Diagnostic")

    m.nnoremap("<leader>is", "<cmd>Telescope lsp_document_symbols<cr>", opt, "Document Symbols")
    m.nnoremap("<leader>iS", "<cmd>Telescope lsp_workspace_symbols<cr>", opt, "Workspace Symbols")
    m.nnoremap("<leader>id", "<cmd>Telescope lsp_document_diagnostics<cr>", opt, "Document Diagnostics")
    m.nnoremap("<leader>iD", "<cmd>Telescope lsp_workspace_diagnostics<cr>", opt, "Workspace Diagnostics")
    m.nnoremap("<leader>ia", "<cmd>Telescope lsp_range_code_actions<cr>", opt, "Code Actions")
    m.nnoremap("<leader>ir", "<cmd>Lspsaga rename<cr>", opt, "Rename Symbol")

    m.inoremap("<C-h>", "<cmd>Lspsaga signature_help<cr>", opt)
    m.inoremap("<C-k>", "<cmd>lua vim.lsp.buf.hover()<cr>", opt)
    m.inoremap("<C-i>", "<cmd>Lspsaga code_action<cr>", opt)

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
