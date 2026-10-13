return {
  -- Override the engines inherited from NvChad.
  { "L3MON4D3/LuaSnip", enabled = false },
  { "saadparwaiz1/cmp_luasnip", enabled = false },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "nvim-mini/mini.nvim", "rafamadriz/friendly-snippets" },
    opts = function(_, opts)
      local cmp = require "cmp"
      local snippets = require "mini.snippets"
      local gen_loader = snippets.gen_loader
      local latex_patterns = { "latex/**/*.json", "**/latex.json", "**/tex.json", "**/tex.lua" }

      snippets.setup {
        snippets = {
          gen_loader.from_runtime "global.json",
          gen_loader.from_lang {
            lang_patterns = {
              tex = latex_patterns,
              plaintex = latex_patterns,
              latex = latex_patterns,
              markdown_inline = { "**/markdown.json", "**/markdown.lua" },
              sage = { "python/**/*.json", "**/python.json", "**/python.lua", "**/sage.json", "**/sage.lua" },
            },
          },
        },
        -- nvim-cmp owns Tab; keep the existing Ctrl-j/Ctrl-k navigation.
        mappings = { expand = "", jump_next = "", jump_prev = "", stop = "<C-c>" },
        expand = {
          match = function(available)
            -- An ordinary Tab must not open a fuzzy snippet picker.
            return snippets.default_match(available, { pattern_fuzzy = "" })
          end,
        },
      }

      -- Publish snippets through the existing cmp-nvim-lsp source.
      snippets.start_lsp_server { match = false }
      opts.sources = vim.tbl_filter(function(source)
        return source.name ~= "luasnip"
      end, opts.sources)
      opts.snippet.expand = function(args)
        snippets.default_insert { body = args.body }
      end

      opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif snippets.session.get() then
          snippets.session.jump "next"
        elseif #snippets.expand { insert = false } > 0 then
          snippets.expand()
        else
          fallback()
        end
      end, { "i", "s" })
      opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif snippets.session.get() then
          snippets.session.jump "prev"
        else
          fallback()
        end
      end, { "i", "s" })
    end,
  },
}
