local nvim_lsp = require("lspconfig")
local lsp_util = require("lspconfig.util")
local lspsaga = require("lspsaga")
local dap = require("dap")
local dapui = require("dapui")
local lsp_signature = require("lsp_signature")
local keymap = require("my-config.keymap")
local util = require("my-config.util")

local M = {}

function M.standard_lsp_on_attach(client, bufnr)
    keymap.bind_lsp_keys(client, bufnr)
end

M.standard_lsp_capabilities = require("blink.cmp").get_lsp_capabilities({}, true)

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
    code_action = {
        show_server_name = true,
        max_height = 0.4,
        keys = {
            quit = { "q", "<Esc>" },
            exec = "<CR>",
        },
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
    require("avante_lib").load()
    require("avante").setup({
        -- mode = "legacy",
        provider = "copilot",
        providers = {
            copilot = {
                -- model = "gpt-4o-2024-08-06",
                model = "gemini-2.5-pro",
                timeout = 30000,
                disable_tools = false,
                extra_request_body = {
                    temperature = 0,
                },
            },
        },
        auto_suggestions_provider = nil,
        memory_summary_provider = "copilot",
        windows = {
            width = 36,
            sidebar_header = {
                rounded = false,
            },
            edit = {
                border = "rounded",
            },
            ask = {},
        },
        behaviour = {
            auto_set_keymaps = false,
        },
        disabled_tools = { "web_search", "rag_search" },
        hints = { enabled = false },
        mappings = {
            files = {
                add_current = "<leader>Ac",
            },
            submit = {
                insert = "<CR>",
            },
        },
    })
end

vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {},
    -- LSP configuration
    server = {
        on_attach = M.standard_lsp_on_attach,
        capabilities = vim.tbl_deep_extend(
            "force",
            M.standard_lsp_capabilities,
            require("rustaceanvim.config.server").create_client_capabilities()
        ),
    },
    -- DAP configuration
    dap = {},
}

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
    on_attach = M.standard_lsp_on_attach,
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
    -- Need this to make lspsaga show_line_diagnostics work
    -- https://github.com/nvimdev/lspsaga.nvim/issues/1520
    severity_sort = true,
})

require("lazydev").setup({
    integrations = {
        -- TODO: turn this back on once the formatter issue is fixed
        lspconfig = false,
        cmp = false,
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

if vim.loop.os_uname().sysname ~= "Darwin" then
    nvim_lsp.serve_d.setup({
        on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            M.standard_lsp_on_attach(client, bufnr)
        end,
        capabilities = M.standard_lsp_capabilities,
    })
end

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

    root_dir = function(fname)
        -- Check if the buffer has a name and corresponds to a readable file
        if fname == "" or vim.fn.filereadable(fname) == 0 then
            -- If no valid file path, return nil to prevent Marksman from starting
            return nil
        end
        local root_files = { ".marksman.toml" }
        return lsp_util.root_pattern(unpack(root_files))(fname)
            or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
    end,
})

vim.g.disable_autoformat = false
require("conform").setup({
    undojoin = true,
    formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        go = { "golines" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        html = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
    },
    format_after_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { undojoin = true, lsp_format = "fallback" }
    end,
    formatters = {
        golines = {
            inherit = true,
            prepend_args = { "--max-len=100", "--base-formatter=gofumpt" },
        },
    },
})
vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

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
