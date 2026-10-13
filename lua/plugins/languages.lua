return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  { "nvim-treesitter/nvim-treesitter", opts = require "configs.treesitter" },
  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      vim.g.lean_config = { mappings = true }
    end,
    config = function()
      require("configs.lean").setup()
    end,
  },
  { "petRUShka/vim-sage" },
  {
    dir = "/home/xiaou0/Projects/LuaProjects/sage-complete.nvim",
    name = "sage-complete.nvim",
    ft = "sage",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    opts = {
      use_snippets = true,
      snippet_optional_arguments = false,
    },
  },
}
