return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },
    on_attach = function(buf)
      local gs = require("gitsigns")
      local map = vim.keymap.set

      -- ハンク間の移動
      map("n", "]h", function() gs.nav_hunk("next") end, { buffer = buf, desc = "Next hunk" })
      map("n", "[h", function() gs.nav_hunk("prev") end, { buffer = buf, desc = "Previous hunk" })

      -- ハンク操作
      map({ "n", "v" }, "<leader>gs", gs.stage_hunk,        { buffer = buf, desc = "Stage hunk" })
      map({ "n", "v" }, "<leader>gr", gs.reset_hunk,        { buffer = buf, desc = "Reset hunk" })
      map("n", "<leader>gS", gs.stage_buffer,               { buffer = buf, desc = "Stage buffer" })
      map("n", "<leader>gR", gs.reset_buffer,               { buffer = buf, desc = "Reset buffer" })
      map("n", "<leader>gu", gs.undo_stage_hunk,            { buffer = buf, desc = "Undo stage hunk" })

      -- 表示
      map("n", "<leader>gp", gs.preview_hunk,               { buffer = buf, desc = "Preview hunk" })
      map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { buffer = buf, desc = "Blame line" })
      map("n", "<leader>gd", gs.diffthis,                   { buffer = buf, desc = "Diff this" })

      -- テキストオブジェクト（ih = inner hunk）
      map({ "o", "x" }, "ih", gs.select_hunk, { buffer = buf, desc = "Select hunk" })
    end,
  },
}
