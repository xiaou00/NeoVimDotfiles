local border = require("configs.ui").border

return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        prompt_prefix = "> ",
        selection_caret = "› ",
        entry_prefix = "  ",
        color_devicons = false,
        disable_devicons = true,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      renderer = {
        highlight_git = "name",
        indent_markers = { icons = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " } },
        icons = {
          show = { file = false, folder = false, folder_arrow = true },
          symlink_arrow = " -> ",
          glyphs = {
            default = ".",
            symlink = "@",
            bookmark = "*",
            modified = "+",
            hidden = ".",
            folder = { arrow_closed = "▸", arrow_open = "▾" },
            git = {
              unstaged = "~",
              staged = "+",
              unmerged = "!",
              renamed = ">",
              untracked = "?",
              deleted = "-",
              ignored = ".",
            },
          },
        },
      },
      diagnostics = { icons = { hint = "H", info = "I", warning = "W", error = "E" } },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- Only customize appearance; snippet integration lives in snippets.lua.
      opts.formatting.fields = { "abbr", "kind", "menu" }
      opts.formatting.format = function(_, item)
        item.menu = ""
        item.kind = item.kind or ""
        item.kind_hl_group = "CmpItemKind"
        if vim.fn.strchars(item.abbr) > 60 then
          item.abbr = vim.fn.strcharpart(item.abbr, 0, 57) .. "..."
        end
        return item
      end
      opts.window.completion.border = border
      opts.window.documentation.border = border
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
        untracked = { text = "?" },
      },
      signs_staged = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
        untracked = { text = "?" },
      },
    },
  },
  { "lukas-reineke/indent-blankline.nvim", opts = { indent = { char = "│" }, scope = { char = "│" } } },
  {
    "mason-org/mason.nvim",
    opts = {
      ui = { border = border, icons = { package_installed = "+", package_pending = "~", package_uninstalled = "-" } },
    },
  },
}
