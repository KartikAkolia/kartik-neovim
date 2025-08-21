-- Optimized init.lua - Faster startup with deferred loading
if vim.loader and vim.loader.enable then
  vim.loader.enable()
end

-- Set leaders early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable unused providers for faster startup
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Load critical configs immediately (only essential options)
local function load_essential_options()
  local opt = vim.opt
  opt.number = true
  opt.relativenumber = true
  opt.mouse = "a"
  opt.clipboard = "unnamedplus"
  opt.termguicolors = true
  opt.signcolumn = "yes"
  opt.splitright = true
  opt.splitbelow = true
  opt.updatetime = 250
  opt.timeoutlen = 300 -- Reduced from 400ms
end

load_essential_options()

-- Essential keymaps (before lazy loading)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins with optimized performance settings
require("lazy").setup({
  spec = { { import = "k.plugins" } },
  ui = { border = "rounded" },
  install = {
    missing = true,
    colorscheme = { "synthwave84" }
  },
  checker = {
    enabled = false, -- Disable for faster startup
    notify = false,
  },
  change_detection = {
    enabled = false, -- Disable config file watching
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "zipPlugin",
        "netrwPlugin",
        "matchit",
        "matchparen",
        "tohtml",
        "tutor",
        "rplugin",
        "shada",
        "spellfile_plugin",
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "logipat",
        "rrhelper",
        "vimball",
        "vimballPlugin",
      },
    },
  },
})

-- Defer loading of remaining configs to improve startup time
vim.defer_fn(function()
  require("k.config.options")
  require("k.config.keymaps")
end, 0)
