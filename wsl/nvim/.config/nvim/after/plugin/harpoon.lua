local width = vim.api.nvim_win_get_width(0) - 85
if width < 80 then
    width = 80
end
require("harpoon").setup({
    menu = {
        width = width
    }
})
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local set_current_at = function(id)
    print("Set current: " .. id)
    mark.set_current_at(id)
end

-- Add
vim.keymap.set("n", "<A-a>", function()
    local relative_path = vim.fn.expand('%')
    mark.add_file(relative_path)
    print("Added:" .. relative_path)
end)
-- List
vim.keymap.set("n", "<A-e>", ui.toggle_quick_menu)
-- Move to
vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)
-- Set to
vim.keymap.set("n", "<leader><C-h>", function() set_current_at(1) end)
vim.keymap.set("n", "<leader><C-j>", function() set_current_at(2) end)
vim.keymap.set("n", "<leader><C-k>", function() set_current_at(3) end)
vim.keymap.set("n", "<leader><C-l>", function() set_current_at(4) end)
-- Same thing but using marks (to be the most accurate)
vim.keymap.set("n", "<A-C-h>", function() require('bedware.utils').feedkeys('`Hzz', 'n') end)
vim.keymap.set("n", "<A-C-j>", function() require('bedware.utils').feedkeys('`Jzz', 'n') end)
vim.keymap.set("n", "<A-C-k>", function() require('bedware.utils').feedkeys('`Kzz', 'n') end)
vim.keymap.set("n", "<A-C-l>", function() require('bedware.utils').feedkeys('`Lzz', 'n') end)
-- I'm in doubt
-- vim.keymap.set("n", "<C-F5>", function() ui.nav_file(5) end)
-- vim.keymap.set("n", "<C-F6>", function() ui.nav_file(6) end)
-- vim.keymap.set("n", "<leader><C-F5>", function() set_current_at(5) end)
-- vim.keymap.set("n", "<leader><C-F6>", function() set_current_at(6) end)
-- vim.keymap.set("n", "<A-C-F5>", function() require('bedware.utils').feedkeys('`H', 'n') end)
-- vim.keymap.set("n", "<A-C-F6>", function() require('bedware.utils').feedkeys('`H', 'n') end)

