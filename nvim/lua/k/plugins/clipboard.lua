return {
  {
    "ekickx/clipboard-image.nvim",
    ft = { "markdown" },
    opts = {
      default = {
        img_dir = "images",
        img_dir_txt = "images",
        affix = "![](<%s>)",
      },
    },
    keys = {
      {
        "<leader>p",
        "<cmd>PasteImg<cr>",
        mode = "n",
        ft = "markdown",
        desc = "Paste clipboard image",
      },
    },
  },
}
