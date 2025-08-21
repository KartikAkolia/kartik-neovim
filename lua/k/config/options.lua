-- Optimized options for better performance and UX
local opt = vim.opt
local g = vim.g

-- Performance optimizations
opt.lazyredraw = false -- Don't redraw during macros (can cause issues with some plugins)
opt.regexpengine = 0 -- Use automatic regex engine selection
opt.synmaxcol = 300 -- Limit syntax highlighting column for long lines
opt.updatetime = 200 -- Reduced from 250ms for better responsiveness
opt.timeoutlen = 300 -- Reduced from 400ms for faster which-key

-- Essential UI settings
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes:1" -- Always show sign column to prevent text shifting
opt.cursorline = true
opt.cursorcolumn = false -- Disable for performance
opt.colorcolumn = "80" -- Show column guide
opt.wrap = false
opt.linebreak = true -- Wrap at word boundaries when wrap is enabled
opt.showbreak = "↪ " -- Show wrapped lines indicator

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smoothscroll = true -- Smooth scrolling

-- Mouse and clipboard
opt.mouse = "a"
if vim.fn.has("unnamedplus") == 1 then
  opt.clipboard = "unnamedplus"
else
  opt.clipboard = "unnamed"
end

-- Indentation and tabs
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true
opt.breakindent = true -- Preserve indentation when wrapping

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false -- Don't highlight search results by default
opt.incsearch = true -- Show search results as you type

-- File handling
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.undolevels = 10000
opt.confirm = true -- Confirm before closing unsaved files

-- Split behavior
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen" -- Keep screen position when splitting

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 15 -- Limit completion menu height
opt.pumblend = 10 -- Transparent completion menu

-- Visual settings
opt.termguicolors = true
opt.background = "dark"
opt.conceallevel = 2 -- Hide markup characters
opt.concealcursor = "nc" -- Hide conceal in normal and command modes
opt.list = true -- Show whitespace characters
opt.listchars = {
  tab = "→ ",
  trail = "·",
  extends = "…",
  precedes = "…",
  nbsp = "␣"
}
opt.fillchars = {
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ", -- Hide end of buffer tildes
}

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldtext = ""
opt.fillchars:append({ fold = " " })

-- Spell checking
opt.spell = false -- Disabled by default, can be toggled
opt.spelllang = { "en_us" }
opt.spelloptions = "camel" -- Check camelCase words

-- Session options
opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds"
}

-- Command line
opt.cmdheight = 1
opt.showcmd = false -- Don't show partial commands
opt.showmode = false -- Don't show mode (using statusline instead)

-- Status line
opt.laststatus = 3 -- Global statusline

-- Wild menu
opt.wildmode = { "longest:full", "full" }
opt.wildoptions = "pum" -- Show completion in popup menu
opt.wildignorecase = true

-- Window title
opt.title = true
opt.titlestring = "Neovim - %t"

-- Format options
opt.formatoptions:remove({ "c", "r", "o" }) -- Don't auto-comment on new lines

-- Performance settings
opt.redrawtime = 10000
opt.maxmempattern = 20000

-- Diff settings
opt.diffopt:append({ "linematch:60" }) -- Better diff algorithm

-- Python provider (disabled for performance)
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0

-- Netrw settings (in case it's used)
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_browse_split = 4
g.netrw_altv = 1
g.netrw_winsize = 25

-- Autocmds for better UX
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Auto-resize splits on window resize",
})

-- Close certain filetypes with q
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "qf", "help", "man", "lspinfo", "checkhealth",
    "tsplayground", "notify", "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close with q",
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup,
  command = "checktime",
  desc = "Check for file changes",
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Go to last location",
})

-- Auto create directories when saving files
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup,
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto create dir when saving",
})

-- Disable spell checking in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
  desc = "Disable spell in terminal",
})

-- Set filetype for dotfiles
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup,
  pattern = {
    "*.env*",
    ".env*",
  },
  callback = function()
    vim.bo.filetype = "sh"
  end,
  desc = "Set env files to sh filetype",
})
