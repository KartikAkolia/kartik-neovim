-- Optimized LSP configuration with lazy loading
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- Changed from start to event-based
    dependencies = {
      {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" }, -- Lazy load Mason
        opts = {
          ui = {
            border = "rounded",
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
            }
          },
          max_concurrent_installers = 10,
        }
      },
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          ensure_installed = {
            "lua_ls",
            "pyright",
            "tsserver",
            "rust_analyzer",
            "gopls",
            "bashls",
            "jsonls",
          },
          automatic_installation = true,
          handlers = nil, -- We'll set this up manually for better control
        }
      },
      {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" }, -- Load only when needed
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
          {
            "L3MON4D3/LuaSnip",
            build = "make install_jsregexp",
            dependencies = {
              "saadparwaiz1/cmp_luasnip",
            },
          },
        },
        config = function()
          local cmp = require("cmp")
          local luasnip = require("luasnip")

          cmp.setup({
            performance = {
              debounce = 60,
              throttle = 30,
              fetching_timeout = 500,
              max_view_entries = 20,
            },
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.abort(),
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
              { name = "nvim_lsp", priority = 1000 },
              { name = "luasnip", priority = 750 },
              { name = "buffer", priority = 500, max_item_count = 5 },
              { name = "path", priority = 250 },
            }),
            formatting = {
              format = function(entry, vim_item)
                -- Limit completion item text length
                if string.len(vim_item.abbr) > 40 then
                  vim_item.abbr = string.sub(vim_item.abbr, 1, 40) .. "..."
                end
                return vim_item
              end,
            },
          })

          -- Set configuration for specific filetype
          cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
              { name = "buffer" },
            })
          })

          -- Use buffer source for `/` and `?` 
          cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = "buffer" }
            }
          })

          -- Use cmdline & path source for ':'
          cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = "path" }
            }, {
              { name = "cmdline" }
            })
          })
        end,
      },
    },
    config = function()
      -- Optimized LSP setup with performance improvements
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- Enhanced capabilities with nvim-cmp
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )

      -- Optimize capabilities for better performance
      capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        },
      }

      -- Optimized on_attach function
      local on_attach = function(client, bufnr)
        -- Disable semantic tokens for better performance
        client.server_capabilities.semanticTokensProvider = nil

        local opts = { buffer = bufnr, silent = true }
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
        end

        -- Essential LSP mappings
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "K", vim.lsp.buf.hover, "Hover documentation")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

        -- LSP actions under <leader>l
        map("n", "<leader>lr", vim.lsp.buf.rename, "Rename symbol")
        map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>lf", function()
          pcall(function()
            require("conform").format({ async = true, lsp_fallback = true })
          end)
        end, "Format document")

        -- Diagnostic mappings
        map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("n", "<leader>ld", vim.diagnostic.open_float, "Show diagnostic")
        map("n", "<leader>lq", vim.diagnostic.setloclist, "Diagnostic list")

        -- Document highlight
        if client.server_capabilities.documentHighlightProvider then
          local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = {
          source = "if_many",
          spacing = 2,
        },
        float = {
          source = "always",
          border = "rounded",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- LSP server configurations
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
              },
              completion = { callSnippet = "Replace" },
              diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields" },
              },
              hint = { enable = true },
              telemetry = { enable = false },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
              },
            },
          },
        },
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            },
          },
        },
        bashls = {},
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
      }

      -- Setup Mason and LSP servers
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })

      -- Setup each server
      for server, config in pairs(servers) do
        lspconfig[server].setup(vim.tbl_deep_extend("force", {
          capabilities = capabilities,
          on_attach = on_attach,
        }, config))
      end
    end,
  },
}
