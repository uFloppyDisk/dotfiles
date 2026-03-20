require("telescope").setup({
	defaults = {
		file_ignore_patterns = {}, -- clear the global ignore patterns
	},
	pickers = {
		find_files = {
			hidden = true, -- show dotfiles and hidden directories
		},
		live_grep = {
			hidden = true, -- show dotfiles and hidden directories
		},
	},
})
