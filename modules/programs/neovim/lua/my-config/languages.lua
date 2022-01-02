local nvim_lsp = require "lspconfig"
local lsp_status = require "lsp-status"
local lspsaga = require "lspsaga"
local rust_tools = require "rust-tools"
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
    -- TODO: Enable after it respects global enabled flag and current word highlight
    -- require("illuminate").on_attach(client)
end

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
    server = coq.lsp_ensure_capabilities {
        on_attach = lsp_on_attach,
        capabilities = lsp_status.capabilities,
    },
}

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

-- auto format
-- TODO: add a small delay and skip format if it's in insert mode, and add undojoin
-- only if necessary. This should fix the problem with auto-save.
vim.cmd [[
augroup MyNeoformat
  autocmd!
  autocmd BufWritePre *.lua undojoin | Neoformat
  autocmd BufWritePre *.nix undojoin | Neoformat
augroup END
]]
