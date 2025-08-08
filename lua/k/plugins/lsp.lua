return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", build = ":MasonUpdate" },
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
        automatic_installation = true,
      })

      local cmp = require("cmp")
      local cmp_lsp = require("cmp_nvim_lsp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"]     = cmp.mapping.select_next_item(),
          ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
        }),
        sources = { { name = "nvim_lsp" }, { name = "buffer" } },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
      })

      local capabilities = cmp_lsp.default_capabilities()
      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        -- Common LSP actions
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "K",  vim.lsp.buf.hover, "Hover")

        -- LSP menu under <leader>l
        map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>lf", function()
          require("conform").format({ async = true })
        end, "Format")
      end

      require("lspconfig").lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim" } },
          },
        },
      })
    end,
  },
}
