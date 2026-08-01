return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "amansingh-afk/milli.nvim" },
    opts = function()
        local splash = require("milli").load({ splash = "shader" })
        return {
            theme = "doom",
            config = {
                header = splash.frames[1], -- seed header with frame 0
                center = {
                    {
                        action = "lua LazyVim.pick()()",
                        desc = " Find File",
                        icon = " ",
                        key = "f",
                    },
                    {
                        action = 'lua LazyVim.pick("live_grep")()',
                        desc = " Find Text",
                        icon = " ",
                        key = "g",
                    },
                    {
                        action = function()
                            vim.api.nvim_input("<cmd>qa<cr>")
                        end,
                        desc = " Quit",
                        icon = " ",
                        key = "q",
                    },
                },
            },
        }
    end,
    config = function(_, opts)
        require("dashboard").setup(opts)
        require("milli").dashboard({ splash = "finger", loop = true })
    end,
}
