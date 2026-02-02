return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
---@diagnostic disable-next-line: undefined-doc-name
  ---@type neotree.Config?
  opts = {
    -- fill any relevant options here
  },
  config = function()
    vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')

    -- Auto-open neo-tree on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Only open if no file was specified
        if vim.fn.argc() == 0 then
          vim.cmd("Neotree filesystem reveal left")
        else
          -- If file was specified, still open neo-tree but keep focus on file
          vim.cmd("Neotree filesystem show left")
        end
      end,
    })
  end
}
