-- nvim-treesitter は main ブランチを使う。
-- master ブランチは "support upper bounds" が設定されていて Neovim 0.12 は非対応。
-- 0.12 で master を使うと injection の非同期パースで nil ノードが生まれ
--   treesitter.lua:197 attempt to call method 'range' (a nil value)
-- でクラッシュする。0.11+/0.12 のサポートは main ブランチに移っている。
--
-- main ブランチは API が master と全く違う:
--   * ensure_installed / highlight / indent の opts は無い
--   * パーサは require("nvim-treesitter").install{...} で入れる
--   * ハイライトは vim.treesitter.start() を自分で呼ぶ
--   * incremental_selection は削除されたので下で自前実装する
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- main ブランチ推奨。FileType より前に install を済ませたい
  build = ":TSUpdate",
  config = function()
    local nts = require("nvim-treesitter")
    -- master → main へ切り替えた直後の初回起動では、まだ master の
    -- チェックアウトが読み込まれていて main API (install 等) が無い。
    -- ここで落ちると設定全体が中断するので、警告して空振りさせる。
    -- 案内どおり :Lazy sync でブランチを main にして再起動すれば本処理が走る。
    if type(nts.install) ~= "function" then
      vim.schedule(function()
        vim.notify(
          "nvim-treesitter: main ブランチ未取得です。:Lazy sync を実行し nvim を再起動してください",
          vim.log.levels.WARN
        )
      end)
      return
    end

    -- パーサ/クエリのインストール先（rtp 先頭に入る）
    nts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- インストールするパーサ（master の ensure_installed 相当）
    nts.install({
      -- 使用言語
      "c", "cpp",
      "python",
      "typescript", "tsx", "javascript",
      "nix",
      "prisma",
      -- Neovim 設定用
      "lua", "vim", "vimdoc", "query",
      -- その他よく使う
      "json", "yaml", "markdown", "markdown_inline", "bash",
    })

    -- ハイライト + インデント（master の highlight.enable / indent.enable 相当）
    -- main ブランチは自動で開始しないので FileType で start する。
    -- インストール済みパーサがある filetype だけ対象にすれば
    -- 並行リストを保守せずに済む。
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf = args.buf
        local ft = args.match
        local lang = vim.treesitter.language.get_lang(ft) or ft
        -- パーサが無ければ start は失敗するので pcall で握りつぶす
        if not pcall(vim.treesitter.start, buf, lang) then
          return
        end
        -- インデント（Telescope のプロンプト等では無効化）
        if not ft:find("Telescope") then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- ビジュアル選択の段階的な拡張（master の incremental_selection 相当）
    -- main ブランチには無いので treesitter ノードを使って自前実装する。
    do
      local stack = {}

      -- ノードの範囲を charwise visual selection にする
      local function select_node(node)
        local srow, scol, erow, ecol = node:range()
        -- setpos は 1 始まり・バイト列。range() は 0 始まり、ecol は排他的。
        vim.fn.setpos("'<", { 0, srow + 1, scol + 1, 0 })
        vim.fn.setpos("'>", { 0, erow + 1, math.max(ecol, 1), 0 })
        vim.cmd("normal! gv")
      end

      local function init_selection()
        local node = vim.treesitter.get_node()
        if not node then
          return
        end
        stack = { node }
        select_node(node)
      end

      local function increment()
        local node = stack[#stack]
        if not node then
          return init_selection()
        end
        -- 今の範囲より広くなる最初の親までさかのぼる
        local parent = node:parent()
        while parent do
          local ps, pc, pe, pce = parent:range()
          local ns, nc, ne, nce = node:range()
          if ps ~= ns or pc ~= nc or pe ~= ne or pce ~= nce then
            break
          end
          parent = parent:parent()
        end
        if not parent then
          return
        end
        stack[#stack + 1] = parent
        select_node(parent)
      end

      local function decrement()
        if #stack > 1 then
          stack[#stack] = nil
        end
        select_node(stack[#stack])
      end

      vim.keymap.set("n", "<C-space>", init_selection, { desc = "TS 選択開始" })
      vim.keymap.set("x", "<C-space>", increment, { desc = "TS 選択を広げる" })
      vim.keymap.set("x", "<bs>", decrement, { desc = "TS 選択を狭める" })
    end
  end,
}
