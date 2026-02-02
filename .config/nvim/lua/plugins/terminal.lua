return {
  -- Tmux pane management (no plugin needed)
  dir = vim.fn.stdpath("config"),
  name = "tmux-terminal",
  config = function()
    -- Check if running in tmux
    local function in_tmux()
      return vim.env.TMUX ~= nil
    end

    -- Get the number of tmux panes
    local function get_pane_count()
      if not in_tmux() then return 0 end
      local result = vim.fn.system("tmux list-panes | wc -l")
      return tonumber(result) or 0
    end

    -- Toggle tmux pane below
    local function toggle_tmux_pane()
      if not in_tmux() then
        vim.notify("Not running in tmux", vim.log.levels.WARN)
        return
      end

      local pane_count = get_pane_count()

      if pane_count > 1 then
        -- Close the bottom pane (assumes it's the last pane)
        vim.fn.system("tmux kill-pane -t {bottom-right}")
      else
        -- Open a new pane below with 30% height
        vim.fn.system("tmux split-window -v -p 30")
        -- Focus back to the top pane (nvim)
        vim.fn.system("tmux select-pane -t {top}")
      end
    end

    -- Auto-open tmux pane on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if in_tmux() then
          -- Delay slightly to ensure neo-tree opens first
          vim.defer_fn(function()
            local pane_count = get_pane_count()
            if pane_count == 1 then
              -- Open pane below with 30% height
              vim.fn.system("tmux split-window -v -p 30")
              -- Focus back to nvim pane
              vim.fn.system("tmux select-pane -t {top}")
            end
          end, 100)
        end
      end,
    })

    -- Keybinding to toggle tmux pane
    vim.keymap.set('n', '<C-\\>', toggle_tmux_pane, { desc = "Toggle tmux pane" })
  end,
}
