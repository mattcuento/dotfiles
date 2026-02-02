return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {"lua_ls", "ts_ls", "pylsp", "kotlin_language_server", "jdtls"},
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Use new vim.lsp.enable API (Neovim 0.11+)
      local servers = {
        'lua_ls',
        'ts_ls',
        'pylsp',
        'kotlin_language_server',
        'jdtls'
      }

      for _, server in ipairs(servers) do
        vim.lsp.enable(server, {
          capabilities = capabilities
        })
      end

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  }
}
