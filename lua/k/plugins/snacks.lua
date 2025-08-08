return {
  -- Icons (used by UIs)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Theme
  {
    "lunarvim/synthwave84.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("synthwave84")
    end,
  },

  -- Snacks (dashboard, bigfile, notifier)
  {
    "folke/snacks.nvim",
    event = "VimEnter",  -- defer until UI is ready
    priority = 1000,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = table.concat({
            "██   ██  █████  ███    ██ ██    ██ ██ ███    ███ ",
            "██  ██  ██   ██ ████   ██ ██    ██ ██ ████  ████ ",
            "█████   ███████ ██ ██  ██ ██    ██ ██ ██ ████ ██ ",
            "██  ██  ██   ██ ██  ██ ██  ██  ██  ██ ██  ██  ██ ",
            "██   ██ ██   ██ ██   ████   ████   ██ ██      ██ ",
            "",
            "KANVIM — Kartik's Neovim",
          }, "\n"),
        },
      },
      bigfile = { enabled = true },
      notifier = { enabled = true },
    },
    -- Auto-open dashboard on empty start
    init = function()
      if vim.fn.argc(-1) == 0 then
        vim.schedule(function()
          pcall(function() require("snacks.dashboard").open() end)
        end)
      end
    end,
  },
}

