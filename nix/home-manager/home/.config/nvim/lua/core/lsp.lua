-- Diagnostic display
vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})

-- LSP keymaps (set on attach, buffer-local)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local map = vim.keymap.set
    local buf = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Inlay hints (型推論結果をインラインで表示)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
      map("n", "<leader>li", function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }),
          { bufnr = buf }
        )
      end, { buffer = buf, desc = "Toggle inlay hints" })
    end

    -- Navigation
    map("n", "gd", vim.lsp.buf.definition,      { buffer = buf, desc = "Go to definition" })
    map("n", "gD", vim.lsp.buf.declaration,     { buffer = buf, desc = "Go to declaration" })
    map("n", "gr", vim.lsp.buf.references,      { buffer = buf, desc = "References" })
    map("n", "gi", vim.lsp.buf.implementation,  { buffer = buf, desc = "Implementation" })
    map("n", "gt", vim.lsp.buf.type_definition, { buffer = buf, desc = "Type definition" })
    map("n", "K",  vim.lsp.buf.hover,           { buffer = buf, desc = "Hover" })

    -- Actions (under <leader>l)
    map("n", "<leader>la", vim.lsp.buf.code_action,                              { buffer = buf, desc = "Code action" })
    map("n", "<leader>lr", vim.lsp.buf.rename,                                   { buffer = buf, desc = "Rename" })
    map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end,  { buffer = buf, desc = "Format" })
    map("n", "<leader>lh", vim.lsp.buf.signature_help,                           { buffer = buf, desc = "Signature help" })
    map("n", "<leader>ls", vim.lsp.buf.document_symbol,                          { buffer = buf, desc = "Document symbols" })
    map("n", "<leader>lS", vim.lsp.buf.workspace_symbol,                         { buffer = buf, desc = "Workspace symbols" })
  end,
})

-- Python
-- Install: pip install pyright  /  nix: pkgs.pyright
vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "pyrightconfig.json", ".git" },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})
vim.lsp.enable("pyright")

-- C / C++
-- Install: apt/brew install clangd  /  nix: pkgs.clang-tools
vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { "compile_commands.json", "compile_flags.txt", "CMakeLists.txt", ".git" },
})
vim.lsp.enable("clangd")

-- TypeScript / JavaScript / React (TSX/JSX)
-- Install: npm i -g typescript-language-server typescript  /  nix: pkgs.nodePackages.typescript-language-server
vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
})
vim.lsp.enable("ts_ls")

-- Nix
-- Install: nix: pkgs.nil
vim.lsp.config("nil_ls", {
  cmd = { "nil" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", "default.nix", "shell.nix", ".git" },
  settings = {
    ["nil"] = {
      formatting = { command = { "nixfmt" } },
    },
  },
})
vim.lsp.enable("nil_ls")

-- Lua (for editing Neovim config)
-- Install: nix: pkgs.lua-language-server  /  brew: lua-language-server
vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        -- make lua_ls aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable("lua_ls")
