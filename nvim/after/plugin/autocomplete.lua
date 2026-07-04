local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    sources = cmp.config.sources({            -- Check packer.lua
        { name = 'nvim_lsp' },                -- hrsh7th/cmp-nvim-lsp
        { name = 'nvim_lsp_signature_help' }, -- hrsh7th/cmp-nvim-lsp-signature-help
        { name = 'nvim_lua' },                -- hrsh7th/cmp-nvim-lua
        { name = 'luasnip' },                 -- saadparwaiz1/cmp_luasnip
        { name = 'path' },                    -- hrsh7th/cmp-path
        { name = 'buffer' },                  -- hrsh7th/cmp-buffer
    }),
    -- Autoselect 1st item
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    mapping = cmp.mapping.preset.insert({
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        -- Navigate between snippet placeholder
        ["<C-n>"] = cmp.mapping(function(_)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            end
        end, {'i', 's'}),
        ["<C-p>"] = cmp.mapping(function(_)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, {'i', 's'}),
        -- Scroll up and down in the completion documentation
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    formatting = {
        fields = { 'kind', 'abbr', 'menu', },
        format = function(entry, item)
            -- Make 2nd column like method_name(parms) and 3rd like return_type
            -- local inout = entry.completion_item.labelDetails
            if entry.completion_item.filterText ~= nil and item.kind == "Method" then
                item.abbr = entry.completion_item.filterText
                item.menu = nil
                -- item.abbr = string.gsub(item.abbr, "~", inout.detail)
                -- item.abbr = entry.resolved_completion_item.detail
                -- item.menu = inout.description
            end
            local function cut(target, above)
                if item[target] ~= nil and string.len(item[target]) > above then
                    item[target] = string.sub(item[target], 1, above) .. "!"
                end
            end
            -- Cut length
            -- cut("abbr", 30)
            -- cut("menu", 15)
            return item
        end
    },
    window = {
        completion = {
            col_offset = -7,
        }
    },
})
