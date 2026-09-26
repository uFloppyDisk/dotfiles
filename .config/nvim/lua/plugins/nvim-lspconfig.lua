return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    init = function()
      local group = vim.api.nvim_create_augroup("LspAttach_conflicts", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        desc = "Prefer vue_ls over ts_ls",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          if client.name == "vue_ls" then
            for _, active_client in pairs(vim.lsp.get_clients()) do
              if active_client.name == "ts_ls" then
                active_client:stop()
              end
            end
          elseif client.name == "ts_ls" then
            for _, active_client in pairs(vim.lsp.get_clients()) do
              if active_client.name == "vue_ls" then
                client:stop()
                break
              end
            end
          end
        end,
      })
    end,
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers["*"] = opts.servers["*"] or {}
      opts.servers["*"].keys = opts.servers["*"].keys or {}
      opts.servers["*"].capabilities = vim.tbl_deep_extend(
        "force",
        opts.servers["*"].capabilities or {},
        require("cmp_nvim_lsp").default_capabilities()
      )

      vim.list_extend(opts.servers["*"].keys, {
        { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
        { "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
        { "<leader>vws", vim.lsp.buf.workspace_symbol, desc = "Workspace Symbols" },
        { "<leader>vd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
        { "<leader>vca", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>vrr", vim.lsp.buf.references, desc = "References" },
        { "<leader>vrn", vim.lsp.buf.rename, desc = "Rename Symbol" },
        { "<C-h>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
      })

      local vue_language_server_path = vim.fn.stdpath("data")
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

      opts.servers.vtsls = vim.tbl_deep_extend("force", opts.servers.vtsls or {}, {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_language_server_path,
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
        },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      })
      opts.servers.vue_ls = vim.tbl_deep_extend("force", opts.servers.vue_ls or {}, {})

      opts.diagnostics = opts.diagnostics or {}
      opts.diagnostics.virtual_text = true
      opts.diagnostics.signs = opts.diagnostics.signs or {}
      opts.diagnostics.signs.text = {
        [vim.diagnostic.severity.ERROR] = "E",
        [vim.diagnostic.severity.WARN] = "W",
        [vim.diagnostic.severity.HINT] = "H",
        [vim.diagnostic.severity.INFO] = "I",
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local select_opts = { behavior = cmp.SelectBehavior.Select }

      opts.window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }
      opts.snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      }
      opts.mapping["<C-p>"] = cmp.mapping.select_prev_item(select_opts)
      opts.mapping["<C-n>"] = cmp.mapping.select_next_item(select_opts)
      opts.mapping["<C-y>"] = cmp.mapping.confirm({ select = true })
      opts.mapping["<C-Space>"] = cmp.mapping.complete()
      opts.mapping["<Tab>"] = nil
      opts.mapping["<tab>"] = nil
      opts.mapping["<S-Tab>"] = nil
      opts.sources = {
        { name = "nvim_lsp" },
      }
    end,
  },
}
