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
        'tpope/vim-surround',
        requires = { { 'tpope/vim-repeat' } }
    })
    use('vim-scripts/argtextobj.vim')
    use('theprimeagen/harpoon')
    use({
        'justinmk/vim-sneak',
        requires = { { 'tpope/vim-repeat' } }
    })
    use('mbbill/undotree')
    use({
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } }
    })
    use({
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    })
    use({
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    })
    -------------- Testing
    use({
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim"
        }
    })
    use('andy-bell101/neotest-java')
    -------------- Git
    use('tpope/vim-fugitive')
    use('lewis6991/gitsigns.nvim')
    -------------- Other
    use('folke/zen-mode.nvim')
    use('eandrju/cellular-automaton.nvim')
    use('stevearc/vim-arduino')
    -------------- AI
    -- use("github/copilot.vim")
    use({
        "jackMort/ChatGPT.nvim",
        config = function()
            require("chatgpt").setup({})
        end,
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    })
    -------------- LSP
    use({
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Manage LSP servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    })
end)
