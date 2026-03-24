require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- CPH mappings
-- 我们可以将 competitest 的快捷键组织为一个逻辑簇
-- 在 Normal 模式下映射
map("n", "<leader>cr", "<cmd>CompetiTest run<CR>", { desc = "CompetiTest Run" })
map("n", "<leader>ca", "<cmd>CompetiTest add_testcase<CR>", { desc = "CompetiTest Add" })
map("n", "<leader>ce", "<cmd>CompetiTest edit_testcase<CR>", { desc = "CompetiTest Edit" })
map("n", "<leader>cd", "<cmd>CompetiTest delete_testcase<CR>", { desc = "CompetiTest Delete" })
map("n", "<leader>cp", "<cmd>CompetiTest receive<CR>", { desc = "CompetiTest Receive (Problem)" })
map("n", "<leader>r", ":RunCode<CR>", { desc = "Run C++ code" })

-- 常见的 Ctrl mapping
map("n", "<C-a>", "ggVG", { desc = "Select All" })
map("i", "<C-a>", "<ESC>ggVGi", { desc = "Select All" })
map("n", "<C-z>", "u", { desc = "undo" })
map("i", "<C-z>", "<ESC>ui", { desc = "undo" })
map("i", "<C-r>", "<ESC><C-r>i", { desc = "redo" })
map("i", "<C-s>", "<ESC>v", { desc = "select" })
map("n", "<C-s>", "v", { desc = "select" })
map("i", "<C-d>", "<ESC>Vdi", { desc = "delete line" })

-- 插入模式：注释当前行并进入插入模式
map("i", "<C-/>", "<Esc>gccA", { desc = "Comment line and append" })

-- 普通模式：直接注释
map("n", "<C-/>", "gcc", { desc = "Toggle comment" })
map("v", "<C-/>", "gc", { desc = "Toggle comment selection" })

map("i", "<C-BS>", "<ESC>\"_diwi", { desc = "Delete word" })
map("i", "<C-del>", "<ESC>\"_daB", { desc = "Delete content between brackets" })

map("i", "<C-]>", "copilot#Suggest()", {
    expr = true;
    desc = "Trigger Copilot suggestion";
})

local function create_abbrev(lhs, rhs)
    vim.cmd("iabbrev " .. lhs .. " " .. rhs)
end

-- 示例：输入 'func' 自动替换为 'function'
create_abbrev("mian", "main")
