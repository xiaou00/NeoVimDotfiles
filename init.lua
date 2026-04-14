vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

-- Sage filetype support
vim.treesitter.language.register('python', 'sage')
vim.filetype.add({
    extension = { sage = 'python' },
    pattern   = { ['.*%.sage'] = 'sage' },
})

vim.g.neovide_padding_top = 20
vim.g.neovide_padding_left = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_bottom = 20

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, require "configs.lazy")

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Hook base46.load_all_highlights so our theme always wins after NvChad reloads
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    local ok, base46 = pcall(require, "base46")
    if ok then
      local orig = base46.load_all_highlights
      base46.load_all_highlights = function(...)
        orig(...)
        require("theme_toggle").init()
      end
    end
    -- Also apply immediately on first load
    vim.defer_fn(function()
      require("theme_toggle").init()
    end, 0)
  end,
})
