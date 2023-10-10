vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})

local bedware_group = vim.api.nvim_create_augroup('bedware_group', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    group = bedware_group,
    desc = 'Highlight on yank',
    callback = function(_)
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 950 })
    end
})

-- function nvim_create_augroups(definitions)
--     for group_name, definition in pairs(definitions) do
--         vim.api.nvim_command('bedware_group '..group_name)
--         vim.api.nvim_command('autocmd!')
--         for _, def in ipairs(definition) do
--             local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
--             vim.api.nvim_command(command)
--         end
--         vim.api.nvim_command('bedware_group END')
--     end
-- end
--
-- local autoCommands = {
--     open_folds = {
--         {"BufReadPost,FileReadPost", "*", "normal zR"}
--     }
-- }
-- nvim_create_augroups(autoCommands)
