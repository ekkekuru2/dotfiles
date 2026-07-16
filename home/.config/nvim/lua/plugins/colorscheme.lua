-- ここを変えるだけで切り替わる
-- catppuccin: catppuccin-latte / catppuccin-frappe / catppuccin-macchiato / catppuccin-mocha
-- tokyonight: tokyonight / tokyonight-night / tokyonight-storm / tokyonight-moon
-- kanagawa:   kanagawa-wave / kanagawa-dragon / kanagawa-lotus
-- rose-pine:  rose-pine / rose-pine-moon / rose-pine-dawn
local ACTIVE = "catppuccin-mocha"

local function apply(name)
  if ACTIVE:find(name) then vim.cmd.colorscheme(ACTIVE) end
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function() apply("catppuccin") end,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    config = function() apply("tokyonight") end,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    config = function() apply("kanagawa") end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    lazy = false,
    config = function() apply("rose-pine") end,
  },
}
