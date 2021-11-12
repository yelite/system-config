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
    t = { [[<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<cr>]], "Open Terminal" },
    f = { [[<cmd>exe v:count1 . "ToggleTerm direction=float"<cr>]], "Open Floating Terminal" },
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

m.nnoremap("0", "^")
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

m.inoremap("<C-Space>", "<C-n>")
m.cnoremap("<C-Space>", "<C-n>")

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

return M
