local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local set_current_at = function(id)
    print("Set current: " .. id)
    mark.set_current_at(id)
end
vim.keymap.set("n", "<A-a>", function()
    local relative_path = vim.fn.expand('%')
    mark.add_file(relative_path)
    print("Added:" .. relative_path)
end)
vim.keymap.set("n", "<A-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)
vim.keymap.set("n", "<C-F5>", function() ui.nav_file(5) end)
vim.keymap.set("n", "<C-F6>", function() ui.nav_file(6) end)

vim.keymap.set("n", "<leader><C-h>", function() set_current_at(1) end)
vim.keymap.set("n", "<leader><C-j>", function() set_current_at(2) end)
vim.keymap.set("n", "<leader><C-k>", function() set_current_at(3) end)
vim.keymap.set("n", "<leader><C-l>", function() set_current_at(4) end)
vim.keymap.set("n", "<leader><C-F5>", function() set_current_at(5) end)
vim.keymap.set("n", "<leader><C-F6>", function() set_current_at(6) end)

