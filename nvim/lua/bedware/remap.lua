vim.g.mapleader = " "

-- Navigation
vim.keymap.set("n", "<Tab>", vim.cmd.Ex)
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Command mode by arrows
vim.keymap.set("c", "<Up>", "<C-p>")
vim.keymap.set("c", "<Down>", "<C-n>")

-- Put space not leaving Comand mode
vim.keymap.set("n", "<leader>[", "i <Esc>")
vim.keymap.set("n", "<leader>]", "a <Esc>")

-- Moving lines around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Moving around with centralized view
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Buffers
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Others
vim.keymap.set("n", "<C-f>", ":silent !tmux new-window ~/.dotfiles/tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", ":!chmod +x %<CR>")

-- vim.keymap.set({"n", "i", "c", "x", "s", "o", "t", "l"}, "<C-BS>", "<C-w>")
-- vim.keymap.set({"n", "i", "c", "x", "s", "o", "t", "l"}, "<C-h>", "<C-w>")

