local M = {}

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.ERROR, { title = "JJ" })
end

function M.file_history()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        return notify("File history requires a saved file", vim.log.levels.WARN)
    end

    local root = require("jj.utils").get_jj_root()
    if not root then
        return notify("Current file is not in a jj repository")
    end

    local relative = vim.fs.relpath(root, file)
    if not relative or relative:sub(1, 2) == ".." then
        return notify("Current file is outside the jj repository")
    end

    local template = table.concat({
        [[change_id.shortest()]],
        [["\t"]],
        [[coalesce(author.name(), "(no author)")]],
        [["\t"]],
        [[committer.timestamp()]],
        [["\t"]],
        [[coalesce(description.first_line(), "(no description)")]],
        [["\n"]],
    }, " ++ ")

    local result = vim.system({
        "jj",
        "--repository",
        root,
        "--no-pager",
        "log",
        "-r",
        "all() ~ @",
        "--no-graph",
        "-T",
        template,
        "--",
        relative,
    }, { text = true }):wait()

    if result.code ~= 0 then
        return notify(vim.trim(result.stderr or "Unable to read file history"))
    end

    local items = {}
    for line in (result.stdout or ""):gmatch("[^\r\n]+") do
        local rev, author, timestamp, description = line:match("^(.-)\t(.-)\t(.-)\t(.*)$")
        if rev then
            items[#items + 1] = {
                rev = rev,
                author = author,
                time = timestamp,
                description = description,
                text = string.format(
                    "%s  %s  %s  %s",
                    rev,
                    author,
                    timestamp:match("^%d%d%d%d%-%d%d%-%d%d") or timestamp,
                    description
                ),
                preview_cmd = {
                    "jj",
                    "--repository",
                    root,
                    "--no-pager",
                    "diff",
                    "-r",
                    rev,
                    "--stat",
                    "--git",
                    "--",
                    relative,
                },
                confirm_action = "edit_revision",
            }
        end
    end

    if #items == 0 then
        return notify("No file history found", vim.log.levels.INFO)
    end

    require("jj.picker.snacks").file_log_history(require("jj.picker").config, items)
end

return M
