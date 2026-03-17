local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		"christoomey/vim-tmux-navigator",

		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.4",
			dependencies = { "nvim-lua/plenary.nvim" },
		},

		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
		},

		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup({
					registries = {
						"github:mason-org/mason-registry",
						"github:Crashdummyy/mason-registry",
					},
				})
			end,
		},

		{
			"VonHeikemen/lsp-zero.nvim",
			branch = "v3.x",
			dependencies = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
				"neovim/nvim-lspconfig",
				"hrsh7th/nvim-cmp",
				"hrsh7th/cmp-nvim-lsp",
				"L3MON4D3/LuaSnip",
			},
		},

		"theprimeagen/harpoon",
		"mbbill/undotree",
		"tpope/vim-fugitive",

		{ "stevearc/conform.nvim" },

		{
			"folke/trouble.nvim",
			cmd = "Trouble",
			config = function()
				require("trouble").setup({})
			end,
		},

		{
			"brianhuster/live-preview.nvim",
			dependencies = {
				"nvim-telescope/telescope.nvim",
				"ibhagwan/fzf-lua",
				"echasnovski/mini.pick",
				"folke/snacks.nvim",
			},
		},

		-- {
		-- 	"GustavEikaas/easy-dotnet.nvim",
		-- 	dependencies = {
		-- 		"nvim-lua/plenary.nvim",
		-- 		"nvim-telescope/telescope.nvim",
		-- 	},
		-- 	config = function()
		-- 		require("easy-dotnet").setup({})
		-- 	end,
		-- },

		{
			"seblyng/roslyn.nvim",
			config = function()
				require("roslyn").setup({})
			end,
		},

		{
			"rose-pine/neovim",
			name = "rose-pine",
			priority = 1000,
			config = function()
				vim.cmd("colorscheme rose-pine")
			end,
		},
	},
})
