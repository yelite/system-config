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
    mappings = {}
})

return M
