return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = { "eslint", "vtsls", "vue_ls" },
	},
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
	},
}
