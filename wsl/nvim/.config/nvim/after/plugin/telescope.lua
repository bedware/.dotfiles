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
                ["<C-j>"] = actions.preview_scrolling_left,
                ["<M-j>"] = actions.results_scrolling_left,
            }
        }
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
        }
    }
})
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fif', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fic', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fig', builtin.git_files, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fc', builtin.autocommands, {})
vim.keymap.set('n', '<leader>ft', builtin.builtin, {})
