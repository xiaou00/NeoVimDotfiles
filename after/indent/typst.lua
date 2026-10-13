vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

vim.b.undo_indent = (vim.b.undo_indent or "") .. " | setlocal tabstop<"
