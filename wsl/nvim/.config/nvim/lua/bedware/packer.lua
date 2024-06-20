vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use('wbthomason/packer.nvim')
    -------------- Visual
    use('rose-pine/neovim')
    use('folke/tokyonight.nvim')
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/nvim-treesitter-context')
    -------------- Coding
    use({
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    })
    use('nvim-telescope/telescope-ui-select.nvim')
    use('nvim-telescope/telescope-dap.nvim')
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
    use({
        'tpope/vim-surround',
        requires = { { 'tpope/vim-repeat' } }
    })
    use('vim-scripts/argtextobj.vim')
    use('theprimeagen/harpoon')
    use({
        'justinmk/vim-sneak',
        requires = { { 'tpope/vim-repeat' } }
    })
    use({
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    })
    use({
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup() end
    })
    use('mbbill/undotree')
    -- Arduino
    use('stevearc/vim-arduino')
    -------------- LSP
    use({
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            --- Manage LSP servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- ac itself
                { 'hrsh7th/cmp-nvim-lsp' },     -- nvim-lsp source
            -- everything below is optional
                { 'hrsh7th/cmp-nvim-lsp-signature-help' },
                { 'hrsh7th/cmp-nvim-lua' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-path' },
            { 'L3MON4D3/LuaSnip' },     -- snippet engine
                { 'saadparwaiz1/cmp_luasnip' }, -- luasnip source
        }
    })
    -- SQL
    use('nanotee/sqls.nvim')
    -- Neovim
    use('folke/neodev.nvim')
    -- Java
    use('mfussenegger/nvim-jdtls')
    -------------- Debugging
    use('mfussenegger/nvim-dap')
    use({
        'rcarriga/nvim-dap-ui',
        requires = {
            'nvim-neotest/nvim-nio'
        }
    })
    -------------- Git
    use('tpope/vim-fugitive')
    use('lewis6991/gitsigns.nvim')
    -------------- AI
    -- use('github/copilot.vim')
    use({
        'jackMort/ChatGPT.nvim',
        requires = {
            'MunifTanjim/nui.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim'
        }
    })
    -------------- Other
    use('folke/zen-mode.nvim')
    use('eandrju/cellular-automaton.nvim')
end)
