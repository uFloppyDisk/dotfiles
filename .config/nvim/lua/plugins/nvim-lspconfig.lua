return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
  },
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    opts.servers["*"] = opts.servers["*"] or {}
    opts.servers["*"].keys = opts.servers["*"].keys or {}

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
  end,
  config = function(_, opts)
    local cmp = require("cmp")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local luasnip = require("luasnip")

    local capabilities = cmp_nvim_lsp.default_capabilities()

    require("lazyvim.plugins.lsp.keymaps").set({}, opts.servers["*"].keys)

    local vue_language_server_path = vim.fn.stdpath("data")
      .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
    local vue_plugin = {
      name = "@vue/typescript-plugin",
      location = vue_language_server_path,
      languages = { "vue" },
      configNamespace = "typescript",
    }

    local vtsls_ignored_codes = {
      -- [2306] = true,
      -- [2339] = true,
      -- [6133] = true,
      -- [6192] = true,
      -- [80001] = true,
      -- [80006] = true,
    }
    local vtsls_config = {
      capabilities = capabilities,
      on_attach = function(_, bufnr)
        -- -- Define common ESLint config files
        -- local eslint_configs = {
        -- 	".eslintrc",
        -- 	".eslintrc.js",
        -- 	".eslintrc.cjs",
        -- 	".eslintrc.yaml",
        -- 	".eslintrc.yml",
        -- 	".eslintrc.json",
        -- 	"eslint.config.js",
        -- 	"eslint.config.mjs",
        -- 	"eslint.config.cjs",
        -- 	"eslint.config.ts",
        -- }
        --
        -- -- Check if any ESLint config exists in the project
        -- local file_path = vim.api.nvim_buf_get_name(bufnr)
        -- local has_eslint = vim.fs.find(eslint_configs, {
        -- 	path = file_path,
        -- 	upward = true,
        -- 	stop = vim.loop.os_homedir(), -- Stop at home directory for safety
        -- })[1] ~= nil
        --
        -- -- If ESLint is found, disable vtsls diagnostics for this buffer
        -- if has_eslint then
        -- 	local original_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
        -- 	-- vim.diagnostic.enable(false, { bufnr = bufnr })
        -- 	vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        -- 		if result.diagnostics then
        -- 			result.diagnostics = vim.tbl_filter(function(d)
        -- 				return not vtsls_ignored_codes[d.code]
        -- 			end, result.diagnostics)
        -- 		end
        -- 	end
        -- end
      end,
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
