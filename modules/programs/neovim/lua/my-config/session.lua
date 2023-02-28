local possession = require('possession')
local possession_paths = require('possession.paths')

vim.o.sessionoptions = "blank,curdir,folds,help,tabpages,winsize,winpos,terminal"

possession.setup {
    autosave = {
        current = true,
        tmp = true,
        tmp_name = 'temp session',
        on_load = true,
        on_quit = true,
    },
    plugins = {
        close_windows = {
            hooks = { 'before_save', 'before_load' },
            preserve_layout = true, -- or fun(win): boolean
            match = {
                floating = true,
                buftype = {},
                filetype = {},
                custom = false, -- or fun(win): boolean
            },
        },
        delete_hidden_buffers = {
            hooks = {
                'before_load',
                vim.o.sessionoptions:match('buffer') and 'before_save',
            },
            force = false, -- or fun(buf): boolean
        },
        nvim_tree = true,
        tabby = true,
        dap = true,
        delete_buffers = false,
    },
}

local auto_session_disabled_dirs = {
    "etc",
}

local function should_enter_auto_session(path)
    for _, disabled_dir in ipairs(auto_session_disabled_dirs) do
        if vim.startswith(path, disabled_dir) then
            return false
        end
    end
    return true
end

local function get_auto_session_name(path)
    return path:gsub("/", "\\%%")
end

vim.api.nvim_create_augroup("MyAutoSession", { clear = true })
-- Auto load session
-- Based on https://github.com/stevearc/resession.nvim#create-one-session-per-directory
vim.api.nvim_create_autocmd("VimEnter", {
    group = "MyAutoSession",
    callback = function()
        local dir = vim.fn.getcwd()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 and should_enter_auto_session(dir) then
            local session_name = get_auto_session_name(dir)
            local session_file_path = possession_paths.session(session_name)
            if session_file_path:exists() then
                possession.load(session_name)
            else
                possession.save(session_name)
            end
        end
    end,
})
-- Auto save on quit is handled by possession itself
