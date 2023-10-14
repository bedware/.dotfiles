-- fugitive
vim.keymap.set("n", "<leader>git", vim.cmd.Git);

local function fugitive_mapping(event)
    -- Close window
    vim.keymap.set("n", "q", ":quit<CR>", { buffer = event.buf, silent = true, nowait = true })
end

local bedware_group = vim.api.nvim_create_augroup('bedware_group', { clear = false })
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'fugitive',
    group = bedware_group,
    desc = 'Key bindings for fugitive',
    callback = fugitive_mapping
})
