-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'christoomey/vim-tmux-navigator'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.4',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = function()
		  local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
		  ts_update()
	  end,
  }

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v3.x',
	  requires = {
		  --- Uncomment these if you want to manage LSP servers from neovim
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'L3MON4D3/LuaSnip'},
	  }
  }

  use 'theprimeagen/harpoon'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'

  use({
      "stevearc/conform.nvim",
      config = function()
          require("conform").setup({
              formatters_by_ft = {
                  lua = { "stylua" },
                  rust = { "rustfmt", lsp_format = "fallback" },
                  javascript = { "prettierd", "prettier", stop_after_first = true },
              },
              format_on_save = {
                  timeout_ms = 500,
                  lsp_format = "fallback",
              },
          })
      end,
  })

  use {
    'folke/trouble.nvim',
    cmd = "Trouble",
    config = function ()
      require("trouble").setup({})
    end
  }

  use({
	  'rose-pine/neovim', as = 'rose-pine',
	  config = function()
		  vim.cmd('colorscheme rose-pine')
	  end
  })

  use {
	  'GustavEikaas/easy-dotnet.nvim',
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope.nvim'},
    },
    config = function()
      require("easy-dotnet").setup({})
    end
  }
end)
