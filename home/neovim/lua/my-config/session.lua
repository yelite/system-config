local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local themes = require("telescope.themes")

local possession = require("possession")
local possession_session = require("possession.session")
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

local auto_session_disabled_dirs = {
    "/etc",
}

local function should_enable_auto_session()
    if vim.fn.argc(-1) > 0 then
        return false
    end

    local cwd = vim.fn.getcwd()
    for _, disabled_dir in ipairs(auto_session_disabled_dirs) do
        if vim.startswith(cwd, disabled_dir) then
            return false
        end
    end
    return true
end

possession.setup({
    autosave = {
        current = true,
        cwd = should_enable_auto_session,
        on_load = true,
        on_quit = true,
    },
    autoload = function()
        if should_enable_auto_session() then
            return "auto_cwd"
        else
            return false
        end
    end,
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
            preserve_layout = false,
            match = {
                floating = true,
                buftype = {},
                filetype = {},
                custom = false, -- or fun(win): boolean
            },
        },
        delete_hidden_buffers = {
            hooks = {
                "before_load",
                vim.o.sessionoptions:match("buffer") and "before_save",
            },
            force = function(bufnr)
                local bt = vim.bo[bufnr].buftype
                return bt == "nofile" or bt == "nowrite" or bt == "terminal"
            end,
        },
        symbols_outline = true,
    },
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
