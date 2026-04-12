return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- use latest release
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "cuentonotes",
                path = "~/Documents/cuentonotes", -- change to your vault path
            },
        },
        picker = { name = "fzf-lua" },
    },
    keys = {
        { "<leader>nn", "<cmd>Obsidian new<cr>", desc = "New note" },
        { "<leader>nf", "<cmd>Obsidian quick_switch<cr>", desc = "Find note" },
        { "<leader>ns", "<cmd>Obsidian search<cr>", desc = "Search notes" },
        { "<leader>nt", "<cmd>Obsidian today<cr>", desc = "Today's daily note" },
        { "<leader>nw", "<cmd>Obsidian workspace<cr>", desc = "Switch workspace" },
    },
}
