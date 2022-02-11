local bufdelete = require "bufdelete"
local action_state = require "telescope.actions.state"
local trouble = require "trouble.providers.telescope"
local ts_themes = require "telescope.themes"
local ts_actions = require "telescope.actions"
local ts_layout_actions = require "telescope.actions.layout"

local M = {}

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
                    ["<C-h>"] = "which_key",
                    ["<C-CR>"] = "select_horizontal",
                    ["<C-d>"] = fb_action "remove",
                    ["<C-e>"] = fb_action "create",
                    ["<C-r>"] = fb_action "rename",
                    ["<C-y>"] = fb_action "copy",
                    ["<C-x>"] = fb_action "move",
                    ["<C-v>"] = fb_action "toggle_browser",
                    ["<C-t>"] = fb_action "toggle_hidden",
                },
            },
        },
    },
}
require("telescope").load_extension "fzf"
require("telescope").load_extension "neoclip"
require("telescope").load_extension "file_browser"
require("telescope").load_extension "live_grep_raw"

return M
