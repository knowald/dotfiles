return {
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "darker",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
    -- stylua: ignore
    close_command = function(n) LazyVim.ui.bufremove(n) end,
    -- stylua: ignore
    right_mouse_command = function(n) LazyVim.ui.bufremove(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = LazyVim.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "ʕノ•ᴥ•ʔノ ︵ ┻━┻",
            highlight = "Directory",
            text_align = "center",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts)
          return LazyVim.config.icons.ft[opts.filetype]
        end,
      },
    },
  },
}
