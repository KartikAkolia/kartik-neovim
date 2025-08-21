-- Optimized core plugins with better lazy loading
return {
  -- Treesitter - Load on file events only
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash", "markdown", "json", "yaml",
        "python", "javascript", "typescript", "rust", "go", "c", "cpp",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false, -- Disable for performance
      },
      indent = { 
        enable = true,
        disable = { "python", "yaml" }, -- These can be problematic
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      
      -- Performance optimization: compile languages to bytecode
      vim.defer_fn(function()
        pcall(function()
          vim.cmd("TSUpdateSync")
        end)
      end, 1000)
    end,
  },

  -- Gitsigns - Only load for git repositories
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cond = function()
      -- Only load if we're in a git repository
      return vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):match("true") ~= nil
    end,
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, desc="Next hunk"})

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, desc="Previous hunk"})

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, {desc="Stage hunk"})
        map('n', '<leader>hr', gs.reset_hunk, {desc="Reset hunk"})
        map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc="Stage hunk"})
        map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc="Reset hunk"})
        map('n', '<leader>hS', gs.stage_buffer, {desc="Stage buffer"})
        map('n', '<leader>hu', gs.undo_stage_hunk, {desc="Undo stage hunk"})
        map('n', '<leader>hR', gs.reset_buffer, {desc="Reset buffer"})
        map('n', '<leader>hp', gs.preview_hunk, {desc="Preview hunk"})
        map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc="Blame line"})
        map('n', '<leader>tb', gs.toggle_current_line_blame, {desc="Toggle line blame"})
        map('n', '<leader>hd', gs.diffthis, {desc="Diff this"})
        map('n', '<leader>hD', function() gs.diffthis('~') end, {desc="Diff this ~"})
        map('n', '<leader>td', gs.toggle_deleted, {desc="Toggle deleted"})
      end,
      preview_config = {
        border = 'rounded',
      },
      current_line_blame_opts = {
        delay = 1000,
        virt_text_pos = 'eol',
      },
      update_debounce = 200,
      max_file_length = 40000,
    },
  },

  -- Statusline - Load after UI is ready
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local function get_lsp_clients()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if next(clients) == nil then
          return "No LSP"
        end
        local client_names = {}
        for _, client in ipairs(clients) do
          table.insert(client_names, client.name)
        end
        return table.concat(client_names, ", ")
      end

      return {
        options = {
          theme = "auto",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {
            {
              get_lsp_clients,
              icon = "",
              color = { fg = "#98be65" },
            },
            "encoding",
            "fileformat",
            "filetype"
          },
          lualine_y = { "progress" },
          lualine_z = { "location" }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {}
        },
        extensions = { "neo-tree", "trouble", "lazy" }
      }
    end,
  },

  -- Formatter - Load only when needed
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        rust = { "rustfmt" },
        go = { "gofmt" },
        sh = { "shfmt" },
      },
      format_on_save = function(bufnr)
        -- Disable format on save for certain filetypes
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
    },
  },

  -- Indent guides - Optimized loading
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm",
        },
      },
    },
  },

  -- Autosave - Optimized with better conditions
  {
    "Pocco81/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      execution_message = {
        enabled = false, -- Disable messages for performance
      },
      events = {"InsertLeave", "TextChanged"},
      conditions = {
        exists = true,
        filename_is_not = {},
        filetype_is_not = {"snacks_dashboard", "neo-tree", "TelescopePrompt", "trouble"},
        modifiable = true,
      },
      write_all_buffers = false,
      debounce_delay = 1000, -- Increased debounce for performance
      on_off_commands = true,
      clean_command_line_interval = 0,
    },
  },

  -- Undotree - Only load when needed
  {
    "mbbill/undotree",
    keys = {
      { "<F5>", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" }
    },
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SplitWidth = 30
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },

  -- Sudo operations - Command-based loading
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
    config = function()
      vim.g.suda_smart_edit = 1
    end,
  },

  -- Trouble diagnostics - Optimized lazy loading
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "<leader>xd",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xD",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    opts = {
      modes = {
        diagnostics = {
          auto_open = false,
          auto_close = true,
        },
      },
    },
  },
}
