vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.treesitter.language.register('python', 'sage')

vim.opt.rtp:prepend(lazypath)
local lazy_config = require "configs.lazy"

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
    inoreabbrev ## #include <bits/stdc++.h><enter>using namespace std;<enter><enter>#define ll long long<enter>#define ld long double<enter>#define pii pair<int,int><enter>#define fi(_x) _x.first<enter>#define se(_x) _x.second<enter>const int N=200009;<enter><enter>void input(){<enter><enter>}<enter><enter>void solve(){<enter><enter>}<enter><enter>int main(){<enter>ios::sync_with_stdio(false);<enter>cin.tie(0);<enter>input();<enter>solve();<enter>return 0;<enter>}<C-R>  
]]

vim.cmd [[ 
    
]]

