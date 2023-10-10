-- Global mappings.
vim.keymap.set("n", "<leader>cl", ":LspInfo<CR>")

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({})
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    -- superseded by trouble vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
    end, opts)
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { "lua_ls", "jdtls" },
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    },
})

local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
    formatting = {
        fields = { 'kind', 'abbr', 'menu', },
        format = function(entry, item)
            -- Make 2nd column like method_name(parms) and 3rd like return_type
            local inout = entry.completion_item.labelDetails
            if item.kind == "Method" then
                item.abbr = string.gsub(item.abbr, "~", inout.detail)
                item.menu = inout.description
            end
            local function cut(target, above)
                if item[target] ~= nil and string.len(item[target]) > above then
                    item[target] = string.sub(item[target], 1, above) .. "!"
                end
            end
            -- Cut length
            cut("abbr", 30)
            cut("menu", 15)
            return item
        end,
    },
    window = {
        completion = {
            col_offset = -7,
        }
    },
    mapping = cmp.mapping.preset.insert({
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        -- Navigate between snippet placeholder
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        -- Scroll up and down in the completion documentation
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
    }),
    -- Autoselect 1st item
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
})
