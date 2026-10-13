local M = {}

local function chapters_root(path)
    local dir = vim.fs.dirname(vim.fn.fnamemodify(path, ":p"))
    while dir do
        if vim.fs.basename(dir) == "chapters" then
            return vim.fs.dirname(dir)
        end
        local parent = vim.fs.dirname(dir)
        if parent == dir then
            break
        end
        dir = parent
    end
end

function M.root(path)
    local book_root = chapters_root(path)
    if book_root then
        return book_root
    end
    local start = vim.fs.dirname(vim.fn.fnamemodify(path, ":p"))
    local template = vim.fs.find("template.typ", { path = start, upward = true })[1]

    return template and vim.fs.dirname(template) or start
end

-- Chapter references belong to the document that includes the chapters.
function M.main_file(path)
    path = vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
    local root = chapters_root(path)
    if not root then
        return path
    end

    local candidates = {}
    for name, kind in vim.fs.dir(root) do
        if (kind == "file" or kind == "link") and name:match("%.typ$") then
            local file = vim.fs.joinpath(root, name)
            local ok, lines = pcall(vim.fn.readfile, file)
            if ok then
                for _, line in ipairs(lines) do
                    if line:match('^%s*#include%s+"%./chapters/')
                        or line:match('^%s*#include%s+"chapters/') then
                        candidates[#candidates + 1] = file
                        break
                    end
                end
            end
        end
    end

    if #candidates == 1 then
        return candidates[1]
    end
    for _, name in ipairs({ "main.typ", "book.typ", "index.typ" }) do
        for _, file in ipairs(candidates) do
            if vim.fs.basename(file) == name then
                return file
            end
        end
    end
    return path
end

function M.on_attach(client, bufnr)
    local function update_main()
        if client:is_stopped() or vim.api.nvim_get_current_buf() ~= bufnr then
            return
        end
        local path = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
        local main = M.main_file(path)
        local target = main ~= path and main or nil
        if client._typst_auto_main == target then
            return
        end
        client._typst_auto_main = target
        client:exec_cmd({
            title = "Select Typst book entry",
            command = "tinymist.pinMain",
            arguments = { target or vim.v.null },
        }, { bufnr = bufnr }, function(err)
            if err then
                client._typst_auto_main = nil
                vim.notify("Tinymist: " .. err.message, vim.log.levels.WARN)
            end
        end)
    end

    local group = vim.api.nvim_create_augroup("TypstBookEntry" .. client.id, { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        group = group,
        buffer = bufnr,
        callback = update_main,
        desc = "Use the book entry for files below chapters",
    })
    vim.schedule(update_main)
end

function M.command(action, path)
    -- return { "typst", action, "--root", M.root(path), path }
    return { "typst", action, path }
end

function M.atomic_compile_command(path)
    return {
        "bash",
        "-c",
        table.concat({
            "set -euo pipefail",
            'input="$1"',
            'output="${input%.typ}.pdf"',
            'dir="$(dirname -- "$output")"',
            'base="$(basename -- "$output")"',
            'tmp="$(mktemp "${TMPDIR:-/tmp}/typst-atomic.XXXXXX.pdf")"',
            'cleanup() { rm -f -- "$tmp"; }',
            "trap cleanup EXIT",
            'reload_zathura() {',
            '  pkill -HUP -x zathura 2>/dev/null || true',
            '}',
            'typst compile --creation-timestamp 0 "$input" "$tmp"',
            'cp -- "$tmp" "$output"',
            "reload_zathura",
        }, "\n"),
        "typst-atomic-compile",
        path,
    }
end

function M.atomic_watch_command(path)
    return {
        "bash",
        "-c",
        table.concat({
            "set -euo pipefail",
            'input="$1"',
            'output="${input%.typ}.pdf"',
            'dir="$(dirname -- "$output")"',
            'base="$(basename -- "$output")"',
            'tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/typst-watch.XXXXXX")"',
            'tmp_pdf="$tmp_dir/$base"',
            'watch_pid=""',
            'cleanup() {',
            '  if [ -n "$watch_pid" ]; then kill "$watch_pid" 2>/dev/null || true; fi',
            '  rm -rf -- "$tmp_dir"',
            '}',
            "trap cleanup EXIT INT TERM",
            'reload_zathura() {',
            '  pkill -HUP -x zathura 2>/dev/null || true',
            '}',
            'publish_pdf() {',
            '  cp -- "$tmp_pdf" "$output"',
            '  reload_zathura',
            '}',
            'typst compile --creation-timestamp 0 "$input" "$tmp_pdf"',
            "publish_pdf",
            'typst watch --creation-timestamp 0 "$input" "$tmp_pdf" &',
            'watch_pid="$!"',
            'last_seen=""',
            'last_published=""',
            "stable_count=0",
            'while kill -0 "$watch_pid" 2>/dev/null; do',
            '  if [ -s "$tmp_pdf" ]; then',
            '    current="$(stat -c "%Y:%s" -- "$tmp_pdf")"',
            '    if [ "$current" = "$last_seen" ]; then',
            "      stable_count=$((stable_count + 1))",
            "    else",
            '      last_seen="$current"',
            "      stable_count=0",
            "    fi",
            '    if [ "$stable_count" -ge 2 ] && [ "$current" != "$last_published" ]; then',
            "      publish_pdf",
            '      last_published="$current"',
            "    fi",
            "  fi",
            "  sleep 0.25",
            "done",
            'wait "$watch_pid"',
        }, "\n"),
        "typst-atomic-watch",
        path,
    }
end

return M
