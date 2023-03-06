local bufdelete = require "bufdelete"
local action_state = require "telescope.actions.state"
local action_generate = require "telescope.actions.generate"
local trouble = require "trouble.providers.telescope"
local ts_themes = require "telescope.themes"
local ts_actions = require "telescope.actions"
local ts_layout_actions = require "telescope.actions.layout"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local sorters = require "telescope.sorters"
local finders = require "telescope.finders"

local util = require "my-config.util"
local my_git = require "my-config.git"

local M = {}

function M.git_changed_files()
    -- Based on https://github.com/nvim-telescope/telescope.nvim/issues/758#issuecomment-844868644
    local base_branch = my_git.get_or_ask_base_branch()
    local cmd = {
        "bash",
        util.my_script_path "git-branch-changed-files.sh",
        base_branch
    }
    local opts = {
        entry_maker = make_entry.gen_from_file(),
    }

    pickers
        .new(require("telescope.themes").get_dropdown {}, {
            prompt_title = string.format("Modified Files (base: %s)", base_branch),
            finder = finders.new_oneshot_job(cmd, opts),
            sorter = sorters.get_fuzzy_file(),
        })
        :find()
end

function M.quick_find_files()
    require("telescope.builtin").find_files(ts_themes.get_dropdown { previewer = false })
end

local function delete_buffer(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    current_picker:delete_selection(function(selection)
        bufdelete.bufdelete(selection.bufnr, false)
    end)
end

-- TODO: remove this once nvim-telescope/telescope.nvim#1473 is merged
-- Snippet copied from https://github.com/nvim-telescope/telescope-file-browser.nvim/pull/6
local function fb_action(f)
    return function(b)
        require("telescope").extensions.file_browser.actions[f](b)
    end
end

require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                    ["<esc>"] = ts_actions.close,
                    ["<C-s>"] = ts_layout_actions.toggle_preview,
                    ["<C-t>"] = trouble.open_with_trouble,
                    ["<C-h>"] = "which_key",
                    ["<C-/>"] = "which_key",
                -- TODO: smart open in opposite window
                    ["<C-Enter>"] = function()
                end,
            },
        },
        prompt_prefix = "  ",
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                height = 0.55,
                width = 0.75,
                preview_width = 0.618,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
    },
    pickers = {
        buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            theme = "dropdown",
            previewer = false,
            mappings = {
                i = {
                        ["<c-d>"] = delete_buffer,
                },
            },
        },
        lsp_workspace_symbols = {
            layout_strategy = "vertical",
        },
        lsp_document_symbols = {
            layout_strategy = "vertical",
        },
        commands = {
            theme = "ivy",
        },
        command_history = {
            theme = "ivy",
        },
    },
    extensions = {
        file_browser = {
            mappings = {
                i = {
                        ["<C-f>"] = { "<Right>", type = "command" },
                        ["<C-e>"] = { "<End>", type = "command" },
                        ["<C-h>"] = action_generate.which_key {
                        keybind_width = 12,
                        max_height = 0.5,
                    },
                        ["<S-CR>"] = fb_action "create_from_prompt",
                        ["<C-g>"] = fb_action "goto_parent_dir",
                        ["<C-w>"] = false,
                        ["<C-w><Esc>"] = false,
                        ["<C-w><C-d>"] = fb_action "remove",
                        ["<C-w><C-n>"] = fb_action "create",
                        ["<C-w><C-r>"] = fb_action "rename",
                        ["<C-w><C-p>"] = fb_action "copy",
                        ["<C-w><C-m>"] = fb_action "move",
                        ["<C-w><C-f>"] = fb_action "toggle_browser",
                        ["<C-w><C-t>"] = fb_action "toggle_hidden",
                        ["<C-w><C-w>"] = fb_action "goto_cwd",
                        ["<C-w><C-s>d"] = fb_action "sort_by_size",
                        ["<C-w><C-s>s"] = fb_action "sort_by_date",
                },
            },
        },
    },
}
require("telescope").load_extension "fzf"
require("telescope").load_extension "neoclip"
require("telescope").load_extension "file_browser"
require("telescope").load_extension "live_grep_args"
require("telescope").load_extension "termfinder"
require("telescope").load_extension "telescope-alternate"

return M
