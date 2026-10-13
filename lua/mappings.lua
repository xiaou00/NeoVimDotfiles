require "nvchad.mappings"

local map = vim.keymap.set

-- 按屏幕显示行上下移动，保留折行中的屏幕列位置。
map({ "n", "x" }, "j", "gj", { desc = "Move down one display line" })
map({ "n", "x" }, "k", "gk", { desc = "Move up one display line" })
map({ "n", "x" }, "<Down>", "gj", { desc = "Move down one display line" })
map({ "n", "x" }, "<Up>", "gk", { desc = "Move up one display line" })
map("i", "<Down>", "<C-\\><C-o>gj", { desc = "Move down one display line" })
map("i", "<Up>", "<C-\\><C-o>gk", { desc = "Move up one display line" })
map("i", "<C-j>", "<C-\\><C-o>gj", { desc = "Move down one display line" })
map("i", "<C-k>", "<C-\\><C-o>gk", { desc = "Move up one display line" })

map("n", ";", ":", { desc = "CMD enter command mode" })

-- 常见的 Ctrl mapping
map("n", "<C-a>", "ggVG", { desc = "Select All" })
map("i", "<C-a>", "<ESC>ggVGi", { desc = "Select All" })
map("n", "<C-z>", "u", { desc = "Undo" })
map("i", "<C-z>", "<ESC>ui", { desc = "Undo" })
map("i", "<C-r>", "<ESC><C-r>i", { desc = "Redo" })
map("i", "<C-s>", "<ESC>v", { desc = "Select" })
map("n", "<C-s>", "v", { desc = "Select" })
map("i", "<C-d>", "<ESC>Vdi", { desc = "Delete line" })
map("i", "<C-BS>", "<ESC>\"_diwi", { desc = "Delete word" })
map("i", "<C-del>", "<ESC>\"_daB", { desc = "Delete content between brackets" })

-- 注释
map("i", "<C-/>", "<Esc>gccA", { desc = "Comment line and append" })
map("n", "<C-/>", "gcc", { desc = "Toggle comment" })
map("v", "<C-/>", "gc", { desc = "Toggle comment selection" })

-- Copilot;word
map("n", "<leader>ct", function()
    if vim.g.copilot_enabled == 0 or vim.g.copilot_enabled == false then
        vim.cmd "Copilot enable"
        print("Copilot On")
    else
        vim.cmd "Copilot disable"
        print("Copilot Off")
    end
end, { desc = "Toggle Copilot" })

map("i", "<C-]>", "<Plug>(copilot-accept-word)", {
    desc = "Accept next Copilot word",
})

-- Auto-save toggle
local autosave_enabled = true
map('n', '<leader>as', function()
    autosave_enabled = not autosave_enabled
    if autosave_enabled then
        vim.opt.updatetime = 2000
        print("Auto-save On")
    else
        vim.opt.updatetime = 4000
        print("Auto-save Off")
    end
end, { desc = 'Toggle Auto-save' })

-- Toggle line wrap
map('n', '<leader>w', function()
    vim.opt.wrap = not vim.opt.wrap:get()
    print(vim.opt.wrap:get() and "Wrap On" or "Wrap Off")
end, { desc = 'Toggle Line Wrap' })

-- Silicon (code screenshot)
map("v", "<leader>si", function() require("nvim-silicon").clip() end, { desc = "Silicon: copy selection to clipboard" })
map("n", "<leader>si", function() require("nvim-silicon").clip() end, { desc = "Silicon: copy whole file to clipboard" })

-- Telescope
map('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Telescope find files' })
map('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Telescope live grep' })
map('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = 'Telescope buffers' })
map('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = 'Telescope help tags' })

-- CompetiTest
map("n", "<leader>cr", "<cmd>CompetiTest run<CR>", { desc = "CompetiTest Run" })
map("n", "<leader>ca", "<cmd>CompetiTest add_testcase<CR>", { desc = "CompetiTest Add" })
map("n", "<leader>ce", "<cmd>CompetiTest edit_testcase<CR>", { desc = "CompetiTest Edit" })
map("n", "<leader>cd", "<cmd>CompetiTest delete_testcase<CR>", { desc = "CompetiTest Delete" })
map("n", "<leader>cp", "<cmd>CompetiTest receive<CR>", { desc = "CompetiTest Receive (Problem)" })
map("n", "<leader>r", function()
    if vim.bo.filetype == 'markdown' then
        require('configs.markdown_runner').run_codeblock()
    else
        -- Dispatch by filetype; ancestor project markers must not override the language.
        -- Use :RunCode explicitly when running the whole project.
        vim.cmd('RunFile')
    end
end, { desc = "Run current file / Run markdown codeblock" })

-- Typst
map('n', '<leader>tp', '<cmd>TypstPreviewToggle<CR>', { desc = 'Toggle Typst preview' })

local typst_job = nil
map('n', '<leader>tc', function()
    if typst_job then
        vim.fn.jobstop(typst_job)
        typst_job = nil
        print("Typst watch stopped")
    else
        local file = vim.fn.expand('%:p')
        typst_job = vim.fn.jobstart(require('configs.typst').atomic_watch_command(file), { detach = false })
        print("Typst watch started: " .. file)
    end
end, { desc = 'Toggle typst watch' })

require "abbreviations"
