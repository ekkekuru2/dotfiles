-- Leader key must be set before lazy.nvim loads
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable netrw (use neo-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim into this config directory (not ~/.local/share/nvim)
local lazypath = vim.fn.stdpath("config") .. "/.lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Core settings (no plugin dependencies)
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lsp")

-- Plugin setup
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  -- Store plugins inside this config directory
  root = vim.fn.stdpath("config") .. "/lazy-plugins",
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  defaults = {
    lazy = true,
    version = false,
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false },
  ui = { border = "rounded" },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})
