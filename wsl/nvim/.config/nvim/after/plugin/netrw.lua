-- Variables
vim.g.netrw_preview = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 35
-- Interesting option but off because it brokes harpoon bookmarks
-- vim.g.netrw_keepdir = 0

-- Functions
local toggle_sidebar = function()
    local relative_path = tostring(vim.fn.expand("%:h"))
    if string.sub(relative_path, 0, 1) == '/' then
        local pwd = vim.fn.getcwd() .. '/'
        relative_path = string.gsub(relative_path, pwd, "");
    end
    for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        if vim.api.nvim_get_option_value('filetype', { buf = buf_id }) == 'netrw' then
            vim.fn.win_gotoid(win_id)
            return
        end
    end
    local startPos, endPos = string.find(relative_path, "/")
    if startPos == 1 then
        relative_path = "."
    end
    vim.cmd [[:let @/=expand("%:t")]]
    vim.cmd.Vex()
    -- vim.g.netrw_liststyle = 3
    vim.g.netrw_browse_split = 4
    vim.cmd(":normal iii")
    if startPos ~= nil and startPos > 1 then
        while startPos ~= nil do
            startPos, endPos = string.find(relative_path, "/", endPos + 1)
            vim.cmd("call netrw#Call('NetrwBrowseUpDir', 1)")
        end
        vim.cmd("call netrw#Call('NetrwBrowseUpDir', 1)")
    end
    vim.cmd(":normal nzz")
end

-- Hotkeys
vim.keymap.set("n", "<A-u>", ":Ex<CR>", { silent = true })
vim.keymap.set('n', '<leader>e', toggle_sidebar)

-- Auto commands {{{1
local group = vim.api.nvim_create_augroup('bedware_software_group', { clear = false })
vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'netrw',
    desc = 'Apply netrw key binding',
    callback = function(e)
        if e.buf ~= nil then
            vim.cmd('highlight netrwMarkFile guifg=#191724 guibg=#eb6f92')
            -- Up
            vim.keymap.set('n', '<A-u>', function() vim.cmd('normal -') end, { buffer = e.buf, silent = true })

            -- Mark
            vim.keymap.set('n', 's', function()
                vim.cmd('normal mf')
                require('bedware.utils').feedkeys('n', '<Down>')
            end, { buffer = e.buf, silent = true })

            -- Close preview window
            vim.api.nvim_buf_set_keymap(e.buf, 'n', '<Esc>', '<C-w>z', {noremap = true})
            -- Command
            -- vim.keymap.set('n', 'c', function() vim.cmd('normal mx') end, { buffer = e.buf, silent = true, nowait = true })

            -- Toggle dotfiles
            vim.keymap.set('n', '.', 'gh', { buffer = e.buf, remap = true })

            -- Debug
            vim.keymap.set('n', 't', function()
                local dbg = {
                    browse = vim.api.nvim_buf_get_var(e.buf, 'netrw_curdir'),
                    real = vim.fn.getcwd()
                }
                local relative, count = string.gsub(string.gsub(dbg.browse, '-', ''), string.gsub(dbg.real, '-', ''), '')
                local mode, root
                if count == 0 then
                    mode = "real"
                    root = dbg.real
                    local relative, count = string.gsub(string.gsub(dbg.real, '-', ''), string.gsub(dbg.browse, '-', ''), '')
                    print("root[" .. mode .. "]:" .. root .. "[" .. relative .. "]")
                else
                    mode = "browsing"
                    root = dbg.real
                    print("root[" .. mode .. "]:" .. root .. "[" .. relative .. "]")
                end
            end, { buffer = e.buf })
        end
    end
})
