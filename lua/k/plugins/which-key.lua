return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register({
      mode = { "n", "v" },
      { "<leader>f", group = "find" },
      { "<leader>l", group = "lsp" },
      { "<leader>s", group = "search" },
      { "<leader>t", group = "tree" },
      { "<leader>x", group = "diagnostics" },
      -- `<leader>h` is a standalone mapping defined in keymaps.lua,
      -- so it must NOT appear here to avoid duplicates or warnings.
    })
  end,
}
