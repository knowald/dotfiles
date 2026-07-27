return {
  "mfussenegger/nvim-lint",
  opts = function()
    local lint = require("lint")
    lint.linters["markdownlint-cli2"].args = {
      "--config",
      vim.fn.expand("~/.markdownlint.jsonc"),
      "-",
    }
  end,
}
