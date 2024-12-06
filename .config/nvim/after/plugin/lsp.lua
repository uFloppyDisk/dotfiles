local lsp = require("lsp-zero")

lsp.preset("recommended")

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
	'eslint',
	'tsserver'
  },
  handlers = {
    lsp.default_setup,
    tsserver = function()
      require('lspconfig').tsserver.setup({

      })
    end,
    volar = function()
      require('lspconfig').volar.setup({
        filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue'},
        init_options = {
          vue = {
            hybridMode = false,
          }
        }
      })
    end,
  },
})

-- Fix Undefined global 'vim'
-- lsp.nvim_workspace()


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp_mappings
})


lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

-- Credit: https://www.reddit.com/r/neovim/comments/117gopv/comment/jmgsic8/
local lsp_conficts, _ = pcall(vim.api.nvim_get_autocmds, { group = "LspAttach_conflicts" })
if not lsp_conficts then
	vim.api.nvim_create_augroup("LspAttach_conflicts", {})
end
vim.api.nvim_create_autocmd("LspAttach", {
	group = "LspAttach_conflicts",
	desc = "Ensure either Volar XOR tsserver are running",
	callback = function(args)
		if not (args.data and args.data.client_id) then
			return
		end
		local active_clients = vim.lsp.get_clients()

		local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then return end

    -- if client.name == "volar" or require("lspconfig").util.root_pattern("nuxt.config.ts")(vim.fn.getcwd()) then
		if client.name == "volar" then
			for _, client_ in pairs(active_clients) do
				-- stop tsserver if volar is already active
				if client_.name == "tsserver" then
					client_.stop()
				end
			end
		elseif client.name == "tsserver" then
			for _, client_ in pairs(active_clients) do
				-- prevent tsserver from starting if volar is already active
				if client_.name == "volar" then
					client.stop()
				end
			end
		end
	end,
})
