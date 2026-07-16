return {
  "Julian/lean.nvim",
  ft = "lean",
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    -- New API: set config via vim.g.lean_config before plugin loads
    vim.g.lean_config = {
      mappings = false, -- use our own keymaps
      infoview = {
        autoopen = true,
      },
    }
  end,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lean",
      callback = function(args)
        vim.keymap.set("n", "<leader>lv",
          function() require("lean.infoview").toggle() end,
          { buffer = args.buf, desc = "Toggle infoview" })
      end,
    })
  end,
}
