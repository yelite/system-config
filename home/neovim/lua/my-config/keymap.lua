local toggleterm = require("toggleterm")
local leap = require("leap")
local leap_util = require("leap.util")
local wk = require("which-key")

local my_window = require("my-config.window")
local my_settings = require("my-config.settings")
local my_git = require("my-config.git")
local my_util = require("my-config.util")

local M = {}

vim.g.mapleader = " "
vim.o.timeoutlen = 1200

wk.setup({
    preset = "helix",
    win = { border = "single" },
    icons = { separator = " " },
    layout = {
        height = { max = 18 },
        width = { max = 36 },
    },
})

local function goto_start_of_line()
    local current_col = vim.api.nvim_win_get_cursor(0)[2]
    vim.api.nvim_command([[normal! ^]])
    local new_col = vim.api.nvim_win_get_cursor(0)[2]
    if new_col == current_col then
        vim.api.nvim_command([[normal! 0]])
    end
end

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

local function search_current_dir()
    require("telescope").extensions.live_grep_args.live_grep_args({
        cwd = "%:p:h",
        results_title = vim.fn.fnamemodify(vim.fn.expand("%:h"), ":~:."),
    })
end

local function browse_current_dir()
    require("telescope").extensions.file_browser.file_browser({ path = "%:p:h" })
end

local function browse_project_root_folders()
    require("telescope").extensions.file_browser.file_browser({ files = false })
end

wk.add({
    {
        "<leader>a",
        function()
            require("avante.api").ask()
        end,
        desc = "Ask AI",
        mode = { "n", "v" },
    },
    { "<leader>j", require("my-config.telescope").git_changed_files, desc = "Changed Files in Git Branch" },
    { "<leader>J", search_current_dir, desc = "Search in the directory of current file" },
    { "<leader>k", require("my-config.telescope").quick_find_files, desc = "Quick Find Files" },
    { "<leader>K", browse_current_dir, desc = "Browser in current directory" },
    { "<leader>l", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>L", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
    { "<leader>x", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>.", "<cmd>Telescope resume<cr>", desc = "Resume Last Telescope Picker" },
    { "<leader>>", "<cmd>Telescope pickers<cr>", desc = "Previous Telescope Pickers" },

    { "<leader>A", group = "Avante" },
    {
        "<leader>Ar",
        function()
            require("avante.api").refresh()
        end,
        desc = "avante: refresh",
    },
    {
        "<leader>AA",
        function()
            require("avante.api").select_history()
        end,
        desc = "avante: history",
    },
    {
        "<leader>Aa",
        function()
            require("avante.api").select_history()
        end,
        desc = "avante: history",
    },
    {
        "<leader>AR",
        function()
            require("avante.repo_map").show()
        end,
        desc = "avante: repo map",
    },
    {
        "<leader>Ad",
        function()
            require("avante.api").toggle.debug()
        end,
        desc = "Avante: toggle debug",
    },
    {
        "<leader>Ah",
        function()
            require("avante.api").toggle.hint()
        end,
        desc = "Avante: toggle hints",
    },

    { "<leader>b", group = "buffer" },
    { "<leader>bb", [[<cmd>Telescope buffers<cr>]], desc = "Switch Buffer" },
    { "<leader>bd", [[<cmd>Bdelete<cr>]], desc = "Close Buffer" },
    { "<leader>bD", [[<cmd>Bdelete!<cr>]], desc = "Force Close Buffer" },
    { "<leader>bn", [[<cmd>bn<cr>]], desc = "Next Buffer" },
    { "<leader>bp", [[<cmd>bp<cr>]], desc = "Previous Buffer" },

    { "<leader>e", group = "edit" },
    { "<leader>em", [[<cmd>Glow<cr>]], desc = "Preview Markdown" },
    { "<leader>ep", [[<cmd>Telescope neoclip<cr>]], desc = "Clipboard History" },
    { "<leader>es", [[<plug>(SubversiveSubstituteWordRange)]], desc = "Substitute Word in Range" },
    { "<leader>eS", [[<plug>(SubversiveSubstituteRange)]], desc = "Substitue Range" },
    { "<leader>et", [[<cmd>Telescope spell_suggest<cr>]], desc = "Spell Suggests" },

    { "<leader>f", group = "file" },
    {
        "<leader>fe",
        [[<cmd>lua require'telescope'.extensions.file_browser.file_browser{path='%:p:h'}<cr>]],
        desc = "Browser in current directory",
    },
    {
        "<leader>fE",
        [[<cmd>lua require'telescope'.extensions.file_browser.file_browser{files=false}<cr>]],
        desc = "Browser folders",
    },
    {
        "<leader>ff",
        [[<cmd>lua require('telescope.builtin').find_files({cwd="%:p:h", results_title=vim.fn.expand("%:h")})<cr>]],
        desc = "Find Files",
    },
    { "<leader>fF", [[<cmd>Telescope find_files no_ignore=true<cr>]], desc = "Find All Files" },
    {
        "<leader>fp",
        function()
            copy_expansion_result("%:.")
        end,
        desc = "Copy relative path",
    },
    {
        "<leader>fP",
        function()
            copy_expansion_result("%:.:h")
        end,
        desc = "Copy relative path of the current directory",
    },
    { "<leader>fr", [[<cmd>lua require('telescope.builtin').oldfiles({only_cwd=true})<cr>]], desc = "Recent Files" },
    { "<leader>fR", [[<cmd>lua require('telescope.builtin').oldfiles({})<cr>]], desc = "Global Recent Files" },
    { "<leader>fs", [[<cmd>w<cr>]], desc = "Save File" },
    {
        "<leader>fy",
        function()
            require("yazi").yazi(nil, vim.fn.expand("%:p:h"))
        end,
        desc = "Open yazi in cwd",
    },
    {
        "<leader>fY",
        function()
            require("yazi").yazi(nil, vim.fn.getcwd())
        end,
        desc = "Open yazi in cwd",
    },

    { "<leader>i", group = "code" },
    { "<leader>ia", [[<cmd>Telescope lsp_range_code_actions<cr>]], desc = "Code Actions", mode = { "n", "v" } },
    {
        "<leader>ie",
        function()
            require("avante.api").edit()
        end,
        desc = "Avante edit",
        mode = { "n", "v" },
    },
    { "<leader>id", [[<cmd>Trouble diagnostics<cr>]], desc = "Diagnostics" },
    { "<leader>ir", [[<cmd>Lspsaga rename<cr>]], desc = "Rename Symbol", mode = { "n", "v" } },
    { "<leader>is", [[<cmd>Telescope lsp_dynamic_workspace_symbols<cr>]], desc = "Workspace Symbols" },
    { "<leader>iS", [[<cmd>Telescope lsp_document_symbols symbol_width=50<cr>]], desc = "Document Symbols" },
    { "<leader>if", [[<cmd>Format<cr>]], desc = "Format file", mode = { "n", "v" } },

    { "<leader>d", group = "debug" },
    { "<leader>dr", require("telescope").extensions.dap.commands, desc = "commands" },
    {
        "<leader>dS",
        function()
            require("go.dap").stop(true)
        end,
        desc = "stop",
    },
    { "<leader>df", require("telescope").extensions.dap.frames, desc = "toggle breakpoint" },
    { "<leader>db", require("dap").toggle_breakpoint, desc = "toggle breakpoint" },
    { "<leader>dl", require("telescope").extensions.dap.list_breakpoints, desc = "list breakpoints" },
    { "<leader>dp", require("dap").pause, desc = "pause" },

    { "<leader>n", group = "notes" },

    { "<leader>p", group = "project" },
    { "<leader>pf", [[<cmd>Telescope git_files<cr>]], desc = "Project Files" },
    { "<leader>pt", [[<cmd>TodoTelescope<cr>]], desc = "Todo Items" },

    { "<leader>q", group = "state" },
    { "<leader>ql", require("my-config.session").list_sessions, desc = "Search Sessions" },
    { "<leader>qq", [[<cmd>qa<cr>]], desc = "Quit" },
    { "<leader>qQ", [[<cmd>wa<cr><cmd>qa<cr>]], desc = "Save and Quit" },
    { "<leader>qs", [[<cmd>PossessionSave<cr>]], desc = "Save Session" },
    { "<leader>qt", [[<cmd>Telescope resume<cr>]], desc = "Resume Last Telescope Picker" },
    { "<leader>qT", [[<cmd>Telescope pickers<cr>]], desc = "Previous Telescope Pickers" },

    { "<leader>s", group = "search" },
    { "<leader>sf", [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>]], desc = "Search" },
    {
        "<leader>sF",
        [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({cwd="%:p:h", results_title=vim.fn.fnamemodify(vim.fn.expand("%:h"), ":~:.")})<cr>]],
        desc = "Search in the directory of current file",
    },
    { "<leader>sh", [[<cmd>Telescope help_tags<cr>]], desc = "Help Tags" },
    { "<leader>si", [[<cmd>Telescope treesitter<cr>]], desc = "Search Syntax Node" },
    { "<leader>sk", [[<cmd>Telescope keymaps<cr>]], desc = "Keymap" },
    { "<leader>sr", [[<cmd>lua require('spectre').open()<CR>]], desc = "Search and replace" },
    { "<leader>sR", [[viw:lua require('spectre').open_file_search()<CR>]], desc = "Search and replace current symbol" },

    { "<leader>t", group = "toggle features" },
    { "<leader>tb", [[<cmd>Gitsigns toggle_current_line_blame<cr>]], desc = "Toggle Blame Line" },
    { "<leader>tc", my_util.toggle_copilot_suppression, desc = "Toggle Copilot suppression" },
    { "<leader>tC", [[<cmd>Copilot panel<cr>]], desc = "Toggle Copilot panel" },
    { "<leader>td", [[<cmd>TroubleToggle<cr>]], desc = "Trouble Window" },
    { "<leader>tf", require("zen-mode").toggle, desc = "Focus Mode" },
    { "<leader>tl", my_util.toggle_auto_formatting, desc = "Auto formatting on save" },
    {
        "<leader>tgb",
        my_util.make_async_func(my_settings.prompt_setting, "git_base_branch"),
        desc = "Set Git Base Branch",
    },
    {
        "<leader>tgr",
        my_util.make_async_func(my_settings.prompt_setting, "git_alternative_remote"),
        desc = "Set Git Alternative Remote",
    },
    { "<leader>tn", [[<cmd>set invnumber<cr>]], desc = "Line Number" },
    { "<leader>tp", [[<cmd>InspectTree<cr>]], desc = "Treesitter Playground" },
    { "<leader>ti", require("lsp-endhints").toggle, desc = "Inlay hint at EOL" },
    { "<leader>ts", require("auto-save").toggle, desc = "Auto Save" },
    { "<leader>tS", [[<cmd>set invspell<cr>]], desc = "Spell Check" },

    { "<leader>v", group = "version control" },
    { "<leader>vb", [[<cmd>lua require"gitsigns".blame_line{}<cr>]], desc = "Blame" },
    { "<leader>vB", [[<cmd>lua require"gitsigns".blame_line{full=true}<cr>]], desc = "Blame Full Hunk" },
    { "<leader>vf", [[<cmd>Telescope git_status<cr>]], desc = "Git Status" },
    { "<leader>vh", [[<cmd>Gitsigns setqflist all<cr>]], desc = "List All Hunks" },
    { "<leader>vH", [[<cmd>Gitsigns setqflist<cr>]], desc = "List Buffer Hunks" },
    { "<leader>vl", my_git.copy_link_to_remote, desc = "Copy link to repo remote" },
    { "<leader>vL", my_git.copy_link_to_alternative_remote, desc = "Copy link to alternative remote" },
    { "<leader>vp", [[<cmd>Gitsigns preview_hunk<cr>]], desc = "Preview Hunk" },
    { "<leader>vr", [[<cmd>Gitsigns reset_hunk<cr>]], desc = "Reset Hunk" },
    { "<leader>vR", [[<cmd>Gitsigns reset_buffer<cr>]], desc = "Reset Buffer" },
    { "<leader>vs", [[<cmd>Gitsigns stage_hunk<cr>]], desc = "Stage Hunk" },
    { "<leader>vS", [[<cmd>Gitsigns stage_buffer<cr>]], desc = "Stage Buffer" },
    { "<leader>vu", [[<cmd>Gitsigns undo_stage_hunk<cr>]], desc = "Undo Stage Hunk" },
    { "<leader>vU", [[<cmd>Gitsigns reset_buffer_index<cr>]], desc = "Reset Buffer Index" },
    { "<leader>vv", [[<cmd>lua require("my-config.terminal").toggle_lazygit()<cr>]], desc = "Open lazygit" },

    { "<leader>w", group = "window", mode = { "n", "v" } },
    {
        "<leader>wa",
        function()
            require("avante.api").focus()
        end,
        desc = "Focus Avante window",
        mode = { "n", "v" },
    },
    {
        "<C-w>a",
        function()
            require("avante.api").focus()
        end,
        desc = "Focus Avante window",
        mode = { "n", "v" },
    },
    {
        "<leader>wA",
        function()
            require("avante.api").toggle()
        end,
        desc = "Toggle Avante window",
        mode = { "n", "v" },
    },
    { "<leader>wo", my_window.move_to_next_window, desc = "Move Buffer to Next Window", mode = { "n", "v" } },
    { "<leader>wO", my_window.open_in_next_window, desc = "Open Buffer in Next Window", mode = { "n", "v" } },
    {
        "<leader>wp",
        [[<cmd>lua require'my-config.window'.move_to_next_window(true)<cr>]],
        desc = "Move Buffer to Next Window And Enter",
    },
    { "<leader>ww", leap_to_window, desc = "Jump to Window" },

    { "]c", [[<cmd>Gitsigns next_hunk<CR>]], desc = "Next Hunk" },
    { "[c", [[<cmd>Gitsigns prev_hunk<CR>]], desc = "Previous Hunk" },

    { "gl", "<cmd>HopLineStart<cr>", desc = "Hop Line" },
})

wk.add({
    { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Git Hunk", mode = { "o", "x" } },
})

local function mapkey(lhs, modes, rhs, opts, desc)
    -- shortcut for vim.keymap.set so that lhs will be
    -- aligned vertically in a series of key bindings
    if desc ~= nil then
        opts = vim.tbl_extend("force", opts, { desc = desc })
    end
    vim.keymap.set(modes, lhs, rhs, opts)
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
    mapkey("goo", "n", "<cmd>Lspsaga show_cursor_diagnostics ++unfocus<cr>", opts, "Show Cursor Diagnostics")
    mapkey("god", "n", "<cmd>Lspsaga peek_definition<cr>", opts, "Preview Definition")
    mapkey("got", "n", "<cmd>Lspsaga peek_type_definition<cr>", opts, "Preview Type Definition")
    mapkey("ga", { "n", "x" }, my_util.code_action, opts, "Code Actions")
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

local function set_avanteinput()
    local opts = { buffer = vim.fn.bufnr(), silent = true }
    mapkey("<S-CR>", "i", "<CR>", vim.tbl_extend("force", opts, { remap = false }))
    mapkey("<C-s>", "n", function()
        require("avante.api").toggle()
    end, opts)
    mapkey("<C-s>", "i", function()
        vim.api.nvim_input("<esc>")
        -- Use schedule so that the side bar is turned off after
        -- getting back to normal mode, in this way the cursor
        -- won't move one char backward.
        vim.schedule(function()
            require("avante.api").toggle()
        end)
    end, opts)
    vim.wo.wrap = true
end

vim.api.nvim_create_augroup("AvanteInputMappings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "AvanteInput",
    group = "AvanteInputMappings",
    callback = set_avanteinput,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "Avante",
    group = "AvanteInputMappings",
    callback = function()
        local opts = { buffer = vim.fn.bufnr(), silent = true }
        mapkey("<C-s>", "n", function()
            vim.schedule(function()
                require("avante.api").toggle()
            end)
        end, opts)
    end,
})

vim.api.nvim_create_augroup("MyVimSurround", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    group = "MyVimSurround",
    callback = function()
        if vim.bo.filetype == "AvanteConfirm" then
            return
        end
        local opts = { buffer = vim.fn.bufnr(), silent = true }

        vim.keymap.set("n", "ds", "<Plug>Dsurround", opts)
        vim.keymap.set("n", "cs", "<Plug>Csurround", opts)
        vim.keymap.set("n", "cS", "<Plug>CSurround", opts)
        vim.keymap.set("n", "ys", "<Plug>Ysurround", opts)
        vim.keymap.set("n", "yS", "<Plug>YSurround", opts)
        vim.keymap.set("n", "yss", "<Plug>Yssurround", opts)
        vim.keymap.set("n", "ySs", "<Plug>YSsurround", opts)
        vim.keymap.set("n", "ySS", "<Plug>YSsurround", opts)
        vim.keymap.set("v", "S", "<Plug>VSurround", opts)
        vim.keymap.set("v", "gS", "<Plug>VgSurround", opts)
    end,
})

return M
