local map = vim.keymap.set

-- Core commands
map("n", "<leader>qq", ":qa!<CR>", { desc = "Quit all", noremap = true, silent = true })
map("n", "<leader>e", ":edit %:p<CR>", { desc = "Edit current file", noremap = true, silent = true })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer", noremap = true, silent = true })

-- Dashboard (simple new buffer)
map("n", "<leader>h", "<cmd>enew<cr>", { desc = "New buffer" })

-- Telescope
map("n", "<leader>ff", function() 
  require("telescope.builtin").find_files() 
end, { desc = "Find files" })

map("n", "<leader>fg", function() 
  require("telescope.builtin").live_grep() 
end, { desc = "Grep" })

map("n", "<leader>/", function() 
  require("telescope.builtin").live_grep() 
end, { desc = "Search in files" })

map("n", "<leader>sr", function() 
  require("telescope.builtin").resume() 
end, { desc = "Search resume" })

map("n", "<leader>fb", function() 
  require("telescope.builtin").buffers() 
end, { desc = "Buffers" })

-- Neo-tree
map("n", "<leader>tt", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neo-tree" })
map("n", "<leader>tf", "<cmd>Neotree reveal<cr>", { desc = "Reveal file" })

-- Trouble diagnostics
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics list" })

-- Undotree
map("n", "<F5>", "<cmd>UndotreeToggle<cr>", { desc = "Undotree" })

-- Additional useful keymaps
-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })