vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

local undo = "setlocal tabstop< shiftwidth< softtabstop< expandtab<"
vim.b.undo_ftplugin = vim.b.undo_ftplugin and (vim.b.undo_ftplugin .. " | " .. undo) or undo
