local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
    controls = {
      enabled = false,
    },
    layouts = { {
        elements = { {
            id = "stacks",
            size = 0.40
          }, {
            id = "watches",
            size = 0.10
          }, {
            id = "scopes",
            size = 0.50
          } },
        position = "left",
        size = 45
      }, {
        elements = {{
            id = "console",
            size = 1.0
          } },
        position = "bottom",
        size = 10
      } },
  }
)

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
-- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
-- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

vim.keymap.set('n', '<leader><leader>,', "<cmd>lua require('dapui').toggle()<cr>", {})
vim.keymap.set('n', ',e', "<cmd>lua require('dapui').float_element('repl', {position = 'center'})<cr>", {})
vim.keymap.set('v', ',q', "<cmd>lua require('dapui').eval()<cr>", {})

vim.keymap.set('n', ',,', "<cmd>lua require('dap').step_over()<cr>", {})
vim.keymap.set('n', ',i', "<cmd>lua require('dap').step_into()<cr>", {})
vim.keymap.set('n', ',o', "<cmd>lua require('dap').step_out()<cr>", {})
vim.keymap.set('n', ',b', "<cmd>lua require('dap').toggle_breakpoint()<cr>", {})
vim.keymap.set('n', ',c', "<cmd>lua require('dap').continue()<cr>", {})
vim.keymap.set('n', ',h', "<cmd>lua require('dap').run_to_cursor()<cr>", {})
vim.keymap.set('n', ',s', "<cmd>lua require('dap').terminate()<cr>", {})
