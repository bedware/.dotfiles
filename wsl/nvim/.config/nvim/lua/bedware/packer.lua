vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -------------- Visual
    use({ 'rose-pine/neovim', as = 'rose-pine' })
    vim.cmd('colorscheme rose-pine')
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/nvim-treesitter-context')
    use('machakann/vim-highlightedyank')
    -------------- Coding
    use({'tpope/vim-surround',
        requires = { { 'tpope/vim-repeat' } }
    })
    use('vim-scripts/argtextobj.vim')
    use('theprimeagen/harpoon')
    use({'justinmk/vim-sneak',
        requires = { { 'tpope/vim-repeat' } }
    })
    use('mbbill/undotree')
    use({ 'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } }
    })
    use { 'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    -------------- Git
    use('tpope/vim-fugitive')
    -------------- Other
    use('folke/zen-mode.nvim')
    use('eandrju/cellular-automaton.nvim')
    use('stevearc/vim-arduino')
    -------------- AI 
    -- use("github/copilot.vim")
    use({ "jackMort/ChatGPT.nvim",
        config = function()
            require("chatgpt").setup()
        end,
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    })
    -------------- Language support (things I don't understand yet)
    use({
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    })
end)
