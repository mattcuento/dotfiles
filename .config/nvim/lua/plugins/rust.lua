return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                bacon_ls = {
                    init_options = {
                        cargo = {
                            updateOnInsert = true,
                        },
                    },
                    settings = {
                        bacon_ls = {
                            backend = "cargo",
                            cargo = {
                                command = "clippy",
                                checkOnSave = true,
                                updateOnInsertDebounceMillis = 1500,
                            },
                        },
                    },
                },
            },
        },
    },
}
