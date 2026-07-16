return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- main ブランチは新APIで configs モジュールがない
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      -- 使用言語
      "c", "cpp",
      "python",
      "typescript", "tsx", "javascript",
      "nix",
      -- Neovim 設定用
      "lua", "vim", "vimdoc", "query",
      -- その他よく使う
      "json", "yaml", "markdown", "markdown_inline", "bash",
    },
    highlight = { enable = true },
    indent = {
      enable = true,
      disable = function(_, buf)
        return vim.bo[buf].filetype:find("Telescope") ~= nil
      end,
    },
    -- ビジュアル選択の段階的な拡張
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection   = "<C-space>", -- ノーマルモードで選択開始
        node_incremental = "<C-space>", -- 選択範囲を広げる
        node_decremental = "<bs>",      -- 選択範囲を狭める
      },
    },
  },
}
