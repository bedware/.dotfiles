local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
-- vim.keymap.set("n", "<A-a>", mark.add_file)
vim.keymap.set("n", "<A-a>", function()
    local path = vim.fn.expand('%:p')
    local pwd = vim.fn.getcwd()
    pwd = vim.fn.substitute(pwd, '\\', '/', 'g') .. "/"
    path = vim.fn.substitute(path, '\\', '/', 'g')
    path = vim.fn.substitute(path, pwd, '', 'g')
    mark.add_file(path)
    print("Added:" .. path)
end)
vim.keymap.set("n", "<A-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)
