-- Indentation {{{
-- length of an actual \t character:
vim.opt.tabstop = 4
-- length to use when shifting text (eg. <<, >> and == commands)
-- (0 for ‘tabstop’):
vim.opt.shiftwidth = 0
-- length to use when editing text (eg. TAB and BS keys)
-- (0 for ‘tabstop’, -1 for ‘shiftwidth’):
vim.opt.softtabstop = -1
-- round indentation to multiples of 'shiftwidth' when shifting text
-- (so that it behaves like Ctrl-D / Ctrl-T):
vim.opt.shiftround = true
-- reproduce the indentation of the previous line:
vim.opt.autoindent = true
-- try to be smart (increase the indenting level after ‘{’,
-- decrease it after ‘}’, and so on):
vim.opt.smartindent = true
-- if set, only insert spaces; otherwise insert \t and complete with spaces:
vim.opt.expandtab = true -- use :retab to change indentings in current file
-- Other {{{1
vim.opt.fixeol = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.tmp/.nvim/undodir"
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
-- vim.opt.mouse = ''
-- vim.opt.shell = '/bin/pwsh'
vim.opt.shellcmdflag = '-NoProfile -c'
-- vim.opt.shell = '/bin/bash'

