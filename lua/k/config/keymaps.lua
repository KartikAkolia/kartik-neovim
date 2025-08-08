local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Core commands
map("n", "<leader>qq", ":qa!<CR>", opts)
map("n", "<leader>e", ":edit %:p<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", opts)

-- Dashboard (only mapping, no `g` binding)
map("n", "<leader>h", function()
  vim.cmd("enew")
  vim.schedule(function()
    pcall(function() require("snacks.dashboard").open() end)
  end)
end, { desc = "Dashboard" })

-- Telescope
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Grep" })
map("n", "<leader>/", function() require("telescope.builtin").live_grep() end, { desc = "Search in files" })
map("n", "<leader>sr", function() require("telescope.builtin").resume() end, { desc = "Search resume" })
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Buffers" })

-- Neo-tree
map("n", "<leader>tt", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neo-tree" })
map("n", "<leader>tf", "<cmd>Neotree reveal<cr>", { desc = "Reveal file" })

-- Trouble diagnostics
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics list" })

-- Undotree
map("n", "<F5>", "<cmd>UndotreeToggle<cr>", { desc = "Undotree" })

-- Clipboard images in Markdown (defined in clipboard plugin spec)
