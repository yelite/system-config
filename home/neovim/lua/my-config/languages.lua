local lsp_util = require("lspconfig.util")
local lspsaga = require("lspsaga")
local dap = require("dap")
local dapui = require("dapui")
local lsp_signature = require("lsp_signature")
local keymap = require("my-config.keymap")

local M = {}

function M.standard_lsp_on_attach(client, bufnr) end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client == nil then
            return
        end
        keymap.bind_lsp_keys(client.name, ev.buf)
    end,
})

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

vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {},
    -- LSP configuration
    server = {},
    -- DAP configuration
    dap = {},
}

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--all-scopes-completion",
        "--inlay-hints",
        "--clang-tidy",
        "--header-insertion=iwyu",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})
vim.lsp.enable("clangd")
vim.lsp.enable("basedpyright")
vim.lsp.enable("ruff")
vim.lsp.enable("cmake")
vim.lsp.config("nil_ls", {
    settings = {
        ["nil"] = {
            formatting = {
                command = { "alejandra" },
            },
        },
    },
})
vim.lsp.enable("nil_ls")

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
        capabilities = {
            workspace = {
                didChangeWatchedFiles = {
                    -- Fix for https://github.com/neovim/neovim/issues/28058
                    -- From https://github.com/fredrikaverpil/dotfiles/blob/219cde0111c613154121a8b2c34956bda859ff9c/nvim-fredrik/lua/plugins/lsp.lua#L88-L96
                    relativePatternSupport = false,
                },
            },
        },
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

vim.lsp.config("lua_ls", {
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
})
vim.lsp.enable("lua_ls")

if vim.loop.os_uname().sysname ~= "Darwin" then
    vim.lsp.config("serve_d", {
        on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end,
    })
    vim.lsp.enable("serve_d")
end

vim.lsp.enable("buf_ls")
vim.lsp.enable("taplo")
vim.lsp.config("jsonls", {
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
})
vim.lsp.enable("jsonls")

vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            schemaStore = {
                enable = false,
            },
            schemas = require("schemastore").yaml.schemas(),
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
    end,
})
vim.lsp.enable("yamlls")

vim.lsp.config("astro", {
    on_attach = function(client, bufnr)
        -- use biome
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
})
vim.lsp.enable("astro")
vim.lsp.enable("tailwindcss")
vim.lsp.config("vtsls", {
    on_attach = function(client, bufnr)
        -- use biome
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
        vtsls = {
            autoUseWorkspaceTsdk = true,
            enableMoveToFileCodeAction = true,
        },
        typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
            },
        },
        javascript = {
            updateImportsOnFileMove = "always",
        },
    },
})
vim.lsp.enable("vtsls")

local function make_vtsls_action_handler(title)
    return function(err, locations, ctx, config)
        if err then
            error(err)
        end

        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client == nil then
            vim.notify("No lsp client found", vim.log.levels.INFO)
            return
        end

        -- Handle empty results
        if not locations or vim.tbl_isempty(locations) then
            vim.notify("No locations found for " .. title, vim.log.levels.INFO)
            return
        end

        -- If there is only one result, jump to it directly (standard behavior)
        if #locations == 1 then
            vim.lsp.util.show_document(locations[1], client.offset_encoding, { reuse_win = true, focus = true })
            return
        end

        local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local make_entry = require("telescope.make_entry")

        pickers
            .new({}, {
                prompt_title = title,
                finder = finders.new_table({
                    results = items,
                    entry_maker = make_entry.gen_from_quickfix({}),
                }),
                previewer = conf.qflist_previewer({}),
                sorter = conf.generic_sorter({}),
            })
            :find()
    end
end

require("vtsls").config({
    handlers = {
        source_definition = make_vtsls_action_handler("Source Definitions"),
        file_references = make_vtsls_action_handler("File References"),
    },
})

vim.lsp.enable("html")
vim.lsp.config("cssls", {
    settings = {
        css = {
            lint = {
                unknownAtRules = "ignore",
            },
        },
    },
})
vim.lsp.enable("cssls")
vim.lsp.config("marksman", {
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
vim.lsp.enable("marksman")
vim.lsp.enable("biome")

require("nvim-highlight-colors").setup({
    render = "virtual",
    virtual_symbol_suffix = "",
    virtual_symbol_position = "eol",
    exclude_buffer = function(bufnr)
        local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
        return vim.bo[bufnr].filetype ~= "css" or file_size > 1000000
    end,
})
require("nvim-highlight-colors").turnOff()

vim.g.disable_autoformat = false
require("conform").setup({
    undojoin = true,
    formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        go = { "golines" },
        c = { "clang-format" },
        cpp = { "clang-format" },
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
require("dap-python").setup("debugpy-adapter")

vim.api.nvim_create_augroup("MyLangCustomization", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "markdown",
        "json",
        "jsonc",
        "yaml",
        "cpp",
        "c",
        "nix",
        "astro",
        "css",
        "graphql",
        "javascript",
        "javascriptreact",
        "svelte",
        "typescript",
        "typescript.tsx",
        "typescriptreact",
        "vue",
    },
    group = "MyLangCustomization",
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json", "jsonc", "markdown" },
    group = "MyLangCustomization",
    callback = function()
        vim.opt_local.conceallevel = 0
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
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = {
        "*/.cargo/registry/src/*",
        "*/.cargo/git/checkouts/*",
        "*/.venv/*",
        "*/node_modules/*",
    },
    group = "MyLangCustomization",
    callback = function()
        vim.bo.readonly = true
        vim.bo.modifiable = false
    end,
})

return M
