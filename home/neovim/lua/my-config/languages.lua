local nvim_lsp = require("lspconfig")
local lspsaga = require("lspsaga")
local dap = require("dap")
local dapui = require("dapui")
local lsp_signature = require("lsp_signature")
local rust_tools = require("rust-tools")
local keymap = require("my-config.keymap")
local util = require("my-config.util")

local M = {}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

function M.standard_lsp_on_attach(client, bufnr)
    keymap.bind_lsp_keys(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_buf_create_user_command(bufnr, "LspFormatting", function()
            util.auto_lsp_formatting(bufnr)
        end, {})
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            command = "undojoin | LspFormatting",
        })
    end
end

M.standard_lsp_capabilities = vim.tbl_deep_extend("force", {}, require("cmp_nvim_lsp").default_capabilities())

local standard_lsp_config = {
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
}

lsp_signature.setup({
    bind = true,
    doc_lines = 10,
    max_height = 12, -- max height of signature floating_window
    max_width = 80, -- max_width of signature floating_window
    noice = false, -- set to true if you using noice to render markdown

    floating_window_above_cur_line = true,

    close_timeout = 4000, -- close floating window after ms when laster parameter is entered
    fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
    hint_enable = false, -- virtual hint enable
    hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
    handler_opts = {
        border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
    },

    toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
    select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
    move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor betw
})

lspsaga.setup({
    symbol_in_winbar = {
        enable = false,
    },
    rename = {
        keys = {
            quit = "<Esc>",
        },
    },
    lightbulb = {
        enable = false,
    },
    beacon = {
        enable = false,
    },
})

require("fidget").setup({})

require("lsp-endhints").setup({
    icons = {
        type = "󰠱 ",
        parameter = "󰊕 ",
        offspec = "=> ", -- hint kind not defined in official LSP spec
        unknown = "", -- hint kind is nil
    },
    label = {
        padding = 1,
        marginLeft = 0,
        bracketedParameters = true,
    },
    autoEnableHints = true,
})

if util.is_copilot_installed() then
    require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = true },
        filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            toggleterm = false,
            TelescopePrompt = false,
            ["."] = false,
        },
    })
    require("copilot_cmp").setup()
    require("avante_lib").load()
    require("avante").setup({
        provider = "copilot",
        copilot = {
            -- model = "gpt-4o-2024-08-06",
            model = "claude-3.5-sonnet",
            timeout = 30000,
            temperature = 0,
            max_tokens = 4096,
        },
        windows = {
            width = 36,
        },
        behaviour = {
            auto_set_keymaps = false,
        },
        mappings = {
            submit = {
                insert = "<CR>",
            },
        },
    })
end

rust_tools.setup({
    tools = {
        hover_actions = {
            auto_focus = false,
        },
    },
    server = standard_lsp_config,
})

nvim_lsp.clangd.setup({
    cmd = {
        "clangd",
        "--background-index",
        "--all-scopes-completion",
        "--inlay-hints",
        "--clang-tidy",
        "--header-insertion=iwyu",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    on_attach = function(client, bufnr)
        M.standard_lsp_on_attach(client, bufnr)
        require("clangd_extensions.inlay_hints").setup_autocmd()
        require("clangd_extensions.inlay_hints").set_inlay_hints()
    end,

    capabilities = M.standard_lsp_capabilities,
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
nvim_lsp.nil_ls.setup(vim.tbl_deep_extend("force", standard_lsp_config, {
    settings = {
        ["nil"] = {
            formatting = {
                command = { "alejandra" },
            },
        },
    },
}))

require("go").setup({
    lsp_keymaps = false,
    lsp_codelens = true,
    lsp_gofumpt = true,
    disgnostic = {
        hdlr = false,
    },
    trouble = true,
    luasnip = true,
    lsp_cfg = {
        on_attach = M.standard_lsp_on_attach,
        capabilities = vim.tbl_deep_extend("force", M.standard_lsp_capabilities, {
            workspace = {
                didChangeWatchedFiles = {
                    -- Fix for https://github.com/neovim/neovim/issues/28058
                    -- From https://github.com/fredrikaverpil/dotfiles/blob/219cde0111c613154121a8b2c34956bda859ff9c/nvim-fredrik/lua/plugins/lsp.lua#L88-L96
                    relativePatternSupport = false,
                },
            },
        }),
        settings = {
            gopls = {
                usePlaceholders = true,
                gofumpt = true,
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
            },
        },
    },
    lsp_inlay_hints = {
        enable = false,
    },
    dap_debug_keymap = true,
})

vim.diagnostic.config({
    signs = false,
})

require("lazydev").setup({
    integrations = {
        lspconfig = true,
        cmp = true,
    },
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

nvim_lsp.buf_ls.setup({
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
})

nvim_lsp.taplo.setup({
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
})

nvim_lsp.jsonls.setup({
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
})

nvim_lsp.yamlls.setup({
    on_attach = function(client, bufnr)
        M.standard_lsp_on_attach(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
    end,
    capabilities = M.standard_lsp_capabilities,
    settings = {
        yaml = {
            schemaStore = {
                enable = false,
            },
            schemas = require("schemastore").yaml.schemas(),
        },
    },
})

nvim_lsp.astro.setup({
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
})
nvim_lsp.tailwindcss.setup({
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
})
nvim_lsp.vtsls.setup({
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
})
nvim_lsp.html.setup({
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
})
nvim_lsp.cssls.setup({
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
    settings = {
        css = {
            lint = {
                unknownAtRules = "ignore",
            },
        },
    },
})
nvim_lsp.marksman.setup({
    on_attach = M.standard_lsp_on_attach,
    capabilities = M.standard_lsp_capabilities,
})

require("null-ls").setup({
    diagnostics_format = "#{m} (#{c} #{s})",
    sources = {
        require("null-ls").builtins.formatting.isort,
        require("null-ls").builtins.formatting.black,
        require("null-ls").builtins.formatting.buf,
        require("null-ls").builtins.formatting.clang_format.with({
            filetypes = { "c", "cpp", "cs", "java", "cuda" },
        }),
        require("null-ls").builtins.formatting.golines.with({
            extra_args = {
                "--max-len=100",
                "--base-formatter=gofumpt",
            },
        }),
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
        require("null-ls").builtins.formatting.prettier.with({
            filetypes = { "html", "json", "markdown" },
        }),
    },
    on_attach = M.standard_lsp_on_attach,
})

dapui.setup()
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

vim.api.nvim_create_augroup("MyLangCustomization", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "json", "yaml", "cpp", "c", "nix" },
    group = "MyLangCustomization",
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "nix" },
    group = "MyLangCustomization",
    callback = function()
        require("my-config.nix-indent")
        vim.bo.indentexpr = "GetNixIndent()"
    end,
})

return M
