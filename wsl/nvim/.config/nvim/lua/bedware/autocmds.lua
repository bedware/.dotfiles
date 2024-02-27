vim.api.nvim_create_user_command('W', ':w', {})

local group = vim.api.nvim_create_augroup('bedware_software_group', { clear = false })
vim.api.nvim_create_autocmd('TextYankPost', {
    group = group,
    desc = 'Highlight on yank',
    callback = function(_)
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 950 })
    end
})

for _, pattern in ipairs({'help', 'qf', 'dapui_console', 'dap-float'}) do
    vim.api.nvim_create_autocmd('FileType', {
        group = group,
        desc = 'Quit key binding for ' .. pattern,
        pattern = pattern,
        callback = function(e)
            vim.keymap.set("n", "q", ":quit<CR>", { buffer = e.buf, silent = true, nowait = true })
        end
    })
end
