return {
    {
        "nvim-neotest/neotest",
        keys = {
            {
                "<leader>tt",
                function()
                    local neotest = require("neotest")
                    neotest.output_panel.open()
                    neotest.run.run(vim.fn.expand("%"))
                end,
                desc = "Run File (Neotest)",
            },
        },
    },
}
