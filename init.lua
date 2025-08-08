if vim.loader and vim.loader.enable then
  vim.loader.enable()
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("k.config.options")
require("k.config.keymaps")

-- bootstrap lazy
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

-- load plugin specs from k.plugins/*
require("lazy").setup({
  spec = { { import = "k.plugins" } },
  ui = { border = "rounded" },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "zipPlugin",
        "netrwPlugin", -- remove if you want to use netrw
        "matchparen",
        "tohtml",
        "tutor",
        "rplugin",
        "shada",
      },
    },
  },
})

