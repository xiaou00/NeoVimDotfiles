-- Local syntax colors; every UI surface is derived from the shared background.
local accents = {
  dark = {
    fg = "#f5f1ee",
    fg2 = "#c9bfba",
    fg3 = "#8b8380",
    red = "#ff3b3b",
    orange = "#ff5a36", -- vivid vermilion, deliberately close to red
    teal = "#4fd7cf",
    dark_teal = "#2fa8a1",
  },
  light = {
    fg = "#292725",
    fg2 = "#55514d",
    fg3 = "#79736d",
    red = "#ce3038",
    orange = "#ce421f",
    teal = "#137e78",
    dark_teal = "#116b66",
  },
}

local M = {}

local function rgb(hex)
  return { tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16) }
end

local function mix(background, foreground, amount)
  local bg, fg = rgb(background), rgb(foreground)
  local channels = {}
  for i = 1, 3 do
    channels[i] = math.floor(bg[i] + (fg[i] - bg[i]) * amount + 0.5)
  end
  return string.format("#%02x%02x%02x", unpack(channels))
end

local function luminance(hex)
  local channels = rgb(hex)
  for i, channel in ipairs(channels) do
    channel = channel / 255
    channels[i] = channel <= 0.04045 and channel / 12.92 or ((channel + 0.055) / 1.055) ^ 2.4
  end
  return channels[1] * 0.2126 + channels[2] * 0.7152 + channels[3] * 0.0722
end

local function readable_on(background)
  return luminance(background) > 0.179 and "#000000" or "#ffffff"
end

function M.load(mode)
  local ok, palette = pcall(function()
    local path = (vim.env.XDG_CONFIG_HOME or vim.fn.expand "~/.config") .. "/theme/palette.json"
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  palette = ok and type(palette) == "table" and palette or {}
  local base = mode == "light" and palette.light or palette.nvim_dark or palette.dark
  local colors = vim.tbl_extend("force", base or {}, accents[mode])
  local system = palette[mode]
  colors.bg = system and system.bg or (mode == "light" and "#f7f5f2" or "#151515")
  local contrast = readable_on(colors.bg)
  -- Blend towards a contrasting pole so even pure black/white retain layers.
  -- Keep the selected hue instead of fixed gray/red selection backgrounds.
  colors.bg1 = mix(colors.bg, contrast, 0.045)
  colors.bg2 = mix(colors.bg, contrast, 0.09)
  colors.bg3 = mix(colors.bg, contrast, 0.16)
  colors.sel = mix(colors.bg, contrast, 0.18)
  colors.text_selection = mix(colors.bg, contrast, 0.23)
  colors.search = mix(colors.bg, contrast, 0.30)
  colors.selection_fg = readable_on(colors.text_selection)
  colors.menu_fg = readable_on(colors.sel)
  colors.search_fg = readable_on(colors.search)
  colors.cursorline_fg = mix(colors.bg, contrast, 0.75)
  local line_lum, number_lum = luminance(colors.bg1), luminance(colors.cursorline_fg)
  if (math.max(line_lum, number_lum) + 0.05) / (math.min(line_lum, number_lum) + 0.05) < 4.5 then
    colors.cursorline_fg = readable_on(colors.bg1)
  end
  local editor_bg = vim.g.neovide and colors.bg or nil
  -- Compatibility for plugins which name these roles green/yellow.
  colors.green, colors.yellow, colors.accent = colors.teal, colors.orange, colors.red
  colors.blue, colors.purple = colors.teal, colors.orange
  return colors, editor_bg
end

return M
