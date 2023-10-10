-- Netrw
vim.keymap.set('n', '<leader>E', '<cmd>Lexplore %:p:h<cr>')
vim.keymap.set("n", "<leader>e", vim.cmd.Lexplore)

local function netrw_mapping(event)
    local opts = { buffer = true, remap = true }
    -- Close window
    vim.keymap.set('n', '<leader>e', ':Lexplore<cr>', opts)
    vim.keymap.set('n', '.', 'gh', opts)
    -- Toggle dotfiles
    vim.keymap.set("n", "q", ":quit<CR>", { buffer = event.buf, silent = true, nowait = true })
end

local bedware_group = vim.api.nvim_create_augroup('bedware_group', { clear = false })
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'netrw',
    group = bedware_group,
    desc = 'Keybindings for netrw',
    callback = netrw_mapping
})
