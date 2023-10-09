vim.g.mapleader = " "

-- Format
vim.keymap.set("n", "==", vim.lsp.buf.format)
-- Replace word in all buffer
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Make current file executable
vim.keymap.set("n", "<leader>x", ":!chmod +x %<CR>")
-- Source curent file
vim.keymap.set("n", "<leader>s", ":source %<CR>")
-- Registers
vim.keymap.set({ "n", "x" }, "<leader>p", [["*p]])
vim.keymap.set({ "n", "x" }, "<leader>y", [["*y]])
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
vim.keymap.set("n", [["c]], [[:let @*=@"<CR>:echo "In clipboard now"<CR>]])
-- Put space not leaving normal mode
vim.keymap.set("n", "<leader>[", "i <Esc>")
vim.keymap.set("n", "<leader>]", "a <Esc>")

-- Quickfix
vim.keymap.set("n", "<A-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<A-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<A-Up>", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<A-Down>", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>cq", ":ccl<CR>")
-- Command mode by arrows
vim.keymap.set("c", "<Up>", "<C-p>")
vim.keymap.set("c", "<Down>", "<C-n>")
-- Enter
vim.keymap.set("n", "<Enter>", "o<Esc>")
vim.keymap.set("n", "<S-Enter>", "O<Esc>")
-- Line text object
vim.keymap.set("x", "il", "g_o0")
vim.keymap.set("o", "il", ":normal vil<CR>")
vim.keymap.set("x", "al", "$o0")
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
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- Tmux
vim.keymap.set("n", "<C-f>", ":silent !tmux new-window ~/.dotfiles/tmux-sessionizer<CR>")

