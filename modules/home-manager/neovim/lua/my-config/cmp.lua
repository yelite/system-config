local cmp = require("cmp")
local cmp_types = require("cmp.types")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
local luasnip_types = require("luasnip.util.types")

luasnip.config.set_config({
    ext_opts = {
        -- hl_group has to be set explicitly otherwise default hl will be cleared due to we load
        -- color scheme in the end of the config.
        -- https://sourcegraph.com/github.com/L3MON4D3/LuaSnip@bc8ec05022743d3f08bda7a76c6bb5e9a9024581/-/blob/lua/luasnip/config.lua?L196
        [luasnip_types.insertNode] = {
            unvisited = {
                hl_group = "LuasnipInsertNodeUnvisited",
                virt_text = { { "  Snippet Edit Region", "LuasnipInsertNode" } },
            },
        },
        [luasnip_types.choiceNode] = {
            unvisited = { hl_group = "LuasnipChoiceNodeUnvisited" },
        },
    },
    updateevents = "TextChanged,TextChangedI",
    region_check_events = "InsertEnter,CursorHold",
    delete_check_events = "TextChanged,InsertLeave",
})

require("luasnip.loaders.from_vscode").load({ paths = { vim.g._friendly_snippets_path } })

local get_visible_buffers = function()
    local bufs = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        bufs[vim.api.nvim_win_get_buf(win)] = true
    end
    return vim.tbl_keys(bufs)
end

local buffer_source = {
    name = "buffer",
    keyword_length = 2,
    option = {
        get_bufnrs = get_visible_buffers,
    },
}

local regular_mapping = cmp.mapping.preset.insert({
    -- TODO: reverse C-n/C-p when menu is reversed due to near_cursor
    ["<C-n>"] = {
        i = cmp.mapping.select_next_item({ behavior = cmp_types.cmp.SelectBehavior.Select }),
    },
    ["<C-p>"] = {
        i = cmp.mapping.select_prev_item({ behavior = cmp_types.cmp.SelectBehavior.Select }),
    },
    ["<C-d>"] = {
        i = cmp.mapping.scroll_docs(-4),
    },
    ["<C-u>"] = {
        i = cmp.mapping.scroll_docs(4),
    },
    ["<C-f>"] = cmp.mapping(function(fallback)
        -- Confirm if this is the end of line, otherwise abort completion and fallback
        local _, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()
        if string.sub(line, col + 1) == "" and cmp.confirm({ select = true }) then
            return
        end
        cmp.abort()
        fallback()
    end, { "i" }),
    ["<C-Space>"] = { i = cmp.mapping.complete() },
    ["<C-e>"] = { i = cmp.mapping.abort() },
    ["<CR>"] = { i = cmp.mapping.confirm({ select = false }) },
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.confirm({ select = true }) then
            return
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
})

-- pumheight also limits the height of cmp custom menu
vim.o.pumheight = 8
cmp.setup({
    enabled = function()
        local disabled = false
        local context = require("cmp.config.context")
        disabled = disabled or (vim.api.nvim_buf_get_option(0, "buftype") == "prompt")
        disabled = disabled or (vim.fn.reg_recording() ~= "")
        disabled = disabled or (vim.fn.reg_executing() ~= "")
        disabled = disabled or (context.in_treesitter_capture("comment"))
        disabled = disabled or (context.in_syntax_group("Comment"))
        return not disabled
    end,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    view = {
        entries = { name = "custom", selection_order = "top_down" },
    },
    window = {
        documentation = cmp.config.window.bordered(),
    },
    mapping = regular_mapping,
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip", max_item_count = 5 },
        buffer_source,
        { name = "path", keyword_length = 2 },
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 60,
            ellipsis_char = "...",
            menu = {
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
            },
            before = function(entry, vim_item)
                return vim_item
            end,
        }),
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    experimental = {
        ghost_text = {
            hl_group = "CmpGhostText",
        },
    },
})

cmp.setup.filetype("markdown", {
    completion = {
        autocomplete = {},
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        {
            name = "buffer",
            keyword_length = 4,
            option = {
                get_bufnrs = get_visible_buffers,
            },
        },
    }),
})

local cmdline_mapping = cmp.mapping.preset.cmdline({
    ["<C-n>"] = {
        c = cmp.mapping.select_prev_item({ behavior = cmp_types.cmp.SelectBehavior.Select }),
    },
    ["<C-p>"] = {
        c = cmp.mapping.select_next_item({ behavior = cmp_types.cmp.SelectBehavior.Select }),
    },
    ["<CR>"] = { c = cmp.mapping.confirm({ select = false }) },
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.confirm({ select = true }) then
            return
        else
            fallback()
        end
    end, { "c" }),
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmdline_mapping,
    formatting = {
        fields = { "abbr" },
    },
    view = {
        entries = { name = "custom", selection_order = "near_cursor" },
    },
    sources = {
        buffer_source,
    },
})

cmp.setup.cmdline(":", {
    mapping = cmdline_mapping,
    formatting = {
        fields = { "abbr" },
    },
    view = {
        entries = { name = "custom", selection_order = "near_cursor" },
    },
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})
