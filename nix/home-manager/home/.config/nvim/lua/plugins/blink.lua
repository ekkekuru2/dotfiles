return {
  "saghen/blink.cmp",
  version = "*",
  event = "InsertEnter",
  opts = {
    keymap = {
      preset = "default",
      -- <C-space>  : open completion
      -- <C-e>      : close
      -- <C-y>      : confirm
      -- <C-n>/<C-p>: next/prev item
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
    completion = {
      ghost_text = { enabled = true }, -- 選択中の候補をカーソル右にプレビュー
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
      },
      menu = {
        border = "rounded",
      },
    },
    signature = {
      enabled = true,
      window = { border = "rounded" },
    },
  },
}
