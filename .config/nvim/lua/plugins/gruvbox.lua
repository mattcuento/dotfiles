return {
    -- add gruvbox
    { "ellisonleao/gruvbox.nvim" },

    {
        "cormacrelf/dark-notify",
        lazy = false,
        priority = 900,
        dependencies = { "ellisonleao/gruvbox.nvim" },
        config = function()
            require("dark_notify").run({
                schemes = {
                    dark = {
                        colorscheme = "gruvbox",
                        background = "dark",
                    },
                    light = {
                        colorscheme = "gruvbox",
                        background = "light",
                    },
                },
            })
        end,
    },

    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "gruvbox",
        },
    },
}
