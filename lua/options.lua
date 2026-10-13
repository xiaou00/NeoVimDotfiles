require "nvchad.options"

local opt = vim.opt

-- Paint the shared Kitty background; Hyprland supplies the window opacity.
if vim.g.neovide then
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_normal_opacity = 1.0
  vim.o.guifont = "VictorMono Nerd Font Mono,LXGW WenKai Screen:h11"
end

opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.timeoutlen = 250
opt.conceallevel = 2
opt.wrap = true
opt.showbreak = " "
opt.breakindent = true
opt.breakindentopt = "list:-1"

-- Popup / floating window transparency (0 = opaque, 100 = fully transparent)
opt.pumblend = 40 -- completion menu
opt.winblend = 40 -- floating windows (LSP hover, diagnostics, etc.)

-- Thin borders and subtle whitespace markers.
opt.fillchars:append {
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
  fold = "─",
}
opt.listchars = { tab = "› ", trail = "·", extends = "›", precedes = "‹", nbsp = "·" }
opt.winborder = require("configs.ui").border

-- Neovide settings

vim.g.neovide_padding_top = 10
vim.g.neovide_padding_left = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_bottom = 10

vim.g.neovide_cursor_animation_length = 0.12
vim.g.neovide_cursor_short_animation_length = 0.01
vim.g.neovide_scroll_animation_length = 0.035
vim.g.neovide_position_animation_length = 0.02
vim.g.neovide_cursor_trail_size = 1.0
