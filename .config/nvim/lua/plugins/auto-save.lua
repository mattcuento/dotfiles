return {
  "okuuva/auto-save.nvim",
  cmd = "ASToggle",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" },
      defer_save = { "InsertLeave", "TextChanged" },
      cancel_deferred_save = { "InsertEnter" },
    },
    condition = function(buf)
      local fn = vim.fn
      local utils = require("auto-save.utils.data")

      -- Don't save for special buffers
      if fn.getbufvar(buf, "&modifiable") == 1
        and utils.not_in(fn.getbufvar(buf, "&filetype"), { "oil", "neo-tree" }) then
        return true
      end
      return false
    end,
    write_all_buffers = false,
    debounce_delay = 1000,
    debug = false,
  },
}
