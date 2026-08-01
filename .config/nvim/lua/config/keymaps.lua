-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ============================================================================
-- KEYMAPS
-- ============================================================================

-- Map Ctrl+C to act exactly like Escape
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("v", "<C-c>", "<Esc>", { desc = "Exit visual mode" })
vim.keymap.set("c", "<C-c>", "<C-c>", { desc = "Clear command line" })

-- better movement in wrapped text
vim.keymap.set("n", "j", function()
    return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
    return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlights" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- macOS-style Option+Left/Right word navigation. Ghostty sends these as
-- modified arrow sequences so they do not collide with Zellij's Alt keys.
vim.keymap.set({ "n", "x" }, "<A-Left>", "b", { desc = "Previous word" })
vim.keymap.set({ "n", "x" }, "<A-Right>", "w", { desc = "Next word" })
vim.keymap.set({ "i", "c" }, "<A-Left>", "<C-Left>", { desc = "Previous word" })
vim.keymap.set({ "i", "c" }, "<A-Right>", "<C-Right>", { desc = "Next word" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })

-- LazyVim provides Ctrl+hjkl for split navigation and Ctrl+arrows for resize.
-- Keep line movement on leader mappings so those window bindings remain intact.
vim.keymap.set("n", "<leader>mj", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<leader>mk", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<leader>mj", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<leader>mk", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

vim.keymap.set("n", "<leader>pa", function() -- show file path
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    print("file:", path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>td", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- ============================================================================
-- RUST TESTS (cargo nextest) — turbopuffer conventions (see repo README):
--   ct   = cargo nextest run
--   ctdd = cargo nextest run --no-fail-fast --no-capture -p tpuf-engine --test=datadriven_tests
--   REWRITE=1 updates datadriven expected-output files.
-- These complement neotest's <leader>t{r,t,T,l,s,o,...} (nearest/file/cwd),
-- which don't model `-p <crate>` runs or the REWRITE env.
-- ============================================================================

-- Workspace root = nearest ancestor containing Cargo.lock (fallback: cwd).
local function cargo_root()
    local name = vim.api.nvim_buf_get_name(0)
    local source = name ~= "" and name or vim.fn.getcwd()
    return vim.fs.root(source, { "Cargo.lock", ".git" }) or vim.fn.getcwd()
end

-- Parse the [package] name from a single Cargo.toml (nil if it has none).
local function package_name(toml)
    local in_package = false
    for line in io.lines(toml) do
        local section = line:match("^%s*%[([%w_.-]+)%]")
        if section then
            in_package = section == "package"
        elseif in_package then
            local pkg = line:match('^%s*name%s*=%s*"([^"]+)"')
            if pkg then
                return pkg
            end
        end
    end
    return nil
end

-- Package name from the nearest Cargo.toml above the current file.
local function current_crate()
    local name = vim.api.nvim_buf_get_name(0)
    local dir = vim.fs.dirname(name ~= "" and name or vim.fn.getcwd())
    for _, toml in ipairs(vim.fs.find("Cargo.toml", { path = dir, upward = true, limit = 10 })) do
        local pkg = package_name(toml)
        if pkg then
            return pkg
        end
    end
    return nil
end

-- All workspace crate names (from <root>/crates/*/Cargo.toml), for completion.
local function crate_names()
    local names = {}
    for _, toml in ipairs(vim.fn.glob(cargo_root() .. "/crates/*/Cargo.toml", true, true)) do
        local pkg = package_name(toml)
        if pkg then
            names[#names + 1] = pkg
        end
    end
    table.sort(names)
    return names
end

-- Run `cargo nextest run <args...>` in a floating terminal at the workspace
-- root. interactive=false keeps the output visible after the run finishes.
local function nextest(args, env)
    local cmd = vim.list_extend({ "cargo", "nextest", "run" }, args)
    Snacks.terminal.open(cmd, {
        cwd = cargo_root(),
        env = env,
        interactive = false,
        win = { position = "float" },
    })
end

local dd_args = { "--no-fail-fast", "--no-capture", "-p", "tpuf-engine", "--test=datadriven_tests" }

-- :Ct [crate]  — run <crate>'s tests, or the current file's crate if omitted.
--                Tab-completes workspace crate names.
vim.api.nvim_create_user_command("Ct", function(o)
    local crate = o.args ~= "" and o.args or current_crate()
    if not crate then
        vim.notify("No crate supplied and none detected above this file", vim.log.levels.WARN)
        return
    end
    nextest({ "-p", crate })
end, {
    nargs = "?",
    desc = "cargo nextest run -p <crate>",
    complete = function(lead)
        return vim.tbl_filter(function(n)
            return n:find(lead, 1, true) == 1
        end, crate_names())
    end,
})

-- :Ctdd [filter...]         — datadriven tests, optional test-fn filter(s).
-- :CtddRewrite [filter...]  — same, updating expected output (REWRITE=1).
vim.api.nvim_create_user_command("Ctdd", function(o)
    nextest(vim.list_extend(vim.deepcopy(dd_args), o.fargs))
end, { nargs = "*", desc = "datadriven tests (ctdd) [filter...]" })

vim.api.nvim_create_user_command("CtddRewrite", function(o)
    nextest(vim.list_extend(vim.deepcopy(dd_args), o.fargs), { REWRITE = "1" })
end, { nargs = "*", desc = "datadriven tests + REWRITE=1 [filter...]" })

-- Quick keymaps (defaults / prompt). Commands above let you type the name.
-- Current crate: `cargo nextest run -p <crate>`
vim.keymap.set("n", "<leader>tp", function()
    vim.cmd("Ct")
end, { desc = "Test: current crate (nextest -p)" })

-- Datadriven: prompt for an optional filter (empty = all). Mirrors `ctdd`.
local function run_datadriven(cmd)
    vim.ui.input({ prompt = "datadriven filter (empty = all): " }, function(filter)
        if filter == nil then
            return -- cancelled
        end
        vim.cmd(filter == "" and cmd or (cmd .. " " .. filter))
    end)
end

vim.keymap.set("n", "<leader>tD", function()
    run_datadriven("Ctdd")
end, { desc = "Test: datadriven (ctdd)" })

vim.keymap.set("n", "<leader>tR", function()
    run_datadriven("CtddRewrite")
end, { desc = "Test: datadriven REWRITE=1 (update expected)" })

-- NOTE: <leader>nn/nf/ns/nt/nw are defined in lua/plugins/obsidian.lua via the
-- plugin's `keys` spec, so obsidian.nvim lazy-loads on first use.

-- TODO fix fzf-lua
-- vim.keymap.set("n", "<leader>ff", function()
--     require("fzf-lua").files()
-- end, { desc = "FZF Files" })
-- vim.keymap.set("n", "<leader>fg", function()
--     require("fzf-lua").live_grep()
-- end, { desc = "FZF Live Grep" })
-- vim.keymap.set("n", "<leader>fb", function()
--     require("fzf-lua").buffers()
-- end, { desc = "FZF Buffers" })
-- vim.keymap.set("n", "<leader>fh", function()
--     require("fzf-lua").help_tags()
-- end, { desc = "FZF Help Tags" })
-- vim.keymap.set("n", "<leader>fx", function()
--     require("fzf-lua").diagnostics_document()
-- end, { desc = "FZF Diagnostics Document" })
-- vim.keymap.set("n", "<leader>fX", function()
--     require("fzf-lua").diagnostics_workspace()
-- end, { desc = "FZF Diagnostics Workspace" })

-- ============================================================================
-- PLUGIN CONFIGS
-- ============================================================================

local setup_treesitter = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup({})
    local ensure_installed = {
        "vim",
        "vimdoc",
        "rust",
        "c",
        "cpp",
        "go",
        "html",
        "css",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "typescript",
        "vue",
        "svelte",
        "bash",
    }

    local config = require("nvim-treesitter.config")

    local already_installed = config.get_installed()
    local parsers_to_install = {}

    for _, parser in ipairs(ensure_installed) do
        if not vim.tbl_contains(already_installed, parser) then
            table.insert(parsers_to_install, parser)
        end
    end

    if #parsers_to_install > 0 then
        treesitter.install(parsers_to_install)
    end

    local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
            if vim.list_contains(config.get_installed(), vim.treesitter.language.get_lang(args.match)) then
                vim.treesitter.start(args.buf)
            end
        end,
    })
end

setup_treesitter()
