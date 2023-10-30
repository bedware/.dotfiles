local telescope = require("telescope")
local actions = require("telescope.actions")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(require("telescope.config").values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
-- table.insert(vimgrep_arguments, "--glob")
-- table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
    defaults = {
        vimgrep_arguments = vimgrep_arguments,
        mappings = {
            i = {
                ["<C-h>"] = actions.preview_scrolling_left,
                ["<C-j>"] = actions.preview_scrolling_down,
                ["<C-k>"] = actions.preview_scrolling_up,
                ["<C-l>"] = actions.preview_scrolling_right,

                ["<M-h>"] = actions.results_scrolling_left,
                ["<M-j>"] = actions.results_scrolling_down,
                ["<M-k>"] = actions.results_scrolling_up,
                ["<M-l>"] = actions.results_scrolling_right,
            }
        },
        layout_config = {
            horizontal = { prompt_position = "bottom", preview_width = 0.55, results_width = 0.8 },

            vertical = { mirror = false },
            width = 200,
            height = 100,

            preview_cutoff = 100, -- if preview columns less than that value its not shown 
        },
    },
    pickers = {
        find_files = {
            find_command = {
                "fd",
                "--hidden",
                "--follow",
                "--strip-cwd-prefix",
                "--type", "file",
                "--exclude", ".git"
            },
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        },
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        }
    }
})
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fif', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fic', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fig', builtin.git_files, {})
vim.keymap.set('n', '<leader>fgs', builtin.git_files, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
vim.keymap.set('n', '<leader>fd', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>fw', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fc', builtin.autocommands, {})
vim.keymap.set('n', '<leader>ft', builtin.builtin, {})

