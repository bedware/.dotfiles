vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})
vim.api.nvim_create_user_command('W', ':w', {})

local bedware_group = vim.api.nvim_create_augroup('bedware_group', { clear = false })
vim.api.nvim_create_autocmd('TextYankPost', {
    group = bedware_group,
    desc = 'Highlight on yank',
    callback = function(_)
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 950 })
    end
})
vim.api.nvim_create_autocmd('FileType', {
    group = bedware_group,
    desc = 'Key bindings for help',
    pattern = 'help',
    callback = function(event)
        vim.keymap.set("n", "q", ":quit<CR>", { buffer = event.buf, silent = true, nowait = true })
    end
})

