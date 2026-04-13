require "nvchad.options"

local opt = vim.opt

opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.timeoutlen = 250
opt.conceallevel = 2
opt.wrap = true

-- Popup / floating window transparency (0 = opaque, 100 = fully transparent)
opt.pumblend  = 40   -- completion menu
opt.winblend  = 40   -- floating windows (LSP hover, diagnostics, etc.)
