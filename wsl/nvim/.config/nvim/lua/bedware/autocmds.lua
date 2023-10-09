vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})

local augroup = vim.api.nvim_create_augroup('bedware_autocmds', {clear = true})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  desc = 'Highlight on yank',
  callback = function(event)
    vim.highlight.on_yank({higroup = 'Visual', timeout = 950})
  end
})

-- function nvim_create_augroups(definitions)
--     for group_name, definition in pairs(definitions) do
--         vim.api.nvim_command('augroup '..group_name)
--         vim.api.nvim_command('autocmd!')
--         for _, def in ipairs(definition) do
--             local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
--             vim.api.nvim_command(command)
--         end
--         vim.api.nvim_command('augroup END')
--     end
-- end
--
-- local autoCommands = {
--     open_folds = {
--         {"BufReadPost,FileReadPost", "*", "normal zR"}
--     }
-- }
-- nvim_create_augroups(autoCommands)

