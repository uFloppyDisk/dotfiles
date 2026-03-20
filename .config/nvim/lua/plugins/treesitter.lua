vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site/")

return {
	"nvim-treesitter/nvim-treesitter",
	tag = "v0.10.0",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			ensure_installed = { "javascript", "typescript", "python", "c", "lua", "vim", "vimdoc", "query" },
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			incremental_selection = { enable = true },
		})
	end,
}
