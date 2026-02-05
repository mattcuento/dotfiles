return {
  'folke/which-key.nvim',
  event = "VeryLazy",
  config = function()
    require('which-key').setup({
      -- Your which-key configuration here
      preset = "modern",
    })
  end
}
