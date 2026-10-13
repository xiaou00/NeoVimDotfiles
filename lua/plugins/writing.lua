return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
    build = "git apply --ignore-whitespace "
      .. vim.fn.stdpath "config"
      .. "/patches/render-markdown-latex.patch || true",
    cmd = "RenderMarkdown",
    lazy = false,
    opts = {
      anti_conceal = { enabled = false },
      heading = { enabled = false },
      quote = { icon = "│", repeat_linebreak = true },
      bullet = { icons = { "•", "◦", "·" } },
      dash = { icon = "─" },
      checkbox = { unchecked = { icon = "□ " }, checked = { icon = "✓ " } },
      code = { sign = false, language_icon = false, language_border = "─" },
      link = { image = "[img] ", email = "@ ", hyperlink = "↗ ", footnote = { icon = "^ " }, wiki = { icon = "# " } },
      callout = {
        def = { raw = "[!DEF]", rendered = "≝ Definition", highlight = "RenderMarkdownDef" },
        thm = { raw = "[!THM]", rendered = "⊢ Theorem", highlight = "RenderMarkdownThm" },
        lem = { raw = "[!LEM]", rendered = "· Lemma", highlight = "RenderMarkdownLem" },
        prop = { raw = "[!PROP]", rendered = "◇ Proposition", highlight = "RenderMarkdownProp" },
        col = { raw = "[!COL]", rendered = "∴ Corollary", highlight = "RenderMarkdownCol" },
        pf = { raw = "[!PF]", rendered = "□ Proof", highlight = "RenderMarkdownPf" },
      },
      latex = {
        enabled = true,
        render_modes = false,
        converter = { "utftex-clean", "latex2text" },
        highlight = "RenderMarkdownMath",
        position = "center",
        top_pad = 0,
        bottom_pad = 0,
      },
    },
    config = function(_, opts)
      local markdown = require "render-markdown"
      -- Keep all built-in callout/link types, replacing their decorative icons.
      for name, callout in pairs(markdown.default.callout) do
        if not opts.callout[name] then
          opts.callout[name] = { rendered = callout.rendered:gsub("^%S+%s+", "") }
        end
      end
      opts.link.custom = vim.deepcopy(markdown.default.link.custom)
      for _, link in pairs(opts.link.custom) do
        link.icon = "↗ "
      end
      opts.checkbox.custom = vim.deepcopy(markdown.default.checkbox.custom)
      for _, checkbox in pairs(opts.checkbox.custom) do
        checkbox.rendered = "[~] "
      end
      markdown.setup(opts)
    end,
  },
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-xelatex",
        },
      }
    end,
  },
  {
    "chomosuke/typst-preview.nvim",
    lazy = false,
    version = "1.*",
    opts = {
      open_cmd = "/usr/bin/chromium --disable-gpu --app=%s 2>/dev/null",
      invert_colors = "never",
      get_root = require("configs.typst").root,
      get_main_file = require("configs.typst").main_file,
      dependencies_bin = {
        tinymist = "tinymist",
      },
    },
  },
}
