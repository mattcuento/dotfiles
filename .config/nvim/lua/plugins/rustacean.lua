return {
  'mrcjkb/rustaceanvim',
  version = '^5',
  lazy = false,
  ft = { 'rust' },
  config = function()
    vim.g.rustaceanvim = {
      server = {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = function(client, bufnr)
          -- Rust-specific keybindings are handled by the LspAttach autocmd in lsp-config.lua
          -- This ensures consistent keybindings across all languages
        end,
      },
    }
  end
}
