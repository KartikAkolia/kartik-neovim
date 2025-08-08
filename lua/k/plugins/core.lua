return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "lua", "vim", "vimdoc", "bash", "markdown", "json", "yaml" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = { add = { text = "▎" }, change = { text = "▎" }, delete = { text = "▁" } },
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = { options = { theme = "auto", section_separators = "", component_separators = "" } },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = { notify_on_error = false },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  -- Autosave
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        condition = function(buf)
          local bt = vim.bo[buf].buftype
          local ft = vim.bo[buf].filetype
          if bt ~= "" then return false end
          if ft == "snacks_dashboard" then return false end
          if ft == "neo-tree" then return false end
          if ft == "TelescopePrompt" then return false end
          return true
        end,
      })
    end,
  },

  -- Undotree
  {
    "mbbill/undotree",
    keys = { { "<F5>", "<cmd>UndotreeToggle<cr>", desc = "Undotree" } },
  },

  -- Sudo read/write
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
  },

  -- Trouble diagnostics (grouped under +diagnostics)
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xd", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics list" },
    },
    opts = {},
  },
}
