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
    lsp_status.on_attach(client, bufnr)
    require("illuminate").on_attach(client)
end

lspsaga.init_lsp_saga {
    use_saga_diagnostic_sign = false,
    code_action_prompt = {
        sign = false,
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

-- auto format
vim.cmd [[
augroup MyNeoformat
  autocmd!
  autocmd BufWritePre *.lua undojoin | Neoformat
  autocmd BufWritePre *.nix undojoin | Neoformat
augroup END
]]
