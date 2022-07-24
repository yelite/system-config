local nvim_lsp = require "lspconfig"
local lsp_status = require "lsp-status"
local lspsaga = require "lspsaga"
local aerial = require "aerial"
local rust_tools = require "rust-tools"
local clangd_extensions = require "clangd_extensions"
local keymap = require "my-config.keymap"

vim.g.coq_settings = {
    auto_start = "shut-up",
    xdg = true,
    ["keymap.recommended"] = false,
    ["keymap.pre_select"] = false,
    ["display.pum.fast_close"] = false,
    ["display.ghost_text.enabled"] = false,
    clients = {
        ["third_party.enabled"] = false,
        ["tmux.enabled"] = false,
        ["snippets.enabled"] = false,
        ["tags.enabled"] = false,
    },
}
local coq = require "coq"

local function lsp_on_attach(client, bufnr)
    keymap.bind_lsp_keys(client, bufnr)
    lsp_status.on_attach(client)
    aerial.on_attach(client, bufnr)
end

local standard_lsp_config = coq.lsp_ensure_capabilities {
    on_attach = lsp_on_attach,
    capabilities = lsp_status.capabilities,
}

lspsaga.init_lsp_saga {
    use_saga_diagnostic_sign = false,
    code_action_prompt = {
        enable = false,
    },
}

rust_tools.setup {
    tools = {
        hover_actions = {
            auto_focus = false,
        },
    },
    server = standard_lsp_config,
}

clangd_extensions.setup {
    server = {
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
    },
}

nvim_lsp.pylsp.setup(standard_lsp_config)
nvim_lsp.cmake.setup(standard_lsp_config)
nvim_lsp.rnix.setup(standard_lsp_config)

-- TODO move this into project-specific settings because
-- lua-dev should only be used with init.lua development
local luadev = require("lua-dev").setup {
    lspconfig = {
        cmd = { "lua-language-server" },
        on_attach = lsp_on_attach,
        capabilities = lsp_status.capabilities,
    },
}
nvim_lsp.sumneko_lua.setup(luadev)

-- C indent
vim.o.cinoptions = "h1,l1,g1,t0,i4,+4,(0,w1,W4"

-- auto format
vim.cmd [[
augroup MyNeoformat
  autocmd!
  autocmd BufWritePre *.lua silent! undojoin | Neoformat
  autocmd BufWritePre *.nix silent! undojoin | Neoformat
augroup END
]]
