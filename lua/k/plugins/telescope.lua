return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make",
        config = function() require("telescope").load_extension("fzf") end },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Grep" },
      { "<leader>/",  function() require("telescope.builtin").live_grep() end,  desc = "Search in files" },
      { "<leader>sr", function() require("telescope.builtin").resume() end,     desc = "Search resume" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Buffers" },
    },
    opts = {
      defaults = {
        vimgrep_arguments = {
          "rg","--hidden","--glob","!.git","--ignore-file",".gitignore",
          "--no-heading","--with-filename","--line-number","--column","--smart-case",
        },
        file_ignore_patterns = { "node_modules", "%.png$", "%.jpg$", "%.jpeg$", "%.gif$", "%.webp$", "%.svg$" },
      },
    },
  },
}

