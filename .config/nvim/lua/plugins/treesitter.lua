return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "jinja", "jinja_inline" } },
    init = function()
      -- Templates are named <file>.<ext>.jinja (or .j2), so the base language
      -- comes from the filename with the template extension stripped.
      vim.treesitter.query.add_directive("set-template-base-language!", function(_, _, source, _, metadata)
        if type(source) ~= "number" then
          return
        end
        local name = vim.api.nvim_buf_get_name(source):gsub("%.jinja2?$", ""):gsub("%.j2$", "")
        local filetype = vim.filetype.match({ filename = name })
        if filetype then
          metadata["injection.language"] = vim.treesitter.language.get_lang(filetype)
        end
      end, { force = true })

      local function clear_template_comments()
        vim.api.nvim_set_hl(0, "@comment.jinja", {})
        vim.api.nvim_set_hl(0, "@comment.block.jinja", { link = "Comment" })
      end
      clear_template_comments()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = clear_template_comments })
    end,
  },
}
