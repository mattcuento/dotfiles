return {
  "nvim-treesitter/nvim-treesitter", 
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      auto_install = true,
      ensure_installed = {"lua", "javascript", "java", "go", "python", "kotlin"},
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
