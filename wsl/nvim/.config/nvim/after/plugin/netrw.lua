-- Netrw
vim.keymap.set('n', '<leader>E', '<cmd>Lexplore %:p:h<cr>')
vim.keymap.set("n", "<leader>e", vim.cmd.Lexplore)

local function netrw_mapping()
  local bufmap = function(lhs, rhs)
    local opts = {buffer = true, remap = true}
    vim.keymap.set('n', lhs, rhs, opts)
  end
  -- Close window
  bufmap('<leader>e', ':Lexplore<cr>')
  bufmap('<leader>E', ':Lexplore<cr>')
  -- Toggle dotfiles
  bufmap('.', 'gh')
end

local augroup = vim.api.nvim_create_augroup('bedware_autocmds_netrw', {clear = true})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  group = augroup,
  desc = 'Keybindings for netrw',
  callback = netrw_mapping
})

