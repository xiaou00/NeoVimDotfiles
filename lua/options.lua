require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

local opt = vim.opt

opt.shiftwidth = 4   -- 每一级缩进为 4 个空格
opt.tabstop = 4      -- 一个 Tab 字符显示为 4 个空格宽度
opt.softtabstop = 4  -- 编辑时按 Tab 键实际插入 4 个空格
opt.expandtab = true -- 将所有 Tab 自动映射为空格（实现一致性）
opt.timeoutlen = 250
