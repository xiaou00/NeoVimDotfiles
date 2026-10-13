local M = {}

local config_home = vim.env.XDG_CONFIG_HOME or vim.fn.expand "~/.config"
local mode_path = config_home .. "/theme/mode"
local generation_path = config_home .. "/theme/generation"
local runtime_dir = vim.env.XDG_RUNTIME_DIR or "/tmp"
local override_path = string.format("%s/nvim-window-theme-%d", runtime_dir, vim.fn.getpid())

local function read_global_mode()
  local ok, lines = pcall(vim.fn.readfile, mode_path)
  return ok and lines[1] == "light" and "light" or "dark"
end

local function read_mode()
  local global_mode = read_global_mode()
  local generation_ok, generation_lines = pcall(vim.fn.readfile, generation_path)
  local global_generation = generation_ok and generation_lines[1] or global_mode
  local ok, lines = pcall(vim.fn.readfile, override_path)
  if ok and (lines[1] == "light" or lines[1] == "dark") and lines[2] == global_generation then
    return lines[1], global_generation
  end
  return global_mode, global_generation
end

local active_mode, active_generation = read_mode()
local colors, editor_bg = require("theme.palette").load(active_mode)

local make_highlights = require "theme.highlights"
local highlights = make_highlights(colors, editor_bg)

-- Keep the existing public name for external callers.
M.dark_highlights = highlights

-- Reload render-markdown's cached combined highlight groups and re-render all
-- open markdown buffers. Must be called after highlight groups are updated.
local function refresh_render_markdown()
  local ok_colors, rm_colors = pcall(require, "render-markdown.core.colors")
  if ok_colors then
    rm_colors.reload()
  end

  local ok_api, rm_api = pcall(require, "render-markdown")
  if not ok_api then
    return
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "markdown" then
      pcall(rm_api.render, { buf = buf, event = "ThemeToggle" })
    end
  end
end

local function redraw_all()
  pcall(vim.cmd, "redrawstatus!")
  pcall(vim.cmd, "redraw!")
end

-- apply-theme.sh publishes generation then mode, even for same-mode recolors.
-- Switch immediately when ~/.config/theme/mode changes. Keeping the watcher
-- outside package.loaded lets it survive this module being reloaded for the
-- new palette without creating duplicate libuv handles.
local function ensure_mode_watcher()
  if rawget(_G, "__global_theme_mode_watcher") then
    return
  end

  local watcher = vim.uv.new_fs_event()
  if not watcher then
    return
  end

  local mode_dir = vim.fn.fnamemodify(mode_path, ":h")
  local started, start_err = watcher:start(mode_dir, {}, function(err, filename)
    if err then
      return
    end
    if filename and filename ~= "mode" then
      return
    end
    vim.schedule(function()
      local loaded, module = pcall(require, "theme_toggle")
      if loaded then
        module.sync()
      end
    end)
  end)

  if started ~= nil then
    _G.__global_theme_mode_watcher = watcher
  else
    watcher:close()
    if start_err then
      vim.schedule(function()
        vim.notify("Global theme watcher: " .. start_err, vim.log.levels.WARN)
      end)
    end
  end
end

-- Register refresh triggers once, and coalesce events from the same startup cycle.
function M.setup()
  local group = vim.api.nvim_create_augroup("ThemeRefresh", { clear = true })
  local pending = false
  local function apply_later()
    if pending then
      return
    end
    pending = true
    vim.schedule(function()
      pending = false
      require("theme_toggle").init()
    end)
  end

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = { "NvDashReady", "NvThemeReload", "LazyLoad" },
    callback = apply_later,
  })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "NvimTree",
    callback = apply_later,
  })
  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    once = true,
    callback = apply_later,
  })
  -- lazy.setup() has already emitted LazyDone by the time this module is set up.
  apply_later()
end

function M.sync()
  local mode, generation = read_mode()
  if mode == active_mode and generation == active_generation then
    return false
  end

  package.loaded["theme_toggle"] = nil
  require("theme_toggle").init()
  return true
end

-- Apply the globally selected theme at startup and after base46 reloads.
function M.init()
  vim.o.background = active_mode
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
  local silicon = package.loaded["nvim-silicon"]
  if silicon and silicon.options then
    silicon.options.background = colors.bg
  end

  local autocmd_group = vim.api.nvim_create_augroup("GlobalThemeSync", { clear = true })
  vim.api.nvim_create_autocmd({ "FocusGained", "VimResume", "CursorHold", "CursorHoldI" }, {
    group = autocmd_group,
    callback = function()
      M.sync()
    end,
  })
  vim.api.nvim_create_autocmd("Signal", {
    group = autocmd_group,
    pattern = "SIGUSR1",
    callback = function()
      M.sync()
    end,
  })
  ensure_mode_watcher()
  vim.schedule(function()
    refresh_render_markdown()
    redraw_all()
  end)
end

return M
