local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local themes = require("telescope.themes")

local possession = require("possession")
local possession_session = require("possession.session")
local possession_paths = require("possession.paths")
local possession_utils = require("possession.utils")

local my_settings = require("my-config.settings")

local M = {}

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

local function save_user_data(name)
    local data = {}
    for k, v in pairs(my_settings.settings) do
        data[k] = v
    end
    return data
end

local function load_user_data(user_data)
    for k, v in pairs(user_data) do
        my_settings.settings[k] = v
    end
end

possession.setup({
    autosave = {
        current = true,
        tmp = true,
        tmp_name = "temp session",
        on_load = true,
        on_quit = true,
    },
    hooks = {
        before_save = save_user_data,
        -- load user data before sourcing the session vimscript,
        -- in order to avoid losing persistent settings due to failure in
        -- session restoration.
        before_load = function(_, user_data)
            load_user_data(user_data)
            return true
        end,
        after_load = function()
            vim.api.nvim_command("clearjumps")
        end,
    },
    plugins = {
        close_windows = {
            hooks = { "before_save", "before_load" },
            preserve_layout = true, -- or fun(win): boolean
            match = {
                floating = true,
                buftype = {},
                filetype = {},
                custom = false, -- or fun(win): boolean
            },
        },
        delete_hidden_buffers = false,
        nvim_tree = false,
        tabby = false,
        dap = false,
        delete_buffers = false,
    },
})

local auto_session_disabled_dirs = {
    "/etc",
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
    return path:gsub("/", "__")
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
            -- unconditionally set the session name
            require("possession.session").session_name = session_name
            if session_file_path:exists() then
                -- There is a (uncomfirmed) bug in nvim_exec, which caused buffer
                -- local options to be left in a weird state (ft is null, etc.) if
                -- possession.load is called eagerly at VimEnter. So here it calls
                -- it with defer_fn.
                vim.defer_fn(function()
                    possession.load(session_name)
                end, 0)
            end
        end
    end,
})

-- Session Picker

local load_session_action = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    if not selection then
        possession_utils.warn("Nothing currently selected")
        return
    end
    actions.close(prompt_bufnr)
    vim.defer_fn(function()
        possession_session.load(selection.value.name)
    end, 0)
end

local delete_session_action = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    current_picker:delete_selection(function(selection)
        possession_session.delete(selection.value.name, { no_confirm = true })
    end)
end

function M.list_sessions(opts)
    local sessions = {}
    for file, data in pairs(possession_session.list()) do
        data.file = file
        table.insert(sessions, data)
    end
    -- TODO: Make current session on the top?
    table.sort(sessions, function(a, b)
        return a.name < b.name
    end)

    pickers
        .new({
            prompt_title = "Sessions",
            finder = finders.new_table({
                results = sessions,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry.name,
                        ordinal = entry.name,
                    }
                end,
            }),
            sorter = conf.generic_sorter(opts),
            previewer = false,
            attach_mappings = function(buf, map)
                actions.select_default:replace(load_session_action)
                map("i", "<c-d>", delete_session_action)
                return true
            end,
        }, themes.get_dropdown())
        :find()
end

return M
