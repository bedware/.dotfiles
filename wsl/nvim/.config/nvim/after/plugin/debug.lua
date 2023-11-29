-- :h dap-configuration
require("dapui").setup()

vim.keymap.set('n', '<leader>,', function()
    local windows = require("dapui.windows")
    for i = 1, #windows.layouts, 1 do
        if windows.layouts[i]:is_open() then
            require("dapui").close({ reset = true })
            return
        end
    end
    require("dapui").open({ reset = true })
end, {})
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

vim.keymap.set('n', ',lc', function() require 'telescope'.extensions.dap.configurations {} end, {})
vim.keymap.set('n', ',lb', function() require 'telescope'.extensions.dap.list_breakpoints {} end, {})

vim.keymap.set('n', ',r', function()
    require("dapui").open({ layout = 2, reset = true })
    require("dapui").close({ layout = 1, reset = true })
    require('telescope').extensions.dap.configurations({})
end, {})


-- vim.keymap.set('n', ',l', function() -- scope
--     local widgets = require('dap.ui.widgets')
--     widgets.centered_float(widgets.scopes)
-- end)
--
-- vim.keymap.set('n', ',s', function() -- stack
--     local widgets = require('dap.ui.widgets')
--     widgets.centered_float(widgets.frames)
-- end)

-- vim.keymap.set('n', ',t', function() require'telescope'.extensions.dap.commands{} end, {})
-- vim.keymap.set('n', ',lf', function() require'telescope'.extensions.dap.frames{} end, {})
-- vim.keymap.set('n', ',r', function() require('dap').repl.toggle() end)
-- vim.keymap.set('n', ',B',
--     function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)

-- vim.keymap.set({ 'n', 'v' }, ',K', function()
--     require('dap.ui.widgets').hover()
-- end)

-- dap.listeners.after.event_initialized["dapui_config"] = function() require('dap').repl.open() end
-- dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
-- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
-- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- local dapui = require("dapui")
-- {
--     elements = { {
--         id = "stacks",
--         size = 0.40
--     }, {
--         id = "watches",
--         size = 0.10
--     }, {
--         id = "scopes",
--         size = 0.50
--     } },
--     position = "left",
--     size = 45
-- },
-- dapui.setup()
