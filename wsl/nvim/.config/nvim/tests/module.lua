local M = {}

function M.realistic_func()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_command("sbuffer " .. buf)
end

return M

-- Async testing
-- Tests run in a coroutine, which can be yielded and resumed.
-- This can be used to test code that uses asynchronous Neovim functionalities.
-- For example, this can be done inside a test:

-- local co = coroutine.running()
-- vim.defer_fn(function()
--   coroutine.resume(co)
-- end, 1000)
-- --The test will reach here immediately.
-- coroutine.yield()
-- --The test will only reach here after one second, when the deferred function runs.
