-- Run: nvim --headless -u NONE -i NONE -l ~/.config/nvim/tests/lean-infoview.lua
vim.opt.rtp:prepend(vim.fn.expand "~/.local/share/nvim/lazy/lean.nvim")
vim.opt.rtp:prepend(vim.fn.expand "~/.local/share/nvim/lazy/ui")
vim.opt.rtp:prepend(vim.fn.expand "~/.config/nvim")
vim.g.lean_config = {
  mappings = true,
  lsp = { enable = false },
  infoview = { autoopen = false, orientation = "horizontal", horizontal_position = "bottom" },
}
vim.cmd "filetype plugin on"
require("lean").init()
require("configs.lean").setup()
require("configs.lean").setup()

local infoview = require "lean.infoview"
local source = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_name(source, vim.fn.tempname() .. ".lean")
vim.bo.filetype = "lean"
local contents = { "example : True := by", "  trivial" }
vim.api.nvim_buf_set_lines(source, 0, -1, false, contents)
vim.api.nvim_win_set_cursor(0, { 2, 2 })

local function windows(count)
  assert(#vim.api.nvim_tabpage_list_wins(0) == count, "unexpected window count")
end

local function source_intact()
  assert(vim.api.nvim_get_current_buf() == source, "source buffer was not restored")
  assert(vim.deep_equal(vim.api.nvim_buf_get_lines(source, 0, -1, false), contents), "source changed")
  assert(vim.bo[source].modified, "unsaved changes were lost")
end

-- Exercise NvChad's actual close entry points, with scheduled ftplugin work
-- running between actions as it does in an interactive editor.
local tabufline = require "nvchad.tabufline"
vim.t.bufs = { source }
for _, button in ipairs { false, true } do
  for _ = 1, 3 do
    vim.cmd.LeanInfoviewToggle()
    vim.wait(20)
    windows(2)
    local panel = infoview.get_current_infoview()
    local info_buffer = panel.pin.buffer.bufnr
    assert(vim.fn.winlayout()[1] == "col", "expected an infoview below the source")
    if button then
      -- The mouse callback can name a buffer while the source has focus.
      tabufline.close_buffer(info_buffer)
    else
      panel:enter()
      tabufline.close_buffer()
    end
    vim.wait(20)
    windows(1)
    source_intact()
    assert(vim.api.nvim_buf_is_valid(info_buffer), "close wiped Lean's internal buffer")
  end
end

-- Repair a session damaged before this configuration was loaded.
vim.cmd.LeanInfoviewOpen()
local damaged = infoview.get_current_infoview()
vim.api.nvim_buf_delete(damaged.pin.buffer.bufnr, { force = true })
vim.cmd.LeanInfoviewToggle()
windows(2)
source_intact()
assert(infoview.get_current_infoview() ~= damaged, "deleted infoview was reused")
vim.cmd.LeanInfoviewToggle()

-- A failed reopen must never make the next toggle close the source window.
damaged = infoview.get_current_infoview()
damaged.window = require("std.nvim.window"):current()
vim.cmd.LeanInfoviewToggle()
windows(2)
source_intact()
vim.cmd.LeanInfoviewToggle()

vim.cmd.LeanInfoviewOpen()
windows(2)
source_intact()
vim.cmd.LeanInfoviewOpen()
windows(2)
vim.cmd.LeanInfoviewToggle()
windows(1)
source_intact()
vim.cmd.LeanInfoviewToggle()
windows(2)

local iv = infoview.get_current_infoview()
iv:enter()
vim.cmd.only()
windows(1)
vim.cmd.LeanInfoviewToggle()
windows(1)
source_intact()
assert(vim.deep_equal(vim.api.nvim_win_get_cursor(0), { 2, 2 }), "cursor position was not restored")

vim.cmd.LeanInfoviewOpen()
iv:enter()
vim.cmd.only()
vim.cmd.LeanInfoviewOpen()
windows(2)
source_intact()

-- A floating window does not prevent E444 when the infoview is the last split.
iv:enter()
vim.cmd.only()
local float = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), false, {
  relative = "editor", row = 1, col = 1, width = 10, height = 2,
})
vim.cmd.LeanInfoviewToggle()
source_intact()
vim.api.nvim_win_close(float, true)
windows(1)

-- No source exists when the panel was opened from a blank, non-Lean buffer.
vim.cmd.tabnew()
vim.cmd.LeanInfoviewOpen()
iv = infoview.get_current_infoview()
iv:enter()
vim.cmd.only()
vim.cmd.LeanInfoviewToggle()
windows(1)
assert(vim.bo.buftype == "" and vim.bo.modifiable, "expected an editable fallback buffer")
print "PASS: NvChad keyboard/button close and reopen, deleted buffer/stale window recovery, unsaved source and cursor, last window, float, no source"
