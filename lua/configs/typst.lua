local M = {}

function M.root(path)
    local start = vim.fs.dirname(vim.fn.fnamemodify(path, ":p"))
    local template = vim.fs.find("template.typ", { path = start, upward = true })[1]

    return template and vim.fs.dirname(template) or start
end

function M.command(action, path)
    -- return { "typst", action, "--root", M.root(path), path }
    return { "typst", action, path }
end

return M
