return {
  'akinsho/git-conflict.nvim',
  version = "*",  -- Use the latest stable version
  config = function()
    require('git-conflict').setup({
      default_mappings = true,      -- Enable default keybindings
      default_commands = true,      -- Enable commands like :GitConflictChooseOurs
      disable_diagnostics = false,  -- Show diagnostics during conflicts
      list_opener = 'copen',        -- Use quickfix list for conflict navigation
    })
  end
}
