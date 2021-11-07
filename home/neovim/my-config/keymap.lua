vim.g.mapleader = " "
vim.o.timeoutlen = 1200

local wk = require("which-key")
wk.setup({
    window = { border = "single" },
    icons = { separator = " " },
    layout = {
        height = { max = 18 },
        width = { max = 36 },
    },
})

-- f
local file_keymap = {
    name = "file",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    F = { "<cmd>Telescope file_browser<cr>", "File Browser" },
    r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
    s = { "<cmd>w<cr>", "Save File" },
}
-- b
local buffer_keymap = {
    name = "buffer",
    b = { "<cmd>Telescope buffers<cr>", "Switch Buffer" },
}
-- s
local search_keymap = {
    name = "search",
    s = { "<cmd>Telescope grep_string<cr>", "Search Current Symbol" },
    f = { "<cmd>Telescope live_grep<cr>", "Search File" },
    i = { "<cmd>Telescope treesitter<cr>", "Search Syntax Node" },
}
-- v
local vcs_keymap = {
    name = "version control",
}
-- q
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
    s = search_keymap,
    v = vcs_keymap,
    q = session_keymap,
    ["j"] = buffer_keymap.b,
    ["k"] = file_keymap.f,
}, {
    prefix = "<leader>",
})

local m = require("mapx")
m.setup({ whichkey = true })

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

m.inoremap("<C-Space>", "<C-n>")
m.cnoremap("<C-Space>", "<C-n>")
