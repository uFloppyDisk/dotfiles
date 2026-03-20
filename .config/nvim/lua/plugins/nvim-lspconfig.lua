local on_attach = function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "<leader>vca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>vrr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>vrn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip",
	},
	config = function()
		local cmp = require("cmp")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local luasnip = require("luasnip")

		local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				on_attach("", event.buf)
			end,
		})

		local vue_language_server_path = vim.fn.stdpath("data")
			.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
		local vue_plugin = {
			name = "@vue/typescript-plugin",
			location = vue_language_server_path,
			languages = { "vue" },
			configNamespace = "typescript",
		}
		local vtsls_config = {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							vue_plugin,
						},
					},
				},
			},
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		}
		local vue_ls_config = {
			capabilities = capabilities,
			on_attach = on_attach,
		}

		vim.lsp.config("vtsls", vtsls_config)
		vim.lsp.config("vue_ls", vue_ls_config)
		vim.lsp.enable({ "vtsls", "vue_ls" })

		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		local cmp_mappings = {
			["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
			["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
			["<C-y>"] = cmp.mapping.confirm({ select = true }),
			["<C-Space>"] = cmp.mapping.complete(),
		}

		cmp_mappings["<Tab>"] = nil
		cmp_mappings["<S-Tab>"] = nil

		cmp.setup({
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp_mappings,
			sources = {
				{ name = "nvim_lsp" },
			},
		})

		local signs = {
			Error = "E",
			Warn = "W",
			Hint = "H",
			Info = "I",
		}
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		vim.diagnostic.config({
			virtual_text = true,
		})

		local lsp_conflicts, _ = pcall(vim.api.nvim_get_autocmds, { group = "LspAttach_conflicts" })
		if not lsp_conflicts then
			vim.api.nvim_create_augroup("LspAttach_conflicts", {})
		end
		vim.api.nvim_create_autocmd("LspAttach", {
			group = "LspAttach_conflicts",
			desc = "Ensure either Volar XOR ts_ls are running",
			callback = function(args)
				if not (args.data and args.data.client_id) then
					return
				end
				local active_clients = vim.lsp.get_clients()

				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client == nil then
					return
				end

				if client.name == "vue_ls" then
					for _, client_ in pairs(active_clients) do
						if client_.name == "ts_ls" then
							client_.stop()
						end
					end
				elseif client.name == "ts_ls" then
					for _, client_ in pairs(active_clients) do
						if client_.name == "vue_ls" then
							client.stop()
						end
					end
				end
			end,
		})
	end,
}
