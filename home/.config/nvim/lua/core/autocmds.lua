-- ディレクトリバッファが開かれたとき neo-tree に置き換える
-- （nvim . / :edit dir/ など全てのケースに対応）
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    if vim.fn.isdirectory(bufname) == 1 then
      vim.schedule(function()
        vim.cmd("bwipeout " .. args.buf)
        require("neo-tree.command").execute({ toggle = true, dir = bufname })
      end)
    end
  end,
})
