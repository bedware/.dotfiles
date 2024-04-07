-- Settings
vim.lsp.set_log_level('debug')

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
    -- enable type checking for nvim-dap-ui to get type checking,
    -- documentation and autocompletion for all API functions.
    library = { plugins = { "nvim-dap-ui" }, types = true },
})
local lsp_zero = require('lsp-zero')
local lspconfig = require('lspconfig')

-- Global key binding
vim.keymap.set("n", "<leader>ci", ":LspInfo<CR>")
vim.keymap.set("n", "<leader>cl", ":LspLog<CR>")
vim.keymap.set("n", "<leader>cc", ":Inspect<CR>")
vim.keymap.set("n", "<leader>ch", ":hi<CR>")
-- LSP key binding
lsp_zero.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-p>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>re', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set({ 'n', 'v', 'i' }, '<A-Enter>', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
    end, opts)
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { "lua_ls" },
    handlers = {
        lsp_zero.default_setup,
        jdtls = lsp_zero.noop, -- let plugin do the work (check jdtls.lua)
        lua_ls = function()
            local tweaks = {
                settings = {
                    Lua = {
                        diagnostics = {
                            disable = { "missing-fields" }
                        },
                        workspace = {
                            -- https://luals.github.io/wiki/settings/#runtimepath 
                            library = {
                                vim.fn.expand '~/.local/share/nvim/site/pack/packer/start/plenary.nvim/lua',
                                vim.fn.expand '~/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim/lua',
                                vim.fn.expand '~/.local/share/nvim/site/pack/packer/start/harpoon/lua',
                                vim.fn.expand '~/.local/share/nvim/site/pack/packer/start/telescope.nvim/lua',
                                vim.fn.expand '~/.local/share/nvim/site/pack/packer/start/nvim-jdtls/lua',
                                vim.fn.expand '~/.local/share/nvim/site/pack/packer/start/telescope-dap.nvim/lua/'
                            },
                            -- library = vim.api.nvim_get_runtime_file('', true),
                        },
                    },
                }
            }
            local lua_opts = lsp_zero.nvim_lua_ls(tweaks)
            lspconfig.lua_ls.setup(lua_opts)
        end,
        julials = function()
            lspconfig.julials.setup {
                symbol_cache_download = false,
            }
        end,
    },
})
