return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("claudecode").setup()

    -- Create :claude command alias for :ClaudeCode
    vim.api.nvim_create_user_command('Claude', 'ClaudeCode', {
      desc = 'Alias for :ClaudeCode - Toggle Claude in split terminal'
    })
  end,
}
