local nvim_lsp = require("lspconfig")
local lsp_status = require("lsp-status")
local lspsaga = require("lspsaga")
local aerial = require("aerial")
local rust_tools = require("rust-tools")
local clangd_extensions = require("clangd_extensions")
local keymap = require("my-config.keymap")

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

vim.g.coq_settings = {
    auto_start = "shut-up",
    xdg = true,
    keymap = {
        recommended = false,
        pre_select = false,
        jump_to_mark = "<C-h>",
    },
    ["display.pum.fast_close"] = false,
    ["display.ghost_text.enabled"] = false,
    clients = {
        lsp = {
            weight_adjust = 2,
            resolve_timeout = 0.12,
        },
        buffers = {
            weight_adjust = -0.5,
        },
        ["third_party.enabled"] = false,
        ["tmux.enabled"] = false,
        ["snippets.enabled"] = false,
        ["tags.enabled"] = false,
    },
}
local coq = require("coq")

local function lsp_on_attach(client, bufnr)
    keymap.bind_lsp_keys(client, bufnr)
    lsp_status.on_attach(client)
    require("lsp_basics").make_lsp_commands(client, bufnr)
end

local standard_lsp_config = coq.lsp_ensure_capabilities({
    on_attach = lsp_on_attach,
    capabilities = lsp_status.capabilities,
})

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
    server = coq.lsp_ensure_capabilities({
        cmd = {
            "clangd",
            "--background-index",
            "--all-scopes-completion",
            "--inlay-hints",
            "--clang-tidy",
            "--header-insertion=iwyu",
        },
        on_attach = lsp_on_attach,
        capabilities = lsp_status.capabilities,
    }),
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
    on_attach = lsp_on_attach,
    capabilities = lsp_status.capabilities,
})

nvim_lsp.cmake.setup(standard_lsp_config)
nvim_lsp.rnix.setup(standard_lsp_config)

-- TODO move this into project-specific settings because
-- lua-dev should only be used with init.lua development
require("neodev").setup({})
nvim_lsp.lua_ls.setup({
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            completion = {
                enable = true,
                -- TODO: Fix this. It seems it doesn't work well with coq-nvim
                -- callSnippet = "Both",
                callSnippet = "Disable",
                keywordSnippet = "Both",
            },
            format = {
                enable = false, -- Use stylua
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
                maxPreload = 50000,
            },
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = lsp_on_attach,
    capabilities = lsp_status.capabilities,
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
