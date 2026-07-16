return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>",                 desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",                  desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",                    desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",                  desc = "Help" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                   desc = "Recent files" },
    { "<leader>f.", "<cmd>Telescope current_buffer_fuzzy_find<cr>",  desc = "Find in buffer" },
    { "<leader>fs", "<cmd>Telescope grep_string<cr>",                desc = "Grep word under cursor" },
    { "<leader>,",  "<cmd>Telescope buffers<cr>",                    desc = "Switch buffer" },
    { "<leader>/",  "<cmd>Telescope live_grep<cr>",                  desc = "Search in project" },
    { "<leader>ft", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, desc = "Themes (live preview)" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        file_ignore_patterns = { "node_modules/", "%.git/" },
        mappings = {
          i = {
            ["<C-j>"]  = actions.move_selection_next,
            ["<C-k>"]  = actions.move_selection_previous,
            ["<C-q>"]  = actions.send_to_qflist + actions.open_qflist,
            ["<Esc>"]  = actions.close,
          },
        },
      },
      pickers = {
        find_files = { hidden = true },
        buffers = {
          sort_lastused = true,
          mappings = { i = { ["<C-d>"] = actions.delete_buffer } },
        },
      },
    })

    pcall(telescope.load_extension, "fzf")
  end,
}
