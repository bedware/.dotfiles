-- require("tokyonight").setup{ transparent = vim.g.transparent_enabled }
-- require('rose-pine').setup({ disable_background = true })
-- vim.cmd('colorscheme tokyonight-storm')
-- vim.cmd('colorscheme tokyonight-day')
-- vim.cmd('colorscheme tokyonight-moon')
-- vim.cmd('colorscheme tokyonight-night')
-- vim.cmd('colorscheme tokyonight')
-- function ColorMyPencils(color) 
-- 	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- 	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--
-- end
--
-- ColorMyPencils()

vim.cmd('colorscheme rose-pine')
vim.cmd('highlight Directory guifg=#9ccfd8')
vim.cmd('highlight TelescopeNormal guifg=#6e6a86 guibg=#1f1d2e')
vim.cmd('highlight TelescopeTitle cterm=bold gui=bold guifg=#6e6a86')
vim.cmd('highlight TelescopeBorder cterm=bold gui=bold guifg=#4e4a66')

