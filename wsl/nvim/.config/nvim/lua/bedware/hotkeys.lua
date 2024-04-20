vim.g.mapleader = " "

-- Replace word in all buffer
vim.keymap.set("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Make current file executable
vim.keymap.set("n", "<leader>x", ":!chmod +x %<CR>")
-- Source curent file
vim.keymap.set("n", "<leader>s", ":source %<CR>")
-- Show highliting settings
vim.keymap.set("n", "<leader>ch", ":hi<CR>")
-- Copy reference
vim.keymap.set("n", "<leader>cr", [[:let @+ = expand('%') . ':' . line('.')<CR>:echo "Reference was copied"<CR>]])
-- Quickfix & Location lists
vim.keymap.set("n", "<leader>q", ":copen<CR>", { silent = true })
vim.keymap.set("n", "<leader>l", ":lopen<CR>", { silent = true })
vim.keymap.set("n", "<A-k>", ":cprev<CR>", { silent = true })
vim.keymap.set("n", "<A-j>", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "<A-S-k>", ":lprev<CR>", { silent = true })
vim.keymap.set("n", "<A-S-j>", ":lnext<CR>", { silent = true })
-- Registers
vim.keymap.set({ "n", "x" }, "<leader>p", [["+p]])
vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]])
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
vim.keymap.set("n", [["c]], [[:let @+=@"<CR>:echo "Saved to clipboard now"<CR>]])
-- Put space not leaving normal mode
vim.keymap.set("n", "[<space>", "i <Esc>")
vim.keymap.set("n", "<space>]", "a <Esc>")
vim.keymap.set("n", "[<space>", "i <Esc>")
vim.keymap.set("n", "<space>]", "a <Esc>")
-- Command mode by arrows
vim.keymap.set("c", "<Up>", "<C-p>")
vim.keymap.set("c", "<Down>", "<C-n>")
-- Line text object
vim.keymap.set("x", "il", "g_o_")
vim.keymap.set("o", "il", ":normal vil<CR>")
vim.keymap.set("x", "al", "$o0")
-- Arguments
vim.keymap.set("x", "iA", "i(") -- this works for viA
vim.keymap.set("o", "iA", ":normal viA<CR>") -- this works for ciA
-- Buffer text object
vim.keymap.set("x", "i%", "GoggV")
vim.keymap.set("o", "i%", ":normal vi%<CR>")
-- Moving lines around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- Moving around with centralized view
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- Fold method
vim.keymap.set("n", "zi", function()
    if vim.opt.foldmethod:get() ~= 'marker' then
        vim.cmd(":set foldmethod=marker")
    else
        require('bedware.utils').feedkeys('zi', 'n')
    end
end, { silent = true })
-- For nvim-qt
vim.keymap.set("c", "<S-Insert>", "<C-R>+")
