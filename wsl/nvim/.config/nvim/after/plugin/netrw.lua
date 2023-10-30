-- Netrw

-- Options {{{1
vim.g.netrw_preview = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
vim.g.netrw_localrmdir = 'rm -r'

-- State {{{1
local state = {
    LEFT = {
        window = nil,
        bufnr = nil,
        path = nil,
        selected_files = nil
    },
    RIGHT = {
        window = nil,
        bufnr = nil,
        path = nil,
        selected_files = nil
    },
    selected = 'LEFT',
    alt_window_cursor_pos = { 1, 0 },
}

-- Functions {{{1
local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local debug_counter = 0
local debug_output_var = function(var)
    print("dbg_cnt: " .. debug_counter .. " " .. vim.inspect(var))
    debug_counter = debug_counter + 1
    feedkey(":messages<CR>", "n")
end

local toggle_sidebar = function()
    for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        if vim.api.nvim_get_option_value('filetype', { buf = buf_id }) == 'netrw' then
            vim.fn.win_gotoid(win_id)
            return
        end
    end
    vim.g.netrw_liststyle = 3
    local relative_path = vim.fn.expand("%:h")
    local startPos, endPos = string.find(relative_path, "/")
    if startPos == 1 then
        relative_path = "."
    end
    vim.cmd [[:let @/=expand("%:t")]]
    vim.cmd("Lexplore " .. relative_path)
    if startPos ~= nil and startPos > 1 then
        while startPos ~= nil do
            startPos, endPos = string.find(relative_path, "/", endPos + 1)
            vim.cmd("call netrw#Call('NetrwBrowseUpDir', 1)")
        end
        vim.cmd("call netrw#Call('NetrwBrowseUpDir', 1)")
    end
    vim.cmd(":normal n<CR>zz")
end

local open_total_on_windows = function()
    vim.fn.win_gotoid(state["LEFT"].window)
    local left = vim.b.netrw_curdir

    vim.fn.win_gotoid(state["RIGHT"].window)
    local right = vim.b.netrw_curdir
    vim.cmd("silent !total -Left '" .. left .. "' -Right '" .. right .. "'")
end

local react = function()
    if #vim.api.nvim_list_wins() == 2 then
        local prev_cursor_position = state.alt_window_cursor_pos
        state.alt_window_cursor_pos = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())

        state.LEFT.window = vim.api.nvim_list_wins()[1]
        state.LEFT.bufnr = vim.fn.winbufnr(state.LEFT.window)
        state.LEFT.path = vim.api.nvim_buf_get_var(state.LEFT.bufnr, 'netrw_curdir')
        state.RIGHT.window = vim.api.nvim_list_wins()[2]
        state.RIGHT.bufnr = vim.fn.winbufnr(state.RIGHT.window)
        state.RIGHT.path = vim.api.nvim_buf_get_var(state.RIGHT.bufnr, 'netrw_curdir')

        vim.fn.win_gotoid(state[state.selected].window)

        vim.api.nvim_win_set_cursor(state[state.selected].window, prev_cursor_position)
    end
end
local opposite = function() return state.selected == 'LEFT' and 'RIGHT' or 'LEFT' end
local change_total_pane = function()
    state.selected = opposite()
    react()
end

local create_new_file = function()
    vim.cmd('normal cd')
    local current_dir = vim.fn.expand('%:p:h')
    local success, value = pcall(vim.fn.input, "Create file in directory:" .. current_dir .. ". Filename: ")
    if success then
        vim.cmd("silent !touch " .. current_dir .. "/" .. value)
        vim.cmd('e %:p:h')
        feedkey('/' .. value .. '<CR>', 'n')
    end
end

local search_by_directory = function() vim.cmd('Telescope fd find_command=fd,--type,directory,--hidden,--strip-cwd-prefix') end

-- Command handlers {{{1
local function on_open(_)
    if #vim.api.nvim_list_wins() == 1 then
        vim.cmd.Explore()
        vim.cmd.vs()
        vim.opt.statusline = '%{b:netrw_curdir}'
        react()
    end
end

local function on_close(_)
    local if_window_is_netrw = function(win)
        return vim.api.nvim_get_option_value('filetype',
            { buf = vim.api.nvim_win_get_buf(win) }) == 'netrw'
    end
    local window_used_in_total = function(win)
        return state.LEFT.window == win or state.RIGHT.window == win
    end
    local left_windows_are_totals_windows = function()
        for _, win_id in ipairs(vim.api.nvim_list_wins()) do
            if not window_used_in_total(win_id) then
                return false
            end
        end
        return true
    end
    if not window_used_in_total(vim.api.nvim_get_current_win()) and if_window_is_netrw(vim.api.nvim_get_current_win()) then
        vim.cmd.quit()
    elseif #vim.api.nvim_list_wins() == 2 and left_windows_are_totals_windows() then
        if (if_window_is_netrw(state.LEFT.window) and if_window_is_netrw(state.RIGHT.window)) then
            vim.cmd.quitall()
        else
            vim.opt.statusline = ''
            vim.api.nvim_win_close(state[opposite()].window, false)
        end
    end
end

-- WIP Copy marked files {{{1
local do_with_marked_files = function(func)
    vim.cmd('normal ma')
    if vim.fn.argc() < 2 then
        vim.cmd('normal mf')
        vim.cmd('normal ma')
        if vim.fn.argc() < 2 then
            error("No files selected")
            return
        end
    end
    -- debug_output_var(state)
    local unquoted = {}
    local quoted = {}
    local i = 1
    while i < vim.fn.argc() do
        local filename = vim.fn.argv(i)
        table.insert(unquoted, filename)
        table.insert(quoted, "'" .. filename .. "'")
        i = i + 1
    end
    -- vim.cmd.args()
    vim.cmd('2,$argd')
    state[state.selected].selected_files = unquoted

    local success, result = pcall(func, quoted)
    -- debug_output_var(result)
    if success then
        vim.cmd(result)
    end
end
local copy_marked_files = function()
    do_with_marked_files(
        function(selected_files)
            return "silent !Copy-Item -Recurse -Path " ..
                table.concat(selected_files, ",") .. " -Destination '" .. state[opposite()]["path"] .. "'"
        end)
end
local delete_marked_files = function()
    do_with_marked_files(
        function(selected_files)
            return "silent !Remove-Item -Force -Recurse " .. table.concat(selected_files, ",")
        end)
end
local move_marked_files = function()
    do_with_marked_files(
        function(selected_files)
            return "silent !Move-Item -Path " ..
                table.concat(selected_files, ",") .. " -Destination '" .. state[opposite()]["path"] .. "'"
        end)
end

-- Global key bindings {{{1
vim.keymap.set("n", "<leader>t", vim.cmd.TotalOpen)
vim.keymap.set("n", "<leader>d", function() debug_output_var(state) end)
vim.keymap.set('n', '<leader>e', toggle_sidebar)

-- Buffer key bindings {{{1
local function netrw_key_binding(buffer)
    vim.keymap.set("n", "<leader><leader>", open_total_on_windows, { buffer = buffer, nowait = true, silent = true })
    vim.keymap.set("n", "<Tab>", change_total_pane, { buffer = buffer })
    vim.keymap.set("n", "<F5>", copy_marked_files, { buffer = buffer, nowait = true })
    vim.keymap.set("n", "<F6>", move_marked_files, { buffer = buffer, nowait = true })
    vim.keymap.set("n", "<F8>", delete_marked_files, { buffer = buffer, nowait = true })
    vim.keymap.set("n", "q", vim.cmd.TotalClose, { buffer = buffer, nowait = true })
    vim.keymap.set('n', '<C-g>', search_by_directory, { buffer = buffer })
    vim.keymap.set('n', '.', 'gh', { buffer = buffer, remap = true }) -- Toggle dotfiles
    vim.keymap.set('n', 's', function()
        feedkey("<Down>", "n")
        vim.cmd('normal mf')
    end, { buffer = buffer })                                                              -- Mark a file
    vim.keymap.set('n', '<Esc>', function() vim.cmd('normal mF') end, { buffer = buffer }) -- Unmark all files
    -- vim.keymap.set("n", "%", create_new_file, { buffer = buffer })
end

-- User commands {{{1
vim.api.nvim_create_user_command('TotalOpen', on_open, {})
vim.api.nvim_create_user_command('TotalClose', on_close, {})

local bedware_group = vim.api.nvim_create_augroup('bedware_group', { clear = false })

-- Auto commands {{{1
vim.api.nvim_create_autocmd('VimEnter', {
    group = bedware_group,
    pattern = '*',
    desc = 'At the beginning',
    callback = function(_)
        if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
            vim.cmd.TotalOpen()
        end
    end
})
vim.api.nvim_create_autocmd('BufEnter', {
    group = bedware_group,
    pattern = '*',
    desc = 'Autoclose preview window',
    callback = function(e)
        local filetype = vim.api.nvim_get_option_value('filetype', { buf = e.buf })
        if filetype ~= '' and filetype ~= 'netrw' then
            vim.cmd.TotalClose()
        end
    end
})
vim.api.nvim_create_autocmd('FileType', {
    group = bedware_group,
    pattern = 'netrw',
    desc = 'Apply Total key binding',
    callback = function(e)
        if e.buf ~= nil then
            vim.cmd('highlight netrwMarkFile guibg=#eb6f92')
            netrw_key_binding(e.buf)
        end
    end
})
