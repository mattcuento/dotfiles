return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('snacks').setup({
      -- Enable only the features you want
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      image = { enabled = false },
      input = { enabled = false },
      notifier = { enabled = false },
      picker = { enabled = false },
      quickfile = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },

      -- Enable terminal integration (used by claudecode)
      terminal = { enabled = true },

      -- Enable lazygit integration
      lazygit = { enabled = true },
    })
  end
}
