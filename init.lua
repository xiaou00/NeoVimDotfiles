vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.treesitter.language.register('python', 'sage')
-- 将缩放系数强制设为 1.0 (等效于恒等态 Identity)
vim.g.neovide_scale_factor = 1.0

vim.opt.rtp:prepend(lazypath)
local lazy_config = require "configs.lazy"

vim.opt.wrap = true -- 禁用软换行，让文本保持在单行逻辑轨道上
local toggle_wrap = function()
    vim.opt.wrap = not vim.opt.wrap:get()
    if vim.opt.wrap:get() then
        print("显示范畴：开启自动换行 (Wrap On)  (๑>ᴗ<๑)")
    else
        print("显示范畴：关闭自动换行 (Wrap Off) (｡•́︿•̀｡)")
    end
end

-- 绑定快捷键 <leader>w
-- 你可以根据习惯修改 'nw' 为你喜欢的组合
vim.keymap.set('n', '<leader>w', toggle_wrap, { desc = 'Toggle Line Wrap' })
-- 建立 后缀 -> 类型 的显式映射 (Morphism)
vim.filetype.add({
    pattern = {
        ['.*%.sage'] = 'sage',
    },
})

vim.keymap.set('n', '<leader>ct', function()
  if vim.g.copilot_enabled == 1 then
    vim.g.copilot_enabled = 0
    print("Copilot Off")
  else
    vim.g.copilot_enabled = 1
    print("Copilot On")
  end
end, { desc = "Toggle Copilot" })

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

vim.filetype.add({
  extension = {
    sage = 'python',
  }
})

-- 关于渲染替换的设置
vim.opt.conceallevel = 2  -- 0: 不隐藏, 1: 隐藏但留位, 2: 完全替换渲染

vim.g.vimtex_view_method = 'zathura' -- 或者你喜欢的阅读器
vim.g.vimtex_compiler_method = 'latexmk'

-- 关键步：修改 latexmk 的参数，强制使用 xelatex
vim.g.vimtex_compiler_latexmk = {
    options = {
        '-shell-escape',
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
        '-xelatex', -- 注入这个态射，确保生成过程映射到 xelatex
    },
}

-- 设置顶部内边距为 20 像素
vim.g.neovide_padding_top = 20
-- 设置左侧内边距为 20 像素
vim.g.neovide_padding_left = 20
-- 右侧和底部通常为了对称也会设置
vim.g.neovide_padding_right = 20
vim.g.neovide_padding_bottom = 20

vim.cmd[[
    inoreabbrev cr <cmd>CompetiTest run<CR>
]]

vim.cmd [[
    inoreabbrev mian main
    inoreabbrev fori for(int i=1;i<=n;++i){}<left><C-R>
    inoreabbrev forj for(int j=1;j<=n;++j){}<left><C-R>
    inoreabbrev cin cin>><C-R>
    inoreabbrev cout cout<<<C-R>
    inoreabbrev lb lower_bound()<C-R>
    inoreabbrev ub upper_bound()<C-R>
    inoreabbrev be begin()<C-R>
    inoreabbrev en end()<C-R>
    inoreabbrev // /*  */<left><left><left><C-R>
    inoreabbrev #i #include <bits/stdc++.h><enter>using namespace std;<enter><enter>#define ll long long<enter>#define ld long double<enter>#define pii pair<int,int><enter>#define fi(_x) _x.first<enter>#define se(_x) _x.second<enter>const int N=200009;<enter><enter>void input(){<enter><enter>}<enter><enter>void solve(){<enter><enter>}<enter><enter>int main(){<enter>ios::sync_with_stdio(false);<enter>cin.tie(0);<enter>input();<enter>solve();<enter>return 0;<enter>}<C-R>  
]]

vim.cmd [[ 
    
]]

-- 接下来是Markdown的设置

require('render-markdown').setup({
    anti_conceal = {
        enabled = false,
    },
    latex = {
        enabled = true,
        render_modes = false,
        converter = { 'utftex', 'latex2text' },
        highlight = 'RenderMarkdownMath',
        position = 'center',
        top_pad = 0,
        bottom_pad = 0,
    },
    code = {
        enabled = true,
        render_modes = false,
        sign = true,
        conceal_delimiters = true,
        language = true,
        position = 'left',
        language_icon = true,
        language_name = true,
        language_info = true,
        language_pad = 0,
        disable = {},
        disable_background = { 'diff' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = 'hide',
        language_border = '█',
        language_left = '',
        language_right = '',
        above = '▄',
        below = '▀',
        inline = true,
        inline_left = '',
        inline_right = '',
        inline_pad = 0,
        priority = 140,
        highlight = 'RenderMarkdownCode',
        highlight_info = 'RenderMarkdownCodeInfo',
        highlight_language = nil,
        highlight_border = 'RenderMarkdownCodeBorder',
        highlight_fallback = 'RenderMarkdownCodeFallback',
        highlight_inline = 'RenderMarkdownCodeInline',
        style = 'full',
    },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


