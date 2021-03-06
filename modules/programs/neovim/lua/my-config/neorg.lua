require("neorg").setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {
            config = {
                folds = {
                    enable = false,
                },
            },
        },
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    main = "~/neorg",
                },
            },
        },
        ["core.gtd.base"] = {},
        ["core.integrations.telescope"] = {},
        ["myconfig.foldtext"] = {},
    },
    hook = function()
        local neorg_leader = "<Leader>n"

        local neorg_callbacks = require "neorg.callbacks"

        neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
            -- Map all the below keybinds only when the "norg" mode is active
            keybinds.map_event_to_mode("norg", {
                n = {
                    -- Keys for managing TODO items and setting their states
                    { "gtd", "core.norg.qol.todo_items.todo.task_done" },
                    { "gtu", "core.norg.qol.todo_items.todo.task_undone" },
                    { "gtp", "core.norg.qol.todo_items.todo.task_pending" },
                    { "gth", "core.norg.qol.todo_items.todo.task_on_hold" },
                    { "gtc", "core.norg.qol.todo_items.todo.task_cancelled" },
                    { "gtr", "core.norg.qol.todo_items.todo.task_recurring" },
                    { "gti", "core.norg.qol.todo_items.todo.task_important" },
                    { "<C-Space>", "core.norg.qol.todo_items.todo.task_cycle" },

                    -- Keys for managing GTD
                    { neorg_leader .. "tc", "core.gtd.base.capture" },
                    { neorg_leader .. "tv", "core.gtd.base.views" },
                    { neorg_leader .. "te", "core.gtd.base.edit" },

                    -- Keys for managing notes
                    { neorg_leader .. "n", "core.norg.dirman.new.note" },
                    -- TODO: This is currently broken. Fix it or update and verify
                    { neorg_leader .. "f", "core.integrations.telescope.search_headings" },

                    -- Link
                    { neorg_leader .. "l", "core.integrations.telescope.find_linkable" },

                    { "<CR>", "core.norg.esupports.hop.hop-link" },
                    { "<M-CR>", "core.norg.esupports.hop.hop-link", "vsplit" },
                    { "<C-k>", "core.norg.manoeuvre.item_up" },
                    { "<C-j>", "core.norg.manoeuvre.item_down" },
                },
                o = {
                    { "ah", "core.norg.manoeuvre.textobject.around-heading" },
                    { "ih", "core.norg.manoeuvre.textobject.inner-heading" },
                    { "at", "core.norg.manoeuvre.textobject.around-tag" },
                    { "it", "core.norg.manoeuvre.textobject.inner-tag" },
                    { "al", "core.norg.manoeuvre.textobject.around-whole-list" },
                },
                i = { -- Bind in insert mode
                    { "<C-l>", "core.integrations.telescope.insert_link" },
                },
            }, { silent = true, noremap = true })

            -- Map the below keys only when traverse-heading mode is active
            keybinds.map_event_to_mode("traverse-heading", {
                n = {
                    { "j", "core.integrations.treesitter.next.heading" },
                    { "k", "core.integrations.treesitter.previous.heading" },
                },
            }, {
                silent = true,
                noremap = true,
            })

            -- Map the below keys on gtd displays
            keybinds.map_event_to_mode("gtd-displays", {
                n = {
                    { "<CR>", "core.gtd.ui.goto_task" },

                    { "q", "core.gtd.ui.close" },
                    { "<Esc>", "core.gtd.ui.close" },

                    { "e", "core.gtd.ui.edit_task" },
                    { "<Tab>", "core.gtd.ui.details" },
                },
            }, {
                silent = true,
                noremap = true,
                nowait = true,
            })

            -- Map the below keys on presenter mode
            keybinds.map_event_to_mode("presenter", {
                n = {
                    { "<CR>", "core.presenter.next_page" },
                    { "l", "core.presenter.next_page" },
                    { "h", "core.presenter.previous_page" },

                    { "q", "core.presenter.close" },
                    { "<Esc>", "core.presenter.close" },
                },
            }, {
                silent = true,
                noremap = true,
                nowait = true,
            })

            -- Apply the below keys to all modes
            keybinds.map_to_mode("all", {
                n = {
                    { neorg_leader .. "m", ":Neorg mode norg<CR>" },
                    { neorg_leader .. "h", "<cmd>Trouble neorg<cr>" },
                },
                i = {
                    -- TODO: This is a quick hack for smart enter. Replace this with a real one
                    { "<C-CR>", "<C-o>o- [ ] " },
                },
            }, {
                silent = true,
                noremap = true,
            })
        end)
    end,
}
