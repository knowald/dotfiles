-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- For *.<ext>.j2 files detected as jinja, set a dual filetype "<ext>.jinja" so
-- both the base language and jinja syntax/snippets apply.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "jinja",
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    local ext = name:match("%.(%w+)%.j2$")
    if not ext then
      return
    end
    if ext == "yml" then
      ext = "yaml"
    end
    -- Defer past LazyVim's own filetype handling; recheck validity and that
    -- nothing else already changed the filetype before overriding.
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].filetype == "jinja" then
        vim.bo[args.buf].filetype = ext .. ".jinja"
      end
    end)
  end,
})
