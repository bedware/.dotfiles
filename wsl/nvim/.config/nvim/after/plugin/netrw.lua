-- Netrw

-- Variables {{{1
vim.g.netrw_preview = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 35
vim.g.netrw_localrmdir = 'rm -r'

-- Hotkeys
vim.keymap.set("n", "<A-u>", ":Ex<CR>", { silent = true })

-- Auto commands {{{1
local group = vim.api.nvim_create_augroup('bedware_software_group', { clear = false })
vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'netrw',
    desc = 'Apply Total key binding',
    callback = function(e)
        if e.buf ~= nil then
            vim.cmd('highlight netrwMarkFile guifg=#191724 guibg=#eb6f92')
            -- Up
            vim.keymap.set('n', '<A-u>', function() vim.cmd('normal -') end, { buffer = e.buf, silent = true })
        end
    end
})
