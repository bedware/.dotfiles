-- Netrw

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
-- Options
vim.g.netrw_preview = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
vim.g.netrw_liststyle = 3
vim.g.netrw_localrmdir = 'rm -r'

-- Key bindings
vim.keymap.set('n', '<leader>e', function ()
    local relative_path = vim.fn.expand("%:h")
    vim.cmd [[:let @/=expand("%:t")]]
    vim.cmd("Lexplore " .. relative_path)
    local count = 1
    local startPos, endPos = string.find(relative_path, "/")
    while startPos do
        count = count + 1
        startPos, endPos = string.find(relative_path, "/", endPos + 1)
    end
    while count > 0 do
        count = count - 1
        vim.cmd("call netrw#Call('NetrwBrowseUpDir', 1)")
    end
    vim.cmd(":normal n<CR>zz")
end)

-- WIP {{{1
vim.keymap.set("n", "<leader>t", vim.cmd.TotalNetrw)
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
        vim.cmd('normal ma')
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
    -- vim.keymap.set("n", "%", function()
    --     vim.cmd('normal cd')
    --     local current_dir = vim.fn.expand('%:p:h')
    --     local success, value = pcall(vim.fn.input, "Create file in directory:" .. current_dir .. ". Filename: ")
    --     if success then
    --         vim.cmd(":silent! !touch " .. current_dir .. "/" .. value)
    --         vim.cmd('e %:p:h')
    --         feedkey('/' .. value .. '<CR>', 'n')
    --     end
    -- end, { buffer = buffer })

    -- Toggle dotfiles
    vim.keymap.set('n', '.', 'gh', { buffer = buffer, remap = true })
end

local function init(event)
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
        feedkey("<C-w>z", 'n')
    end
})
vim.api.nvim_create_autocmd('FileType', {
    group = bedware_group,
    pattern = 'netrw',
    desc = 'Apply key binding in TotalNetrw',
    callback = function(e)
        vim.cmd('highlight netrwMarkFile guibg=#eb6f92')
        if e.buf ~= nil then
            local success, _ = pcall(vim.api.nvim_buf_get_var, e.buf, 'totalnrw_status')
            if not success then
                vim.api.nvim_buf_set_var(e.buf, 'totalnrw_status', vim.fn.bufname(e.buf))
                netrw_key_binding(e.buf)
            end
        end
    end
})
