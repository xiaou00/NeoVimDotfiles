local M = {}

-- A buffer wipe (e.g. NvChad's default close action) leaves lean.nvim's
-- cached infoview pointing at a deleted buffer. Discard it before reopening.
local function repair_infoview(infoview)
  local iv = infoview.get_current_infoview()
  if not iv then
    return
  end
  if not vim.api.nvim_buf_is_valid(iv.pin.buffer.bufnr) then
    iv:__was_closed()
    infoview._by_tabpage[vim.api.nvim_get_current_tabpage()] = nil
  elseif iv.window and (not iv.window:is_valid() or iv.window:bufnr() ~= iv.pin.buffer.bufnr) then
    -- A failed open can leave the source window recorded as the info window.
    iv:__was_closed()
  end
end

-- lean.nvim tries to close the last editor window if the source split was
-- closed first. Restore that split before toggling or explicitly opening.
local function restore_source_window(infoview)
  local iv = infoview.get_current_infoview()
  if not iv or not iv.window or not iv.window:is_valid() then
    return
  end

  local info_window = iv.window.id
  local tab = vim.api.nvim_win_get_tabpage(info_window)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    if win ~= info_window and vim.api.nvim_win_get_config(win).relative == "" then
      return
    end
  end

  local buffer, pos = iv.pin:__extmark_pos()
  local bufnr = buffer and buffer.bufnr
  if not bufnr then
    local params = iv.pin.__position_params
    bufnr = params and vim.uri_to_bufnr(params.textDocument.uri) or vim.api.nvim_create_buf(true, false)
  end
  local win = vim.api.nvim_open_win(bufnr, true, { split = "left", win = info_window })
  vim.wo[win].winfixbuf = false
  vim.wo[win].winfixwidth = false
  vim.wo[win].winfixheight = false
  if pos then
    vim.api.nvim_win_set_cursor(win, { pos[1] + 1, pos[2] })
  end
end

function M.setup()
  if M.configured then
    return
  end
  M.configured = true

  local infoview = require "lean.infoview"
  local open = infoview.open
  infoview.open = function()
    repair_infoview(infoview)
    restore_source_window(infoview)
    return open()
  end

  local toggle = infoview.toggle
  infoview.toggle = function()
    repair_infoview(infoview)
    restore_source_window(infoview)
    return toggle()
  end

  vim.api.nvim_create_user_command("LeanInfoviewOpen", function()
    infoview.open()
  end, { desc = "Open the Lean infoview alongside its source" })

  -- Both <leader>x and the tabline close button call this function. Closing
  -- the split preserves Lean's internal buffer so it can be opened again.
  local ok, tabufline = pcall(require, "nvchad.tabufline")
  if ok then
    local close_buffer = tabufline.close_buffer
    tabufline.close_buffer = function(bufnr)
      local target = bufnr or vim.api.nvim_get_current_buf()
      if vim.api.nvim_buf_is_valid(target) and vim.bo[target].filetype == "leaninfo" then
        for _, win in ipairs(vim.fn.win_findbuf(target)) do
          vim.api.nvim_win_call(win, function()
            repair_infoview(infoview)
            restore_source_window(infoview)
            vim.api.nvim_win_close(win, true)
          end)
        end
        return
      end
      return close_buffer(bufnr)
    end
  end
end

return M
