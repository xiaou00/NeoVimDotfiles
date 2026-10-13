-- The same mark as ~/.config/fish/functions/fish_greeting.fish.
local rows = {
  { { "▄█████████▄", "GhostBody" } },
  { { "█████████▓▓", "GhostBody" } },
  { { "█████████▓▓", "GhostBody" } },
  { { "█▄▄", "GhostBody" }, { "▄", "GhostAccent" }, { "▄▄▄▄▄█████▀", "GhostBody" } },
  { { "▀██", "GhostBody" }, { "█", "GhostAccent" }, { "████████▀", "GhostBody" } },
}

local M = { lines = {}, highlights = {} }
local width = 0
for i, row in ipairs(rows) do
  local parts, spans, column = {}, {}, 0
  for _, chunk in ipairs(row) do
    parts[#parts + 1] = chunk[1]
    spans[#spans + 1] = { chunk[2], column, column + #chunk[1] }
    column = column + #chunk[1]
  end
  M.lines[i] = table.concat(parts)
  M.highlights[i] = spans
  width = math.max(width, vim.fn.strdisplaywidth(M.lines[i]))
end

-- Pad every row to the same width so both dashboards preserve the silhouette.
for i, line in ipairs(M.lines) do
  M.lines[i] = line .. string.rep(" ", width - vim.fn.strdisplaywidth(line))
end

function M.nvdash()
  local result = {}
  for i, row in ipairs(rows) do
    local line = { multicolumn = true, content = "fit", pad = 0, no_gap = true }
    for _, chunk in ipairs(row) do
      line[#line + 1] = { txt = chunk[1], hl = chunk[2] }
    end
    line[#line + 1] = { txt = M.lines[i]:match " *$", hl = "GhostBody" }
    result[#result + 1] = line
  end
  result[#result + 1] = { txt = "", no_gap = true }
  return result
end

return M
