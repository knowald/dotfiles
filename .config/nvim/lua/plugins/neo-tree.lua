return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      commands = {
        yank_relative_path = function(state)
          local node = state.tree:get_node()
          local relative_path = vim.fn.fnamemodify(node:get_id(), ":~:.")
          vim.fn.setreg("+", relative_path)
          vim.notify(relative_path, vim.log.levels.INFO, { title = "Copied relative path" })
        end,
        yank_absolute_path = function(state)
          local node = state.tree:get_node()
          local absolute_path = node:get_id()
          vim.fn.setreg("+", absolute_path)
          vim.notify(absolute_path, vim.log.levels.INFO, { title = "Copied absolute path" })
        end,
      },
      window = {
        mappings = {
          ["Y"] = "yank_relative_path",
          ["gy"] = "yank_absolute_path",
        },
      },
    },
  },
}
