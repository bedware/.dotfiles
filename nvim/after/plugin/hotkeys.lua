-- fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git);

-- undootree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- makeitrain
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

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

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n", "<leader><leader>", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)

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

