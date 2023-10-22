local luasnip = require("luasnip")

-- Every unspecified option will be set to the default.
luasnip.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = false,
})

-- One peculiarity of honza/vim-snippets is that the file with the global snippets is _.snippets, so global snippets
-- are stored in `ls.snippets._`.
-- We need to tell luasnip that "_" contains global snippets:
luasnip.filetype_extend("all", { "_" })

require("luasnip.loaders.from_snipmate").lazy_load() -- Lazy loading
