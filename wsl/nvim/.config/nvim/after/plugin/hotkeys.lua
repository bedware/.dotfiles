-- fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git);

-- undootree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- makeitrain
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

-- harpoon
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
    -- local filename = vim.fn.expand('%:t')
    -- vim.api.nvim_command("echoerr '" .. filename .. "'")
vim.keymap.set("n", "<A-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>ps', function()
-- 	builtin.grep_string({ search = vim.fn.input("Grep > ") });
-- end)

-- arduino
vim.keymap.set("n", "<leader>ai", "<cmd>ArduinoInfo<CR>")
vim.keymap.set("n", "<leader>aa", "<cmd>ArduinoAttach<CR>")
vim.keymap.set("n", "<leader>av", "<cmd>ArduinoVerify<CR>")
vim.keymap.set("n", "<leader>au", "<cmd>ArduinoUpload<CR>")
vim.keymap.set("n", "<leader>aus", "<cmd>ArduinoUploadAndSerial<CR>")
vim.keymap.set("n", "<leader>acp", "<cmd>ArduinoChoosePort<CR>")
vim.keymap.set("n", "<leader>as", "<cmd>ArduinoSerial<CR>")
vim.keymap.set("n", "<leader>ab", "<cmd>ArduinoChooseBoard<CR>")
vim.keymap.set("n", "<leader>ap", "<cmd>ArduinoChooseProgrammer<CR>")

-- zenmode
vim.keymap.set("n", "<leader>zz", function()
    require("zen-mode").setup {
        window = {
            width = 90,
            options = { }
        },
    }
    require("zen-mode").toggle()
    vim.wo.wrap = false
    vim.wo.number = true
    vim.wo.rnu = true
end)

