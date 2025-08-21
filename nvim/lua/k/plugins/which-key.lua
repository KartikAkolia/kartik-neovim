return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>f", group = "find" },
        { "<leader>t", group = "tree" },
        { "<leader>s", group = "search" },
        { "<leader>l", group = "lsp" },
        { "<leader>x", group = "diagnostics" },
      },
    },
  },
  config = function(_, opts)
    require("which-key").setup(opts)
  end,
}