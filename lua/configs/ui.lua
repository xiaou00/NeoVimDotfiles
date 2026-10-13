local M = {}
M.border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

local function escape(text)
  return (text:gsub("%%", "%%%%"))
end

local function shorten(text, width)
  if vim.fn.strdisplaywidth(text) <= width then
    return text
  end
  while vim.fn.strdisplaywidth(text) > width - 2 do
    text = vim.fn.strcharpart(text, 0, vim.fn.strchars(text) - 1)
  end
  return text .. ".."
end

local function status_buf()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

M.statusline = {
  theme = "default",
  separator_style = { left = "", right = "" },
  order = { "mode", "file", "git", "%=", "diagnostics", "position" },
  modules = {
    mode = function()
      local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
      local labels =
        { n = "N", i = "I", v = "V", V = "V-L", ["\22"] = "V-B", c = ":", R = "R", s = "S", S = "S", t = "T" }
      local groups =
        { i = "Insert", v = "Visual", V = "Visual", ["\22"] = "Visual", c = "Command", R = "Replace", t = "Terminal" }
      local group = groups[mode] or "Normal"
      return "%#St_" .. group .. "Mode# " .. (labels[mode] or mode:upper()) .. " %#St_separator# │ "
    end,
    file = function()
      local buf = status_buf()
      local path = vim.api.nvim_buf_get_name(buf)
      local name = path == "" and "[no name]" or vim.fn.fnamemodify(path, ":t")
      local flag = vim.bo[buf].modified and "%#St_modified# +" or ""
      if vim.bo[buf].readonly then
        flag = flag .. " [ro]"
      end
      return "%#St_file#%<" .. escape(name) .. flag .. " "
    end,
    git = function()
      if vim.o.columns < 80 then
        return ""
      end
      local git = vim.b[status_buf()].gitsigns_status_dict
      if not git or not git.head or git.head == "" then
        return ""
      end
      local parts = { "%#St_gitBranch#" .. escape(git.head) }
      for _, entry in ipairs { { "added", "+", "Add" }, { "changed", "~", "Change" }, { "removed", "-", "Delete" } } do
        local count = git[entry[1]] or 0
        if count > 0 then
          parts[#parts + 1] = "%#St_git" .. entry[3] .. "#" .. entry[2] .. count
        end
      end
      return "%#St_separator#│ " .. table.concat(parts, " ") .. " %#St_file#"
    end,
    diagnostics = function()
      local counts = vim.diagnostic.count(status_buf())
      local parts = {}
      local groups = { "Error", "Warn", "Info", "Hint" }
      for severity, label in ipairs { "E", "W", "I", "H" } do
        if (counts[severity] or 0) > 0 then
          parts[#parts + 1] = "%#St_diag" .. groups[severity] .. "#" .. label .. counts[severity]
        end
      end
      return #parts == 0 and "" or " " .. table.concat(parts, " ") .. "%#St_separator# │"
    end,
    position = function()
      local ft = vim.bo[status_buf()].filetype
      local label = vim.o.columns >= 65 and ft ~= "" and ("%#St_filetype# " .. escape(ft) .. "%#St_separator# │")
        or ""
      return label .. "%#St_pos_text# %l:%c "
    end,
  },
}

-- Reuse NvChad's click actions and buffer tracking; render plain text labels.
local function button(label, group, action, id)
  return require("nvchad.tabufline.utils").btn(label, group, action, id)
end

M.tabufline = {
  lazyload = false,
  order = { "buffers", "tabs" },
  modules = {
    buffers = function()
      local bufs = vim.tbl_filter(vim.api.nvim_buf_is_valid, vim.t.bufs or {})
      local current, names, counts = 1, {}, {}
      for i, buf in ipairs(bufs) do
        if buf == vim.api.nvim_get_current_buf() then
          current = i
        end
        local path = vim.api.nvim_buf_get_name(buf)
        local name = path == "" and "[no name]" or vim.fn.fnamemodify(path, ":t")
        names[i] = name
        counts[name] = (counts[name] or 0) + 1
      end
      local tabs = #vim.api.nvim_list_tabpages()
      local space = math.max(10, vim.o.columns - (tabs > 1 and tabs * 3 + 3 or 0))
      local width = math.min(22, space)
      local slots = math.max(1, math.floor(space / width))
      local first = math.max(1, math.min(current - math.floor(slots / 2), #bufs - slots + 1))
      local result = {}
      for i = first, math.min(#bufs, first + slots - 1) do
        local buf, name = bufs[i], names[i]
        if counts[name] > 1 then
          name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":h:t") .. "/" .. name
        end
        local group = buf == vim.api.nvim_get_current_buf() and "BufOn" or "BufOff"
        local modified = vim.bo[buf].modified
        local flag = modified and "●" or "×"
        local flag_group = group .. (modified and "Modified" or "Close")
        result[#result + 1] = button(" " .. escape(shorten(name, width - 5)) .. " ", group, "GoToBuf", buf)
          .. button(flag .. " ", flag_group, "KillBuf", buf)
          .. "%#TbSep#│"
      end
      return table.concat(result) .. "%#TbFill#%="
    end,
    tabs = function()
      local result = {}
      local count = #vim.api.nvim_list_tabpages()
      if count < 2 then
        return ""
      end
      for tab = 1, count do
        local group = tab == vim.fn.tabpagenr() and "TabOn" or "TabOff"
        result[#result + 1] = button(" " .. tab .. " ", group, "GotoTab", tab)
      end
      return table.concat(result) .. button(" + ", "TabNewBtn", "NewTab")
    end,
  },
}

function M.diagnostics()
  local severity = vim.diagnostic.severity
  vim.diagnostic.config {
    virtual_text = { prefix = "·", spacing = 2 },
    signs = { text = { [severity.ERROR] = "E", [severity.WARN] = "W", [severity.INFO] = "I", [severity.HINT] = "H" } },
    float = { border = M.border },
  }
end

return M
