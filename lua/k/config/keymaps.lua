-- Optimized keymaps with better organization and performance
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Helper function for creating keymaps with descriptions
local function keymap(mode, lhs, rhs, desc, extra_opts)
  local options = vim.tbl_extend("force", opts, extra_opts or {})
  options.desc = desc
  map(mode, lhs, rhs, options)
end

-- Core commands - Essential operations
keymap("n", "<leader>qq", ":qa!<CR>", "Quit all")
keymap("n", "<leader>qQ", ":qa<CR>", "Quit all (save prompt)")
keymap("n", "<leader>w", ":w<CR>", "Save file")
keymap("n", "<leader>W", ":wa<CR>", "Save all files")
keymap("n", "<leader>e", ":edit %:p<CR>", "Edit current file")
keymap("n", "<leader>bd", ":bdelete<CR>", "Delete buffer")
keymap("n", "<leader>bD", ":%bd|e#<CR>", "Delete all buffers except current")

-- Dashboard/New buffer
keymap("n", "<leader>h", "<cmd>enew<cr>", "New buffer")

-- Clear search highlighting (already in init.lua, but keeping for consistency)
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlighting")

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", "Go to left window")
keymap("n", "<C-j>", "<C-w>j", "Go to lower window")
keymap("n", "<C-k>", "<C-w>k", "Go to upper window")
keymap("n", "<C-l>", "<C-w>l", "Go to right window")

-- Window management
keymap("n", "<leader>wv", "<C-w>v", "Split window vertically")
keymap("n", "<leader>ws", "<C-w>s", "Split window horizontally")
keymap("n", "<leader>we", "<C-w>=", "Equalize windows")
keymap("n", "<leader>wx", ":close<CR>", "Close current window")
keymap("n", "<leader>wm", ":only<CR>", "Maximize current window")

-- Resize windows with arrows (improved responsiveness)
keymap("n", "<C-Up>", ":resize +2<CR>", "Increase window height")
keymap("n", "<C-Down>", ":resize -2<CR>", "Decrease window height")
keymap("n", "<C-Left>", ":vertical resize -2<CR>", "Decrease window width")
keymap("n", "<C-Right>", ":vertical resize +2<CR>", "Increase window width")

-- Buffer navigation
keymap("n", "<S-h>", ":bprevious<CR>", "Previous buffer")
keymap("n", "<S-l>", ":bnext<CR>", "Next buffer")
keymap("n", "[b", ":bprevious<CR>", "Previous buffer")
keymap("n", "]b", ":bnext<CR>", "Next buffer")

-- Tab management
keymap("n", "<leader>to", ":tabnew<CR>", "New tab")
keymap("n", "<leader>tx", ":tabclose<CR>", "Close tab")
keymap("n", "<leader>tn", ":tabn<CR>", "Next tab")
keymap("n", "<leader>tp", ":tabp<CR>", "Previous tab")
keymap("n", "<leader>tf", ":tabfirst<CR>", "First tab")
keymap("n", "<leader>tl", ":tablast<CR>", "Last tab")

-- Better indenting (stay in visual mode)
keymap("v", "<", "<gv", "Indent left")
keymap("v", ">", ">gv", "Indent right")

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", "Move line down")
keymap("n", "<A-k>", ":m .-2<CR>==", "Move line up")
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move selection down")
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", "Move selection up")

-- Alternative move mappings (more common)
keymap("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
keymap("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")

-- Better paste (don't lose clipboard content when pasting over selection)
keymap("v", "p", '"_dP', "Paste without losing clipboard")
keymap("x", "<leader>p", '"_dP', "Paste without losing clipboard")

-- Delete without yanking
keymap({ "n", "v" }, "<leader>d", '"_d', "Delete without yanking")
keymap("n", "x", '"_x', "Delete char without yanking")

-- Better yank operations
keymap("n", "Y", "y$", "Yank to end of line")
keymap("n", "<leader>y", '"+y', "Yank to system clipboard")
keymap("v", "<leader>y", '"+y', "Yank to system clipboard")
keymap("n", "<leader>Y", '"+Y', "Yank line to system clipboard")

-- Search and replace
keymap("n", "<leader>sr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", "Replace word under cursor")
keymap("v", "<leader>sr", '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>', "Replace selection")

-- Quick navigation
keymap("n", "<C-d>", "<C-d>zz", "Half page down and center")
keymap("n", "<C-u>", "<C-u>zz", "Half page up and center")
keymap("n", "n", "nzzzv", "Next search result and center")
keymap("n", "N", "Nzzzv", "Previous search result and center")

-- Join lines and keep cursor position
keymap("n", "J", "mzJ`z", "Join lines")

-- Undo break points (create undo points for better undo granularity)
keymap("i", ",", ",<c-g>u", "Undo break point")
keymap("i", ".", ".<c-g>u", "Undo break point")
keymap("i", "!", "!<c-g>u", "Undo break point")
keymap("i", "?", "?<c-g>u", "Undo break point")

-- Quick list navigation
keymap("n", "<C-q>", ":copen<CR>", "Open quickfix list")
keymap("n", "[q", ":cprev<CR>", "Previous quickfix item")
keymap("n", "]q", ":cnext<CR>", "Next quickfix item")
keymap("n", "[Q", ":cfirst<CR>", "First quickfix item")
keymap("n", "]Q", ":clast<CR>", "Last quickfix item")

-- Location list
keymap("n", "<leader>xl", ":lopen<CR>", "Open location list")
keymap("n", "[l", ":lprev<CR>", "Previous location item")
keymap("n", "]l", ":lnext<CR>", "Next location item")

-- Terminal mappings
keymap("t", "<Esc>", "<C-\\><C-n>", "Exit terminal mode")
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", "Terminal: Go to left window")
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", "Terminal: Go to lower window")
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", "Terminal: Go to upper window")
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", "Terminal: Go to right window")

-- Command mode improvements
keymap("c", "<C-j>", "<Down>", "Next command in history")
keymap("c", "<C-k>", "<Up>", "Previous command in history")

-- Insert mode navigation
keymap("i", "<C-h>", "<Left>", "Move cursor left")
keymap("i", "<C-j>", "<Down>", "Move cursor down")
keymap("i", "<C-k>", "<Up>", "Move cursor up")
keymap("i", "<C-l>", "<Right>", "Move cursor right")

-- Increment/decrement numbers
keymap("n", "<leader>+", "<C-a>", "Increment number")
keymap("n", "<leader>-", "<C-x>", "Decrement number")
keymap("v", "<leader>+", "<C-a>", "Increment numbers")
keymap("v", "<leader>-", "<C-x>", "Decrement numbers")
keymap("v", "g<C-a>", "g<C-a>", "Increment numbers sequentially")
keymap("v", "g<C-x>", "g<C-x>", "Decrement numbers sequentially")

-- File operations
keymap("n", "<leader>fn", ":enew<CR>", "New file")
keymap("n", "<leader>fs", ":w<CR>", "Save file")
keymap("n", "<leader>fS", ":wa<CR>", "Save all files")
keymap("n", "<leader>fr", ":e!<CR>", "Reload file")

-- Diagnostic navigation (these may be overridden by LSP config)
keymap("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
keymap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
keymap("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, "Previous error")
keymap("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, "Next error")
keymap("n", "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end,
  "Previous warning")
keymap("n", "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end, "Next warning")

-- Plugin-specific keymaps (these should match your plugin configurations)
-- Telescope (lazy-loaded, so using functions)
keymap("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, "Find files")

keymap("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, "Live grep")

keymap("n", "<leader>/", function()
  require("telescope.builtin").current_buffer_fuzzy_find()
end, "Fuzzy find in current buffer")

keymap("n", "<leader>sr", function()
  require("telescope.builtin").resume()
end, "Search resume")

keymap("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, "Find buffers")

keymap("n", "<leader>fr", function()
  require("telescope.builtin").oldfiles()
end, "Recent files")

keymap("n", "<leader>fc", function()
  require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, "Find config files")

keymap("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end, "Help tags")

keymap("n", "<leader>fk", function()
  require("telescope.builtin").keymaps()
end, "Keymaps")

-- Neo-tree
keymap("n", "<leader>tt", "<cmd>Neotree toggle<cr>", "Toggle Neo-tree")
keymap("n", "<leader>tf", "<cmd>Neotree reveal<cr>", "Reveal file in Neo-tree")
keymap("n", "<leader>tg", "<cmd>Neotree git_status<cr>", "Git status in Neo-tree")
keymap("n", "<leader>tb", "<cmd>Neotree buffers<cr>", "Buffers in Neo-tree")

-- Trouble diagnostics
keymap("n", "<leader>xd", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)")
keymap("n", "<leader>xD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)")
keymap("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", "Location List (Trouble)")
keymap("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)")

-- Undotree
keymap("n", "<F5>", "<cmd>UndotreeToggle<cr>", "Toggle Undotree")

-- LSP keymaps (these will be overridden by LSP on_attach if LSP is active)
keymap("n", "gd", vim.lsp.buf.definition, "Go to definition")
keymap("n", "gr", vim.lsp.buf.references, "Go to references")
keymap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
keymap("n", "K", vim.lsp.buf.hover, "Hover documentation")
keymap("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

-- Formatting
keymap({ "n", "v" }, "<leader>lf", function()
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({ async = true, lsp_fallback = true })
  else
    vim.lsp.buf.format({ async = true })
  end
end, "Format buffer")

-- Git hunks (if gitsigns is loaded)
keymap("n", "<leader>hs", function()
  local ok, gitsigns = pcall(require, "gitsigns")
  if ok then
    gitsigns.stage_hunk()
  end
end, "Stage hunk")

keymap("n", "<leader>hr", function()
  local ok, gitsigns = pcall(require, "gitsigns")
  if ok then
    gitsigns.reset_hunk()
  end
end, "Reset hunk")

keymap("n", "<leader>hp", function()
  local ok, gitsigns = pcall(require, "gitsigns")
  if ok then
    gitsigns.preview_hunk()
  end
end, "Preview hunk")

-- Quick access to config files
keymap("n", "<leader>ce", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
end, "Edit init.lua")

keymap("n", "<leader>ck", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/lua/k/config/keymaps.lua")
end, "Edit keymaps")

keymap("n", "<leader>co", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/lua/k/config/options.lua")
end, "Edit options")

-- Utility functions
keymap("n", "<leader>ui", "<cmd>Inspect<cr>", "Inspect under cursor")
keymap("n", "<leader>uI", "<cmd>InspectTree<cr>", "Inspect tree")

-- Easy access to system clipboard
keymap({ "n", "v" }, "<leader>Y", '"+Y', "Yank to system clipboard")
keymap({ "n", "v" }, "<leader>P", '"+P', "Paste from system clipboard")

-- Toggle options (these can be enhanced with snacks.nvim toggle functions)
keymap("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
  print("Wrap: " .. (vim.wo.wrap and "on" or "off"))
end, "Toggle wrap")

keymap("n", "<leader>us", function()
  vim.wo.spell = not vim.wo.spell
  print("Spell: " .. (vim.wo.spell and "on" or "off"))
end, "Toggle spell")

keymap("n", "<leader>un", function()
  vim.wo.number = not vim.wo.number
  print("Number: " .. (vim.wo.number and "on" or "off"))
end, "Toggle line numbers")

keymap("n", "<leader>ur", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  print("Relative number: " .. (vim.wo.relativenumber and "on" or "off"))
end, "Toggle relative numbers")

-- Disable arrow keys in normal mode (optional - uncomment to enable)
-- keymap("n", "<Up>", "<nop>", "Disabled")
-- keymap("n", "<Down>", "<nop>", "Disabled")
-- keymap("n", "<Left>", "<nop>", "Disabled")
-- keymap("n", "<Right>", "<nop>", "Disabled")

-- Disable Ex mode
keymap("n", "Q", "<nop>", "Disabled Ex mode")

-- Prevent accidental macro recording
keymap("n", "q:", "<nop>", "Disabled command history")

-- Center screen on various movements
keymap("n", "G", "Gzz", "Go to end and center")
keymap("n", "gg", "ggzz", "Go to start and center")
keymap("n", "{", "{zz", "Previous paragraph and center")
keymap("n", "}", "}zz", "Next paragraph and center")
