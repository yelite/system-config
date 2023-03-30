local nvim_lsp = require("lspconfig")
local lsp_status = require("lsp-status")
local lspsaga = require("lspsaga")
local rust_tools = require("rust-tools")
local clangd_extensions = require("clangd_extensions")
local keymap = require("my-config.keymap")

local M = {}

-- Override lsp floating preview border globally
local border = {
    { "🭽", "FloatBorder" },
    { "▔", "FloatBorder" },
    { "🭾", "FloatBorder" },
    { "▕", "FloatBorder" },
    { "🭿", "FloatBorder" },
    { "▁", "FloatBorder" },
    { "🭼", "FloatBorder" },
    { "▏", "FloatBorder" },
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

function M.standard_lsp_on_attach(client, bufnr)
    keymap.bind_lsp_keys(client, bufnr)
    lsp_status.on_attach(client)
    require("lsp_basics").make_lsp_commands(client, bufnr)
end

M.standard_lsp_capabilities =
    vim.tbl_deep_extend("force", {}, lsp_status.capabilities, require("cmp_nvim_lsp").default_capabilities())

local standard_lsp_config = {
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
}

lspsaga.setup({
    max_preview_lines = 20,
    rename = {
        quit = "<Esc>",
    },
    lightbulb = {
        enable = false,
    },
})

rust_tools.setup({
    tools = {
        hover_actions = {
            auto_focus = false,
        },
    },
    server = standard_lsp_config,
})

clangd_extensions.setup({
    server = {
        cmd = {
            "clangd",
            "--background-index",
            "--all-scopes-completion",
            "--inlay-hints",
            "--clang-tidy",
            "--header-insertion=iwyu",
        },
        on_attach = M.standard_lsp_on_attach,
        capabilities = M.standard_lsp_capabilities,
    },
})

nvim_lsp.jedi_language_server.setup({
    settings = {
        jedi = {
            workspace = {
                symbols = {
                    maxSymbols = 100,
                },
            },
        },
    },
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
})

nvim_lsp.cmake.setup(standard_lsp_config)
nvim_lsp.rnix.setup(standard_lsp_config)

-- todo move this into project-specific settings because
-- lua-dev should only be used with init.lua development
require("neodev").setup({
    override = function(root_dir, library)
        if vim.endswith(root_dir, ".system-config") then
            library.enabled = true
            library.plugins = true
        end
    end,
})
nvim_lsp.lua_ls.setup({
    settings = {
        Lua = {
            completion = {
                enable = true,
                callSnippet = "Replace",
                keywordSnippet = "Replace",
            },
            format = {
                enable = false, -- use stylua
            },
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
})

require("null-ls").setup({
    diagnostics_format = "#{m} (#{c} #{s})",
    sources = {
        require("null-ls").builtins.formatting.isort,
        require("null-ls").builtins.formatting.black,
        require("null-ls").builtins.formatting.clang_format,
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.diagnostics.pylint.with({
            -- TODO: read project config
            extra_args = {
                "--disable",
                "typecheck",
                "--disable",
                "protected-access",
            },
        }),
        -- TODO: install pyproject-flake8
        -- require("null-ls").builtins.diagnostics.pyproject_flake8,
    },
})

-- C indent
vim.o.cinoptions = "h1,l1,g1,t0,i4,+4,(0,w1,W4"

return M
