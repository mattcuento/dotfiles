return {
    {
        "NicolasGB/jj.nvim",
        version = "*",
        dependencies = {
            "folke/snacks.nvim",
        },
        cmd = { "J", "Jbrowse", "Jdiff", "Jvdiff", "Jhdiff", "Jread", "Jedit", "Jtabedit" },
        opts = {
            picker = {
                snacks = {},
            },
        },
        keys = {
            { "<leader>jj", "<cmd>J log<cr>", desc = "JJ log" },
            { "<leader>jS", "<cmd>J status<cr>", desc = "JJ status buffer" },
            { "<leader>jb", "<cmd>J annotate<cr>", desc = "JJ annotate file" },
            { "<leader>jB", "<cmd>J annotate_line<cr>", desc = "JJ annotate line" },
            { "<leader>jd", "<cmd>Jdiff<cr>", desc = "JJ diff current file" },
            { "<leader>jD", "<cmd>Jhdiff<cr>", desc = "JJ horizontal diff current file" },
            {
                "<leader>js",
                function()
                    require("jj.picker").status()
                end,
                desc = "JJ status picker",
            },
            {
                "<leader>jf",
                function()
                    require("config.jj_picker").file_history()
                end,
                desc = "JJ file history picker",
            },
            {
                "<leader>jc",
                function()
                    require("jj.picker").conflict()
                end,
                desc = "JJ conflicts picker",
            },
        },
    },

    {
        "julienvincent/hunk.nvim",
        cmd = { "DiffEditor" },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-mini/mini.icons",
        },
        opts = {},
    },

    {
        "rafikdraoui/jj-diffconflicts",
        cmd = { "JJDiffConflicts" },
    },

    {
        "folke/snacks.nvim",
        keys = {
            { "<leader>gd", false },
            { "<leader>gD", false },
            { "<leader>gs", false },
            { "<leader>gS", false },
        },
    },

    {
        "Cretezy/neo-tree-jj.nvim",
        dependencies = {
            {
                "nvim-neo-tree/neo-tree.nvim",
                branch = "v3.x",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                    "MunifTanjim/nui.nvim",
                },
                opts = function(_, opts)
                    opts.sources = opts.sources or { "filesystem", "buffers", "git_status" }
                    if not vim.tbl_contains(opts.sources, "jj") then
                        table.insert(opts.sources, "jj")
                    end

                    opts.source_selector = opts.source_selector or {}
                    opts.source_selector.sources = opts.source_selector.sources
                        or {
                            { source = "filesystem", display_name = " Files" },
                            { source = "buffers", display_name = " Buffers" },
                            { source = "git_status", display_name = " Git" },
                        }
                    table.insert(opts.source_selector.sources, {
                        source = "jj",
                        display_name = " JJ",
                    })
                end,
            },
        },
        keys = {
            { "<leader>je", "<cmd>Neotree jj toggle<cr>", desc = "JJ changed files tree" },
        },
    },
}
