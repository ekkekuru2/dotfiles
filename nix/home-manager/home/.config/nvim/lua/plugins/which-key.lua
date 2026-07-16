return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 300,
    icons = {
      mappings = false,
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
      no_overlap = true,
      title = true,
      title_pos = "center",
      width = 0.45,   -- 画面幅の45%
      row = math.huge, -- 画面下部
      col = math.huge, -- 右寄せ
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>b", group = "buffer" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>l", group = "lsp" },
      { "<leader>x", group = "diagnostics" },
    })
  end,
}
