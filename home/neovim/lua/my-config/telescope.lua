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
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = ts_actions.close,
                ["<c-t>"] = trouble.open_with_trouble,
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
}
require("telescope").load_extension "fzf"
require("telescope").load_extension "neoclip"
