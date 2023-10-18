require('java-deps').setup()

vim.keymap.set("n", "gs", function() require('java-deps').open_outline() end)
