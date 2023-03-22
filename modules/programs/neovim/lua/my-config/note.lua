local zk = require("zk")
local async = require("plenary.async")

local my_util = require("my-config.util")

local M = {}

local prompt_text = async.wrap(function(prompt, text, callback)
    vim.ui.input({
        prompt = prompt,
        default = "",
        kind = "note_prompt",
    }, callback)
end, 3)

local function bind_zk_keys(client, bufnr)
    local make_opts = function(desc)
        return { buffer = bufnr, silent = true, desc = desc }
    end

    vim.keymap.set("n", "<leader>nb", "<Cmd>ZkBacklinks<CR>", make_opts("Show Backlinks"))
    vim.keymap.set("n", "<leader>nl", "<Cmd>ZkLinks<CR>", make_opts("Show Links"))
end

zk.setup({
    picker = "telescope",
    lsp = {
        config = {
            cmd = { "zk", "lsp" },
            name = "zk",
            on_attach = function(client, bufnr)
                require("my-config.languages").standard_lsp_on_attach(client, bufnr)
                bind_zk_keys(client, bufnr)
            end,
        },
        auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
        },
    },
})

M.new_note = my_util.make_async_func(function()
    local title = prompt_text("Title:")
    zk.new({ title = title })
end)

return M
