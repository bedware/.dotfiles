require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        -- ["<C-h>"] = function() vim.cmd ":norm! db" end
        ["<C-h>"] = "which_key"
      }
    }
  }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

