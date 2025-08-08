return {
  -- Icons (used by UIs)
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "echasnovski/mini.icons", lazy = true },
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
    -- Removed problematic auto-open dashboard init function
  },
}
