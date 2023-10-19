-- Netrw

-- Optiongs
vim.g.netrw_preview = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20

-- Key bindings
vim.keymap.set('n', '<leader>e', '<cmd>Lexplore %:p:h<cr>')
vim.keymap.set("n", "<leader>E", vim.cmd.Lexplore)

-- WIP {{{1
-- State
local state = {
    LEFT = {
        window = nil,
        bufnr = nil,
        selected_files = nil
    },
    RIGHT = {
        window = nil,
        bufnr = nil,
        selected_files = nil
    },
    selected = 'LEFT',
    alt_window_cursor_pos = nil,
}

vim.keymap.set("n", "<leader>t", vim.cmd.TotalNetrw)

local function react()
    local prev_cursor_position = state.alt_window_cursor_pos
    if prev_cursor_position == nil then
        prev_cursor_position = { 1, 0 }
    end
    state.alt_window_cursor_pos = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    vim.fn.win_gotoid(state[state.selected].window)
    vim.api.nvim_win_set_cursor(state[state.selected].window, prev_cursor_position)
    state[state.selected].bufnr = vim.fn.winbufnr(state[state.selected].window)
    state[state.selected].bufname = vim.fn.bufname(state[state.selected].bufnr)
end
local function netrw_key_binding(buffer)
    -- vim.g.mapleader = ","
    -- Close window
    vim.keymap.set("n", "q", function()
        -- vim.api.nvim_win_close(state.LEFT.window, false)
        -- if #vim.api.nvim_list_wins() == 1 then
        vim.cmd.quit()
        -- end
        -- vim.api.nvim_win_close(state.RIGHT.window, false)
    end, { buffer = buffer, nowait = true })

    -- Key bindings
    vim.keymap.set("n", "<Tab>", function()
        if vim.api.nvim_get_current_win() == state.LEFT.window then
            state.selected = 'RIGHT'
        elseif vim.api.nvim_get_current_win() == state.RIGHT.window then
            state.selected = 'LEFT'
        end
        react()
    end, { buffer = buffer })

    vim.keymap.set("n", "<leader>mc", function()
        vim.cmd(':normal ma')
        -- vim.api.nvim_feedkeys('ma', 'n', false)
        local res = {}
        local i = 1
        while i < vim.fn.argc() do
            table.insert(res, vim.fn.argv(i))
            i = i + 1
        end
        vim.cmd('2,$argd')
        state[state.selected].selected_files = res
    end, { buffer = buffer, nowait = true })
    -- vim.keymap.set("n", "<space>", function()
    --     vim.cmd(':normal mf')
    -- end, { buffer = buffer, remap = true, nowait = true })
    vim.keymap.set("n", "<leader>w", function()
        print(vim.inspect(state))
    end, { buffer = buffer, nowait = true })
    vim.keymap.set("n", "%", function()
        local filename = vim.fn.input("New filename %>")
        local current_dir = vim.fn.expand('%:p:h')
        vim.cmd("!touch " .. current_dir .. "/" .. filename)
    end, { buffer = buffer })

    -- Toggle dotfiles
    vim.keymap.set('n', '.', 'gh', { buffer = buffer, remap = true })
end

local function init(event)
    vim.cmd('highlight netrwMarkFile guibg=#aa0000')
    vim.cmd.Explore()
    vim.cmd.vs()
    if #vim.api.nvim_list_wins() ~= 2 then
        error("Exactly 2 windows must exist")
    end
    state.LEFT.window = vim.api.nvim_list_wins()[1]
    state.RIGHT.window = vim.api.nvim_list_wins()[2]
    vim.opt.statusline = '%{b:totalnrw_status}'
    react()
end

vim.api.nvim_create_user_command('TotalNetrw', init, {})

-- WIP END }}}

local bedware_group = vim.api.nvim_create_augroup('bedware_group', { clear = false })
vim.api.nvim_create_autocmd('BufEnter', {
    group = bedware_group,
    pattern = '*',
    desc = 'Autoclose preview window',
    callback = function(e)
        local key = vim.api.nvim_replace_termcodes("<C-w>z", true, false, true)
        vim.api.nvim_feedkeys(key, 'n', false)
    end
})
vim.api.nvim_create_autocmd('FileType', {
    group = bedware_group,
    pattern = 'netrw',
    desc = 'Apply key binding in TotalNetrw',
    callback = function(e)
        if e.buf ~= nil then
            local success, _ = pcall(vim.api.nvim_buf_get_var, e.buf, 'totalnrw_status')
            if not success then
                vim.api.nvim_buf_set_var(e.buf, 'totalnrw_status', vim.fn.bufname(e.buf))
                netrw_key_binding(e.buf)
            end
        end
    end
})
