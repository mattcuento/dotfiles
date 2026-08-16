-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ============================================================================
-- AUTOCMDS
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Show long diagnostics in a wrapped float when the cursor rests on them.
vim.diagnostic.config({
    float = {
        border = "rounded",
        source = "if_many",
        wrap = true,
        max_width = 80,
    },
})

vim.api.nvim_create_autocmd("CursorHold", {
    group = augroup,
    desc = "Show diagnostic under cursor",
    callback = function()
        vim.diagnostic.open_float({
            scope = "cursor",
            focusable = false,
        })
    end,
})

-- Format on save (ONLY real file buffers, ONLY when efm is attached)
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = {
        "*.rs",
        "*.lua",
        "*.py",
        "*.go",
        "*.js",
        "*.jsx",
        "*.ts",
        "*.tsx",
        "*.json",
        "*.css",
        "*.scss",
        "*.html",
        "*.sh",
        "*.bash",
        "*.zsh",
        "*.c",
        "*.cpp",
        "*.h",
        "*.hpp",
    },
    callback = function(args)
        -- avoid formatting non-file buffers (helps prevent weird write prompts)
        if vim.bo[args.buf].buftype ~= "" then
            return
        end
        if not vim.bo[args.buf].modifiable then
            return
        end
        if vim.api.nvim_buf_get_name(args.buf) == "" then
            return
        end

        local has_efm = false
        for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
            if c.name == "efm" then
                has_efm = true
                break
            end
        end
        if not has_efm then
            return
        end

        pcall(vim.lsp.buf.format, {
            bufnr = args.buf,
            timeout_ms = 2000,
            filter = function(c)
                return c.name == "efm"
            end,
        })
    end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.hl.on_yank()
    end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    desc = "Restore last cursor position",
    callback = function()
        if vim.o.diff then -- except in diff mode
            return
        end

        local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
        local last_line = vim.api.nvim_buf_line_count(0)

        local row = last_pos[1]
        if row < 1 or row > last_line then
            return
        end

        pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
    end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
    end,
})
