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

lsp_status.config {
    diagnostics = false,
    current_function = false,
}

local function lsp_on_attach(client, bufnr)
    keymap.bind_general_lsp_keys(bufnr)
    lsp_status.on_attach(client, bufnr)
end

nvim_lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities {
    on_attach = lsp_on_attach,
    capabilities = lsp_status.capabilities,
})

lspsaga.setup()
rust_tools.setup()

-- auto format
vim.cmd [[
augroup MyNeoformat
  autocmd!
  autocmd BufWritePre *.lua undojoin | Neoformat
  autocmd BufWritePre *.nix undojoin | Neoformat
augroup END
]]
