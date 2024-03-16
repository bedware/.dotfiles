-- :h dap-configuration
require("dapui").setup({
    layouts = { {
        elements = {},
        position = "left",
        size = 40
      }, {
        elements = { {
            id = "console",
            size = 1.0
        } },
        position = "bottom",
        size = 10
      } },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t"
    }
})

-- local function open_like_I_said()
--     require("dapui").open()
--     require("dapui").close({ layout = 1 })
-- end

require('dap').listeners.after.event_initialized["dapui_config"] = function() require("dapui").open() end
-- require('dap').listeners.before.event_terminated["dapui_config"] = function() require("dapui").close() end
-- require('dap').listeners.before.event_exited["dapui_config"] = function() require("dapui").close() end

-- SHOW {{{1
vim.keymap.set('n', '<leader>,', function()
    local windows = require("dapui.windows")
    for i = 1, #windows.layouts, 1 do
        if windows.layouts[i]:is_open() then
            require("dapui").close()
            return
        end
    end
    require("dapui").open()
end, {})

vim.keymap.set('n', ',r', function()
    require('telescope').extensions.dap.configurations({})
end, {})
-- vim.keymap.set('n', ',lc', function() require 'telescope'.extensions.dap.configurations {} end, {})
vim.keymap.set('n', ',lb', function() require 'telescope'.extensions.dap.list_breakpoints {} end, {})

vim.keymap.set('n', ',ff', function() -- scope
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)

vim.keymap.set('n', ',fs', function() -- stack
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end)

-- vim.keymap.set('n', ',t', function() require'telescope'.extensions.dap.commands{} end, {})
-- vim.keymap.set('n', ',lf', function() require'telescope'.extensions.dap.frames{} end, {})
-- vim.keymap.set('n', ',r', function() require('dap').repl.toggle() end)
-- vim.keymap.set('n', ',B',
--     function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)

-- vim.keymap.set({ 'n', 'v' }, ',K', function()
--     require('dap.ui.widgets').hover()
-- end)

-- DO {{{1
vim.keymap.set('n', ',c', function() require('dap').continue() end, {})
vim.keymap.set('n', ',,', function() require('dap').step_over() end, {})
vim.keymap.set('n', ',i', function() require('dap').step_into() end, {})
vim.keymap.set('n', ',o', function() require('dap').step_out() end, {})
vim.keymap.set('n', ',b', function() require('dap').toggle_breakpoint() end, {})
vim.keymap.set('n', ',h', function() require('dap').run_to_cursor() end, {})
vim.keymap.set('n', ',q', function() require('dap').terminate() end, {})
vim.keymap.set('n', ',l', function() require('dap').run_last() end)

vim.keymap.set('v', ',K', function() require('dapui').eval() end, {})
vim.keymap.set('n', ',K', function() require('dapui').eval() end, {})

-- Group
local group = vim.api.nvim_create_augroup('bedware_software_group', { clear = false })

-- Auto commands {{{1
vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    pattern = '*',
    desc = 'Automatically move cursor to the end on focusing console',
    callback = function(e)
        local filetype = vim.api.nvim_get_option_value('filetype', { buf = e.buf })
        if filetype == 'dapui_console' then
            require('bedware.utils').feedkeys("<S-g>", "n")
        end
    end
})
