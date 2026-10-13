require("nvchad.configs.lspconfig").defaults()
require("configs.ui").diagnostics()

local servers = { "html", "cssls", "tinymist" }

local tinymist_settings = {
  exportPdf = "never",
  outputPath = "$root/$dir/$name",
  previewFeature = "enable",
  sysInputs = {},
}

vim.lsp.config("tinymist", {
  settings = tinymist_settings,
  root_dir = function(bufnr, on_dir)
    on_dir(require("configs.typst").root(vim.api.nvim_buf_get_name(bufnr)))
  end,
  before_init = function(_, config)
    config.settings.rootPath = config.root_dir
  end,
  on_attach = require("configs.typst").on_attach,
})

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
