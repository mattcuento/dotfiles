return {
    {
        "nvim-mini/mini.nvim",
        version = "*", -- Use the stable branch
        config = function()
            -- Enable the specific mini modules you want
            require("mini.ai").setup()
            require("mini.surround").setup({
                mappings = {
                    add = "gsa",
                    delete = "gsd",
                    find = "gsf",
                    find_left = "gsF",
                    highlight = "gsh",
                    replace = "gsr",
                    update_n_lines = "gsn",

                    suffix_last = "l",
                    suffix_next = "n",
                },
            })
            require("mini.pairs").setup()
            require("mini.comment").setup()
            require("mini.move").setup()
            require("mini.notify").setup()
            require("mini.icons").setup()
            require("mini.bufremove").setup()
            require("mini.cursorword").setup()
            -- Add as many modules as you need here...
        end,
    },
}
