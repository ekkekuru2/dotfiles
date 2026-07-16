# Neovim Plugin & Keymap Reference

## プラグイン一覧

| プラグイン | 用途 |
|---|---|
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | `<Space>` でキーバインドヘルプを表示 |
| [saghen/blink.cmp](https://github.com/Saghen/blink.cmp) | 補完 |
| [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | ファジーファインダー（ファイル・grep検索） |
| [nvim-telescope/telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | telescope の検索を fzf で高速化 |
| [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | telescope の依存ライブラリ |
| [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | ファイルエクスプローラー（サイドバー） |
| [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | neo-tree のファイルアイコン |
| [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim) | neo-tree の UI コンポーネント |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | シンタックスハイライト・インデント |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | ステータスライン |
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | git 差分表示・ハンク操作・blame |
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | カラースキーム |
| [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | カラースキーム |
| [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | カラースキーム |
| [rose-pine/neovim](https://github.com/rose-pine/neovim) | カラースキーム |
| [echasnovski/mini.pairs](https://github.com/echasnovski/mini.pairs) | ブラケット・クォートの自動補完 |

---

## キーマップ

### 基本操作

| キー | モード | 動作 |
|---|---|---|
| `<C-s>` | N / I | ファイル保存 |
| `<Esc>` | N | 検索ハイライトを消す |
| `j` / `k` | N / V | 折り返し行も1行ずつ移動 |
| `<` / `>` | V | インデント（ビジュアルモードを維持） |

### ウィンドウ

| キー | モード | 動作 |
|---|---|---|
| `<C-h/j/k/l>` | N | ウィンドウ間を移動 |
| `<C-Up>` / `<C-Down>` | N | ウィンドウの高さを変更 |
| `<C-Left>` / `<C-Right>` | N | ウィンドウの幅を変更 |

### バッファ

| キー | モード | 動作 |
|---|---|---|
| `<S-h>` | N | 前のバッファへ |
| `<S-l>` | N | 次のバッファへ |
| `<leader>bd` | N | バッファを閉じる |
| `<leader>,` | N | バッファ一覧（Telescope） |

### 診断（Diagnostics）

| キー | モード | 動作 |
|---|---|---|
| `[d` | N | 前の診断へ |
| `]d` | N | 次の診断へ |
| `<leader>xd` | N | 診断をフロートで表示 |
| `<leader>xl` | N | 診断をロケーションリストへ |

### LSP（ファイルを開いたとき自動で有効になる）

| キー | モード | 動作 |
|---|---|---|
| `gd` | N | 定義へ移動 |
| `gD` | N | 宣言へ移動 |
| `gr` | N | 参照一覧 |
| `gi` | N | 実装へ移動 |
| `gt` | N | 型定義へ移動 |
| `K` | N | ホバー（型情報・ドキュメント） |
| `<leader>la` | N | コードアクション |
| `<leader>lr` | N | リネーム |
| `<leader>lf` | N | フォーマット |
| `<leader>lh` | N | シグネチャヘルプ |
| `<leader>ls` | N | ドキュメントシンボル一覧 |
| `<leader>lS` | N | ワークスペースシンボル一覧 |
| `<leader>li` | N | Inlay hints のオン/オフ |

### Telescope（ファジー検索）

| キー | モード | 動作 |
|---|---|---|
| `<leader>ff` | N | ファイルを検索 |
| `<leader>fg` | N | プロジェクト全体を grep |
| `<leader>fb` | N | バッファ一覧 |
| `<leader>fh` | N | ヘルプを検索 |
| `<leader>fr` | N | 最近開いたファイル |
| `<leader>f.` | N | 現在のバッファ内を検索 |
| `<leader>fs` | N | カーソル下の単語を grep |
| `<leader>/` | N | grep（ショートカット） |
| `<leader>ft` | N | カラースキームをライブプレビューで切り替え |

**Telescope 内の操作:**

| キー | 動作 |
|---|---|
| `<C-j>` / `<C-k>` | 候補を上下移動 |
| `<CR>` | 選択して開く |
| `<C-q>` | quickfix リストへ送る |
| `<Esc>` | 閉じる |
| `<C-d>` | バッファ一覧でバッファを削除 |

### Git（gitsigns）

| キー | モード | 動作 |
|---|---|---|
| `]h` | N | 次のハンクへ |
| `[h` | N | 前のハンクへ |
| `<leader>gs` | N / V | ハンクをステージ |
| `<leader>gr` | N / V | ハンクをリセット |
| `<leader>gS` | N | バッファ全体をステージ |
| `<leader>gR` | N | バッファ全体をリセット |
| `<leader>gu` | N | ステージを取り消す |
| `<leader>gp` | N | ハンクをプレビュー |
| `<leader>gb` | N | 行の blame を表示 |
| `<leader>gd` | N | diff を表示 |
| `ih` | O / X | ハンクをテキストオブジェクトとして選択 |

### ファイルエクスプローラー（neo-tree）

| キー | モード | 動作 |
|---|---|---|
| `<leader>e` | N | エクスプローラーを開閉 |
| `<leader>E` | N | 現在のファイルをツリーで表示 |

**エクスプローラー内の操作:**

| キー | 動作 |
|---|---|
| `<CR>` | ファイルを開く / ディレクトリを展開 |
| `a` | ファイル/ディレクトリを作成 |
| `d` | 削除 |
| `r` | リネーム |
| `y` | コピー |
| `x` | カット |
| `p` | ペースト |
| `H` | 隠しファイルの表示/非表示 |
| `q` | 閉じる |

### 補完（blink.cmp）

インサートモードで文字を打つと自動でポップアップが出る。

| キー | 動作 |
|---|---|
| `<C-Space>` | 手動で補完を開く |
| `<C-n>` / `<C-p>` | 候補を上下選択 |
| `<C-y>` / `<CR>` | 確定 |
| `<C-e>` | 閉じる |

---

## LSP サーバー

| 言語 | サーバー | Nix パッケージ |
|---|---|---|
| Python | `pyright` | `pkgs.pyright` |
| C / C++ | `clangd` | `pkgs.clang-tools` |
| TypeScript / React | `ts_ls` | `pkgs.nodePackages.typescript-language-server` |
| Nix | `nil` | `pkgs.nil` |
| Lua | `lua_ls` | `pkgs.lua-language-server` |

状態確認: `:LspInfo`

---

## ディレクトリ構造

```
~/.config/nvim/
├── init.lua               # エントリポイント
├── lua/
│   ├── core/
│   │   ├── options.lua    # vim オプション
│   │   ├── keymaps.lua    # 基本キーマップ
│   │   └── lsp.lua        # LSP 設定
│   └── plugins/
│       ├── which-key.lua
│       ├── blink.lua
│       ├── telescope.lua
│       ├── neo-tree.lua
│       ├── treesitter.lua
│       ├── lualine.lua
│       └── gitsigns.lua
├── .lazy/                 # lazy.nvim 本体（gitignore済み）
└── lazy-plugins/          # インストールされたプラグイン（gitignore済み）
```
