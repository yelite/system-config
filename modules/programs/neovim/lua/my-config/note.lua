require("zk").setup({
    picker = "telescope",
    lsp = {
        config = {
            cmd = { "zk", "lsp" },
            name = "zk",
            on_attach = function(client, bufnr)
                require("my-config.languages").standard_lsp_on_attach(client, bufnr)
            end,
        },
        auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
        },
    },
})
