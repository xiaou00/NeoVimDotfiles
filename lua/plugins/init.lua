-- General editing, navigation and UI. Language and writing plugins live alongside this file.
return {
  {
    "sevenc-nanashi/neov-ime.nvim",
    lazy = false, -- The plugin automatically initializes when Neovide is available.
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      autopairs.setup {}
      autopairs.remove_rule("'")
      autopairs.add_rule(
        Rule("$", "$", "typst")
          :with_pair(cond.not_before_text("\\"))
          :with_move(cond.after_text("$"))
          :with_cr(cond.none())
      )
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
  {
    "folke/which-key.nvim",
    enabled = false,
  },
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
      require("nvim-silicon").setup {
        font = "JetBrainsMono Nerd Font=34;Source Han Sans CN=34;Noto Color Emoji=34",
        theme = vim.fn.expand "~/.config/silicon/themes/obsidian-ember.tmTheme",
        background = require("theme.palette").load(vim.o.background).bg,
        to_clipboard = true,
        window_title = function()
          return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
        end,
        line_offset = function(args)
          return args.line1
        end,
      }
    end,
  },
  {
    "goolord/alpha-nvim",
    lazy = false,
    config = function()
      local dashboard = require "alpha.themes.dashboard"
      local ghost = require "configs.ghost"
      dashboard.section.header.val = ghost.lines
      dashboard.section.header.opts.hl = ghost.highlights
      dashboard.section.buttons.val = {
        dashboard.button("e", "+  New file", "<cmd>ene<CR>"),
        dashboard.button("SPC f f", "/  Find file", "<cmd>Telescope find_files<CR>"),
        dashboard.button("SPC f o", ".  Recent files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("SPC f g", ">  Find text", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("SPC f h", "?  Help", "<cmd>Telescope help_tags<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "NvDashButtons"
        button.opts.hl_shortcut = "NvDashFooter"
      end
      require("alpha").setup(dashboard.config)
    end,
  },
}
