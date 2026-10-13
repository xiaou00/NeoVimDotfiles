-- Run: nvim --headless -u NONE -i NONE -l ~/.config/nvim/tests/theme-sync.lua
-- Isolated palette/state; never changes the desktop theme or existing buffers.
local config = vim.fn.expand "~/.config"
vim.opt.rtp:prepend(config .. "/nvim")
local palette = vim.json.decode(table.concat(vim.fn.readfile(config .. "/theme/palette.json"), "\n"))
local temporary = vim.fn.tempname()
vim.fn.mkdir(temporary .. "/theme", "p")
vim.fn.mkdir(temporary .. "/run", "p")
vim.env.XDG_CONFIG_HOME = temporary
vim.env.XDG_RUNTIME_DIR = temporary .. "/run"

local serial = 0
local function publish(background, mode)
  serial = serial + 1
  palette[mode].bg = background
  vim.fn.writefile({ vim.json.encode(palette) }, temporary .. "/theme/palette.json")
  vim.fn.writefile({ tostring(serial) }, temporary .. "/theme/generation")
  -- Same publication order as apply-theme.sh; mode can remain unchanged.
  vim.fn.writefile({ mode }, temporary .. "/theme/mode")
end

local function equal(actual, expected, label)
  assert(vim.deep_equal(actual, expected), string.format("%s: %s != %s", label, vim.inspect(actual), vim.inspect(expected)))
end

local function number(hex)
  return tonumber(hex:sub(2), 16)
end

local function color(group, field)
  return vim.api.nvim_get_hl(0, { name = group, link = false })[field]
end

local function contrast(foreground, background)
  local function luminance(hex)
    local result = 0
    for i, weight in ipairs { 0.2126, 0.7152, 0.0722 } do
      local c = tonumber(hex:sub(2 * i, 2 * i + 1), 16) / 255
      result = result + weight * (c <= 0.04045 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4)
    end
    return result
  end
  local fg, bg = luminance(foreground), luminance(background)
  return (math.max(fg, bg) + 0.05) / (math.min(fg, bg) + 0.05)
end

local function verify_highlights(mode)
  local colors = require("theme.palette").load(mode)
  local backgrounds = {
    Visual = "text_selection", VisualNOS = "text_selection",
    CursorLine = "bg1", CursorLineNr = "bg1", CursorColumn = "bg1",
    Search = "search", IncSearch = "search", Substitute = "search",
    Pmenu = "bg2", PmenuSel = "sel", CmpSel = "sel",
    TelescopeSelection = "sel", NvimTreeCursorLine = "bg1",
    QuickFixLine = "sel", LspReferenceText = "bg2",
    DiagnosticVirtualTextError = "bg1", DiffText = "sel",
    RenderMarkdownH1Bg = "bg2", LazyButtonActive = "sel",
  }
  for group, role in pairs(backgrounds) do
    equal(color(group, "bg"), number(colors[role]), group)
  end
  equal(color("CursorLineNr", "fg"), number(colors.cursorline_fg), "current line number")
  equal(color("@keyword", "fg"), number(colors.red), "syntax colors remain independent")
  equal(color("Normal", "bg"), nil, "terminal background remains transparent")
  equal(package.loaded["nvim-silicon"].options.background, colors.bg, "screenshot background")
  equal(package.loaded["nvim-silicon"].options.font, "keep-font", "screenshot options preserved")
  for _, pair in ipairs {
    { "selection_fg", "text_selection" }, { "menu_fg", "sel" },
    { "search_fg", "search" }, { "cursorline_fg", "bg1" },
  } do
    assert(contrast(colors[pair[1]], colors[pair[2]]) >= 4.5, pair[1] .. " must be readable")
  end
  return colors
end

local ok, error_message = xpcall(function()
  package.loaded["nvim-silicon"] = { options = { font = "keep-font" } }
  publish("#151515", "dark")
  require("theme_toggle").init()
  local initial = verify_highlights "dark"
  for _, background in ipairs { "#204830", "#26304e", "#ffffff", "#000000", "#f7f5f2" } do
    publish(background, "dark")
    local expected = require("theme.palette").load "dark"
    assert(vim.wait(3000, function()
      return color("Visual", "bg") == number(expected.text_selection)
    end, 10), "same-mode palette change was not applied by the filesystem watcher")
    local colors = verify_highlights "dark"
    assert(colors.text_selection ~= initial.text_selection, "selection must track background")
    assert(colors.cursorline_fg ~= initial.cursorline_fg, "line number must track background")
    assert(colors.bg1 ~= colors.bg and colors.bg2 ~= colors.bg1, "surface layers must remain visible")
    equal(require("theme_toggle").sync(), false, "unchanged state must not reload")
  end

  publish("#edf0e8", "light")
  require("theme_toggle").sync()
  verify_highlights "light"
  equal(vim.o.background, "light", "light mode")

  -- A per-window override is valid until a global apply changes the generation.
  local override = temporary .. "/run/nvim-window-theme-" .. vim.fn.getpid()
  vim.fn.writefile({ "dark", tostring(serial) }, override)
  require("theme_toggle").sync()
  verify_highlights "dark"
  publish("#e1e7dc", "light")
  require("theme_toggle").sync()
  verify_highlights "light"

  vim.g.neovide = true
  local colors, editor_bg = require("theme.palette").load "light"
  equal(editor_bg, "#e1e7dc", "Neovide background")
  equal(require("theme.highlights")(colors, editor_bg).Normal.bg, editor_bg, "Neovide normal highlight")
  print "PASS: live same-mode recolors, UI surfaces, contrast, mode switches, window overrides, and Neovide"
end, debug.traceback)

local watcher = rawget(_G, "__global_theme_mode_watcher")
if watcher then
  watcher:stop()
  watcher:close()
  _G.__global_theme_mode_watcher = nil
end
vim.fn.delete(temporary, "rf")
if not ok then
  error(error_message)
end
