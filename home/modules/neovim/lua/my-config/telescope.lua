local bufdelete = require "bufdelete"
local action_state = require "telescope.actions.state"
local trouble = require "trouble.providers.telescope"

local function delete_buffer(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    current_picker:delete_selection(function(selection)
        bufdelete.bufdelete(selection.bufnr, false)
    end)
end

local ts_actions = require "telescope.actions"

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
                ["<C-t>"] = trouble.open_with_trouble,
                ["<C-h>"] = "which_key",
                ["<C-/>"] = "which_key",
            },
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
    },
    extensions = {
        file_browser = {
            mappings = {
                i = {
                    ["<C-f>"] = { "<Right>", type = "command" },
                    ["<C-h>"] = "which_key",
                    ["<C-CR>"] = "select_horizontal",
                    ["<C-x>"] = fb_action "move_file",
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
