local M = {}

require("obsidian").setup({
    workspaces = {
        {
            name = "notes",
            path = "~/notes",
        },
    },
    daily_notes = {
        folder = "journal",
        date_format = "%Y-%m-%d",
        alias_format = "%Y-%m-%d",
    },
    ui = {
        checkboxes = {
            [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
            ["."] = { char = "", hl_group = "ObsidianTodo" },
            ["o"] = { char = "", hl_group = "ObsidianTodo" },
            ["O"] = { char = "", hl_group = "ObsidianTodo" },
            ["x"] = { char = "", hl_group = "ObsidianDone" },
            [">"] = { char = "", hl_group = "ObsidianRightArrow" },
            ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
            ["!"] = { char = "", hl_group = "ObsidianImportant" },
        },
    },
    legacy_commands = false,
})

return M
