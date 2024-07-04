local bufdelete = require("bufdelete")
local action_state = require("telescope.actions.state")
local action_generate = require("telescope.actions.generate")
local trouble = require("trouble.sources.telescope")
local ts_themes = require("telescope.themes")
local ts_actions = require("telescope.actions")
local ts_layout_actions = require("telescope.actions.layout")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")
local lga_actions = require("telescope-live-grep-args.actions")
local fb_actions = require("telescope._extensions.file_browser.actions")

local my_util = require("my-config.util")
local my_settings = require("my-config.settings")

local M = {}

M.git_changed_files = my_util.make_async_func(function()
    -- Based on https://github.com/nvim-telescope/telescope.nvim/issues/758#issuecomment-844868644
    local base_branch = my_settings.get_or_prompt_setting("git_base_branch", "")
    local cmd = {
        "bash",
        my_util.my_script_path("git-branch-changed-files.sh"),
        base_branch,
    }
    local opts = {
        entry_maker = make_entry.gen_from_file(),
    }

    pickers
        .new(require("telescope.themes").get_dropdown({}), {
            prompt_title = string.format("Modified Files (base: %s)", base_branch),
            finder = finders.new_oneshot_job(cmd, opts),
            sorter = sorters.get_fuzzy_file(),
        })
        :find()
end)

function M.quick_find_files()
    require("telescope").extensions.smart_open.smart_open(ts_themes.get_dropdown({
        cwd_only = true,
        previewer = false,
    }))
end

local function delete_buffer(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    current_picker:delete_selection(function(selection)
        bufdelete.bufdelete(selection.bufnr, false)
    end)
end

local toggle_fb_hidden = function(prompt_bufnr)
    fb_actions.toggle_hidden(prompt_bufnr)
    fb_actions.toggle_respect_gitignore(prompt_bufnr)
end

require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = ts_actions.close,
                ["<C-s>"] = ts_layout_actions.toggle_preview,
                ["<C-t>"] = trouble.open,
                ["<C-f>"] = { "<Right>", type = "command" },
                ["<C-h>"] = "which_key",
                ["<C-/>"] = "which_key",
                -- TODO: smart open in opposite window
                ["<C-Enter>"] = function() end,
                ["<S-BS>"] = function()
                    vim.cmd(":norm! dd")
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
        cache_picker = {
            num_pickers = 16,
            limit_entries = 500,
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
        live_grep_args = {
            auto_quoting = true,
            mappings = {
                i = {
                    ["<C-k>"] = lga_actions.quote_prompt(),
                    ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                    ["<C-space>"] = ts_actions.to_fuzzy_refine,
                },
            },
        },
        file_browser = {
            display_stat = { size = true },
            hijack_netrw = true,
            hide_parent_dir = true,
            mappings = {
                i = {
                    ["<C-f>"] = { "<Right>", type = "command" },
                    ["<C-e>"] = { "<End>", type = "command" },
                    ["<C-h>"] = action_generate.which_key({
                        keybind_width = 12,
                        max_height = 0.5,
                    }),
                    ["<S-CR>"] = fb_actions.create_from_prompt,
                    ["<C-g>"] = fb_actions.goto_parent_dir,
                    ["<C-w>"] = false,
                    ["<C-w><Esc>"] = false,
                    ["<C-w><C-d>"] = fb_actions.remove,
                    ["<C-w><C-n>"] = fb_actions.create,
                    ["<C-w><C-r>"] = fb_actions.rename,
                    ["<C-w><C-p>"] = fb_actions.copy,
                    ["<C-w><C-m>"] = fb_actions.move,
                    ["<C-w><C-f>"] = fb_actions.toggle_browser,
                    ["<C-w><C-t>"] = toggle_fb_hidden,
                    ["<C-w><C-w>"] = fb_actions.goto_cwd,
                    ["<C-w><C-a>"] = fb_actions.toggle_all,
                    ["<C-w><C-s>d"] = fb_actions.sort_by_size,
                    ["<C-w><C-s>s"] = fb_actions.sort_by_date,
                },
            },
        },
    },
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("neoclip")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("telescope-alternate")
require("telescope").load_extension("smart_open")

return M
