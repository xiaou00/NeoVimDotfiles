---@type ChadrcConfig
local M = {}

local mode = "dark"
local mode_file = io.open(os.getenv "HOME" .. "/.config/theme/mode", "r")
if mode_file then
  mode = mode_file:read "*l" == "light" and "light" or "dark"
  mode_file:close()
end

M.base46 = {
  theme = mode == "light" and "one_light" or "obsidian-ember",
  transparency = true,
}

local colors = require("theme.palette").load(mode)
M.base46.changed_themes = {
  all = {
    base_30 = {
      white = colors.fg,
      red = colors.red,
      baby_pink = colors.red,
      pink = colors.red,
      orange = colors.orange,
      yellow = colors.orange,
      sun = colors.orange,
      green = colors.teal,
      vibrant_green = colors.teal,
      teal = colors.teal,
      cyan = colors.teal,
      blue = colors.blue,
      nord_blue = colors.blue,
      purple = colors.purple,
      dark_purple = colors.purple,
    },
    base_16 = {
      base04 = colors.fg3,
      base05 = colors.fg,
      base06 = colors.fg2,
      base07 = colors.fg,
      base08 = colors.red,
      base09 = colors.orange,
      base0A = colors.orange,
      base0B = colors.teal,
      base0C = colors.teal,
      base0D = colors.blue,
      base0E = colors.purple,
      base0F = colors.red,
    },
  },
}

local ui = require "configs.ui"
M.ui = {
  statusline = ui.statusline,
  tabufline = ui.tabufline,
  cmp = { style = "default", format_colors = { icon = "#" } },
  telescope = { style = "bordered" },
}
M.colorify = { virt_text = "# " }
M.term = { float = { border = ui.border } }
M.cheatsheet = { theme = "simple" }
M.themepicker = { style = "compact", icon = ">" }
M.nvdash = {
  header = {},
  buttons = vim.list_extend(require("configs.ghost").nvdash(), {
    { txt = "Find file", keys = "ff", cmd = "Telescope find_files" },
    { txt = "Recent files", keys = "fo", cmd = "Telescope oldfiles" },
    { txt = "Find text", keys = "fg", cmd = "Telescope live_grep" },
    { txt = "Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "Mappings", keys = "ch", cmd = "NvCheatsheet" },
  }),
}

return M
